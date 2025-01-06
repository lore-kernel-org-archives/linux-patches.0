Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6244C145348;
	Mon,  6 Jan 2025 15:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179198; cv=none; b=b5Vob956fApNJP81uyN80kDNuATJDLLBUKHRRDD3FQL9Rlj3RhoK6sHXnGATognGBYrkkp65MWJ8r3pVWskHZskyz42dRryrsZHw5b/+y5vT7u/B+KqeSSZ3fZp4Q6uF0OgmLT4MygU4nd9SNcQg32c67PWuZeyHLFf4fAxp9o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179198; c=relaxed/simple;
	bh=vZF1t1TlGho8KnPZkv7thiNuPd+A0kZW8kBRJ5GaF5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S58ZpA1EF2jVms7TM09FByW+skW0vfha21rOkCFiN66/As3h/VUjD+q7rr7JXWuyxqTUbCrQ6NTnw9F+dxwHcJrMShclUJFi7+jukj2H4/DkK+jlBPXBp4z4caN3y9MHkXOw7XhfPDazXNHpei8jtQ4vRxYB0L5R5H7vRkefejY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTqmXrTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTqmXrTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA37BC4CED2;
	Mon,  6 Jan 2025 15:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179198;
	bh=vZF1t1TlGho8KnPZkv7thiNuPd+A0kZW8kBRJ5GaF5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTqmXrTMdPtaGKwTzLwczXUOShDAkUbz6MM+kwrTX1C3QpbbmapAgR512U2DWwd9d
	 paXQT3iPVbNwD8YwD75ZB/CMXfepviSSfx9hZkGVhuGhW4jqTb0yIzIMS/XUH5PTXg
	 B7rQzt3HzywwFNGT7CCL3N62pxrH6I665QM4oG0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 59/93] btrfs: avoid monopolizing a core when activating a swap file
Date: Mon,  6 Jan 2025 16:17:35 +0100
Message-ID: <20250106151130.932552278@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 2c8507c63f5498d4ee4af404a8e44ceae4345056 upstream.

During swap activation we iterate over the extents of a file and we can
have many thousands of them, so we can end up in a busy loop monopolizing
a core. Avoid this by doing a voluntary reschedule after processing each
extent.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7679,6 +7679,8 @@ noinline int can_nocow_extent(struct ino
 			ret = -EAGAIN;
 			goto out;
 		}
+
+		cond_resched();
 	}
 
 	btrfs_release_path(path);


