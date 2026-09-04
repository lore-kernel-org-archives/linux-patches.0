Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D32C423788;
	Fri,  4 Sep 2026 06:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502749; cv=none; b=m13Y0Q5S8GN6Pr/BuTkqcQ6vFHD41dLgFr3te7dE1pZ+Cih+beD8IcSimwl7a0yJioKwbG3zGV43qnbVV/0hQuKhXvEXdhys86JspKrBTqSH0BV/D37QkdPAHpl+gY6YP3E9GPP4ZZ7gvu+1UilSCMT2EpplNTwErYeLNydyg34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502749; c=relaxed/simple;
	bh=86o+KhoDutXSDg15WLa2TI80K1JJ/fRqrN6YIByyemk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GxZj6FHfnlA/Qpj5vye7g/fpTUIDVYOvaam/XvmSeRgo6srZ3kMCkgz49zyj84OMzBXzHM6L+TJZGHHTJRJ8+t9GklEHYZzMUNxeToUzTtahns6dituoQBtUG4Gbziu7You8LRqEUxZH8wCg4O8m4qxpQVmhNdmlgRAanWRrlX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mT4+z26M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mT4+z26M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4031F00A3D;
	Fri,  4 Sep 2026 06:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502747;
	bh=Pg9iR911sWcsRC0WoCe6FrVkxAop9mJUv39YkvQlRpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mT4+z26M3JN/eIa1XAvBpoNEumTHupiHEIXWsfyV6dju1R2eJBJi42KmLTxJVkKnn
	 qMJr3E3Qx6p/TTH0hd8BBbWJweHzDm3MUVvmyzTInvXBOerJYPd03uQRbDJ+99M80d
	 Ug0xcKJdcTt/3jHj1eJTGKE2pPwmPbqKqTw2VjZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 314/403] platform/x86: ISST: Validate logical CPU id and clos id
Date: Fri,  4 Sep 2026 07:01:57 +0200
Message-ID: <20260904045741.979726010@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 124e2dbabe460c2a6e7440f4ad8af560131295c9 upstream.

Validate max CLOS ID and logical CPU ID for core power feature.
Reject any clos level or logical CPU number greater than the
supported maximum. These are used to calculate MMIO offset.

Fixes: 12a7d2cb811d ("platform/x86: ISST: Add SST-CP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-2-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |   13 ++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -647,6 +647,8 @@ static long isst_if_core_power_state(voi
 #define SST_CLOS_CONFIG_MAX_START	16
 #define SST_CLOS_CONFIG_MAX_WIDTH	8
 
+#define SST_MAX_CLOS			3
+
 static long isst_if_clos_param(void __user *argp)
 {
 	struct tpmi_per_power_domain_info *power_domain_info;
@@ -655,6 +657,9 @@ static long isst_if_clos_param(void __us
 	if (copy_from_user(&clos_param, argp, sizeof(clos_param)))
 		return -EFAULT;
 
+	if (clos_param.clos > SST_MAX_CLOS)
+		return -EINVAL;
+
 	power_domain_info = get_instance(clos_param.socket_id, clos_param.power_domain_id);
 	if (!power_domain_info)
 		return -EINVAL;
@@ -701,6 +706,8 @@ static long isst_if_clos_param(void __us
 #define SST_CLOS_ASSOC_CPUS_PER_REG	16
 #define SST_CLOS_ASSOC_BITS_PER_CPU	4
 
+#define SST_CLOS_ASSOC_MAX_LOGICAL_CPU	63
+
 static long isst_if_clos_assoc(void __user *argp)
 {
 	struct isst_if_clos_assoc_cmds assoc_cmds;
@@ -727,9 +734,15 @@ static long isst_if_clos_assoc(void __us
 		if (copy_from_user(&clos_assoc, ptr, sizeof(clos_assoc)))
 			return -EFAULT;
 
+		if (clos_assoc.clos > SST_MAX_CLOS)
+			return -EINVAL;
+
 		if (clos_assoc.socket_id >= topology_max_packages())
 			return -EINVAL;
 
+		if (clos_assoc.logical_cpu > SST_CLOS_ASSOC_MAX_LOGICAL_CPU)
+			return -EINVAL;
+
 		cpu = clos_assoc.logical_cpu;
 		clos = clos_assoc.clos;
 


