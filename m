Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3269215F7C;
	Tue, 29 Apr 2025 17:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948194; cv=none; b=Ct8niHPJ+o0ST8HHBpR7ws9CPkYgxbtMPOj6jKr6EHtlhxpyR3LfLvbFLitAxuQkctz9t0gQqDJxp72cDz6bJ6n6uUfieUkJAC2MtFgOBsiBX7AMCzHquYb59vubvPVlOh8S8qXtfxef173qJQUSbsDBQodltFXQkoqSXCSO8SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948194; c=relaxed/simple;
	bh=PyPyN/PRst+yJOZzgkPc3988dt3Dln2ZL5GNQ75NPFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TQxWhYE60uUhgFruonWWDMC94Xqg6TwwYa7Wa7P7od+Fm63J7iuweZSCoy9kPf+xdZr44nD33IQEEbhngdiFadFw5XgFLLYbEd2RTA5GThm4LU6iUbwz4+p1b2EZkeUToeaWTteo2TmfLC2JAF9oyOvKxp8MoH9gIaQpnfaVNSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zv02GdKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zv02GdKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D386C4CEE3;
	Tue, 29 Apr 2025 17:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948194;
	bh=PyPyN/PRst+yJOZzgkPc3988dt3Dln2ZL5GNQ75NPFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zv02GdKt2ysCavLGoK5m3L71u5VcCAFQDD/FBjE9ap+ySgN9jA9/CdK8xddQQKcCW
	 aC5Z7gAHJqvYGBAB8tYb0lqPVLNjxrw/8n9Q9DO3levRZfK2Op3/9iHvRSRyo6/b8g
	 aP4YA9nO6Zb79DZGr8xmSbpFVB0tgHDk3safuyJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/280] x86/xen: disable CPU idle and frequency drivers for PVH dom0
Date: Tue, 29 Apr 2025 18:42:37 +0200
Message-ID: <20250429161123.962189299@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Roger Pau Monne <roger.pau@citrix.com>

[ Upstream commit 64a66e2c3b3113dc78a6124e14825d68ddc2e188 ]

When running as a PVH dom0 the ACPI tables exposed to Linux are (mostly)
the native ones, thus exposing the C and P states, that can lead to
attachment of CPU idle and frequency drivers.  However the entity in
control of the CPU C and P states is Xen, as dom0 doesn't have a full view
of the system load, neither has all CPUs assigned and identity pinned.

Like it's done for classic PV guests, prevent Linux from using idle or
frequency state drivers when running as a PVH dom0.

On an AMD EPYC 7543P system without this fix a Linux PVH dom0 will keep the
host CPUs spinning at 100% even when dom0 is completely idle, as it's
attempting to use the acpi_idle driver.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Jason Andryuk <jason.andryuk@amd.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250407101842.67228-1-roger.pau@citrix.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/enlighten_pvh.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten_pvh.c b/arch/x86/xen/enlighten_pvh.c
index 0e3d930bcb89e..9d25d9373945c 100644
--- a/arch/x86/xen/enlighten_pvh.c
+++ b/arch/x86/xen/enlighten_pvh.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/acpi.h>
+#include <linux/cpufreq.h>
+#include <linux/cpuidle.h>
 #include <linux/export.h>
 #include <linux/mm.h>
 
@@ -123,8 +125,23 @@ static void __init pvh_arch_setup(void)
 {
 	pvh_reserve_extra_memory();
 
-	if (xen_initial_domain())
+	if (xen_initial_domain()) {
 		xen_add_preferred_consoles();
+
+		/*
+		 * Disable usage of CPU idle and frequency drivers: when
+		 * running as hardware domain the exposed native ACPI tables
+		 * causes idle and/or frequency drivers to attach and
+		 * malfunction.  It's Xen the entity that controls the idle and
+		 * frequency states.
+		 *
+		 * For unprivileged domains the exposed ACPI tables are
+		 * fabricated and don't contain such data.
+		 */
+		disable_cpuidle();
+		disable_cpufreq();
+		WARN_ON(xen_set_default_idle());
+	}
 }
 
 void __init xen_pvh_init(struct boot_params *boot_params)
-- 
2.39.5



