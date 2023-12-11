Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FBBFC06;
	Mon, 11 Dec 2023 18:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uq9XbCR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49044C433C7;
	Mon, 11 Dec 2023 18:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320038;
	bh=hNR1HtgSSCOHPBq8JX2D0oGJkHITlsdkbPaW4kic6Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uq9XbCR8TCOGfd8CNAYEQG1S9RLXC69oWGbFZD0Wieng4fVT9cjTVVRL64QqpLlTT
	 2VdkAhXeThvUHvT+GBtK4DaVUn1gEPICKdaY4bkhb+CgNtnnSr5/PST02200iZL98Y
	 WarUitjpIWQooTqnuh+DKNTgY9favfcDL1KYv/dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 80/97] MIPS: Loongson64: Reserve vgabios memory on boot
Date: Mon, 11 Dec 2023 19:22:23 +0100
Message-ID: <20231211182023.227695028@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 8f7aa77a463f47c9e00592d02747a9fcf2271543 upstream.

vgabios is passed from firmware to kernel on Loongson64 systems.
Sane firmware will keep this pointer in reserved memory space
passed from the firmware but insane firmware keeps it in low
memory before kernel entry that is not reserved.

Previously kernel won't try to allocate memory from low memory
before kernel entry on boot, but after converting to memblock
it will do that.

Fix by resversing those memory on early boot.

Cc: stable@vger.kernel.org
Fixes: a94e4f24ec83 ("MIPS: init: Drop boot_mem_map")
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/loongson64/init.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/mips/loongson64/init.c
+++ b/arch/mips/loongson64/init.c
@@ -140,6 +140,11 @@ static __init void reserve_pio_range(voi
 			}
 		}
 	}
+
+	/* Reserve vgabios if it comes from firmware */
+	if (loongson_sysconf.vgabios_addr)
+		memblock_reserve(virt_to_phys((void *)loongson_sysconf.vgabios_addr),
+				SZ_256K);
 }
 
 void __init arch_init_irq(void)


