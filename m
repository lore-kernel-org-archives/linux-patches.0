Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D972531A04F;
	Mon, 18 Aug 2025 13:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523597; cv=none; b=BCkYlFA3do6zoWDhQj56rRMBF5t3xPwIU2E9nKeW0QPLSGx4tuXOH112+sUdQ8AfsVlX+m/sApMi0n4X+UWheMnuq2arYJz2Y69v0p0C7050biRvnNgssHlWfPTf8JQPUHjHI+CdQuNPcxizH+Ruu9FxRzmifqG4qk4NsB7VUDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523597; c=relaxed/simple;
	bh=Ds88bNaeRLL9NNMKjUvrFw2r3fuC5zBDhFLHknBJ1eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4140E8Uwfaz3ShMN1JcSVr16WZ8pxoMCIB7nd/c3pwRuEBFhHd4CnRm4Cwh9+5KluxC79G6Tu2CGp/fQutDGyea2GHo2JO9udbMwy+GXnvLkl9IGPNhKA+lDtLefZcAIxyXI5MziudVIhvrMAlYyPifDUqjri8PKYr8ntnfviQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQRSN9kP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQRSN9kP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6264EC4CEEB;
	Mon, 18 Aug 2025 13:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523597;
	bh=Ds88bNaeRLL9NNMKjUvrFw2r3fuC5zBDhFLHknBJ1eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQRSN9kP7lUB22MRrth2Nhlz+Nykm6NNZY1D/gQ+UHEHW+OZOJgDLmMwLHGpP0c4T
	 Uuo+AkuFnmEPAin6q97Ums3QO/GkM3omlXzlKQti+V9E98UujXW31kKb6hJYHGR0VJ
	 LHWy6wmSQinE7VqafJ7RQMo2SuhCgnwSzIBU7htE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umio Yasuno <coelacanth_dream@protonmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 219/515] drm/amd/pm: fix null pointer access
Date: Mon, 18 Aug 2025 14:43:25 +0200
Message-ID: <20250818124506.800200029@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 922def51685b..21da5123d95e 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1398,6 +1398,8 @@ static ssize_t amdgpu_set_pp_power_profile_mode(struct device *dev,
 			if (ret)
 				return -EINVAL;
 			parameter_size++;
+			if (!tmp_str)
+				break;
 			while (isspace(*tmp_str))
 				tmp_str++;
 		}
@@ -3618,6 +3620,9 @@ static int parse_input_od_command_lines(const char *buf,
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



