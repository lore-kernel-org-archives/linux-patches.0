Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E3A2DC33B;
	Tue,  2 Sep 2025 13:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820083; cv=none; b=Z8iwboMRbzWhxgKPsGGxeLGGx1TTdULugoVzdpdJ/Rof6f+/S1tRC+oh+jtCPQeWW0+Mg3Xx0OIxo0V3vLv9f2klYF9+kJudIBi0Df6HmQmNNXUNL+GxWQDD+m4/KLfOXq7F/+vZwAeXTbDkiOg7bDA+RgVvIp29h4GXwU1OR5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820083; c=relaxed/simple;
	bh=3Kvwnqo5l6UzUPsfj8lKbFgw+QN+idawybyaVVSEUMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kh5k7xdLgK8Qm4a9sTm7UWS2tGkEYUx4SaQRhQ0FLuinOno4apHcm7gnlS0bXqKrXZilD6cKffwmP0JmrbD0bNfl18VJ9QogT65X+jMZqODFPwdyNVAZmUXhMAIqNArW/5+QfPkTEPnVtgx7lRvsqLEP35EieOLeK7b61nbkats=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8P0Rpxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8P0Rpxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F814C4CEED;
	Tue,  2 Sep 2025 13:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820082;
	bh=3Kvwnqo5l6UzUPsfj8lKbFgw+QN+idawybyaVVSEUMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8P0RpxrfkLTjf2gw4pGAcCMAKCTWHocpftFSQ11bd4yTX/uSSyaf7mcRsbJOEUGM
	 yNwO43CuM0dkoehPtqsqgktNlcgxkeQGW4M7GfTO9zsOsW9kmUhKoZF8vlbEZ1N1+B
	 EF5J+U3VIAV8M8xqcxIYxnPnfphL+eG+xuR2BvME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 88/95] drm/amd/amdgpu: disable hwmon power1_cap* for gfx 11.0.3 on vf mode
Date: Tue,  2 Sep 2025 15:21:04 +0200
Message-ID: <20250902131942.981173898@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

commit 5dff50802b285da8284a7bf17ae2fdc6f1357023 upstream.

the PPSMC_MSG_GetPptLimit msg is not valid for gfx 11.0.3 on vf mode,
so skiped to create power1_cap* hwmon sysfs node.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e82a8d441038d8cb10b63047a9e705c42479d156)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -3668,14 +3668,16 @@ static umode_t hwmon_attributes_visible(
 		effective_mode &= ~S_IWUSR;
 
 	/* not implemented yet for APUs other than GC 10.3.1 (vangogh) and 9.4.3 */
-	if (((adev->family == AMDGPU_FAMILY_SI) ||
-	     ((adev->flags & AMD_IS_APU) && (gc_ver != IP_VERSION(10, 3, 1)) &&
-	      (gc_ver != IP_VERSION(9, 4, 3) && gc_ver != IP_VERSION(9, 4, 4)))) &&
-	    (attr == &sensor_dev_attr_power1_cap_max.dev_attr.attr ||
-	     attr == &sensor_dev_attr_power1_cap_min.dev_attr.attr ||
-	     attr == &sensor_dev_attr_power1_cap.dev_attr.attr ||
-	     attr == &sensor_dev_attr_power1_cap_default.dev_attr.attr))
-		return 0;
+	if (attr == &sensor_dev_attr_power1_cap_max.dev_attr.attr ||
+	    attr == &sensor_dev_attr_power1_cap_min.dev_attr.attr ||
+	    attr == &sensor_dev_attr_power1_cap.dev_attr.attr ||
+	    attr == &sensor_dev_attr_power1_cap_default.dev_attr.attr) {
+		if (adev->family == AMDGPU_FAMILY_SI ||
+		    ((adev->flags & AMD_IS_APU) && gc_ver != IP_VERSION(10, 3, 1) &&
+		     (gc_ver != IP_VERSION(9, 4, 3) && gc_ver != IP_VERSION(9, 4, 4))) ||
+		    (amdgpu_sriov_vf(adev) && gc_ver == IP_VERSION(11, 0, 3)))
+			return 0;
+	}
 
 	/* not implemented yet for APUs having < GC 9.3.0 (Renoir) */
 	if (((adev->family == AMDGPU_FAMILY_SI) ||


