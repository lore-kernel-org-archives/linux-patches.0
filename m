Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F173074B3;
	Wed,  3 Dec 2025 16:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778067; cv=none; b=beyskZCeJ9Zab1vw2WWFkVVpL5TXYb0MlKzpxK8zvb9lORMPy9z9VfrOqqz2NFlczGspSXLOYYOarMCow/RDCQk7ApVWvzSRfXWqOlmDiQFZCbQa4SvR5ytM4WS4azrp+MSnUw9MYMIUE9qvRFqDhpsQgd3oBxTDDd5o6jVKsVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778067; c=relaxed/simple;
	bh=HU5/UI1DtFdQR1a2RIq8JGD7d9bojZoxCKsSSt5Bg6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pzy5amxU2LOBch87pudrFIRJHw6cdfjYestYc0+dthHGh0wa6dq0PsJ0nh7GTcLAi3W8SQWemHfxSp2dybBrFxUXgUzcJM3zkMIYlhJVruU+ZOwkOW4T5+EFR5xvvVDNzvjO+5Lj9zjdCqNuj/MQgIw+jcsoUT0Yf6YRZVE576k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LfIi/Wh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LfIi/Wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEF1C4CEF5;
	Wed,  3 Dec 2025 16:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778067;
	bh=HU5/UI1DtFdQR1a2RIq8JGD7d9bojZoxCKsSSt5Bg6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LfIi/WhLOa/Gv5CcczZAd7tAHd3o5Eb6wdZqVI/+U+skKi3GZtCJza03AS4+zkDe
	 oKaMdjAWMdjRQAR7LDU33rWDsPVu2kA7KOrh1gJ6hBInTocyVQIgkjtudIKtdvfNj3
	 pHYvHz+cBGWnQe9TsiPaWsg4L16dF9KhJXkamX0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>,
	Andrew Jones <ajones@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/392] RISC-V: clear hot-unplugged cores from all task mm_cpumasks to avoid rfence errors
Date: Wed,  3 Dec 2025 16:26:22 +0100
Message-ID: <20251203152422.718637808@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>

[ Upstream commit ae9e9f3d67dcef7582a4524047b01e33c5185ddb ]

openSBI v1.7 adds harts checks for ipi operations. Especially it
adds comparison between hmask passed as an argument from linux
and mask of online harts (from openSBI side). If they don't
fit each other the error occurs.

When cpu is offline, cpu_online_mask is explicitly cleared in
__cpu_disable. However, there is no explicit clearing of
mm_cpumask. mm_cpumask is used for rfence operations that
call openSBI RFENCE extension which uses ipi to remote harts.
If hart is offline there may be error if mask of linux is not
as mask of online harts in openSBI.

this patch adds explicit clearing of mm_cpumask for offline hart.

Signed-off-by: Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20250919132849.31676-1-danil.skrebenkov@cloudbear.ru
[pjw@kernel.org: rewrote subject line for clarity]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpu-hotplug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/cpu-hotplug.c b/arch/riscv/kernel/cpu-hotplug.c
index 28a3fa6e67d79..25659db3b1a43 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -67,6 +67,7 @@ void __cpu_die(unsigned int cpu)
 	}
 	pr_notice("CPU%u: off\n", cpu);
 
+	clear_tasks_mm_cpumask(cpu);
 	/* Verify from the firmware if the cpu is really stopped*/
 	if (cpu_ops[cpu]->cpu_is_stopped)
 		ret = cpu_ops[cpu]->cpu_is_stopped(cpu);
-- 
2.51.0



