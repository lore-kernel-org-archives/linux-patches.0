Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD40B12DDA1;
	Mon, 18 Aug 2025 13:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522088; cv=none; b=YTLJDlv5gabn8h9WorXjtrJUpC4cRj5sc2SarRP3XIPVGp09IGnOp1kToRbl4yhrugvPSfKgDMCrtWAtgKPhVhE6vyfVAIT0eBxdzX9jUxvPduc1xQY0a2K7FzS6mF4DNDus0q1u9QqP+utt7cpL6mz1Qyaj75AQm1D3oaZwQFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522088; c=relaxed/simple;
	bh=sIA6r2WNaVy0QvC6cbn2E1zvAvGFO70+6JNcIEwccYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0eEPDvwyjBWq9cIrt0P9gACJlUqOFfMidFobmbwqkuuQKhTG96SOoEzCMgtjdPhV/Ecx2pIzVfDk8hKNo0iIcf2r7ORAlcXu3X3fypqmaetc/8XGis2X3gdNWf41mwkhIGkMzmeQkw71ZKczaakzoI9ekyVIk0Yj/Jsr/5801g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iL53VgHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iL53VgHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259ECC113D0;
	Mon, 18 Aug 2025 13:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522088;
	bh=sIA6r2WNaVy0QvC6cbn2E1zvAvGFO70+6JNcIEwccYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iL53VgHdDnV5ckZTEY1EctbEWEXiebrvNlIiosqxHBPtVFI+VTpf8LPSHLRiOeWwQ
	 fzH9Pp9K1IkosbGPFT8zREQMZOV34Mq5HLndkOo2D5qczVgolmB8VUpT3CbOryU8Eu
	 vySZ13MZqW7mzfYPXSJnxzXRNjT7mWGDLaS0gJ2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umio Yasuno <coelacanth_dream@protonmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/444] drm/amd/pm: fix null pointer access
Date: Mon, 18 Aug 2025 14:43:30 +0200
Message-ID: <20250818124455.771340982@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umio Yasuno <coelacanth_dream@protonmail.com>

[ Upstream commit d524d40e3a6152a3ea1125af729f8cd8ca65efde ]

Writing a string without delimiters (' ', '\n', '\0') to the under
gpu_od/fan_ctrl sysfs or pp_power_profile_mode for the CUSTOM profile
will result in a null pointer dereference.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4401
Signed-off-by: Umio Yasuno <coelacanth_dream@protonmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index bfdfba676025..c4fdd82a0042 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1490,6 +1490,8 @@ static ssize_t amdgpu_set_pp_power_profile_mode(struct device *dev,
 			if (ret)
 				return -EINVAL;
 			parameter_size++;
+			if (!tmp_str)
+				break;
 			while (isspace(*tmp_str))
 				tmp_str++;
 		}
@@ -3853,6 +3855,9 @@ static int parse_input_od_command_lines(const char *buf,
 			return -EINVAL;
 		parameter_size++;
 
+		if (!tmp_str)
+			break;
+
 		while (isspace(*tmp_str))
 			tmp_str++;
 	}
-- 
2.39.5



