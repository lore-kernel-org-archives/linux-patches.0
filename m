Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373F82BEFF5;
	Tue, 21 Jul 2026 20:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667116; cv=none; b=QzzYX47Ys3hcA2FuBB72BcHqzSdRrYLDl2oUfgf2eHYtqpiFCO1cbxV0j0+N/57BZ8/OH/t3cAkOF2WwkdT4qF8Ou2cV28Yt/hdIY+TNO7G5WWLjEQxPTUS/snJFPGZhg1yIfEU2aer+K7S6oxhFT4BjJlC1x1yAxOv9WZWQnuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667116; c=relaxed/simple;
	bh=KrQA5YO1d0VUtfN/kN1/IixuAKbPqM5aZMSYip2S2fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePVeamFY4LFfHfc5cOKJp/Z8gVm+MmGwd9OnNVLKPE1EmsUfjwiwKGP8mRwKAJvZavsmGVmixyXT5mxuVne04WoaN105BMDnnHk6A/V2kjkxr5PS77VNhsMG8JsReGy+92TRNw7Xr1biv/oTWzbv16Wz7veBbDDf00ElUlkrDHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oO5LmRBc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oO5LmRBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988961F000E9;
	Tue, 21 Jul 2026 20:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667115;
	bh=izidjtwA+mSC9TpVAGPh/cdQIsvcV7wqcnHW4IGVnH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oO5LmRBcBcsH6rg1sZX9+VwRaEAGkUvtaOHVhBOscBNZOUok5p2idyF3xOXKdHGgp
	 fMSZXv/3+bqk9OSMOcidy2QuQ8PVoFqgrcFKTJC4jSX1PTgkIJ6i3+wZ7xqLyJTwb1
	 qw7b0bT6vClZYLHUprc8D87Jl8RADG+MUeLp5Si4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 0939/1266] mfd: sm501: Fix reference leak on failed device registration
Date: Tue, 21 Jul 2026 17:22:56 +0200
Message-ID: <20260721152502.847076522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 8c2f0b42fc252e1bf1c7746447091a468e784ca1 upstream.

When platform_device_register() fails in sm501_register_device(), the
embedded struct device in pdev has already been initialized by
device_initialize(), but the failure path only reports the error and
returns without dropping the device reference for the current platform
device:

  sm501_register_device()
    -> platform_device_register(pdev)
       -> device_initialize(&pdev->dev)
       -> setup_pdev_dma_masks(pdev)
       -> platform_device_add(pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: b6d6454fdb66f ("[PATCH] mfd: SM501 core driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260415162627.3558789-1-lgs201920130244@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/sm501.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -747,9 +747,11 @@ static int sm501_register_device(struct
 	if (ret >= 0) {
 		dev_dbg(sm->dev, "registered %s\n", pdev->name);
 		list_add_tail(&smdev->list, &sm->devices);
-	} else
+	} else {
 		dev_err(sm->dev, "error registering %s (%d)\n",
 			pdev->name, ret);
+		platform_device_put(pdev);
+	}
 
 	return ret;
 }


