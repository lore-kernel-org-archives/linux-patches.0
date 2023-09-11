Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561EB11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8937C433C7;
	Mon, 11 Sep 2023 14:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444319;
	bh=cZavOMwapo2NCvI5r5KMlfXSH6bIYN6J3aQZcs6itSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOaGsnw4uFAfNC2JE7/FKYSUmwhX38Tna3T+zht9fzjjxHRrnPXyVVvVTYy0uV7Xv
	 UVHZE5qa3DrIeyIkM5UnwT9YiN0q3DwuGVJqEjntyGGC5+XOu0WQ/61K/vzjJzQ4ON
	 gf1OD6+5QC7HHdSWzZkkVDy512h6DqV8DFDfx5Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.4 688/737] parisc: Fix /proc/cpuinfo output for lscpu
Date: Mon, 11 Sep 2023 15:49:07 +0200
Message-ID: <20230911134709.750257964@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 9f5ba4b3e1b3c123eeca5d2d09161e8720048b5c upstream.

The lscpu command is broken since commit cab56b51ec0e ("parisc: Fix
device names in /proc/iomem") added the PA pathname to all PA
devices, includig the CPUs.

lscpu parses /proc/cpuinfo and now believes it found different CPU
types since every CPU is listed with an unique identifier (PA
pathname).

Fix this problem by simply dropping the PA pathname when listing the
CPUs in /proc/cpuinfo. There is no need to show the pathname in this
procfs file.

Fixes: cab56b51ec0e ("parisc: Fix device names in /proc/iomem")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/processor.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/processor.c
+++ b/arch/parisc/kernel/processor.c
@@ -377,10 +377,18 @@ int
 show_cpuinfo (struct seq_file *m, void *v)
 {
 	unsigned long cpu;
+	char cpu_name[60], *p;
+
+	/* strip PA path from CPU name to not confuse lscpu */
+	strlcpy(cpu_name, per_cpu(cpu_data, 0).dev->name, sizeof(cpu_name));
+	p = strrchr(cpu_name, '[');
+	if (p)
+		*(--p) = 0;
 
 	for_each_online_cpu(cpu) {
-		const struct cpuinfo_parisc *cpuinfo = &per_cpu(cpu_data, cpu);
 #ifdef CONFIG_SMP
+		const struct cpuinfo_parisc *cpuinfo = &per_cpu(cpu_data, cpu);
+
 		if (0 == cpuinfo->hpa)
 			continue;
 #endif
@@ -425,8 +433,7 @@ show_cpuinfo (struct seq_file *m, void *
 
 		seq_printf(m, "model\t\t: %s - %s\n",
 				 boot_cpu_data.pdc.sys_model_name,
-				 cpuinfo->dev ?
-				 cpuinfo->dev->name : "Unknown");
+				 cpu_name);
 
 		seq_printf(m, "hversion\t: 0x%08x\n"
 			        "sversion\t: 0x%08x\n",


