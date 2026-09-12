Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2636E2FFFA5;
	Sat, 12 Sep 2026 13:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220715; cv=none; b=ubaOPDUFiXnfCSEnL072oOsFW4ngzQ3rDDv49fN91btYzCC9tVh0OEDV76QGCx/Ezpwk+u9H9S7CUuteRkc+oWT0UCf1ckDz53zY5RFwVwz4o6GLziQPIflGHKu7AQXgWAdFIGd1cI5vqftq1CmTC6sSTxYM3AgbHaKM04RxJ/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220715; c=relaxed/simple;
	bh=TrgaBaqNTA4eau1itZxVtnOeHYTvn89BJ0j/YBtwdVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MdAFlZfhWlvVXvt/w6vjpPp4+v0cTS7tSt6ohyWO3O2wXa6ynyQi/SVRMDoM4pRPUS3d26v/1QEhuI/KIA+2RnPeKefbx3YCPpr3gviW6EBz5baGybN/1r3lDZemQvOMOIFuYDTu/gIRi7cos1aERIDde8D4Qeu0k9eKuOuLQnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s48tFOA8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s48tFOA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD661F000FF;
	Sat, 12 Sep 2026 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220714;
	bh=jsQizryxozb2M7t6/9qdcaFh3ioA84+8Q1z99abYJJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s48tFOA8J17c6M0+sf292gSILOJdDJlta91ahCj4IVRsGKfIEYrLLdFGpmOjrXwgr
	 rfa+HBIEhzbGtItTfrPqYQ187d4cpoHtImr5trnC21mC733b5iShPeaKsuleLsoSgC
	 nzZsf2DXFX3qY2teEJiLgAbrL6AHR+x7vS81TZKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0234/1424] platform/x86: ISST: Validate socket ID in clos_assoc ioctl
Date: Sat, 12 Sep 2026 08:44:26 +0200
Message-ID: <20260912065612.521752971@linuxfoundation.org>
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
@@ -573,7 +573,7 @@ static long isst_if_clos_assoc(void __us
 		if (copy_from_user(&clos_assoc, ptr, sizeof(clos_assoc)))
 			return -EFAULT;
 
-		if (clos_assoc.socket_id > topology_max_packages())
+		if (clos_assoc.socket_id >= topology_max_packages())
 			return -EINVAL;
 
 		cpu = clos_assoc.logical_cpu;
@@ -591,6 +591,8 @@ static long isst_if_clos_assoc(void __us
 		pkg_id = clos_assoc.socket_id;
 
 		sst_inst = isst_common.sst_inst[pkg_id];
+		if (!sst_inst)
+			return -EINVAL;
 
 		if (clos_assoc.power_domain_id > sst_inst->number_of_power_domains)
 			return -EINVAL;


