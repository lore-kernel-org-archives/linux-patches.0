Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7B415956D;
	Mon, 29 Jan 2024 17:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548180; cv=none; b=elDAJP1GdTuFETBGsJAvHmDwb2vAVMhJwUfPAWNXg2fqyeRXFRrC0RymWIpil8cW3HGcoXX0PogmE4SlrijxBck9ZcRz5/8S/n3u3ScGwTEllMyb9UPuSvABDbrrb79D7W4BZX+2HxAulV77TCXqSGdFLG/ootaeAmByB+2GO4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548180; c=relaxed/simple;
	bh=5MOGIy/QXEY5Lo1EL203GLt3XLXRXIvUXLx2GIuYe+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGJdJ4nBuYDYobbNAd5QjzVWea0V1yvN52a7jYBMkZwsCRmcwjUTgBXWVwOLdMXymeQdMC9cUs7YaC99BobuDkL+/34dAOSN88qEPMvldsNCibzxQwPUloJ0thlDsfxPc/pxWD0GFj16pEJpFiivddgULIKRAiEeW/X8VMgliUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soJxa+3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soJxa+3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CC1C433F1;
	Mon, 29 Jan 2024 17:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548180;
	bh=5MOGIy/QXEY5Lo1EL203GLt3XLXRXIvUXLx2GIuYe+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soJxa+3+SeJZH3GbH91dLvhXA++A0A3bOy8CZiIDXgMp/gN086c861DuFfMZQLMDn
	 5ZfZDphN7oxfsC0aS6Q1MmTY9ixX++bnZM/cD0qPUkufcqBcHH2kg659uczhZhcAuI
	 NOWuWI3rvNejsqhe+eL9Z6bYMgca2HDViPVLPrFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4a4f1eba14eb5c3417d1@syzkaller.appspotmail.com,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 226/346] btrfs: dont warn if discard range is not aligned to sector
Date: Mon, 29 Jan 2024 09:04:17 -0800
Message-ID: <20240129170023.042645272@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

commit a208b3f132b48e1f94f620024e66fea635925877 upstream.

There's a warning in btrfs_issue_discard() when the range is not aligned
to 512 bytes, originally added in 4d89d377bbb0 ("btrfs:
btrfs_issue_discard ensure offset/length are aligned to sector
boundaries"). We can't do sub-sector writes anyway so the adjustment is
the only thing that we can do and the warning is unnecessary.

CC: stable@vger.kernel.org # 4.19+
Reported-by: syzbot+4a4f1eba14eb5c3417d1@syzkaller.appspotmail.com
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1260,7 +1260,8 @@ static int btrfs_issue_discard(struct bl
 	u64 bytes_left, end;
 	u64 aligned_start = ALIGN(start, 1 << SECTOR_SHIFT);
 
-	if (WARN_ON(start != aligned_start)) {
+	/* Adjust the range to be aligned to 512B sectors if necessary. */
+	if (start != aligned_start) {
 		len -= aligned_start - start;
 		len = round_down(len, 1 << SECTOR_SHIFT);
 		start = aligned_start;


