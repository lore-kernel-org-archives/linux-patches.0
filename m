Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC7F762C1;
	Wed, 21 Feb 2024 13:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522097; cv=none; b=Ur8Y7rxcOr2sNe/Oeqqjhz1O8T99tRrK5jb5zUBolA4hq63vcUiMsJfFwB5K7RrRoHJsccVafNnEpsDSUKL2ve0fkb1U6VtoP65T40NmvSmO+qr+ef0CZFLwcRvFas8WDnjIOYM6P0mBoUmypV71m7qG0EVEH2pTlIJBcGpGCTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522097; c=relaxed/simple;
	bh=ifzO++2H7GHcOZaXFf3sHiryqyxOHBE7Z785tP+VS4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SP7DEYDUOVWsCfkavu3V72QdfvBFWb2TNklqtAldCvqb1ld8maYPttbY0YaRRxvVEFYBOYE/NGQ3Xum96I3WseM3YO6j9R2AYwTibQVsD8JjghdIE0QGE2ov+Ttur8eTVi4gac/RTi3v/bSqrDHWcYVPFxQE0JCeACwuhcPrEgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H246hgXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H246hgXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A81FC433F1;
	Wed, 21 Feb 2024 13:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522097;
	bh=ifzO++2H7GHcOZaXFf3sHiryqyxOHBE7Z785tP+VS4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H246hgXNk5yocJ54/l2JcJiAuWm0xEv8ewaW1Ed4YtSZ73C5Ck+hrIIS2D741NLmc
	 1zizf+xxBTIBKXys7594NDvX94AnqFI1M9sTfuCF9nNBlacAHYjJbPHwsabeJXvz/N
	 KEoAsmgZxNpOsNmTz32UYJs2l2Jk2Qj0nRyYmDNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4a4f1eba14eb5c3417d1@syzkaller.appspotmail.com,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 079/476] btrfs: dont warn if discard range is not aligned to sector
Date: Wed, 21 Feb 2024 14:02:10 +0100
Message-ID: <20240221130010.894539382@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1206,7 +1206,8 @@ static int btrfs_issue_discard(struct bl
 	u64 bytes_left, end;
 	u64 aligned_start = ALIGN(start, 1 << 9);
 
-	if (WARN_ON(start != aligned_start)) {
+	/* Adjust the range to be aligned to 512B sectors if necessary. */
+	if (start != aligned_start) {
 		len -= aligned_start - start;
 		len = round_down(len, 1 << 9);
 		start = aligned_start;


