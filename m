Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5AB3328E6;
	Fri,  4 Sep 2026 06:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502732; cv=none; b=jRHUfpcx/wSF0D31sGO3C43smnULG3JCux2XseASnFEFE9sxpoVlVgRDfeoJbKer9rtw/IS97MZmAEvZi3Oum1cTBjiUCwtwIW9vaXThDinN5BWYMGwdYdS/jXWjlcS14YgnEDdmKVWm2G93R+5vT29c2iwQhERwxTUHPza2Kak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502732; c=relaxed/simple;
	bh=5bbaNjCjCpGK5d8eUwzD4sfXEhlxDPw1VNwMW9qkHok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RIPqMSf0tRfh603Z7IC2606S7q8OCnShf9s3Z/oeZllZDdfZ4CYXTcAL+VTuEivnZyDems4op+3UfBLNKY5nLdtq4b/5ihjlnHG3QMATWL7H55Bbxc6PD+luPxCSXMV5jSyEb7fLsHX5nUQxfrce2aspEWY1YHgn1ohDZAMTodk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVB6DvdS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVB6DvdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265021F00A3D;
	Fri,  4 Sep 2026 06:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502730;
	bh=o3qCpQZNz3ptzDRZHRsWNIk5CCnbWDoyQLUc4St4+Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVB6DvdSqJIbjJMuf70a4gEPKFtjsLv0QtS29W8zLp2H9DFhmH0QK5+lL4Ttjso0C
	 fqigq9lDx0CQmPMGcj26BiKtMY/1BPr8AURDSl+ejdK3ehU5E6kpLUpBKakMeYz4OI
	 7SjSqm/FW1TGVU7KMH4TW3Tz8xOjd6jVPR3d60ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 309/403] platform/x86: ISST: Validate socket ID in clos_assoc ioctl
Date: Fri,  4 Sep 2026 07:01:52 +0200
Message-ID: <20260904045741.870728695@linuxfoundation.org>
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
@@ -724,7 +724,7 @@ static long isst_if_clos_assoc(void __us
 		if (copy_from_user(&clos_assoc, ptr, sizeof(clos_assoc)))
 			return -EFAULT;
 
-		if (clos_assoc.socket_id > topology_max_packages())
+		if (clos_assoc.socket_id >= topology_max_packages())
 			return -EINVAL;
 
 		cpu = clos_assoc.logical_cpu;
@@ -742,6 +742,8 @@ static long isst_if_clos_assoc(void __us
 		pkg_id = clos_assoc.socket_id;
 
 		sst_inst = isst_common.sst_inst[pkg_id];
+		if (!sst_inst)
+			return -EINVAL;
 
 		punit_id = map_partition_power_domain_id(sst_inst, punit_id, &part);
 		if (punit_id < 0)


