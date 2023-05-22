Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E392171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BDCC4339B;
	Mon, 22 May 2023 19:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784208;
	bh=BUPhXJIEQodTfxXUqbY35g5DiO4TZqN0bqwDbmxZIX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFEQT/kM0do3kez02+KmEn7XKBgb85xvaUCd2fZYtvSY88q6kaCcgaoH5/AVcvziM
	 7cblrlOXT7naBLFbchM6D/BkqkC9/kOB4+0nzi8FrfmRjgwMlqwLA4NSZi9F5au0CS
	 YPCFFyx+1V7D5L4zhb2M6uRSE082BsiEd6gUiG2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 272/292] drm/amdgpu/gfx10: Disable gfxoff before disabling powergating.
Date: Mon, 22 May 2023 20:10:29 +0100
Message-Id: <20230522190412.739191240@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit 8173cab3368a13cdc3cad0bd5cf14e9399b0f501 upstream.

Otherwise we get a full system lock (looks like a FW mess).

Copied the order from the GFX9 powergating code.

Fixes: 366468ff6c34 ("drm/amdgpu: Allow GfxOff on Vangogh as default")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2545
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -8236,8 +8236,14 @@ static int gfx_v10_0_set_powergating_sta
 	case IP_VERSION(10, 3, 3):
 	case IP_VERSION(10, 3, 6):
 	case IP_VERSION(10, 3, 7):
+		if (!enable)
+			amdgpu_gfx_off_ctrl(adev, false);
+
 		gfx_v10_cntl_pg(adev, enable);
-		amdgpu_gfx_off_ctrl(adev, enable);
+
+		if (enable)
+			amdgpu_gfx_off_ctrl(adev, true);
+
 		break;
 	default:
 		break;


