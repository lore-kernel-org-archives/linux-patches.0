Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6622FDC30;
	Sat, 12 Sep 2026 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220710; cv=none; b=Y8yFsbeWHw4WBel/EA2aIH/kVDFXxVB6U8AfFLXl4WSa+0uBXTF76GUR3J7xeuEtlfvoVRGclPyBjpZHxwtOb5V3J/jvqRFMxbXBGsTuUG+P85l3R0QgJOUl+YZtQFsnNdYRUchYtlW6eTcvv42UvudhKhsZOWQBc8cTmNFyuTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220710; c=relaxed/simple;
	bh=jdMwFGeBoNCyPV5o9Cp24/7449onH3a+0vZPdhoau+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=arbhQYPt4hPJ+M65uCnI2RDF+dKueL5FEEWDB/9qdZGQvcTkVT7idcFCa1nfqtlDLUqz9k/NwAUFF2+aoANfID5O77Iee4rKUNV0ImJbCMCUO/V2gZ5/YO+iWqkYIFODm3Dc2GoTUjezJGUmxaZpJbZXLk2xrubztpuS3W2mGfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuYsWJ/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuYsWJ/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1AB1F000FF;
	Sat, 12 Sep 2026 13:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220709;
	bh=urX7wxiZu0lZpC+S5H7L/5qV7Kx4hh3EEzp0NqaZ2ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuYsWJ/gai99LWLr1aBi7P46c+ivmE4YpmiS5vqePz7B6LQwdoIBLg1TPo3rQriQh
	 QKi/X64Fan0S4X1In0JLaIZeeqQCqJcqz3EQ+Xde6TEY3K23NYSRvdN9X1COjHTskj
	 yZuclaisS9jv0ytcJ8lQtzZTSCv13WLBS7/hpCUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0233/1424] platform/x86: ISST: Validate level in perf mask ioctls
Date: Sat, 12 Sep 2026 08:44:25 +0200
Message-ID: <20260912065612.500050566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1007,6 +1007,12 @@ static int isst_if_get_perf_level_mask(v
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
@@ -1088,6 +1094,9 @@ static int isst_if_get_base_freq_mask(vo
 	if (!power_domain_info)
 		return -EINVAL;
 
+	if (cpumask.level > power_domain_info->max_level)
+		return -EINVAL;
+
 	_read_bf_level_info("BF-cpumask", mask, cpumask.level, SST_BF_INFO_1_OFFSET,
 			    P1_HI_CORE_MASK_START, P1_HI_CORE_MASK_WIDTH,
 			    SST_MUL_FACTOR_NONE)


