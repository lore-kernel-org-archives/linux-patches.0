Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590543;
	b=BIQPmlDePovmOtM7T5yrnxii2TvlJby4+2kxEkxjjdTV1OJbisb/4/LYnvcIZCH/uIJo
	 RY/A5jI92XhgQZMW3c3Y4cohmTJDJ1QffC/pqPcoW5JFAsQMgE/5CvcEPTDQ2paA6LZ8M
	 8TH0FFcP12GFKnNFFwAgkL6K9IHcSoVnvu7A4CZkjem/DC7VeSeMELRpv6/OMSPVAyMER
	 mBp2OzJIvX7k8kkC7kW7wrI3JsnenawqqWNYQ4IPOhhMEzzn+754kmlJm9aLSsQPoAli8
	 skQvNRV/jeEoXdDxi3TTNWUHKr09wdOkBNnw8XiESuS2C3tDzvGPf0bgT1b6/tQ0CkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y2RiakpvGDibTBTbu8rFBIdxm108PBkEMRvs3fElbSA=;
	b=hHcLvYQZxO6fb2dU3no+cgJKMVCegs246Eg+VZeND3lLaba4IZhFOUc+yMz8dW6ticzc
	 wJeBYnJAchXkTGKVpXeFaSZSOA79Dq33gWg1qjpidJe5nuc1CibtOjoiT4MFR48stQqhr
	 zrqz526Esfnwk0cTChNjyh9FI52kj5XpIuxrA/BVVWLDRU/bBMFP6VX35trmHtxc5Ir40
	 RtSKir1BHx4baXeEnB+nCGAt7CV8NI1ceT0U41QMYfXJTXq1r44BV7dIbXUGO02zHBJ27
	 ev6pyXrmUxb3d6VPaomZ9YceKp45cwrZlearBDl9im1gdhP0GNzE/vLbIQOMohQ01Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGzdaNPh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8B5606B36C;
	Fri, 13 Nov 2026 17:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGzdaNPh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599261F000C4;
	Fri, 13 Nov 2026 17:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590543;
	bh=Y2RiakpvGDibTBTbu8rFBIdxm108PBkEMRvs3fElbSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGzdaNPhc2+ZJRqwafEdNCj5K2KkCQgnCqKnQ60WgVVzAMkifalikQrCm15uwXIpy
	 5udvlwqZN2XmKZkBrEAvJ+j6KuhB4IUFsuG/J0oj6X6OjZQ7Q/ocmB8RR5IlU3HM1J
	 F1g+qZzqQ+1Ha+H3fRac6/L8usNnJiEwk38FeHN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxi Saparov <masaparov@coreweave.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 483/686] kho: do not reserve scratch memory in the kdump kernel
Date: Fri, 13 Nov 2026 10:50:16 -0500
Message-ID: <20261113153837.321183601@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxi Saparov <masaparov@coreweave.com>

[ Upstream commit 48be325089e15077411785d0c41ddb9071a61081 ]

If a kernel with CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y (or kho=on)
does not receive a handover FDT, it reserves KHO scratch memory in
kho_reserve_scratch().

The kdump kernel always takes this path. Since commit a6715d7ec472
("kho: skip KHO for crash kernel"), the kernel does not add KHO
metadata to the crash kimage. As a result, the kdump kernel never
receives a handover FDT and always reserves scratch memory.

The kdump kernel boots in the small crashkernel= memory reservation.
On our x86 hosts, the kernel and initramfs make approximately 176 MB
of early reservations. The scratch areas then use approximately
650 MB more of the crashkernel memory. When a large early allocation
fails, the kdump kernel panics:

  bio: can't create integrity buf pool

A kdump kernel has nothing to hand over: its only task is to dump the
memory of the old kernel and reboot. Fix is to disable KHO at the top of
kho_memory_init() so that the kdump kernel does not reserve scratch
memory.

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Maxi Saparov <masaparov@coreweave.com>
Link: https://patch.msgid.link/20260811161857.3096-1-maxi.saparov@gmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
[ sashal: adjusted context to apply the unchanged additions to the handover implementation at its older source location ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_handover.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 9691f6bc2fba7..e503573e03190 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -10,6 +10,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cma.h>
+#include <linux/crash_dump.h>
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
@@ -1325,6 +1326,12 @@ void __init kho_memory_init(void)
 {
 	struct folio *folio;
 
+	if (is_kdump_kernel()) {
+		kho_enable = false;
+		pr_info("disabled in the kdump kernel\n");
+		return;
+	}
+
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
-- 
2.53.0



