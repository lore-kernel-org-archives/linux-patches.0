Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F352DC783;
	Mon, 17 Aug 2026 14:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977001; cv=none; b=Np42ZG4s1vl4q70LNgnqPbHu6oSgYYKXg1Tu4ovVhMgKS0ffdPAsfVqFfHK0nB2kG2pa2n6NQEiaOpBA3uceS9QVbxB3A4VSw6EVzZgdUgIqHS0CRAxOuIl+Jxd4uRpbSifk5RIzJVU55k1OK907t93lGpaYM++utJP87D6EkFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977001; c=relaxed/simple;
	bh=JuvfiJ1yUBL7Q2oRb4FBcDifjUXmeU9ezeX5af0F2uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePLCpdI66DF+fpcER2NUGVojBkknNacVvCfpGMKrfR9V/qllOGD71f25GEx2x0acI2xm4ttwLhQ+nNHHsw/EHlP8MS6TSUvnJpYvXyNiS0uGQQa0yHpfnXor2wdlDp2cl/hGLqSXIE+mt6J8LGZyOnou52K3a93TOmjiTgn9Xiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlnwKEMY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlnwKEMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70691F00A3D;
	Mon, 17 Aug 2026 14:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976997;
	bh=/JXBoyNGGVVCArP7N0J7ALriDXgfBIuf+0RuHLANtyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlnwKEMYBt+iOwh1/9widTowMNCK3+vxYap4mavq2R+rECG0rNo4wE97CC6+OYsyT
	 JkVLWDhlXzeGYcsXYGZ0Hrufek8/tY3OIw8X8xQlamaCGwIamDBaqTeR9BLxS3P4Rv
	 3V64dI1m34WiZpUXF1NTidAO0oJqtlQ72BcK8Xkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 176/456] media: vimc: fix reference leak on failed device registration
Date: Mon, 17 Aug 2026 15:29:26 +0200
Message-ID: <20260817132547.003726626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 33e2b833c66b890a0d71c4fa82d4c97143f7f75f upstream.

When platform_device_register() fails in vimc_init(), the embedded
struct device in vimc_pdev has already been initialized by
device_initialize(), but the failure path returns the error without
dropping the device reference for the current platform device:

  vimc_init()
    -> platform_device_register(&vimc_pdev)
       -> device_initialize(&vimc_pdev.dev)
       -> setup_pdev_dma_masks(&vimc_pdev)
       -> platform_device_add(&vimc_pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 4babf057c143f ("media: vimc: allocate vimc_device dynamically")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vimc/vimc-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/test-drivers/vimc/vimc-core.c
+++ b/drivers/media/test-drivers/vimc/vimc-core.c
@@ -350,6 +350,7 @@ static int __init vimc_init(void)
 	if (ret) {
 		dev_err(&vimc_pdev.dev,
 			"platform device registration failed (err=%d)\n", ret);
+		platform_device_put(&vimc_pdev);
 		return ret;
 	}
 


