Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA496322775;
	Tue,  2 Sep 2025 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819824; cv=none; b=PpGEe3yeQyzP21tQnp0Dcb76MquZqWnsEhIlTu3U0qsX3JFGF1GqDZkmAbyb/3n4d2BmXhxIhF0ZU3MnWku1SlG3qcr6PfdjDT5crNVP5jn/zdNkjWHnHyF7dYyu92uGsT1SxNnc3GNamY44eD/hSXMISgQbn7OsrHS4YuUB/nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819824; c=relaxed/simple;
	bh=00Uw6/K5Vor2f6FKgnnm0x+HBxK3M/EfCFdGv6T2ug0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIZOqQmW9ojT5sjXRX1ER6gB7LHDE37hizMqnPTqxsknDKGCO4haDV26XVr4dAgktn8KU90x918OR+VvLXhURi4eqP44cA0XAG/yZ01NbbUhALJD1rZVCOnTjBK5/m8QtVIFvFq6hCIlWlhV8r8EqsVBuNMh4g8WyZpNJAqcmmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWd/JLF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWd/JLF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B823C4CEF7;
	Tue,  2 Sep 2025 13:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819824;
	bh=00Uw6/K5Vor2f6FKgnnm0x+HBxK3M/EfCFdGv6T2ug0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWd/JLF29K3Q8e13SwZ2jYhV4pdAxZGSTm+kPcGWmMlgKPQODeADxjYKIlo9urd+w
	 hD2X6vztxoVASfYZQAwaNAWliX1NHK2ncpLOdJ0B7EPodx3fHX5s4pesbJ9Tg5092l
	 vvTWPT4tUHOJUbmv3KlYs+tOL9qxXqoMpWsm3YuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 129/142] drm/amd/amdgpu: disable hwmon power1_cap* for gfx 11.0.3 on vf mode
Date: Tue,  2 Sep 2025 15:20:31 +0200
Message-ID: <20250902131953.228875156@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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
@@ -3458,14 +3458,16 @@ static umode_t hwmon_attributes_visible(
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


