Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4381917E3;
	Tue, 29 Apr 2025 17:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948430; cv=none; b=qxdKMNfjKpQ3uWq5GizjDi0pZBRX8o6Tl+NhgD4EKblYn+MYlKH1j7IBlw0xosiZkQxy1PF6+lSStKiU5ekvMGz2FhYoHDsfqPEzwRYTxo9O+kjbz/5/exgLKL1Dg9sulcyqjUqxx20FEVDrfD5aic8Bu3O5EmGXSwyotauO2yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948430; c=relaxed/simple;
	bh=maRfzqOD+b228K/eLEm9lD6T7SOwOunx9plPG03dIPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a9/PScw+wlPAHecX9VarKaLRFc16RdRI8V7qCaMRP1OS1KFElaN8a6i1kPyEMJ3WGaXI7O2TASLOjWBH1gZfEqLuwE636OKdp/x30qzPOEvKPdQ90Hmus9h/VtMiorFENQMX0z2FENdVsHNGJE3FddXY9YHpQNsRprlicCVKexU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glSwf0Hp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glSwf0Hp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F59EC4CEE3;
	Tue, 29 Apr 2025 17:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948430;
	bh=maRfzqOD+b228K/eLEm9lD6T7SOwOunx9plPG03dIPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glSwf0HpazeMjA9h0VM+QjKiEApkdt41TUODdw39KKEbqW9ZEmE7dBjDqi3f+XksA
	 OqROwvOI/d6Bthrs0uZgs/QfqkBIQNhEWybeCZcecAjDd5Yv1okK7te9WAf6VV64tL
	 xiCpiKRF3+5/fv8Idu+tmTl1eCTI2cQLTj1JVZ2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 271/280] media: i2c: imx214: Fix uninitialized variable in imx214_set_ctrl()
Date: Tue, 29 Apr 2025 18:43:32 +0200
Message-ID: <20250429161126.223887033@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 38985a25682c66d1a7599b0e95ceeb9c7ba89f84 upstream.

You can't pass uninitialized "ret" variables to cci_write().  It has to
start as zero.

Fixes: 4f0aeba4f155 ("media: i2c: imx214: Convert to CCI register access helpers")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: André Apitzsch <git@apitzsch.eu>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx214.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -840,7 +840,7 @@ static int imx214_s_stream(struct v4l2_s
 {
 	struct imx214 *imx214 = to_imx214(subdev);
 	struct v4l2_subdev_state *state;
-	int ret;
+	int ret = 0;
 
 	if (enable) {
 		ret = pm_runtime_resume_and_get(imx214->dev);


