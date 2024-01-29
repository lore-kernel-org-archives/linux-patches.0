Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C86F15B30B;
	Mon, 29 Jan 2024 17:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548580; cv=none; b=BbAwaqNZ+WK1ecTSE0uuuRFkVy6N00LDGx4FxUSmPHViI8H10qCVFN2QGr5kSc+ZfpfE6eieZi5Hn5c6JqXZVLB8K0DCfkLf9tOMVLY+wgnq7YDDAXOwsrMeYa2wEF3XvWMpsxEICqvURw9cMa41YKcwvNM5/9BPM0FKVvZ3no8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548580; c=relaxed/simple;
	bh=O2lvHJUFy2ChF1ms9coE5AkfpdUPdk7sNX1I6H7k/30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQ+JLMnimcxc35OtiKq5TZjqNe36rN2ubcsAya3LRQYvSo52NGzSH7Fb/5Vx2/jWaHDMVmuUlTDDdyrG4pNdkQJGWARID9/T4N8bYayep73gSeuaSOrAWF1bdumLhlVLZ+ZihEAZxmPf16SJmJ3YePRfuSAG4eEL6C2BIW/81os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFFYYH7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFFYYH7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E4DC43394;
	Mon, 29 Jan 2024 17:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548580;
	bh=O2lvHJUFy2ChF1ms9coE5AkfpdUPdk7sNX1I6H7k/30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFFYYH7ALsA1ZtSsE2DcSSQjPiPB7kpLSuwaaGAYvNQxMKquMgDoFIY8zMscXSiXn
	 4Q31bsW9MakhOTC6eNnhbhMsKY4EratwcWr1hcESRTkRbz+HN5Owryx9C92w6FEBd3
	 KKzAtLWzm6rHnmTF5mtlRbqrcm10oPjoKhNLKsTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4a4f1eba14eb5c3417d1@syzkaller.appspotmail.com,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 235/331] btrfs: dont warn if discard range is not aligned to sector
Date: Mon, 29 Jan 2024 09:04:59 -0800
Message-ID: <20240129170021.756184734@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1245,7 +1245,8 @@ static int btrfs_issue_discard(struct bl
 	u64 bytes_left, end;
 	u64 aligned_start = ALIGN(start, 1 << SECTOR_SHIFT);
 
-	if (WARN_ON(start != aligned_start)) {
+	/* Adjust the range to be aligned to 512B sectors if necessary. */
+	if (start != aligned_start) {
 		len -= aligned_start - start;
 		len = round_down(len, 1 << SECTOR_SHIFT);
 		start = aligned_start;


