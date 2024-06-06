Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15071BA874;
	Thu,  6 Jun 2024 14:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683481; cv=none; b=bIiqdad7Ua0m7XfdLXL5947FknBuC8zK0AgsjOVWFeNZUf+o/NgUpgWntU9FZVv9vo/JwGnt3KkjF/jO9b+8UpgAEXE4VlbTBpOqnCimy7YmfQj9+2cOZCo//TGP3sCrKiYrQqwDwKM+qfM7i6RkYE9qfP7kHZwyfst9TYxSTGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683481; c=relaxed/simple;
	bh=76JM6Uzf8BjV17p8saz58Lryn17HXoihSFihPt0Zk6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eF4CPuTInQF/ituMhEKZrRyB1eCwzNhl4RKnnapvRtZkMXhnEvGe9d7gHkRhTYx8CF//lCuvoIr1dDSy7cAj9Fp9ltkGmyyKC71CzrEnsdAcktLcAJOW64vU4A0BSXGS4xcNrne13+CAVjSo3yPdDqnghC18RBN6wUOozCkcpeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NA6FA03F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NA6FA03F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D133AC2BD10;
	Thu,  6 Jun 2024 14:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683480;
	bh=76JM6Uzf8BjV17p8saz58Lryn17HXoihSFihPt0Zk6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NA6FA03Fw1Uj7f7CrEwvj+tjojetgz8GVxDDCilR10+5tl64f5BSWvbGJ0r4gLCPo
	 vRQZk0Lw9xVRuAqgMrH9mT00pUesrtsZiD1ofQkvJ29PSD6JLBhSbySGOatFOFBEFZ
	 mHMY7X6jS5Ea369iW38klTdKTYL8ay+C21WIU9Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <quic_fenglinw@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 367/473] Input: pm8xxx-vibrator - correct VIB_MAX_LEVELS calculation
Date: Thu,  6 Jun 2024 16:04:56 +0200
Message-ID: <20240606131712.036860265@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 53ad25eaf1a28..8bfe5c7b1244c 100644
--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -14,7 +14,8 @@
 
 #define VIB_MAX_LEVEL_mV	(3100)
 #define VIB_MIN_LEVEL_mV	(1200)
-#define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV)
+#define VIB_PER_STEP_mV		(100)
+#define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV + VIB_PER_STEP_mV)
 
 #define MAX_FF_SPEED		0xff
 
@@ -118,10 +119,10 @@ static void pm8xxx_work_handler(struct work_struct *work)
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



