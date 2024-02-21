Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A833EA71;
	Wed, 21 Feb 2024 13:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521161; cv=none; b=nCUoFlck8X5PJ5jaXMW6Sok/tl975FTOvetI6DiPimpV2pHRGtAW42j0dKltzgzzcSlqsM3hnK22+coOvWWoRCk4Ms8fred+En4PU5Yw535o9ZG4WwsgnfeW/4vgzO45uS3TVY1wWCACDbkiFiMLmURbvDIbLOFT7fwtMZR164k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521161; c=relaxed/simple;
	bh=9xgF1jwVIz+LKKLuxQOtL3galtLgrxyao6aIPIOMZmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLXwh8vJ6QO6NfCI9/W8pe6aAvYIxvQ+eTAwyYSyny/7lry384p3xV/w1a+G2EI5SFZVsL+RrDOjKnyrnLtbseBYH87U72X1VrX8f5AjBSbmhkWn1mw9dYUEaTY40AOXwp5Qk2uN4DCP2C9oX5qLNibJnaeZghS2oO5q+1FslOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cm+Ms9Or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cm+Ms9Or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354E7C433C7;
	Wed, 21 Feb 2024 13:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521160;
	bh=9xgF1jwVIz+LKKLuxQOtL3galtLgrxyao6aIPIOMZmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cm+Ms9OrRfXoleyLRkgWwo9Mb8nMbh5w4fyZkOgt101iHM0dPKEpFqckeKcyO2KzO
	 4B/olt2UmtmFQovI3c1JwRdtrx62RC/vbBBHD4csf7CmU83zW8yq4cayAqp7bovHBE
	 8kOkU2TnZUK/cD/xKefoyUKeya9Xs74EtunnzAMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4a4f1eba14eb5c3417d1@syzkaller.appspotmail.com,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 037/202] btrfs: dont warn if discard range is not aligned to sector
Date: Wed, 21 Feb 2024 14:05:38 +0100
Message-ID: <20240221125932.994768544@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1899,7 +1899,8 @@ static int btrfs_issue_discard(struct bl
 	u64 bytes_left, end;
 	u64 aligned_start = ALIGN(start, 1 << 9);
 
-	if (WARN_ON(start != aligned_start)) {
+	/* Adjust the range to be aligned to 512B sectors if necessary. */
+	if (start != aligned_start) {
 		len -= aligned_start - start;
 		len = round_down(len, 1 << 9);
 		start = aligned_start;


