Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19011448DC;
	Thu, 13 Jun 2024 11:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278911; cv=none; b=LwFXDIkrXClEF7tXUSorzt9nbOnmCb9RA2B/gYBNoDbJJ5ugu7bQGvHcIcVWjsscBF1tiV4F9cIUfWrePj8tWZe6gSpxg6jMtjRt88GWILzCsz2oAUDWCZjHYH3hZ7PX/EJONZl0V0QRdldI17v1wIuKdoWw/V8P14IPmLY0GNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278911; c=relaxed/simple;
	bh=hxxNKKHSibE1Ix1wHKljbN2vstLQjhZhuhqs5jDNHls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nh1/AhFhYVDNAumaZHHyYAnNrOkLZEdSqR2o0vc8LeAg9MbwsoCT+DZBzLc68h9qXRZpZ9pKpubcoGVK+F2SFeZlqS1DxGtUwY1dsJZ/Ud01JmeRI0Vc6++6zD29yaJj7PS+c/YN+ABG4P9Whg/DsWHVTJlDUU+XIbI+/LVLJZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnreuoVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnreuoVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EACC32786;
	Thu, 13 Jun 2024 11:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278911;
	bh=hxxNKKHSibE1Ix1wHKljbN2vstLQjhZhuhqs5jDNHls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnreuoVD8YuNYJLP7YeoKz4KsFLDYz+asICPHaZmF2HyBD6eWD9ZRofW4bByisTn7
	 w3GbwdvpGScGvpVdU4Yhm+mZj9pzee2ngB/apJ1QUyF0s8h/gx1m92s8wMA9csqOrt
	 dBKJCu5MJlXXLy3I2Y0Pnij26SdB30wZRXJf55Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <quic_fenglinw@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/213] Input: pm8xxx-vibrator - correct VIB_MAX_LEVELS calculation
Date: Thu, 13 Jun 2024 13:32:38 +0200
Message-ID: <20240613113232.244856922@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 27b3db154a33f..97bf7d94e8c6e 100644
--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -22,7 +22,8 @@
 
 #define VIB_MAX_LEVEL_mV	(3100)
 #define VIB_MIN_LEVEL_mV	(1200)
-#define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV)
+#define VIB_PER_STEP_mV		(100)
+#define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV + VIB_PER_STEP_mV)
 
 #define MAX_FF_SPEED		0xff
 
@@ -126,10 +127,10 @@ static void pm8xxx_work_handler(struct work_struct *work)
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



