Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A781DA38;
	Mon,  2 Oct 2023 17:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C52C433C8;
	Mon,  2 Oct 2023 17:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696269200;
	bh=iNML46xP65XC6ISNmO+ehHzGf5XVNd60+CDz49bWbSo=;
	h=From:Date:Subject:To:Cc:From;
	b=k2Fcjo2dXCk/kG1Iope32OBNxU8BJA8VfAycpsMzWbB6aRnZ9WomnOQdyQSD/I2rW
	 Py79YM+Ugs8m2zhTgUJPuFPHaANmOMkFTsBOmZXMgmK38dchRIxWxtpZ+ia3va1+MH
	 2MnfOKeK2z4lEjOrAgAMVFhc2x83YDvWw7u9oNKofFw7/bFJuPLWjEKovjh/qwM/TJ
	 FPKZaz/TDQ5KRdGpgogK9ihlosXYIEqBj0cA45uZyd5MKVsPRJx3ktAGZ9QX7Us3dE
	 z6eXguGrDkDwuaGjQpMaiBnNsue+HLXQxrzHi29XWe4y0Nk4g2ck7A0U3APF/RM/N1
	 Xipt0yIiixGdQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 02 Oct 2023 10:53:13 -0700
Subject: [PATCH] vfio/cdx: Add parentheses between bitwise AND expression
 and logical NOT
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIgDG2UC/x3NMQqAMAxA0atIZgO1gopXEYfYphqQVhoRQby7x
 fEt/z+gnIUVxuqBzJeopFjQ1BW4jeLKKL4YrLFtY4zFK0hC52/c0yqOdozpxIMyx3NjZUVyNIT
 Fd4vtByiZI3OQ+19M8/t+IV6jxHIAAAA=
To: nipun.gupta@amd.com, nikhil.agarwal@amd.com, alex.williamson@redhat.com
Cc: ndesaulniers@google.com, trix@redhat.com, shubham.rohila@amd.com, 
 kvm@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1912; i=nathan@kernel.org;
 h=from:subject:message-id; bh=iNML46xP65XC6ISNmO+ehHzGf5XVNd60+CDz49bWbSo=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKnSzP0bGk59mG7IbX93jVXSkmjVBKYeNZmIFGFjDq0Dv
 j+thDI7SlkYxDgYZMUUWaofqx43NJxzlvHGqUkwc1iZQIYwcHEKwEQ0njL8s3kwYVp+xr3UM2u9
 Yw5Hpx/iqmqtuegZLGi2e8nPrM1B2xgZblqduyV9Zvl+zjlTf76JT0kLn9HGqOst9cZ36zzhw5k
 WXAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with clang, there is a warning (or error with
CONFIG_WERROR=y) due to a bitwise AND and logical NOT in
vfio_cdx_bm_ctrl():

  drivers/vfio/cdx/main.c:77:6: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
     77 |         if (!vdev->flags & BME_SUPPORT)
        |             ^            ~
  drivers/vfio/cdx/main.c:77:6: note: add parentheses after the '!' to evaluate the bitwise operator first
     77 |         if (!vdev->flags & BME_SUPPORT)
        |             ^
        |              (                        )
  drivers/vfio/cdx/main.c:77:6: note: add parentheses around left hand side expression to silence this warning
     77 |         if (!vdev->flags & BME_SUPPORT)
        |             ^
        |             (           )
  1 error generated.

Add the parentheses as suggested in the first note, which is clearly
what was intended here.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1939
Fixes: 8a97ab9b8b31 ("vfio-cdx: add bus mastering device feature support")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/vfio/cdx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
index a437630be354..a63744302b5e 100644
--- a/drivers/vfio/cdx/main.c
+++ b/drivers/vfio/cdx/main.c
@@ -74,7 +74,7 @@ static int vfio_cdx_bm_ctrl(struct vfio_device *core_vdev, u32 flags,
 	struct vfio_device_feature_bus_master ops;
 	int ret;
 
-	if (!vdev->flags & BME_SUPPORT)
+	if (!(vdev->flags & BME_SUPPORT))
 		return -ENOTTY;
 
 	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,

---
base-commit: fcb2f2ed4a80cfe383d87da75caba958516507e9
change-id: 20231002-vfio-cdx-logical-not-parentheses-aca8fbd6b278

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

