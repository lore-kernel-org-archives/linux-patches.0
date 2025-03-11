Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEF425D8E8;
	Tue, 11 Mar 2025 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705979; cv=none; b=GbAEQyUOAHBOWI2cMd7xD3fgrWUE46LqNkOSuLMPKY8bik5xTPdvx0aJxNTEtiZ1njOQjgVsdXTBKI4QZEbcNEAIYm6sl+hHz+6gEdp5p5aZOk78jDk6aTZSlhIya1n67xAEewgBwH+S8Qot8QcEyaqEtFhHl3ItV5oBBOUmzAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705979; c=relaxed/simple;
	bh=ul0hNh+9fxHgVqxMLFvdhr6ULNa6PcewG2iNbBFCGyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDuyZivED1esA53Rg06EhX6VLJBO7KKle9nXEbn15kzw1YHGVhxrgoixBRuksLKGNWtlYFxnR2ClbAxv3hceb368sXBES1Yo7C1hTgM8m3joWr8lIlkeuX/bAgGx3nUZt5v1ivvoC7PsuJynCSsrdgBW98HKq3z3XX2tMZ8prO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWrNcQwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWrNcQwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D5DC4CEE9;
	Tue, 11 Mar 2025 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705978;
	bh=ul0hNh+9fxHgVqxMLFvdhr6ULNa6PcewG2iNbBFCGyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWrNcQweHtqLtxy8Tt8u4mF+1l2xVbyxDeVDdeEnyGYhw0c0fnT/XvsmuOhqdePQy
	 ggiY9A8HpFHwAi2/VNnatH+AH1thStEiPX9X3TDV1+b7FqJ9xh5y8oxv5N2WU7XiZP
	 3j+/BqTBucr+GM77kLlUnququwbZOmqyhXFxbGos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Koichiro Den <koichiro.den@canonical.com>
Subject: [PATCH 5.4 221/328] btrfs: avoid monopolizing a core when activating a swap file
Date: Tue, 11 Mar 2025 15:59:51 +0100
Message-ID: <20250311145723.689030461@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

This commit re-attempts the backport of the change to the linux-5.4.y
branch. Commit 3d770d44dd5c ("btrfs: avoid monopolizing a core when
activating a swap file") on this branch was reverted.

During swap activation we iterate over the extents of a file and we can
have many thousands of them, so we can end up in a busy loop monopolizing
a core. Avoid this by doing a voluntary reschedule after processing each
extent.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -11079,6 +11079,8 @@ static int btrfs_swap_activate(struct sw
 		}
 
 		start += len;
+
+		cond_resched();
 	}
 
 	if (bsi.block_len)


