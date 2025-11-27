Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE7028CF42;
	Thu, 27 Nov 2025 14:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255114; cv=none; b=l1PjK5pFs0aE1+ocISVuhQXYRbgRBQOLoY0naa8mU0SkjHLQ0VtZ/+lX8rPfljYalzGw7f5tqmXZdTtdWjGg9xD61Sui6jO/zkmVAFrDFv9xiKE22ciOKUVgeLZoSM3y8n5HD0rowaoe4URv07y2qYeBeYGtBphNVrvIyIvIB/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255114; c=relaxed/simple;
	bh=BrjBCzY51X+tBpg0WDP+5z38Pk2g319mErVlNiF6AvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K57gf1QrnngfnDCK0sfTVDCsiDaqKfVjd0CHwSlLYHyHUJyPh45siwbCbmPKXr9KOUQK8ZEw329tLOeVEorBsmpZUhTaKtHxeFAEarPb181J3TZVy9UqisSH4iBQTYUlccnDQdXPKcfcX5Go895tvie4epK8i2P6rLY6r2i7GWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKfunen6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKfunen6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5750FC4CEF8;
	Thu, 27 Nov 2025 14:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255114;
	bh=BrjBCzY51X+tBpg0WDP+5z38Pk2g319mErVlNiF6AvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKfunen6Fzfawq0my94ilTUFQlG/Coy/lsbW40PghqLzASGjExLxyXRCJt+ye4LCM
	 7tntHD7mPPNF4Pi2la/aU309urM9HExs6qnI6U2W/Z6dX3UFJB4KbSnDknM9qMq/68
	 vM6p3cCu9sITS/yhbQ+ad034IkamglZwbMw10Tx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 013/112] exfat: check return value of sb_min_blocksize in exfat_read_boot_sector
Date: Thu, 27 Nov 2025 15:45:15 +0100
Message-ID: <20251127144033.215763543@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit f2c1f631630e01821fe4c3fdf6077bc7a8284f82 upstream.

sb_min_blocksize() may return 0. Check its return value to avoid
accessing the filesystem super block when sb->s_blocksize is 0.

Cc: stable@vger.kernel.org # v6.15
Fixes: 719c1e1829166d ("exfat: add super block operations")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Link: https://patch.msgid.link/20251104125009.2111925-3-yangyongpeng.storage@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -452,7 +452,10 @@ static int exfat_read_boot_sector(struct
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
 	/* set block size to read super block */
-	sb_min_blocksize(sb, 512);
+	if (!sb_min_blocksize(sb, 512)) {
+		exfat_err(sb, "unable to set blocksize");
+		return -EINVAL;
+	}
 
 	/* read boot sector */
 	sbi->boot_bh = sb_bread(sb, 0);


