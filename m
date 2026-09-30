Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8133B2D1A;
	Wed, 30 Sep 2026 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791180; cv=none; b=o75j35nSqC+WY7b1ah9SsQAf30QPVh/iQZi2XG3oiR3c4Fc4NJfPKcrYhgIhT7x+6hXNhJx3S/GJ2g2iJS/5IUOkOB+tpMf2c8WMqOmnUKrs8sdTLyXl0vIP4wU4uwkrCioD2keIkm1aobLgNery0nWeUkB25+GqrahSUZFCv4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791180; c=relaxed/simple;
	bh=eihcQLD/MSmLWokZm5lhubTdHU0YE3sz5tIOcT5f2UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ThRrsB/qkOmJFjXcsSovd5yUvbDzk7qc4F5jq4KuZFWKGIAFfntMC9d16pXyDT8WbKtYcwnSU0sA8xmDOlC6MfA/S9FwYDzXJHCtkDQErMQCSRhO6n3Y9qf6UJ1t6SByZalpjc400VnZcmhKS309j8QTQcpy38Q2JENceLjoxxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Q1IjiL5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Q1IjiL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65AF1F000FF;
	Wed, 30 Sep 2026 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791179;
	bh=Ru6rV7urnXV770xyX26mkp/JU00hXoEBGmhskgzBkNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Q1IjiL5JHySxP6xJ2bFs2jK4hLY2CYpluhqTTTTJoPrLIKG42KvOrL8AdsBofApN
	 2UvTZ3yKagjCMe9elw8e2TEnwm4KpRFDh9sh2A3qGSpWT11v97UPt7s1UH6fN8aHHu
	 6twYZDiixkpNeB8R8cpUDq6TN15z1wbokMP2Hn3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 211/752] drm/amd/pm/si: Dont schedule thermal work when queue isnt initialized
Date: Wed, 30 Sep 2026 17:21:21 +0200
Message-ID: <20260930152402.803911145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
index 67cd731830346..8cf2ad07ce620 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
@@ -7592,7 +7592,7 @@ static int si_dpm_process_interrupt(struct amdgpu_device *adev,
 		break;
 	}
 
-	if (queue_thermal)
+	if (queue_thermal && amdgpu_dpm)
 		schedule_work(&adev->pm.dpm.thermal.work);
 
 	return 0;
-- 
2.53.0



