Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7331A5B92;
	Mon, 18 Aug 2025 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525353; cv=none; b=fmx7Egaj9Bsfu+y1PAwPnpFO0MLzyntptdZQcJtJB+QzQ5ODmht+bXEGWHp5UOzsf9zrEjaohFlSKXQdfDEXG7o65F/kDo0y5uFK2eZ0GDq7NnrgCCFVHnztMr+mJtndG+K6s67yPb1FIdJ0AnzVNSIzLeByH8rsNeaYB1CCXuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525353; c=relaxed/simple;
	bh=alqmlaJ14aM9oJW12CB0IuAnpH01B595bmPyiA91LK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6sGcOICPp+446dpx/O0qoEa8tMStnubygRpwZEPyie6YGnbTvpb73qm9s8Ak1YuXdyHf7okwh5Wg6U7WFGmCrHsS0wR5vSkW7Y8gC7XtAZAg/mKCpEAQdAq8pSTaPJGZu+WBspUdWNNd13hRpQgsMkZWun+LA8hiE1NA4LX4d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGgRlUet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGgRlUet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829F9C4CEEB;
	Mon, 18 Aug 2025 13:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525352;
	bh=alqmlaJ14aM9oJW12CB0IuAnpH01B595bmPyiA91LK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGgRlUetAKh61BR9A0MFa7Sq4m/9IZXNf3Euxssf3RvlOKrkLb+QWsy+R84eLLtJe
	 Jsl47E06BtGexyrHXA5L2Uoa3U5EM5J2RH8EALSxJct+e7/NqQjLM4JCEHOEslV86b
	 HAQM8JgubLe/dFjGJc13dHbKrF55+YfVMLywOoDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umio Yasuno <coelacanth_dream@protonmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 235/570] drm/amd/pm: fix null pointer access
Date: Mon, 18 Aug 2025 14:43:42 +0200
Message-ID: <20250818124514.877655835@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index edd9895b46c0..39ee81085088 100644
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
@@ -3645,6 +3647,9 @@ static int parse_input_od_command_lines(const char *buf,
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



