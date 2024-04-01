Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA344D137;
	Mon,  1 Apr 2024 16:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990667; cv=none; b=e+W595Z2QL9kXRBzdyg7fgzI+/GU9TU4izg+WiKyuHxAvfNUqxpM9/GPC1CqUfKocNUJbFXJ1hPLZhAHnxtJ967d3dwM5xEQiIMiv8UV7YBLSRwOgg/7gCuYY+ZsGpPZmeVTwG8BgjvRf//sWZjf9gaKvw6Dz6IK3eRjKHnqmWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990667; c=relaxed/simple;
	bh=8RgxIasDXbj1qJSYcI82G+hUIXNZtPbXEpS7R10hjTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOACgp4EZGVwhbYnzk1gCNwc1/BZrUreKrVKEGrQ+YbCyYrnwPBt2An2pAeDBu98YgLTrsO9hO3lyMlat9WVCNMNZ3FbjIQPSJNZJAZUvyDPX8Yz006L4lLghuntwH0++hVRkNfdnIm3amS1jMimKbYyaG9Qz/WZlxHPjgqyGhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mknVgtSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mknVgtSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85177C433F1;
	Mon,  1 Apr 2024 16:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990666;
	bh=8RgxIasDXbj1qJSYcI82G+hUIXNZtPbXEpS7R10hjTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mknVgtSVam+a5klpLLBNk6QNUj3AfUglv9VWCy3uTnz/PWm/Ta/8+Lh0JrCE+Ribp
	 ku7vjGxsk7NOXSFCQXvuNbFFk3im6reMxAUOGVPzn8t6dzzlLh8nJYEL3lS3V4jUSz
	 V1KpBls5fxRKaks0JWR3XvLuhztf/YFUMST4bX4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/272] powerpc/smp: Increase nr_cpu_ids to include the boot CPU
Date: Mon,  1 Apr 2024 17:43:39 +0200
Message-ID: <20240401152531.268755523@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a64f4fb332893..9531ab90feb8a 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -375,6 +375,12 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
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



