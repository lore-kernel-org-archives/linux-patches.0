Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACB230C618;
	Thu, 30 Jul 2026 15:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424414; cv=none; b=sEvg3/bnMJ6QwKCw+/aqEmAn5kupRNpjAPpwzr/kWSAJte6V8O77cUE1vApMKSCHxX9WMCj/kLP3YY5exwnOer7HPuhvrDTNpa7tK2QLmiGRxHG/uGiKEhrGdo40T6w9JUjlC1jcFQcrh1G4+wCxIgYBH2SABHVo44O/V2Neygg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424414; c=relaxed/simple;
	bh=XfFGPsDb7IpuSH1q/xG7cD6Np2k0UuKkxQpZGeZ+hJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB3Wqhu2zA55hCxbYjQ5QzGs/V2ehFjNpo/pby1wpXhoCsqcv59RMa/ritC2/1jVlC7wdxoytPVXfk+9H7sL2dE5J6j6xzkS8sv66jXCvmtPe3LlhH6Y87m/pzGjmgi4IovS4lfQy2hBpUcHV/6pelQ7yzo2z7g0sY5WHBZQVjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXqpiVpb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXqpiVpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E8B1F000E9;
	Thu, 30 Jul 2026 15:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424412;
	bh=4kBuGDyFpV6niO4hP2JJwl05fx9g27IzX7xaiQHsMp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXqpiVpb/gT2MCLV5eI17zUChAHnwE6BJuB3klcu7vkCG9S8qEJ1yog9JruAdKhhF
	 KTs16jqhN3bj+zpzyxpBGr2D5GxFo74tfJW1DOfyoYkPDNxvoDlKP0vrMSCszMKewz
	 mvK1ycuHzjoVgHA5+2LzQJGzvrBOSMam9DpHd7fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 385/675] drm/amdgpu: Disable PCIe dynamic speed switching on Ryzen Pinnacle Ridge
Date: Thu, 30 Jul 2026 16:11:55 +0200
Message-ID: <20260730141453.318893168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 0148ac33547b9af1c5a7f3bb6e5baffcb6e9fac2 upstream.

AMD Ryzen Pinnacle Ridge (Zen+, family 0x17 model 0x08) CPUs have
PCI controllers that don't support PCIe dynamic speed switching,
causing system freezes during GPU initialization when enabled.

Disable dynamic speed switching when this CPU is detected.

Assisted-by: Claude:sonnet
Fixes: 466a7d115326 ("drm/amd: Use the first non-dGPU PCI device for BW limits")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5436
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Link: https://patch.msgid.link/20260709031520.841611-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9ceb4e034a327a04155f32f1cd1a5031dfa5fe02)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1878,6 +1878,15 @@ static bool amdgpu_device_pcie_dynamic_s
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)
 		return false;
+
+	/*
+	 * AMD Ryzen Pinnacle Ridge (Zen+, family 0x17 model 0x08) CPUs don't
+	 * support PCIe dynamic speed switching.
+	 * https://gitlab.freedesktop.org/drm/amd/-/work_items/5436
+	 */
+	if (c->x86_vendor == X86_VENDOR_AMD && c->x86 == 0x17 &&
+	    c->x86_model == 0x08)
+		return false;
 #endif
 	return true;
 }


