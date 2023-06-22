Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CDC1F959;
	Thu, 22 Jun 2023 16:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31B4C433C8;
	Thu, 22 Jun 2023 16:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687450375;
	bh=usJVo5I+xdOS+40CAA4svVC3yYICHKGcsYVj9V2YNmo=;
	h=From:Date:Subject:To:Cc:From;
	b=Cvr3yZsAODWPS7ysBd/xRvdwx2qXOiyW4dC32Xfg4CsWYOo7O/5wu+6jWAiz/kCLq
	 CO6eqFW2WNDs+kGyVD/KvoUay7OZmRwyOSUi1plh1FrUJ8CCdGBbGuZ+embHvrY27V
	 2VBcClhhnRUcnEE43DQYTSIwZQgCq3gNbDnO73nUZmE5p3MNU7pm3sda7il4Jjjths
	 pmkIdg8Ly1isYAdMpURvK839Achyp1SnMC6rR2O8oYKqP+CkNgs8wQbdcf5wXi3Vyn
	 azbvMnEt3UZvUTxzJAJ6DYeyRi+76WhHHFhu0bJQ3Yc3EK1CYxQFt5BX6RxFttu7gQ
	 OMouSaf5UF/tA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 22 Jun 2023 16:12:41 +0000
Subject: [PATCH] leds: leds-mt6323: Adjust return/parameter types in wled
 get/set callbacks
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230622-mt6323-wled-wincompatible-function-pointer-types-strict-v1-1-6ad256f220e8@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPhylGQC/x2OywqDMBBFf0Wy7oAmRWh/pXSRx6QOmBgyY20R/
 72xy8PlHO6uGCshq3u3q4pvYlpyg+HSKT/Z/EKg0FjpXpt+1AMkGY02sM0YYKPsl1SskJsR4pq
 9NB3KQlmwgnwLMrBU8gLGXGM/hpuO0alWd5YRXLXZT2c/WW7KOZSKkT7/S4/ncfwAi8UpiqIAA
 AA=
To: lee@kernel.org
Cc: sean.wang@mediatek.com, pavel@ucw.cz, matthias.bgg@gmail.com, 
 angelogioacchino.delregno@collabora.com, ndesaulniers@google.com, 
 trix@redhat.com, linux-leds@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3491; i=nathan@kernel.org;
 h=from:subject:message-id; bh=usJVo5I+xdOS+40CAA4svVC3yYICHKGcsYVj9V2YNmo=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDClTitmmJE1V0UmQW5Etd+hbv7FWRJ6W0+n1a6NyROPMH
 /zLirrUUcrCIMbBICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACYSqsvIsLL2uX7jTONiUfG2
 mxZhm1UO8pi8dwrd2SQkeSzzSaL0XkaGnRrbl3F7T7Zm3nxQ2H5thRcDG5c0e0GdoJ3p2S/CU29
 yAQA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang's kernel Control Flow Integrity (kCFI) is a compiler-based
security mitigation that ensures the target of an indirect function call
matches the expected type of the call and trapping if they do not match
exactly. The warning -Wincompatible-function-pointer-types-strict aims
to catch these issues at compile time, which reveals:

 drivers/leds/leds-mt6323.c:598:49: error: incompatible function pointer types assigning to 'int (*)(struct led_classdev *, enum led_brightness)' from 'int (struct led_classdev *, unsigned int)' [-Werror,-Wincompatible-function-pointer-types-strict]
   598 |                         leds->led[reg]->cdev.brightness_set_blocking =
       |                                                                      ^
   599 |                                                 mt6323_wled_set_brightness;
       |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~
 drivers/leds/leds-mt6323.c:600:40: error: incompatible function pointer types assigning to 'enum led_brightness (*)(struct led_classdev *)' from 'unsigned int (struct led_classdev *)' [-Werror,-Wincompatible-function-pointer-types-strict]
   600 |                         leds->led[reg]->cdev.brightness_get =
       |                                                             ^
   601 |                                                 mt6323_get_wled_brightness;
       |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~
 2 errors generated.

While 'unsigned int' is ABI compatible with 'enum led_brightness' (hence
no warning from -Wincompatible-function-pointer-types) and the callers
of these callbacks use/pass the values as 'unsigned int', the mismatch
between the prototype and the called function will trip kCFI at runtime.

Change the types in the implementations to match the prototypes, clearing
up the warning and avoiding kCFI failures.

Fixes: 9bb0a9e0626c ("leds: leds-mt6323: Add support for WLEDs and MT6332")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/leds/leds-mt6323.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-mt6323.c b/drivers/leds/leds-mt6323.c
index e8fecfc2e90a..24f35bdb55fb 100644
--- a/drivers/leds/leds-mt6323.c
+++ b/drivers/leds/leds-mt6323.c
@@ -76,7 +76,7 @@ struct mt6323_led {
 	int			id;
 	struct mt6323_leds	*parent;
 	struct led_classdev	cdev;
-	unsigned int		current_brightness;
+	enum led_brightness	current_brightness;
 };
 
 /**
@@ -451,7 +451,7 @@ static int mtk_wled_hw_off(struct led_classdev *cdev)
 	return 0;
 }
 
-static unsigned int mt6323_get_wled_brightness(struct led_classdev *cdev)
+static enum led_brightness mt6323_get_wled_brightness(struct led_classdev *cdev)
 {
 	struct mt6323_led *led = container_of(cdev, struct mt6323_led, cdev);
 	struct mt6323_leds *leds = led->parent;
@@ -471,7 +471,7 @@ static unsigned int mt6323_get_wled_brightness(struct led_classdev *cdev)
 }
 
 static int mt6323_wled_set_brightness(struct led_classdev *cdev,
-				      unsigned int brightness)
+				      enum led_brightness brightness)
 {
 	struct mt6323_led *led = container_of(cdev, struct mt6323_led, cdev);
 	struct mt6323_leds *leds = led->parent;

---
base-commit: 7bd932d9adbcc5c5370d968bdb0b00385606bf3a
change-id: 20230621-mt6323-wled-wincompatible-function-pointer-types-strict-334f06d92ffb

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

