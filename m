Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D07C5650F4;
	Wed,  9 Sep 2026 14:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962652; cv=none; b=gUjUjVvVuStICbVyYY3bBaKQkZa1fMv/KhUNSvDstP64OxR+lzsoxY/kKvw8gAUh+wSeiSnEzxf2kC/0nxRQGxSSRmLPtpcSL73lYlo6Gg0lqrL7z3ljLr3l0xdrowR9MeXauIH00CtWzGFf+AORk6Mj6UpIOa2UZ15rCCe7jrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962652; c=relaxed/simple;
	bh=rmDwrYPY3PUazPdDA3Gwofg2ey5/JfBddcfKkTuzcdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLUXRFHvG66staYmj2SsoSdC+5JMqfGMV8Nbu/9hK39sHp6ikiF/NHjWcSLVEBLXVym9VsetF3QzBb7N8XSUqRE0jQIGWL9PDym9wUQcBreaYas2XTIumLwS0oR13ppiJL4L7rRt5zMwIfCOY2DvXeXh1syUSxa+uWYcb7zQ9Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGgjWxZd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGgjWxZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C88B1F00A3A;
	Wed,  9 Sep 2026 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962651;
	bh=jMvcft43R+I4yEUNA6IGg+aXL75gE97h/IEq/gh34rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGgjWxZdb9tPKcPP1OMI6YLKSuN7cJ2PyJf+ViKEmrVBWIe/Y6L19O+NlvH9wCuFl
	 K0NWlGSuLmxTH1bykh5urHZ55hlgkMIsE4tahk399wtDWJkdqS549sEkjHX8bdtIOD
	 zN19tF7LfOs9NJ+bdGrFxs38bxtWRNNRhIhZq4Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Riesch <michael.riesch@collabora.com>,
	Narasimharao Vadlamudi <ahmisaranrao@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 364/556] media: i2c: imx415: Return test pattern write errors
Date: Wed,  9 Sep 2026 15:40:44 +0200
Message-ID: <20260909134243.476330249@linuxfoundation.org>
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

commit 8cd5735b88d76dda80b089031747b6f18ee0bca2 upstream.

imx415_set_testpattern() accumulates failures from cci_write(), but drops
the value and always returns success. Return the accumulated error so V4L2
reports failures to userspace.

Fixes: d5df1c7f3f83 ("media: i2c: imx415: Convert to new CCI register access helpers")
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
@@ -686,7 +686,7 @@ static int imx415_set_testpattern(struct
 		cci_write(sensor->regmap, IMX415_DIG_CLP_MODE, 0x01, &ret);
 		cci_write(sensor->regmap, IMX415_WRJ_OPEN, 0x01, &ret);
 	}
-	return 0;
+	return ret;
 }
 
 static int imx415_s_ctrl(struct v4l2_ctrl *ctrl)


