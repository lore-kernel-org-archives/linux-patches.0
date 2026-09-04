Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C6B414DF6;
	Fri,  4 Sep 2026 05:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501471; cv=none; b=G63xseQ5plgwB+bNLxruWVMka8vD4yCzEwsuggAiwY5HF3PopZV6Wzc0POolaoCz3E1PRKmI1shBA/1SHGFWAuYOAiwhO7sE3suKVS/zTTAJpymzjkqOaNzeXNPKpQwoVfaw0L1Vq+LQGsf3p0theGN8NOndFnkBZC8HBvurg44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501471; c=relaxed/simple;
	bh=Pg/qk0Hfzw2+ZxPxgKs185EFYWm+EEzTfNW2wsxCnes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lb9NcjEhEybVVIUhMlm/NpqqJuMRge0WGYy92rHv8sWaN5vGRmYz2SZDPGkyA10LPr64C8hnNhImMDCDEgOmcerFLn9gv27a2jhxS5heRvDzeYdE3QdkwxqEvlbgIdLlkYCdez2tjxJZXcNM4cjcYUOjUyQrwaxOVJ9zsFjXHqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ku0NOLcn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ku0NOLcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63E41F00A3D;
	Fri,  4 Sep 2026 05:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501469;
	bh=m5F35/b+5rxDYmIcGtock1kDNzNrVG8c/VQFjaQE/60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ku0NOLcnBr1vEF7bD7KaTR1KWv8J77QA88B8cwVqMeoK98qQk27YofqxT1ePVfOzo
	 TldbwFN9MZtqsaV+JmXRDjR7aoJgY2KiX1e6AmzrCd/BmE39zb0+kl/rk9RtRlq8Zr
	 BIuYtTBPVgJBWdGTnKfyoLuE6qB94Lqd0F7ZCa94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 421/552] platform/x86: ISST: Validate logical CPU id and clos id
Date: Fri,  4 Sep 2026 06:59:38 +0200
Message-ID: <20260904045800.152261036@linuxfoundation.org>
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
@@ -652,6 +652,8 @@ static long isst_if_core_power_state(voi
 #define SST_CLOS_CONFIG_MAX_START	16
 #define SST_CLOS_CONFIG_MAX_WIDTH	8
 
+#define SST_MAX_CLOS			3
+
 static long isst_if_clos_param(void __user *argp)
 {
 	struct tpmi_per_power_domain_info *power_domain_info;
@@ -660,6 +662,9 @@ static long isst_if_clos_param(void __us
 	if (copy_from_user(&clos_param, argp, sizeof(clos_param)))
 		return -EFAULT;
 
+	if (clos_param.clos > SST_MAX_CLOS)
+		return -EINVAL;
+
 	power_domain_info = get_instance(clos_param.socket_id, clos_param.power_domain_id);
 	if (!power_domain_info)
 		return -EINVAL;
@@ -706,6 +711,8 @@ static long isst_if_clos_param(void __us
 #define SST_CLOS_ASSOC_CPUS_PER_REG	16
 #define SST_CLOS_ASSOC_BITS_PER_CPU	4
 
+#define SST_CLOS_ASSOC_MAX_LOGICAL_CPU	63
+
 static long isst_if_clos_assoc(void __user *argp)
 {
 	struct isst_if_clos_assoc_cmds assoc_cmds;
@@ -732,9 +739,15 @@ static long isst_if_clos_assoc(void __us
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
 


