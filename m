Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AAE6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1E9C433F0;
	Tue, 10 Jan 2023 18:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374704;
	bh=WLIX9uZPuhQcg4fUGQpIkXpTrhlOfSrICHNVNQ/hrws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wttAczijABcgxvSPKn8U98IFm+yXFIJRldO/xLAnh9snuY4n5HXLQ8ftXKR49RnvQ
	 Zndrve5kOitbEU10mSl9f0ArvjRtgYb8Xyk989kKowgEYQixA28hCabmKkNH8JZ1m7
	 7Msh2q3d6jt4ncOTEzVDQyThVlQsiL1HNATKS52g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/159] gpio: pca953x: avoid to use uninitialized value pinctrl
Date: Tue, 10 Jan 2023 19:03:43 +0100
Message-Id: <20230110180020.696706051@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 90fee3dd5bfc1b9f4c8c0ba6cd2a35c9d79ca4de ]

There is a variable pinctrl declared without initializer. And then
has the case (switch operation chose the default case) to directly
use this uninitialized value, this is not a safe behavior. So here
initialize the pinctrl as 0 to avoid this issue.
This is reported by Coverity.

Fixes: 13c5d4ce8060 ("gpio: pca953x: Add support for PCAL6534")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index ebe1943b85dd..bf21803a0036 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -473,6 +473,9 @@ static u8 pcal6534_recalc_addr(struct pca953x_chip *chip, int reg, int off)
 	case PCAL6524_DEBOUNCE:
 		pinctrl = ((reg & PCAL_PINCTRL_MASK) >> 1) + 0x1c;
 		break;
+	default:
+		pinctrl = 0;
+		break;
 	}
 
 	return pinctrl + addr + (off / BANK_SZ);
-- 
2.35.1



