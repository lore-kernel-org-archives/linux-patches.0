Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D0255D882;
	Wed,  9 Sep 2026 14:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963102; cv=none; b=uO7vZPm4o1EFDijiANGnnfnwJCOjw6UHOWpjX7VysZPc+hr8wi8Xt1r4wRewO4JGZd/gy+s9wJRzsbyWQoyKFfHh0boGOrsM65XVIWWbsPgQxCPTkGtzE5olqjsPFhW35JTD4fvfx4mYRqkj1WyZQ+7LkGyODx4iLaEUW8r0zsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963102; c=relaxed/simple;
	bh=v7pVL4H6EYt9biYT86TexBn3laekfNpIGITgHiXGvCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAn03KYyJQBx0DHZiSsqQ07qdA13SVPW8V0xgcpl3HokIYpmmgq2VOwstaTcVD1iC4Rjz0+ywQ+V7Xx4ESyn80Ni/PFrMCU9uxayva3sQnSTaQ2wo81iBM0Z8E8C/WMWknWSB7wXcBixzBkJGMH2xV5OSi73FS6i2NJxXS6Ws0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntYNQAwi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntYNQAwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4D11F00A3A;
	Wed,  9 Sep 2026 14:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963101;
	bh=tcIFz5lOvr79Jv4Tbp8ZKa6MXbm2v4YfLY9aEBCATVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntYNQAwiXdRNgrkEihRU97ssWHoeEXzqfhg44uV9dgNNvC4fJ8ToIkx8kYVqYFTuT
	 3+3zhv9WocukmxFow3YtUnFMCby98j3One3HSKAB3NSH4xY2PmXROgc7Yndz7ncaNg
	 W3tPw5DjCo/M2LiMGE7SIyR3fPMll/GJtGSaQ6fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Barzilai <amit.barzilai22@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 7.2 484/556] drm/ssd130x: fix column and row end address in partial updates in ssd133x
Date: Wed,  9 Sep 2026 15:42:44 +0200
Message-ID: <20260909134247.540202110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Barzilai <amit.barzilai22@gmail.com>

commit b7fcb70162acd7f15ed20bc64a14c150db34256f upstream.

On partial screen updates, SSD133X controllers expect to get the
rectangle addresses as arguments of the "Set Column Address" and "Set
Row Address" commands. Each command expects the start address and end
address of the row/column in absolute format, however the end
addresses were being sent in a relative format (relative to the start
address).

The relative end addresses work only when the start address is 0. In
those situations, there is no value difference between relative and
absolute addresses.

Fixes: b4299c936d8fd ("drm/ssd130x: Add support for the SSD133x OLED controller family")
Cc: stable@vger.kernel.org
Signed-off-by: Amit Barzilai <amit.barzilai22@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260622122604.32500-4-amit.barzilai22@gmail.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/solomon/ssd130x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -916,12 +916,12 @@ static int ssd133x_update_rect(struct ss
 	 */
 
 	/* Set column start and end */
-	ret = ssd130x_write_cmd(ssd130x, 3, SSD133X_SET_COL_RANGE, x, columns - 1);
+	ret = ssd130x_write_cmd(ssd130x, 3, SSD133X_SET_COL_RANGE, x, x + columns - 1);
 	if (ret < 0)
 		return ret;
 
 	/* Set row start and end */
-	ret = ssd130x_write_cmd(ssd130x, 3, SSD133X_SET_ROW_RANGE, y, rows - 1);
+	ret = ssd130x_write_cmd(ssd130x, 3, SSD133X_SET_ROW_RANGE, y, y + rows - 1);
 	if (ret < 0)
 		return ret;
 


