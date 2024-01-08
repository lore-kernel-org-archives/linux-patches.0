Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6892E4C3A9;
	Mon,  8 Jan 2024 15:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhf8WrBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE9BC433CB;
	Mon,  8 Jan 2024 15:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726804;
	bh=qr0NuEnogppl1m4zV/8xv7AGfjwOoP+6F4drMVKFags=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhf8WrBvH3vtaxds96frxldgbOlRlCbThTfD8s1bnGwDntUsLHpYJposZ3CYz6dvD
	 pRPKrnvzJXpoS1iCo5HG3tYxArwOMqlKA1rVFlph2yj3m0mnNcbXcSv/NEyU/BsXKS
	 834YhkUqtXiHxU4y3bxFF/l1wiNCV+Ph5x33J+gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/124] riscv: dont probe unaligned access speed if already done
Date: Mon,  8 Jan 2024 16:08:28 +0100
Message-ID: <20240108150606.752169778@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit c20d36cc2a2073d4cdcda92bd7a1bb9b3b3b7c79 ]

If misaligned_access_speed percpu var isn't so called "HWPROBE
MISALIGNED UNKNOWN", it means the probe has happened(this is possible
for example, hotplug off then hotplug on one cpu), and the percpu var
has been set, don't probe again in this case.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Fixes: 584ea6564bca ("RISC-V: Probe for unaligned access speed")
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230912154040.3306-1-jszhang@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpufeature.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 1cfbba65d11ae..e12cd22755c78 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -568,6 +568,10 @@ void check_unaligned_access(int cpu)
 	void *src;
 	long speed = RISCV_HWPROBE_MISALIGNED_SLOW;
 
+	/* We are already set since the last check */
+	if (per_cpu(misaligned_access_speed, cpu) != RISCV_HWPROBE_MISALIGNED_UNKNOWN)
+		return;
+
 	page = alloc_pages(GFP_NOWAIT, get_order(MISALIGNED_BUFFER_SIZE));
 	if (!page) {
 		pr_warn("Can't alloc pages to measure memcpy performance");
-- 
2.43.0



