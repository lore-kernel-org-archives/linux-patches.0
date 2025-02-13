Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5462A1D1;
	Thu, 13 Feb 2025 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458750; cv=none; b=u5p5R2kd6MfwGM33gEDueDxnTPFOeQ0zRBeMQU1gf4ui4N3GwQwPFirHVfp/CU5WcILb8440T7ZouE78oKez+C5l7Je9D6MQoEnH77YvUZS029c47aejs3FqoXm+rr2Z6CwvK3QWD92C7F/NGyePyp9QLVj6lUMUl8wsbYWRJKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458750; c=relaxed/simple;
	bh=U55Wti9Pm16jHrYxIk3ourT0vERZhM2wSlHR5Qx+UIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfmjM0X5HVziVft8xlL+IfIys5Ju5MHSArxhkPNAvnlrB8KINTzsLnC3AePsXe6eEvpsii9MsOyr1dOBS2gAeMiFJLA+h+cosCCvxSpb7BDJc/xXQFsUAdnrxTlIbuyK5IqEVWCM/RERMvS7Q1SGwqBV1V+uqxSdo57BPGVh07U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zngXa1YW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zngXa1YW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B795C4CED1;
	Thu, 13 Feb 2025 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458749;
	bh=U55Wti9Pm16jHrYxIk3ourT0vERZhM2wSlHR5Qx+UIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zngXa1YW45gt9XQZQDwuRFO1ccLAmnmSotztxitaW65FHsarT/K2En30/903Ec69X
	 UHiZPrdh3pPqweNliTC/Q9bmA1S1s58Zh8u/tAAxz+OdWrWBWPMmiInEXc8qcqtFP0
	 rRc737crX6d5LAKp6B1utRSnWGjFHInd0Uu+SIaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 035/443] drm/amd/display: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:23:20 +0100
Message-ID: <20250213142441.980169462@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 819bee01eea06282d7bda17d46caf29cae4f6d84 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-4-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 92e1d59921f49..cff07681e0f4c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1037,8 +1037,10 @@ static int amdgpu_dm_audio_component_get_eld(struct device *kdev, int port,
 			continue;
 
 		*enabled = true;
+		mutex_lock(&connector->eld_mutex);
 		ret = drm_eld_size(connector->eld);
 		memcpy(buf, connector->eld, min(max_bytes, ret));
+		mutex_unlock(&connector->eld_mutex);
 
 		break;
 	}
-- 
2.39.5



