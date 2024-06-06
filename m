Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8723196C9F;
	Thu,  6 Jun 2024 14:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682977; cv=none; b=amr0Sq8rrdyAi12G+whzY+kweWuJdKVzI/lT3gOpRG/UYxSWMi/EbH9tahlj9XhvHqx9+SWxpIbiBVLyTNYG2L89Y+RjhltmquvmfogwTtXn6ktHkWrPV41Y5M3gDHv8V7eycYb2UVh6f/42FJinrwTcVm0YBiVre6scn3krQLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682977; c=relaxed/simple;
	bh=R+FWY2vJjHuQ2xTaROQDiQgk1lcEzcOAxAYoaoKrEZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyaI1/NT+oQjHPubgUCBigfU93qodbJKaCasDBLfxicOch+pwlzdtHUnaVIQ1EmTimcycMN6sbFApInsHsyzxPAEV8sBeHlfuSiw0VyyATy7mt3mVarVdWVJ+YK8nYKUuUNaLn1+uN4QMHzpLSHEA6Wprkkl0A29dzbzy0j2Fkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBbjgmfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBbjgmfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BA9C2BD10;
	Thu,  6 Jun 2024 14:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682977;
	bh=R+FWY2vJjHuQ2xTaROQDiQgk1lcEzcOAxAYoaoKrEZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBbjgmfIDPYR7qWI9mP1ZQQUWFIBcwFJJ3aEH9JFv8/inrN1nmL5hCMgCklprsFzI
	 zBLHre54SuOP/Z1DaJfnsU82VW0BSL04fTNsJk9G7jm4+gfuTf+VGQcsa7Zsw8ar/K
	 isJPHD0q/+gNWfzMbjS3M4+uAlBCcQqucmihF+xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <quic_fenglinw@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 156/374] Input: pm8xxx-vibrator - correct VIB_MAX_LEVELS calculation
Date: Thu,  6 Jun 2024 16:02:15 +0200
Message-ID: <20240606131657.142112821@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenglin Wu <quic_fenglinw@quicinc.com>

[ Upstream commit 48c0687a322d54ac7e7a685c0b6db78d78f593af ]

The output voltage is inclusive hence the max level calculation is
off-by-one-step. Correct it.

iWhile we are at it also add a define for the step size instead of
using the magic value.

Fixes: 11205bb63e5c ("Input: add support for pm8xxx based vibrator driver")
Signed-off-by: Fenglin Wu <quic_fenglinw@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240412-pm8xxx-vibrator-new-design-v10-1-0ec0ad133866@quicinc.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/pm8xxx-vibrator.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/pm8xxx-vibrator.c b/drivers/input/misc/pm8xxx-vibrator.c
index 5c288fe7accf1..79f478d3a9b37 100644
--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -13,7 +13,8 @@
 
 #define VIB_MAX_LEVEL_mV	(3100)
 #define VIB_MIN_LEVEL_mV	(1200)
-#define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV)
+#define VIB_PER_STEP_mV		(100)
+#define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV + VIB_PER_STEP_mV)
 
 #define MAX_FF_SPEED		0xff
 
@@ -117,10 +118,10 @@ static void pm8xxx_work_handler(struct work_struct *work)
 		vib->active = true;
 		vib->level = ((VIB_MAX_LEVELS * vib->speed) / MAX_FF_SPEED) +
 						VIB_MIN_LEVEL_mV;
-		vib->level /= 100;
+		vib->level /= VIB_PER_STEP_mV;
 	} else {
 		vib->active = false;
-		vib->level = VIB_MIN_LEVEL_mV / 100;
+		vib->level = VIB_MIN_LEVEL_mV / VIB_PER_STEP_mV;
 	}
 
 	pm8xxx_vib_set(vib, vib->active);
-- 
2.43.0



