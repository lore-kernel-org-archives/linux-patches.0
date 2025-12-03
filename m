Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CA235C193;
	Wed,  3 Dec 2025 16:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780126; cv=none; b=KzgS7GEi/kXfTZgWEj85EzaDXPOzadYBTM3WeLueZJekaOiIhj0b7HPmbK+ALlDmOncymQLQl55bMjU9n61upmd+hIrGwIQ+w1oYVbrlW+7OVLfd3sBEjFM+Uya+I6dYcuR9k/kg7qVlKLIzRom9A8l5LD4qG0GpF7hjj543ZyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780126; c=relaxed/simple;
	bh=JZS7YiEBI0yALU2Amm207KETagVm6OfNHKidTGFx2vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOtsxATCl3nzDJkIw2nP7iUDCHuJNk49Gg8UWmiqu58FowNZtQ2OCdaASKmSRwfKI9L1NESe2MS93zE4wlIBkuYHnHTLR5KNA2pzsIvo6L3YD14cmSFo/+2E0yaKGsKcTDxIGV4sc3JUiQXoIEWtuIwVuEun/dVqpHGVKj7KFVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BD4GU9Bz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BD4GU9Bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FB3C4CEF5;
	Wed,  3 Dec 2025 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780126;
	bh=JZS7YiEBI0yALU2Amm207KETagVm6OfNHKidTGFx2vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BD4GU9Bz5+tq6PLgOxB6n7CGr0O2ZOq8RGVvttyGbR5lVrIgfisUPwdJ0SNcwJes0
	 1WTqlyIzMM0f3JFPnT75pggDQ1ue1hPuCCsnJTirarbM0MLLEKcOWEjhwGBtCBfIPd
	 StdPBV/dnEjhzcgiT5ubFz7hguUrI1Q3pcG5T9qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 431/568] exfat: check return value of sb_min_blocksize in exfat_read_boot_sector
Date: Wed,  3 Dec 2025 16:27:13 +0100
Message-ID: <20251203152456.480798477@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -425,7 +425,10 @@ static int exfat_read_boot_sector(struct
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
 	/* set block size to read super block */
-	sb_min_blocksize(sb, 512);
+	if (!sb_min_blocksize(sb, 512)) {
+		exfat_err(sb, "unable to set blocksize");
+		return -EINVAL;
+	}
 
 	/* read boot sector */
 	sbi->boot_bh = sb_bread(sb, 0);


