Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE3E390608;
	Fri,  7 Aug 2026 15:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117661; cv=none; b=iy880uMvYQOfqQJPxPbY3ExAX6KiYOYsmqVsI/gKDjoS7jQNh7DnlY4CMKAjawie79QWGDMF7+aDjtBCRso6Ply/OYV3EGqOrmuWWsCTWGaK4XitsVO+v4Mmx0mlT5cL5S6UyKJiwY+w8n2LlwkJZaDEZtFCLKdEVV4+jb9qbds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117661; c=relaxed/simple;
	bh=Zn4iO2YrshThggb1tLrQOMExuH/Zlvm0ZdTq5hJOwgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vD9sCQRPn/idOQIkSS39hGUS2lw67mofRSAqmtbM/DED6T3k/KIK14OS80+uQ8FKOLEv0ZmWvImM501vNoWLIz93iG2fu2auG9DF8Coqod1V4pfX36TkHcoqHJIePo6+k+7Yy/OG0YNBbr9CfjooLsjwdK9+bsGmEnQaS2Xhk4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pS+awW8i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pS+awW8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135311F000E9;
	Fri,  7 Aug 2026 15:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117660;
	bh=wSHbvNrBqJAX0rEM6A4Hz+AcMmKD0Jn5nC5D1UM0x6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pS+awW8i7aOThq+nZ2869Eo04DhN8s+qmgsyLCGYHLSdMOTfdf1fGmcYm3RAlxPMg
	 wsXBaDcUtC5D0Tk08hiFXIMc/BavOadDW/EVt2yUJoRGb2K902peWQ7c0oSlVv1c6A
	 OKN2M76b8SVVoV/MW0Z1dhGaZDd9dtOIzSlKUp7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 395/438] drm/amd/pm: hide pp_table sysfs on APUs
Date: Fri,  7 Aug 2026 16:39:51 +0200
Message-ID: <20260807143436.383610675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit a65f5179d3f0c93da31b450aeb416eaa22f1912b upstream.

APUs use firmware-owned DPM tables and do not support replacement through
pp_table. Generic callbacks can nevertheless expose the sysfs file and
accept an upload before resetting the power management stack.

Treat pp_table as unsupported on APUs. Use the same platform check in the
get and set paths to hide the file and reject uploads.

Fixes: 289921b03fe5 ("drm/amd/powerplay: implement sysfs of pp_table for smu11 (v2)")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 74f28db2db69777cd2f059d50fe34e365ddd5add)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -1183,6 +1183,13 @@ int amdgpu_dpm_dispatch_task(struct amdg
 	return ret;
 }
 
+static bool amdgpu_dpm_is_pp_table_allowed(struct amdgpu_device *adev)
+{
+	return !amdgpu_sriov_vf(adev) &&
+	       !(adev->flags & AMD_IS_APU) &&
+	       !adev->scpm_enabled;
+}
+
 int amdgpu_dpm_get_pp_table(struct amdgpu_device *adev, char *table,
 			    size_t size)
 {
@@ -1193,7 +1200,8 @@ int amdgpu_dpm_get_pp_table(struct amdgp
 	if ((!table && size) || (table && !size))
 		return -EINVAL;
 
-	if (amdgpu_sriov_vf(adev) || !pp_funcs->get_pp_table || adev->scpm_enabled)
+	if (!amdgpu_dpm_is_pp_table_allowed(adev) ||
+	    !pp_funcs->get_pp_table)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&adev->pm.mutex);
@@ -1717,7 +1725,8 @@ int amdgpu_dpm_set_pp_table(struct amdgp
 	if (!buf || !size)
 		return -EINVAL;
 
-	if (amdgpu_sriov_vf(adev) || !pp_funcs->set_pp_table || adev->scpm_enabled)
+	if (!amdgpu_dpm_is_pp_table_allowed(adev) ||
+	    !pp_funcs->set_pp_table)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&adev->pm.mutex);


