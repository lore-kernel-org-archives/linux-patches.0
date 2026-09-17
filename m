Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918764EF133;
	Thu, 17 Sep 2026 18:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668453; cv=none; b=m7SBpQp/XHXLvHv7I3bCIaljUiQNFVNYR0ix0MWEqPpd32ALbdJywNpIuOfnuksxPjxAYOb213dCv8pxxj8UT0S66KbBiYRwqNa51sZbAZIDB4aT0xDnD4uwcILguCJljMU7QM8EbbAvnUZ37vSh4xzd35bMGzZUzm/wzI60fzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668453; c=relaxed/simple;
	bh=BwJo2yBvLHre9oWgUY0nIsMxt9up/fsdF2WxM/gI1ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W/ivmN7fcTRUaidZKnX3w8lwHKAIVeWEXlTovvg+2FN567m5CXWhnEXwholgUuN8EIYHAATvegR/tqcaed7AAGaP/L3Ua1Vq6fys40sHHbprknbxgL1Bi5qnECxoqjEyQqH34+7C18jsd+IrSgIj64MneemQUquNJXVDUjVydU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=za1m4u52; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="za1m4u52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84861F00898;
	Thu, 17 Sep 2026 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668452;
	bh=N/6eLZXL8TscsUxuaC2tBra3BSXyPGFytkexjCRHXZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=za1m4u52MvRCZLRBjpy7ftLh+d/yjZN8e+ALYT4lpAj+72BOxb+z9y5X9gNcQ1hzA
	 G3RvfEFHAgUnka72w6SjCD5wvXkFwFCIt9nNrOZwNDfWPfq8Uk6lFSgc6jeoWE5eQo
	 PCFPTxn26gVgSlQJE8hvqPFxJcbKW+Op3XF2kpp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0430/1102] drm/amd/pm/si: Dont schedule thermal work when queue isnt initialized
Date: Thu, 17 Sep 2026 16:06:13 +0100
Message-ID: <20260917151550.469079606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit f8922d5a946699fc2bdc7660e6778bd6726bf8b8 ]

When DPM is turned off with the amdgpu.dpm=0 module parameter,
the thermal work queue isn't initialized so we shouldn't
schedule any work on it.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bd018d36171a695952c6d391471c279c9e05c8b2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index 58a688b1514e3..620deb813e760 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -7666,7 +7666,7 @@ static int si_dpm_process_interrupt(struct amdgpu_device *adev,
 		break;
 	}
 
-	if (queue_thermal)
+	if (queue_thermal && amdgpu_dpm)
 		schedule_work(&adev->pm.dpm.thermal.work);
 
 	return 0;
-- 
2.53.0



