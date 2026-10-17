Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB063BB102;
	Sat, 17 Oct 2026 17:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258077; cv=none; b=J6IIU6d39AAkdSlRUVIcMy59kdZEaIMpLGUJEMTZe6VUp0WkhlZF/kAScupwsXEtmoP9lKqYBcltA7m0iEniisILspSDCcIAXWkdOj5gJG07q/vmQMq+HQ/usUgnQdCan7WIuPhCMb6UGqN9Tj1HY8OlaNt+P5U3T+sVjvOqNMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258077; c=relaxed/simple;
	bh=3N0xRDbZPBIEfG0pxkIR5cBaLI7F8kznW3dLcB5rWEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=to2R4V6vWZ1vRFeLVT2rlSnWw+BFKviCvbKF62h0cLxzD1Y5N+lDtPCeI/jOj8JOthYL4GYCThHjTazPEbmZ6a5+F524CA0U6ZPlMTDR3ZVoMgU1psVyejePz0Q0L5PzOt/l8TYRCqwGvQbnkyNqfSbYByRhMv5A1wby4bOBHTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFGQp5Ub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFGQp5Ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0671F000C5;
	Sat, 17 Oct 2026 17:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258075;
	bh=T4vHEYIj2TyrcX47hZT4bL5Px2ttTemAVT/JAnZP5nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TFGQp5UbENWABUiLRMzS3MYDzR8KoJZFTZzXmEeYhaT34ttag84j329/i71DleVu4
	 /D9Z/F6Kmq7o/0MMf9pQNvr4fq0QuJLINlCJqG3f8iDVUiiaMAEVbqvOsj5Y0nkJVj
	 ILqy+kYAAt2EYO1RY8hM1glrotnlHF74+VDji6qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umio Yasuno <coelacanth_dream@protonmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0765/1674] drm/amd/pm: fix null pointer access
Date: Sat, 17 Oct 2026 17:50:37 +0200
Message-ID: <20261017160450.738013925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index ada58a3f1533c..470d5d5e21f04 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1442,6 +1442,8 @@ static ssize_t amdgpu_set_pp_power_profile_mode(struct device *dev,
 			if (ret)
 				return -EINVAL;
 			parameter_size++;
+			if (!tmp_str)
+				break;
 			while (isspace(*tmp_str))
 				tmp_str++;
 		}
-- 
2.53.0



