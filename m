Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDEE35C6A9;
	Sat, 12 Sep 2026 10:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209559; cv=none; b=GlwvGtAxTviBLGYROQPXAiGBumu6ljbuk1cx+V3RSRpIn3BSqvKmrLQz7InvMyEGuPfGiPU6pnxBK/uGhg7OItDOX4F2fSUfZZxwr2r1aB6M5StIvfhHpuPg9naRxfohq9Ma3iv0uEZ7JD0+MktygKwlx35LfKDejlFmpkSFIt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209559; c=relaxed/simple;
	bh=+BUVok4ZGn3LRPOqzk2gRDvaLNqETp6pEMOIEdg1aLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H70MIoTvvVmQ8AkFOxArnX+uElCXmBNZ4Nmi/Jdd2NsCRBJXzzbbym5smYE5m5cp3XeAldhbv++ziR4w2zCnrfi9CfuzuTgpPfQB0Zu+0wiqPE5ShW2iU0gelUe3qQ3yp9HDmh+0nGWhsTEzlevF+LHbWkTArQRZMa2cixh+ctk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mE5nos7x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mE5nos7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29D01F0089A;
	Sat, 12 Sep 2026 10:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209558;
	bh=2Vmv6QpX+SggTMndDU+JLYPVeYcprrSTvCjH7ZJ2HPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mE5nos7x+8xd8vJeea+N4SFUVOs3n4ikABZOKG7u75XkdXiRelz7wNmYbYwkpk/jl
	 A5u0s2oHyRUoUemreteCfmtr0hiiwYT7QAsT9HU67ETAGSPEugN5G0rAR7Ayt7yOYB
	 eDtT0dDeUpKPdfhjh0W23UGoIZru1uU2swCnd2Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yulin Lu <luyulin@eswincomputing.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0828/1518] pinctrl: eswin: Fix Handling of PIN_CONFIG_PERSIST_STATE
Date: Sat, 12 Sep 2026 08:49:57 +0200
Message-ID: <20260912065642.171371908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yulin Lu <luyulin@eswincomputing.com>

[ Upstream commit f9af1329b98a478f4bba605ec6db429ef0e38d54 ]

The EIC7700 pinctrl driver does not handle PIN_CONFIG_PERSIST_STATE
specifically, and returns -EOPNOTSUPP from the default case.

Since all pins on the EIC7700 SoC are persistent over suspend, the
correct behaviour is to accept this parameter and return success.

Add an explicit case for PIN_CONFIG_PERSIST_STATE that returns 0 to
prevent errors when this parameter is set.

Signed-off-by: Yulin Lu <luyulin@eswincomputing.com>
Fixes: 5b797bcc00ef ("pinctrl: eswin: Add EIC7700 pinctrl driver")
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-eic7700.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-eic7700.c b/drivers/pinctrl/pinctrl-eic7700.c
index ffcd0ec5c2dc6..1e72931feca56 100644
--- a/drivers/pinctrl/pinctrl-eic7700.c
+++ b/drivers/pinctrl/pinctrl-eic7700.c
@@ -423,6 +423,9 @@ static int eic7700_pin_config_set(struct pinctrl_dev *pctldev, unsigned int pin,
 			else
 				value &= ~EIC7700_ST;
 			break;
+		/* All pins are persistent over suspend */
+		case PIN_CONFIG_PERSIST_STATE:
+			return 0;
 		default:
 			return -EOPNOTSUPP;
 		}
-- 
2.53.0



