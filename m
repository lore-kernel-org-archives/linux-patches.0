Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060053F7AA9;
	Wed, 20 May 2026 18:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300376; cv=none; b=D1RiXBOjEHQsc7qhfqX6/Xq41ZbqBAXZj9JVegRRBZJWUggIEAgbOwauDV1Vvcp7wPcn4GIrx9BfZdXOmgmfpH0BUk6hBWU0rW1la8RITg/CT1VKKJ8opAR19JoP6H7L7SD7iWfcyxeSpZ4Kpcc24HfSy2MpehBdnA3VWNiEtAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300376; c=relaxed/simple;
	bh=2Irq6Iji/go7M7BoEU5DW4zrdGk8/vbt67kJKCNxqjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gk8eMzG+xYtyMeG6KV5gWkPZ6s0HmxRsKStBAvacIqFAzHhBGiCmYzXbFTGyxuS7d5PIPBzGKwdfbPU4lyaxrKiWCjK7Zko+EXxQF8+VfLmBe5YatWy3X4eysPcTaAV9AiK2M7IE0ERmQicfn16XwSeRaucDdoYX5I8x3Q+0KI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9zVk9FJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9zVk9FJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6568B1F000E9;
	Wed, 20 May 2026 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300374;
	bh=KrrEW3ntF7tsbvkJ8GT7bTnSduo8VL8HuPvX0KW9e3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9zVk9FJCl3SlO7HQigZde8zAWfo4f7UGbZvhor/iE3QMB+f/UT2S1SpBWfWz4yGI
	 dVLG/xPSKb3AoFQWevs8F/LIIRz68w9/5YwsE7jOqlTOeJDRs/Z4OskpYNE8zRNjGo
	 mb6rIh4gGFGbSQ60/iT2qbhd4vbD0CO0nqEB6q4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/666] drm/amdgpu: Add default case in DVI mode validation
Date: Wed, 20 May 2026 18:16:01 +0200
Message-ID: <20260520162114.459965957@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit e6020a55b8e364d15eac27f9c788e13114eec6b7 ]

amdgpu_connector_dvi_mode_valid() assigns max_digital_pixel_clock_khz
based on connector_object_id using a switch statement that lacks a
default case.

In practice this code path should never be hit because the existing
cases already cover all digital connector types that this function is
used for. This is also legacy display code which is not used for new
hardware.

Add a default case returning MODE_BAD to make the switch exhaustive and
silence the static analyzer smatch error. The new branch is effectively
defensive and should never be reached during normal operation.

Fixes: 585b2f685c56 ("drm/amdgpu: Respect max pixel clock for HDMI and DVI-D (v2)")
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Timur Kristóf <timur.kristof@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index 54067edb7747b..47bef5e7747c4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1247,6 +1247,8 @@ static enum drm_mode_status amdgpu_connector_dvi_mode_valid(struct drm_connector
 		case CONNECTOR_OBJECT_ID_HDMI_TYPE_B:
 			max_digital_pixel_clock_khz = max_dvi_single_link_pixel_clock * 2;
 			break;
+		default:
+			return MODE_BAD;
 		}
 
 		/* When the display EDID claims that it's an HDMI display,
-- 
2.53.0



