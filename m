Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6C2411FA4;
	Fri,  4 Sep 2026 06:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502729; cv=none; b=LmGVJL4NzHJT2yZDP5oeKRpHZAJ2cX+XmNZlZMGis2RSal+tGBTM8OY1UKPVgVo4Gze0n+YiwRbR8a5xVOmjF08EVUVnLdFEg4OwQykFO6QGn3feJj5leTiG091POGKykeMUvOl1FaVmWDDWzflUPBF7gyHAlSMOV+5oui4UHPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502729; c=relaxed/simple;
	bh=jkdr0DXZZbKX1KB56z9Yj2B7JXW+j/JAzEFAXB+NFMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a6ZoooEV/VNlM2VKOBi/XvL468aZjTnFhTFdIY8nAx5VMh2Ekkt+QO9mxLUKtfMpINpu+vNPyYb4wQiH6yCyaXtxE10Q9JVf1deYSxQXISxmMc+d6mjwdYAjAG0QuzpnaZuPuzzsrM62Fmmhl7B0FsYig+jGY1ProTr5WIRitMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pV8RKs8x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pV8RKs8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADAE1F00A3D;
	Fri,  4 Sep 2026 06:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502727;
	bh=8mCdqGtrvyjA034BrtZig1Ct/+9lwy9nxv4VFO66T8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pV8RKs8xECrwLwDgUlZuvzXD5aSgqvmxd4Ue/MmvOxndEl0u+aU3p22nrEMyCs925
	 /qKge8z02Qq9aunHjbtRBrxfCcYTz6xEBJ0H7ucKo189ekH49hFfRsTGMVyw+0Gorw
	 ylLCgfPwn+f7Y4c/a4Xj2fnyjzqx+QgA1/RcK4Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 308/403] platform/x86: ISST: Validate level in perf mask ioctls
Date: Fri,  4 Sep 2026 07:01:51 +0200
Message-ID: <20260904045741.845801631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

commit 80e0d353c86a9a168ad6d213f494796294381538 upstream.

isst_if_get_perf_level_mask() and isst_if_get_base_freq_mask() use the
user-provided level as an index into perf_levels[] via
_read_pp_level_info() and _read_bf_level_info(), but neither helper
validates it first.

The adjacent level-info helpers reject levels above max_level before
reading the same per-level register block. Add the same bounds checks to
the mask helpers, and reject disabled SST-PP levels in
isst_if_get_perf_level_mask() to match isst_if_get_perf_level_info().

This prevents out-of-bounds reads from the per-level offset table on
invalid ioctl input.

Fixes: ea009e4769fa3 ("platform/x86: ISST: Add SST-PP support via TPMI")
Fixes: 06a61df83209 ("platform/x86: ISST: Add SST-BF support via TPMI")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260807144003.3498972-3-sammiee5311@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -1192,6 +1192,12 @@ static int isst_if_get_perf_level_mask(v
 	if (!power_domain_info)
 		return -EINVAL;
 
+	if (cpumask.level > power_domain_info->max_level)
+		return -EINVAL;
+
+	if (!(power_domain_info->pp_header.level_en_mask & BIT(cpumask.level)))
+		return -EINVAL;
+
 	_read_pp_level_info("mask", mask, cpumask.level, SST_PP_INFO_2_OFFSET,
 			    SST_PP_RSLVD_CORE_MASK_START, SST_PP_RSLVD_CORE_MASK_WIDTH,
 			    SST_MUL_FACTOR_NONE)
@@ -1273,6 +1279,9 @@ static int isst_if_get_base_freq_mask(vo
 	if (!power_domain_info)
 		return -EINVAL;
 
+	if (cpumask.level > power_domain_info->max_level)
+		return -EINVAL;
+
 	_read_bf_level_info("BF-cpumask", mask, cpumask.level, SST_BF_INFO_1_OFFSET,
 			    P1_HI_CORE_MASK_START, P1_HI_CORE_MASK_WIDTH,
 			    SST_MUL_FACTOR_NONE)


