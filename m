Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEB3435AB0;
	Thu, 30 Jul 2026 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424944; cv=none; b=GtXinSpUuEiGcCdBUs33HO3okf9U65zrLyLVlPp+qJdN+yz0Ld1mmsly1y5ct6yxnsJ3WMH4vatgCykQk30VYS+vgFMd1cW+hC2dvWwiJCggdc66Hdbp51bZCvkqvJdKavvCHO6LUOnMEbtAKqADfL90VKP0ooBGzf/1F4bSAxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424944; c=relaxed/simple;
	bh=Di/Z5SFetxwGR1r1hM28FPpIMcX0jyZ0KshTkwgFFCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mB3ZNyjxc5+hlWlxRQ1L2Ta7b5nlh3U7HfjqmzK3UbgO7PgEYj/FdvK1ssMB/jBmo5E+y84A6pCS/sdCEn5r2O1X3u/RajW6k7ZMZXwAN6qH1+r8D/94+KyR8ns2C8P/RT4ebfIm/n62dXUvObolBwPVFEuc5KBYub1xCEsDe2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkOJ+Vex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkOJ+Vex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1EA1F000E9;
	Thu, 30 Jul 2026 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424943;
	bh=qU8AWHsgFPeogcabzHla5EbYpJexu9oeNsJbT3KOS9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KkOJ+VexEh9p3OzzbJUbDuyge9YRp/scxKgvUQZv8z/qCfKMVWulw2J4HPHV92Oh/
	 UdWKWXeqcp8hFiyABbqxsb/wxfYpeTdmU/E8aDpV+q3M3l+MPl2x70vBiBaE2Jp2oL
	 EhKwFcG+L7K6rKF5cjPwEU1uSy1sqzeD4LrVloD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 571/675] drm/amd/pm: make pp_features read-only when scpm is enabled
Date: Thu, 30 Jul 2026 16:15:01 +0200
Message-ID: <20260730141457.267432967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit 53c78ab388bfc1a4d72e756815d0db0a842c812e upstream.

SCPM owns power feature control when enabled.

Make pp_features read-only during sysfs setup by clearing its write bits
and store callback.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6a5786e191fdce36c5db170e5209cf609e8f0087)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2619,6 +2619,11 @@ static int default_attr_update(struct am
 		     gc_ver != IP_VERSION(9, 4, 3)) ||
 		    gc_ver < IP_VERSION(9, 0, 0))
 			*states = ATTR_STATE_UNSUPPORTED;
+
+		if (adev->scpm_enabled) {
+			dev_attr->attr.mode &= ~S_IWUGO;
+			dev_attr->store = NULL;
+		}
 	} else if (DEVICE_ATTR_IS(gpu_metrics)) {
 		if (gc_ver < IP_VERSION(9, 1, 0))
 			*states = ATTR_STATE_UNSUPPORTED;


