Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B05139FE3;
	Fri, 24 Nov 2023 18:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnhSpuaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A54DC433C7;
	Fri, 24 Nov 2023 18:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850169;
	bh=WxRUYn0Aqsv7gQpjzY7jiOmrQ5ih9EjyjVxEUXRzj00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnhSpuaXGeqcc+kObAUkDDcb1uWRMomn+sy6YW+6hHeSDcDNd4Hw5H2Of8Vvl0Nps
	 HxBDBNY9hGgMlx3WbKon+KoGvBHe7TglU5OtC0EFbQqfTupcfJvt//ZjQGJ91Mguoh
	 6+wNgKf0MBm17o2079b/WKTSdmietAUHGxjfUpLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Song Shuai <suagrfillet@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 473/530] riscv: correct pt_level name via pgtable_l5/4_enabled
Date: Fri, 24 Nov 2023 17:50:39 +0000
Message-ID: <20231124172042.467210099@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Song Shuai <suagrfillet@gmail.com>

commit e59e5e2754bf983fc58ad18f99b5eec01f1a0745 upstream.

The pt_level uses CONFIG_PGTABLE_LEVELS to display page table names.
But if page mode is downgraded from kernel cmdline or restricted by
the hardware in 64BIT, it will give a wrong name.

Like, using no4lvl for sv39, ptdump named the 1G-mapping as "PUD"
that should be "PGD":

0xffffffd840000000-0xffffffd900000000    0x00000000c0000000         3G PUD     D A G . . W R V

So select "P4D/PUD" or "PGD" via pgtable_l5/4_enabled to correct it.

Fixes: e8a62cc26ddf ("riscv: Implement sv48 support")
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Song Shuai <suagrfillet@gmail.com>
Link: https://lore.kernel.org/r/20230712115740.943324-1-suagrfillet@gmail.com
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230830044129.11481-3-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/ptdump.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/riscv/mm/ptdump.c
+++ b/arch/riscv/mm/ptdump.c
@@ -384,6 +384,9 @@ static int __init ptdump_init(void)
 
 	kernel_ptd_info.base_addr = KERN_VIRT_START;
 
+	pg_level[1].name = pgtable_l5_enabled ? "P4D" : "PGD";
+	pg_level[2].name = pgtable_l4_enabled ? "PUD" : "PGD";
+
 	for (i = 0; i < ARRAY_SIZE(pg_level); i++)
 		for (j = 0; j < ARRAY_SIZE(pte_bits); j++)
 			pg_level[i].mask |= pte_bits[j].mask;


