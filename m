Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3715D277026;
	Sat, 17 Oct 2026 16:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255805; cv=none; b=usIJoELiazRovEHxovR88lHfbG3EYzmnsVDsPhHQXKJcVsjoqFCO3bUPkQV8jBuaLnhbkYE5Ma3As/x+8pI2SXJRx+13bm7icVaVCsLI+kD3n67CILV7bpzp882qkXND4HEnSLKCP3MVYQZpUPvPxaZKp961PwENP9lWgnpg6LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255805; c=relaxed/simple;
	bh=NTpLwQCcOwHGaQhECja8yEWJxKJXoddaxnePKFR3nxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot0Qnr7MhuwiIgGWLG+oGlBesqErunW/xxkb+aC/AzVpP1SBCGfXBe+cySiVA/ORNt3SuDUfb4njJknaPNDNHZ5zhLxkDXXUoAEoeh6Zc6JmQmyG4xaWMopp36MJbaYBaA0quvtzzB4RJTyX9bf5lPUvPaIkg8Wxi8WwekY8q/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGl1O+eP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGl1O+eP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0D51F000C4;
	Sat, 17 Oct 2026 16:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255804;
	bh=qdJJfy3hQya1iv7XfQSpj+l2APrjno5EfzSucBVBgqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGl1O+ePNO2PNotVi7k3hKhTs/6bXVKa16vAvPJuZ7/PmYthD/2duFUtRH9JD/jPy
	 JJJSOr8ZZ2d4/BPX/K8EycxRh1ZgmIzJ3lhMZLTSEEHIz2wU6J0BvuRrwylKGRJpuQ
	 QoiMRDtWYIKfn0y9FWr7ZsV0ovncs6eugkMYBwUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0007/1674] x86/CPU/AMD: Clear virtualized VMLOAD/VMSAVE on Zen4 client
Date: Sat, 17 Oct 2026 17:37:59 +0200
Message-ID: <20261017160431.329676991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit a5ca1dc46a6b610dd4627d8b633d6c84f9724ef0 ]

A number of Zen4 client SoCs advertise the ability to use virtualized
VMLOAD/VMSAVE, but using these instructions is reported to be a cause
of a random host reboot.

These instructions aren't intended to be advertised on Zen4 client
so clear the capability.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219009
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index a2313fa8a0729..955da4c2385fa 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1196,6 +1196,17 @@ static void init_amd_zen3(struct cpuinfo_x86 *c)
 static void init_amd_zen4(struct cpuinfo_x86 *c)
 {
 	init_amd_zen_common();
+
+	/*
+	 * These Zen4 SoCs advertise support for virtualized VMLOAD/VMSAVE
+	 * in some BIOS versions but they can lead to random host reboots.
+	 */
+	switch (c->x86_model) {
+	case 0x18 ... 0x1f:
+	case 0x60 ... 0x7f:
+		clear_cpu_cap(c, X86_FEATURE_V_VMSAVE_VMLOAD);
+		break;
+	}
 }
 
 static void init_amd_zen5(struct cpuinfo_x86 *c)
-- 
2.53.0



