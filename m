Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D9B3CF42;
	Wed, 21 Feb 2024 14:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525140; cv=none; b=f/f4+s9dqxKUUvELAXk8olm9LTr1098ASFgHUBeqEgapx3/gWe3f2wsJtPMsmy0IDcn6aOzeBj91Bwu2jwv6O9ihWHrIjZ0RKUUF9CDJyLeBRy4DLam7xRv4rB0/1bddWyaWdMiyYH8aMQSjedJNI/kCsoShIRgbZwn4sLiN42s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525140; c=relaxed/simple;
	bh=D6D5zR4q7x+BDJSRCWfZSoRtesi/2fMyD8NkObLwGJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsF/IWNsrxRmcqUqPEU5LChW+eFV6JDB6nmxgAleDyTtX034oVKS8MJV3Q/kG++6A8tDQCzL1+RwiIOwyBAhf642X3QJjSvqanGxn9g76y5mdlAjdAajPO+JXLt8wq4bqeXFSX3idglRdbhwPezSunHc+2P466VV3BsuA8HGx/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etThYVgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etThYVgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64674C433F1;
	Wed, 21 Feb 2024 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525139;
	bh=D6D5zR4q7x+BDJSRCWfZSoRtesi/2fMyD8NkObLwGJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etThYVgq9dgZwWP+FLSFq09UekXoeeAPfn9A1OMF5soBDglmt9PlTR8prNmJfxKOv
	 zFVuKcTQnmjIfHp2BdwYIZR4r/NAwMW9GbCeB9XGNcLS4zBYXgpgxHaUZ99p0riaqq
	 9SVWo1f7JxDXMraKRbGv+GjXrjosrBkfpYdxHJg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4a4f1eba14eb5c3417d1@syzkaller.appspotmail.com,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 044/267] btrfs: dont warn if discard range is not aligned to sector
Date: Wed, 21 Feb 2024 14:06:25 +0100
Message-ID: <20240221125941.399573985@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1243,7 +1243,8 @@ static int btrfs_issue_discard(struct bl
 	u64 bytes_left, end;
 	u64 aligned_start = ALIGN(start, 1 << 9);
 
-	if (WARN_ON(start != aligned_start)) {
+	/* Adjust the range to be aligned to 512B sectors if necessary. */
+	if (start != aligned_start) {
 		len -= aligned_start - start;
 		len = round_down(len, 1 << 9);
 		start = aligned_start;


