Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD06E2D60A;
	Tue, 14 May 2024 11:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687146; cv=none; b=JiJjOdTJ4S/JPPG3ETyo8mMcG3era7Wn6CqulO33Qys37iKGIV72ue/m4MScfUVwByBNKjM7bz8PTSyrQQ9CPLYpdg2+PiLsyjCSH3bA9AjBH4Ihktd6sKdqtUr88FNjfjb3XzMDqp6VhuNm+X0n2qc7PwpCo/s3jRB7PeIU5Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687146; c=relaxed/simple;
	bh=/6mnjBJ2fMyJ8by4DQGbJ9Fp6u/Wew/O69v4aQ/TnLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUG4BCnJ6Vjvdp1Nn3t5Zuk+zD2v/tm1HsSj0qg5Tqm4w2g9CnMdjZEsihqvLChMU8duvZ+lG7ERAFAZFmyC8xj9jAFt+H/KEFRA5S75ygCKFdSug8YO+FP0Gd9jDkIN+fk2B6SaYwqJ/UAAY70WFn5JOWT/Iu+UqMaMVDq4w3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4IF33t3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4IF33t3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A7AC32782;
	Tue, 14 May 2024 11:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687146;
	bh=/6mnjBJ2fMyJ8by4DQGbJ9Fp6u/Wew/O69v4aQ/TnLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4IF33t3Mwt9gRe4A7geRHfFnt04heYoFy3Ozu+G+ZLFtPlZr0PJEDAdZPR/NXeGt
	 +IWxm2gnVYVi1ea9wk4/bh7zpOdLmhP/LU4eBBH7UqVMKKKLacmAo2NmC7oVUnPXry
	 i7s9hhlKhKrF0rBy++Rqe2lW1m4tdkc29azlwx+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Zhiyong Tao <zhiyong.tao@mediatek.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 81/84] pinctrl: mediatek: Fix fallback behavior for bias_set_combo
Date: Tue, 14 May 2024 12:20:32 +0200
Message-ID: <20240514100954.731555009@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Yi Wang <hsinyi@chromium.org>

commit 798a315fc359aa6dbe48e09d802aa59b7e158ffc upstream.

Some pin doesn't support PUPD register, if it fails and fallbacks with
bias_set_combo case, it will call mtk_pinconf_bias_set_pupd_r1_r0() to
modify the PUPD pin again.

Since the general bias set are either PU/PD or PULLSEL/PULLEN, try
bias_set or bias_set_rev1 for the other fallback case. If the pin
doesn't support neither PU/PD nor PULLSEL/PULLEN, it will return
-ENOTSUPP.

Fixes: 81bd1579b43e ("pinctrl: mediatek: Fix fallback call path")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Zhiyong Tao <zhiyong.tao@mediatek.com>
Link: https://lore.kernel.org/r/20210701080955.2660294-1-hsinyi@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -877,12 +877,10 @@ int mtk_pinconf_adv_pull_set(struct mtk_
 			err = hw->soc->bias_set(hw, desc, pullup);
 			if (err)
 				return err;
-		} else if (hw->soc->bias_set_combo) {
-			err = hw->soc->bias_set_combo(hw, desc, pullup, arg);
-			if (err)
-				return err;
 		} else {
-			return -ENOTSUPP;
+			err = mtk_pinconf_bias_set_rev1(hw, desc, pullup);
+			if (err)
+				err = mtk_pinconf_bias_set(hw, desc, pullup);
 		}
 	}
 


