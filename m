Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D80B51EDE1;
	Wed, 30 Sep 2026 16:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784808; cv=none; b=UIMvQqbBh5fXeiSDS+irihsPvG15i2KLAkbwy1FiNLedu6K3VIFFawy+J+/oJrNczeXEbM1xlgIW5EYK6Sm/P6YK2S9DRP6/CZiGXpV+Lw40JEuC/RLCh1Fb4o9wQhcNemJRiXIMCCE+EUKeVQh4cfFpWItuNMyhasbNGvpMs0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784808; c=relaxed/simple;
	bh=UzVknkm1kW2LqgaeUj9h2HEr/p5sL+RhSuMDB/lIyWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mg/0SFhpglwxeE2SlmDm/tixlWixVgEc0CALEh+uKYAZU6ix8HBStvPF1hrZT4RA3e34AM5EIP/x7C52wLcQEu3SGfyiiZb07xaKJuoelR9/oNMcazbK3frcrkpg8WGCRIoP5t3UnFgQmWLgqEti69DQcz4+SspxIwEG/re+aUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vts5kJVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vts5kJVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526291F000FF;
	Wed, 30 Sep 2026 16:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784804;
	bh=0RebDvW98cCowKHgttsZh9qPNuv+a6RO7AWwzaeel0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vts5kJVpAV4GcC3Ur+Yd40VZD8w9unRbwL+s7BDtQL0U52+bACG1ytygJaF0HdX45
	 pPJMRxIfzdkTUawVQDvnr+OB6JFre/IoRTaAsbrLd6Ljs1Qp/RJDp1XnzYNYixrrVF
	 NRyILRREmmd9eDbauAdcCU1YrYxP/u5XgpBXm6jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Anushree Mathur <anushree.mathur@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 284/982] powerpc/pseries: Ensure vpa,slb_shadow & dtl are unregistered during crash
Date: Wed, 30 Sep 2026 17:17:00 +0200
Message-ID: <20260930152422.901190746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit 810d07fb4cf7577847f85a6fd6273b69cad8d580 ]

Currently pseries_kexec_cpu_down() skips unregistering vpa, slb_shadow and
dtl areas during a crash and kexec shutdown path. It was done to avoid
doing an HCALL while crashing. However recently Anushree reported that
during kernel crash while the kdump kernel was coming up, Hypervisor
reported invalid values for 'vpa.yield_count' while it dispatching L2-KVM
Guest vcpus. The error manifested as debug build Hypervisor assert
triggering to indicate possible VPA corruption.

Looking at the kexec cpu offline path it was discovered that during crash
kernel doesn't unregister the VPA/SLB-Shadow/DTL area with
Hypervisor. Instead it re-allocates and re-registers these areas
for cpus during boot. During kexec boot the previously allocated areas
can get overwritten with new content without hypervisor knowledge. This
creates a small window where while kexec kernel boots and the L2-VCPUs are
being dispatched, Hypervisor may try to read/write to a wrong memory area
which previously belonged to older VPA.

Fix this possible race and memory corruption by updating
pseries_kexec_cpu_down() to also unregister vpa,slb_shadow & dtl areas
during a kernel crash.

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Tested-by: Anushree Mathur <anushree.mathur@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260708015802.274271-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/kexec.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/kexec.c b/arch/powerpc/platforms/pseries/kexec.c
index 431be156ca9bb..29f7c97ff1932 100644
--- a/arch/powerpc/platforms/pseries/kexec.c
+++ b/arch/powerpc/platforms/pseries/kexec.c
@@ -20,12 +20,15 @@
 void pseries_kexec_cpu_down(int crash_shutdown, int secondary)
 {
 	/*
-	 * Don't risk a hypervisor call if we're crashing
-	 * XXX: Why? The hypervisor is not crashing. It might be better
-	 * to at least attempt unregister to avoid the hypervisor stepping
-	 * on our memory.
+	 * Ensure vpa/slb_shadow/dtl cleanup even while we are crashing.
+	 * Why? The hypervisor is not crashing so at least attempt unregister to
+	 * avoid the hypervisor stepping on our memory. If hypervisor or kexec
+	 * kernel steps on the old memory allocated to these areas before the
+	 * new kexec-kernel happens to allocate and register new areas,
+	 * the hypervisor will see invalid content which may cause
+	 * unexpected behavior.
 	 */
-	if (firmware_has_feature(FW_FEATURE_SPLPAR) && !crash_shutdown) {
+	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
 		int ret;
 		int cpu = smp_processor_id();
 		int hwcpu = hard_smp_processor_id();
-- 
2.53.0



