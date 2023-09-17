Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFB353B4
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6581C433C9;
	Sun, 17 Sep 2023 19:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979369;
	bh=1o1YZXfr+UyXU4aRH0rverGdb94LbQ66Gh+CvKszt8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdRiexo9Zm8OPG73ZdvLMpFKdS+68tNgvwMmxnSbZwNXb8Iq+t7jJcQ3YtzRL3x61
	 lEbULlIQjxA2v/yMSt7EmwycB9aorMzw8yDrGpV3mfX6cEkNV+oEW3e31I7kKZTUl+
	 lopL/mYb+6g6IX/QwEdynA4Z1utBzjSpkaxLoqjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 293/406] parisc: Fix /proc/cpuinfo output for lscpu
Date: Sun, 17 Sep 2023 21:12:27 +0200
Message-ID: <20230917191109.047791117@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -373,10 +373,18 @@ int
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
@@ -421,8 +429,7 @@ show_cpuinfo (struct seq_file *m, void *
 
 		seq_printf(m, "model\t\t: %s - %s\n",
 				 boot_cpu_data.pdc.sys_model_name,
-				 cpuinfo->dev ?
-				 cpuinfo->dev->name : "Unknown");
+				 cpu_name);
 
 		seq_printf(m, "hversion\t: 0x%08x\n"
 			        "sversion\t: 0x%08x\n",


