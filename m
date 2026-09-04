Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F1941684A;
	Fri,  4 Sep 2026 05:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501453; cv=none; b=Y1Yv6qf0gyZAfNsIlnpOycRroSTlNUg5NsUd7Ys3UL8sVFoyQZwyPLINEo6DBm4t4ggGCesGBcxTgwACxGxpyLLkFEX2Thyj1BvFRpgsCpIrwARXNZRk5ZysyW8AYaeDPh062PT475KCkLxpvRqzfFhYiGOP+7k10cv4f2YsIbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501453; c=relaxed/simple;
	bh=2PR8LVT52oPJxMRtEtZ8nJLLnVmaWxYnKRewDMVL+KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ueuX/UIoJxwP8DbgplGOmhD/2hSiZR1Tdi5NC33KKdbNgmWH5iyg5kV1axAbAWlVBPjlfzQuclMrr1L3xY4Lyd19ejF+64hxEcGmETB7i/O2XfwryFRLD5/OYNO7zp36+ywLqAZlfESUQZ+rhZ7SkciP094Xxxw++1JVBp3snZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvFCwCkA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvFCwCkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27721F00A3D;
	Fri,  4 Sep 2026 05:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501452;
	bh=8IxrUM1GxzVT2xUXC5Zllw0NSWKyxH83r+k1PBT/yvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZvFCwCkADSyjVMa8ofZti66TxjNqJyjqq8P9v0J/c5NKg7Woe8ZySvJB3EXGeSYNs
	 A2Wm1eTe17m7tF3oUwhUoWKCXP4/2FxXzDMICVonJSELFlozdi3sWZWC0DSzIi8c6B
	 nzqcGHpH4PNKS1c6IFLVkLP47nl2aX9bzGcP/oU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 415/552] platform/x86: ISST: Validate socket ID in clos_assoc ioctl
Date: Fri,  4 Sep 2026 06:59:32 +0200
Message-ID: <20260904045800.025389119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit a89f07db0cb95c54dac4a8406c79a04e44a73c3c upstream.

isst_if_clos_assoc() validates the user-supplied socket_id with
'socket_id > topology_max_packages()', but isst_common.sst_inst[] is
allocated with topology_max_packages() entries, so the valid index range
is [0, topology_max_packages()).  The '>' comparison lets
socket_id == topology_max_packages() pass and index one entry past the
array.

In addition, isst_common.sst_inst[socket_id] is NULL for an in-range
package that has no bound TPMI SST instance, and the pointer is used
without a NULL check.  Both the out-of-bounds entry and the NULL pointer
are then dereferenced by map_partition_power_domain_id() and the
following power_domain_info access.

Reject socket_id >= topology_max_packages() and a NULL sst_inst, matching
the checks already performed by get_instance().

Fixes: 12a7d2cb811d ("platform/x86: ISST: Add SST-CP support via TPMI")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260807144003.3498972-2-sammiee5311@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -729,7 +729,7 @@ static long isst_if_clos_assoc(void __us
 		if (copy_from_user(&clos_assoc, ptr, sizeof(clos_assoc)))
 			return -EFAULT;
 
-		if (clos_assoc.socket_id > topology_max_packages())
+		if (clos_assoc.socket_id >= topology_max_packages())
 			return -EINVAL;
 
 		cpu = clos_assoc.logical_cpu;
@@ -747,6 +747,8 @@ static long isst_if_clos_assoc(void __us
 		pkg_id = clos_assoc.socket_id;
 
 		sst_inst = isst_common.sst_inst[pkg_id];
+		if (!sst_inst)
+			return -EINVAL;
 
 		punit_id = map_partition_power_domain_id(sst_inst, punit_id, &part);
 		if (punit_id < 0)


