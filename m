Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C213FE2D;
	Mon,  1 Apr 2024 15:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986716; cv=none; b=NMDexDSdnFp+SbzOSpnc2WJ7wi+F5soMgB6F5WDJE0BQ/mrqMiM/PmWvc0GIKPLyuDZdaCmSpdygR+5gQcpQxJ1t7jDVzcFBUgVSnswGGOLN7qQxz1fRCp722zxQO12PD6bG6QHo0CAnnjM6p3IMMW5668laEXB1ihDXnsnM5qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986716; c=relaxed/simple;
	bh=EJkc/Yw9c9o3dkn4nuEqn1BVDoMbiptNlo702bKyjcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKytVEKx1kXHKd0pkv1QMV+2LkFzFGyxw/2UJ8sJ/J2U5ZnzTf41Ir4dp5Pq72PoqeBoKmCuwATC/ngOy9JSjbWG5gzv+vM2Dg9PA8lSNT5MfIxx09BJpx8C6TAG+IlZP+EDcTwYTLrvA/Xswt7xT2J4pQLg5aMt+AMSIKUODRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMDS4q2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMDS4q2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC54C433C7;
	Mon,  1 Apr 2024 15:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986716;
	bh=EJkc/Yw9c9o3dkn4nuEqn1BVDoMbiptNlo702bKyjcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMDS4q2Gt2YWmsrKg7Sze6DFEzr0QCLwNLniKlAj5plJuo4DAOYpxSHnDZmFokjA0
	 SgL5ukFPN0wbHaM4qq/uYsorqm/LFmEElSzi9Hs1Jzy6AXhr4zY8FOBtoqbrwiRaFH
	 wcXHDL7xgiJF6kn4IgpHBi02ZeyZF0H2C+oXiK5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 035/399] powerpc/smp: Increase nr_cpu_ids to include the boot CPU
Date: Mon,  1 Apr 2024 17:40:01 +0200
Message-ID: <20240401152550.213278819@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 777f81f0a9c780a6443bcf2c7785f0cc2e87c1ef ]

If nr_cpu_ids is too low to include the boot CPU adjust nr_cpu_ids
upward. Otherwise the kernel will BUG when trying to allocate a paca
for the boot CPU and fail to boot.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231229120107.2281153-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 58e80076bed5c..77364729a1b61 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -381,6 +381,12 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 			nr_cpu_ids);
 	}
 
+	if (boot_cpuid >= nr_cpu_ids) {
+		set_nr_cpu_ids(min(CONFIG_NR_CPUS, ALIGN(boot_cpuid + 1, nthreads)));
+		pr_warn("Boot CPU %d >= nr_cpu_ids, adjusted nr_cpu_ids to %d\n",
+			boot_cpuid, nr_cpu_ids);
+	}
+
 	/*
 	 * PAPR defines "logical" PVR values for cpus that
 	 * meet various levels of the architecture:
-- 
2.43.0



