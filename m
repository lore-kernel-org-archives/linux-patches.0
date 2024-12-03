Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350361DAC9F;
	Tue,  3 Dec 2024 15:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241061; cv=none; b=uo/W/UVRlsoFulrBpFC8O8ZHbzN6EHAHcl3wNQUQwVCgQQDK35+cWYNQ0yUOyjczPu4AitxIxWFQrI616Qt2VEAjwpIYNlsVpZOjtUh7jw4ANzwD1orFhVUPFlAfp3klbrhrLOX1b77KEBXPmgA1/VP48YevnyCoT/5jNVi7cr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241061; c=relaxed/simple;
	bh=LCYWnrTGIkTsn6WbrvZzITspvJjnQ/B9TjNEqGcm5L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aMpRJSzA98MW4sywDpYQafIs9HcOk7wQqnNXJMGClXbrHPLL9KQFWe+v4yGASAZX1y9u8dCIJrENq2AvQ5yARc1oj/4nj+wUjvg+3MBgnXDUX5h0anxNG+XUAHhov1k+bWJdadA0St/wmTWslXPoF7rTak3Oj3m/wORjmsMWbVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ti//aJJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ti//aJJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C76C4CECF;
	Tue,  3 Dec 2024 15:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241061;
	bh=LCYWnrTGIkTsn6WbrvZzITspvJjnQ/B9TjNEqGcm5L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ti//aJJBJdCmWbeAvxgu0fdPfWdUaH2ciyvvKWMHVXT7+OpswLpJCE1Uqtax9fk/2
	 /4SjzWFVWysRbtzICBRLkj19V1wfgBfVyFBOa7WA8LvtaJbleN5dFwhQOMIYC9qKUd
	 nU2L50OXTPDO9jlbwVIuj6CSHXFOsaObwiEvvMx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/826] drm/panthor: Fix OPP refcnt leaks in devfreq initialisation
Date: Tue,  3 Dec 2024 15:40:33 +0100
Message-ID: <20241203144755.699779649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 21c23e4b64e360d74d31b480f0572c2add0e8558 ]

Rearrange lookup of recommended OPP for the Mali GPU device and its refcnt
decremental to make sure no OPP object leaks happen in the error path.

Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Fixes: fac9b22df4b1 ("drm/panthor: Add the devfreq logical block")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241105205458.1318989-2-adrian.larumbe@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_devfreq.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_devfreq.c b/drivers/gpu/drm/panthor/panthor_devfreq.c
index 9d0f891b9b534..ecc7a52bd688e 100644
--- a/drivers/gpu/drm/panthor/panthor_devfreq.c
+++ b/drivers/gpu/drm/panthor/panthor_devfreq.c
@@ -163,13 +163,6 @@ int panthor_devfreq_init(struct panthor_device *ptdev)
 
 	cur_freq = clk_get_rate(ptdev->clks.core);
 
-	opp = devfreq_recommended_opp(dev, &cur_freq, 0);
-	if (IS_ERR(opp))
-		return PTR_ERR(opp);
-
-	panthor_devfreq_profile.initial_freq = cur_freq;
-	ptdev->current_frequency = cur_freq;
-
 	/* Regulator coupling only takes care of synchronizing/balancing voltage
 	 * updates, but the coupled regulator needs to be enabled manually.
 	 *
@@ -200,18 +193,24 @@ int panthor_devfreq_init(struct panthor_device *ptdev)
 		return ret;
 	}
 
+	opp = devfreq_recommended_opp(dev, &cur_freq, 0);
+	if (IS_ERR(opp))
+		return PTR_ERR(opp);
+
+	panthor_devfreq_profile.initial_freq = cur_freq;
+	ptdev->current_frequency = cur_freq;
+
 	/*
 	 * Set the recommend OPP this will enable and configure the regulator
 	 * if any and will avoid a switch off by regulator_late_cleanup()
 	 */
 	ret = dev_pm_opp_set_opp(dev, opp);
+	dev_pm_opp_put(opp);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "Couldn't set recommended OPP\n");
 		return ret;
 	}
 
-	dev_pm_opp_put(opp);
-
 	/* Find the fastest defined rate  */
 	opp = dev_pm_opp_find_freq_floor(dev, &freq);
 	if (IS_ERR(opp))
-- 
2.43.0



