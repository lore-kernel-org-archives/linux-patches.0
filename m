Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1D85678F9;
	Wed,  9 Sep 2026 14:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962649; cv=none; b=O+3xnhUY0PfV/b6L+FtWVZmp3UTO9wwNDKm9kgZK6BRJx6mflazYyhqENszQIoUVjJo65+wvq08GJUNR8Ee4k6JFmaHgGjSV7OsDJopyMe2vdFbe37XCoTIGPl8NqdPfaL+IHTpji1yTEqq5Xmt5VEF9dgwkACGPXwzeqta5siU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962649; c=relaxed/simple;
	bh=iKfyFmpotJqjqEYI056CcfaMEQD8AdZwZfRQ0r9SHkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXCc/qEyhB+SyoaZaPXTfzNPhGGBCMK/SPZMfulODHPO/gr22v8oTeoxZIAs6AIk6rOU9tF+TT4Wv0r6PZXPHf8OvWw+JeaxiimAKEimEPWJ4pFdFxYy5KIKmrpNYhe4SxiF4/RgnXwfx6E+22zD3t8uMgdRwZanBM855p8Wdbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zX6be7P3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zX6be7P3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44A51F00A3D;
	Wed,  9 Sep 2026 14:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962648;
	bh=MChhDQIl54EvQdrGUHbL0RNZHOmvmWgBPq1CDLfjQtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zX6be7P376N5g2wkHRLcdyo/7yjxGUFfcLmszBIOi8ZDOEG7aygdsYCp8m6F9svh4
	 YUHaxy51KC1dCkVhzwBaTwoFABmWHDgPUUcHgV5t8YpQFZr9YmnQr4qBYBhfTg61eF
	 CKwYEUtYBb5rn4GiiOepM7oTCgJrGlo/rUwe6Zxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Riesch <michael.riesch@collabora.com>,
	Narasimharao Vadlamudi <ahmisaranrao@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 363/556] media: i2c: imx415: Release runtime PM reference on VBLANK error
Date: Wed,  9 Sep 2026 15:40:43 +0200
Message-ID: <20260909134243.440826361@linuxfoundation.org>
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

From: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>

commit bea3001e0f32527a291444e527e84a7ea9b546d4 upstream.

The VBLANK path returned immediately when programming VMAX failed after
pm_runtime_get_if_in_use() had taken a runtime PM reference. Break out of
the switch instead so the common pm_runtime_put() path is used.

Fixes: 3bcae55ab96a ("media: i2c: imx415: Add read/write control of VBLANK")
Cc: stable@vger.kernel.org
Reviewed-by: Michael Riesch <michael.riesch@collabora.com>
Signed-off-by: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx415.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx415.c
+++ b/drivers/media/i2c/imx415.c
@@ -720,7 +720,7 @@ static int imx415_s_ctrl(struct v4l2_ctr
 		ret = cci_write(sensor->regmap, IMX415_VMAX,
 				format->height + ctrl->val, NULL);
 		if (ret)
-			return ret;
+			break;
 		/*
 		 * Exposure is set based on VMAX which has just changed, so
 		 * program exposure register as well


