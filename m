Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8892AE68;
	Mon, 30 Dec 2024 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573948; cv=none; b=sfD/eBEqygy33Ld7mLGppT4LVY2x83HAVO87Z9WI7BD+iEOiDuBsb6gwBhkoIhMYbBa9zpk1t1u5GGXdNF5VmTOBmNiuJfdJVQZfsidEreLvBa0tjyD7gNhYE/j8mDPsKzlZsb6ymFzPcJtFRee9e6MkMjWCE5V0EMUP2CgdlwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573948; c=relaxed/simple;
	bh=eTViMozMthhlSw3UYzBhgpqIc2jR+pTYChl9RDECKqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWSoKVya3l5vq04FiIZPkzUwItgxeqAMp3HnBbAqq1hcjgobXRHci7lo6EfMTWdWGQsqZ0z1RkIengntdSouFBQLdU/nhhQn6CBKy3ltTU/wtIIr2nc4Qi4RIY/zycNntgaUC4Nr1TL3omfDzdAxQHhXFvnmo8UCLh4dLdRwIKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6gpea74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6gpea74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FDFC4CED0;
	Mon, 30 Dec 2024 15:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573948;
	bh=eTViMozMthhlSw3UYzBhgpqIc2jR+pTYChl9RDECKqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6gpea74kuBXHHN6+AsNR8pR3+PdgtblKnAqsAxQTe3/QSeTdcxkkZBL7k6Le05TG
	 2GGgu5rdDsZDzC82D9nSWyhJj/AbACRlwg0ORgBoXnzTkTYJCEXop2UQiwyjekYGWv
	 o8xWOaxdFuquBJMHmNi6Zf118/iCTt/Jmf1JbSJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 81/86] btrfs: avoid monopolizing a core when activating a swap file
Date: Mon, 30 Dec 2024 16:43:29 +0100
Message-ID: <20241230154214.789085983@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7153,6 +7153,8 @@ noinline int can_nocow_extent(struct ino
 			ret = -EAGAIN;
 			goto out;
 		}
+
+		cond_resched();
 	}
 
 	if (orig_start)


