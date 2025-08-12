Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3332FE57E;
	Tue, 12 Aug 2025 18:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024950; cv=none; b=u/hJdOoTxCsFHzR2+KhmFjKYD6L0n+V3ID4g2ezhRobUjpVbMLiKaQUu7ddOZ/IQRTRupOqWGVxMEo2w+9XC+/r0ie4EaqLlojXpznipv54PO8put1vaa9C1DDg+ihyZU8Svog291K+y967uPxa8Fsk5v7do6btroyTPZko+tiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024950; c=relaxed/simple;
	bh=bZ35k29J1YI0vFe3OlV/jo3pz/42ihOXXpNeYpLoRgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKjrUh3YV7AEiEKcBVwhTtsuY3Q1Fa0QIyHh6kRgoQB5Y5Uo1kv4B8Cx+ilnuhapsubKDxexXiX6577K/G3Y/gfdJE1brUU01BRJRW8hISlev6fFQ9UPF56bIGgy6Cf8co1SXb6gqoVdHUIaXn4/8UqybuVyMppvhqytGeyuk60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hu1Vo5CZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hu1Vo5CZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8255BC4CEF0;
	Tue, 12 Aug 2025 18:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024949;
	bh=bZ35k29J1YI0vFe3OlV/jo3pz/42ihOXXpNeYpLoRgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hu1Vo5CZ/Y5lOcQm4mk7vCaeb1PnPUblFQGwLwyLN47hniv9Xzu4u1/VVEtzuxjbw
	 1NAMFK44tF4Xbv6leL7cJHju0rra05uRBdRtupCCAsmUc1aeThl3Xa2xSHg9fqntOO
	 8QbUrluZZdsvksQAej3GTmWHe07+iLQR4ucUpr/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 523/627] s390/mm: Set high_memory at the end of the identity mapping
Date: Tue, 12 Aug 2025 19:33:38 +0200
Message-ID: <20250812173451.663989658@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 56f4cfab1c93b14da422cdcd23898eb008033696 ]

The value of high_memory variable is set by set_high_memory() function
to a value returned by memblock_end_of_DRAM(). The latter function
returns by default the upper bound of the last online memory block,
not the upper bound of the directly mapped memory region. As result,
in case the end of memory happens to be offline, high_memory variable
is set to a value that is short on the last offline memory blocks size:

RANGE                                  SIZE   STATE REMOVABLE   BLOCK
0x0000000000000000-0x000000ffffffffff    1T  online       yes   0-511
0x0000010000000000-0x0000011fffffffff  128G offline           512-575

Memory block size:         2G
Total online memory:       1T
Total offline memory:    128G

crash> p/x vm_layout
$1 = {
  kaslr_offset = 0x3453e918000,
  kaslr_offset_phys = 0xa534218000,
  identity_base = 0x0,
  identity_size = 0x12000000000
}
crash> p/x high_memory
$2 = 0x10000000000

In the past the value of high_memory was derived from max_low_pfn,
which in turn was derived from the identity_size. Since identity_size
accommodates the whole memory size - including tailing offline blocks,
the offlined blocks did not impose any problem. But since commit
e120d1bc12da ("arch, mm: set high_memory in free_area_init()") the
value of high_memory is derived from the last memblock online region,
and that is where the problem comes from.

The value of high_memory is used by several drivers and by external
tools (e.g. crash tool aborts while loading a dump).

Similarily to ARM, use the override path provided by set_high_memory()
function and set the value of high_memory at the end of the identity
mapping early. That forces set_high_memory() to leave in high_memory
the correct value, even when the end of available memory is offline.

Fixes: e120d1bc12da ("arch, mm: set high_memory in free_area_init()")
Tested-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index f244c5560e7f..5c9789804120 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -719,6 +719,11 @@ static void __init memblock_add_physmem_info(void)
 	memblock_set_node(0, ULONG_MAX, &memblock.memory, 0);
 }
 
+static void __init setup_high_memory(void)
+{
+	high_memory = __va(ident_map_size);
+}
+
 /*
  * Reserve memory used for lowcore.
  */
@@ -951,6 +956,7 @@ void __init setup_arch(char **cmdline_p)
 
 	free_physmem_info();
 	setup_memory_end();
+	setup_high_memory();
 	memblock_dump_all();
 	setup_memory();
 
-- 
2.39.5



