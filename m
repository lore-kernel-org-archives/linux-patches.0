Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668102C026C;
	Sat, 17 Oct 2026 16:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254302; cv=none; b=SkXCJwLR70byB7gqHKaUUebCsEaPP6fAHkBcyH5DSsGumI8duNfjHq88Ikm+vcPn+DK+k75tvenmST1wrqyJ7irvOBybptJh+Gc+zyS9um4YZsRf36GW0KjjwPtB7irzP9btF8tOBZGgIOIZDn2uBNbikFZF51B70+g3zsDattc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254302; c=relaxed/simple;
	bh=Me9HBlQIzx8eUhuRuKcBMYvCw9D/D98TrUFqnXW3lUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYwFb3RxNa058LkM9UJU6LwSBPfRYugC99Cc4swjZBhyBy+pvRxrBafTGTKVSedStZJhqSJ/qRKGdpUkL8PVftgM5GpqgVfnjY8F2JJlBeakhsEtZ0TvVt+S2lK5Vr41R3MXwvkEGee2tGch5Jfnp9pSbdLbaUg6iKUxlyqPSgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZAmrtgr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZAmrtgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32071F000C4;
	Sat, 17 Oct 2026 16:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254301;
	bh=lEMRcmSajxbykaXNbqjCjyuaUp0FD+Gngb1SaDSRDfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZAmrtgrjTKJAFNJJcGA6TH3KyV8tCOg0m08MM3EuVS/TyvHv+ojUsV4hxI/OOnS5
	 eMeYDn1Xbhev6we9yhk/sZAPuPVDtz8rKNFCiustLUfSwd6NlN9yJhJwUAZsRr1MRF
	 mHnJzb9oXXTn5W2aGrSYUG4+EBJLOI0FaYLDrN2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 402/869] firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
Date: Sat, 17 Oct 2026 17:54:03 +0200
Message-ID: <20261017160047.437608428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit 3383ffb7ef937317361713ffcc21921a7848511a ]

Sashiko (locally) reports multiple out-of-bound issues in
ffa_setup_and_transmit:
1) Writing ep_mem_access->reserved can write out of bounds for FFA
   versions < 1.2 as ffa_emad_size_get() returns 16 bytes in that case
   while reserved has an offset of 24.
   Instead of zeroing fields, memset the struct to zero first based on
   the FFA version.

2) Make sure there is enough size to write constituents.

While at it, convert the only sizeof() in the driver that uses a
type instead of variable.

Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Fixes: 111a833dc5cb ("firmware: arm_ffa: Set reserved/MBZ fields to zero in the memory descriptors")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Link: https://patch.msgid.link/20260702103848.1647249-2-sebastianene@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 62222c9cfc3e6..58939ca2d7dfa 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -637,11 +637,10 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 					       drv_info->version);
 
 	for (idx = 0; idx < args->nattrs; idx++, ep_mem_access++) {
+		memset(ep_mem_access, 0, sizeof(*ep_mem_access));
 		ep_mem_access->receiver = args->attrs[idx].receiver;
 		ep_mem_access->attrs = args->attrs[idx].attrs;
 		ep_mem_access->composite_off = composite_offset;
-		ep_mem_access->flag = 0;
-		ep_mem_access->reserved = 0;
 	}
 	mem_region->handle = 0;
 	mem_region->ep_count = args->nattrs;
@@ -684,7 +683,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 			constituents = buffer;
 		}
 
-		if ((void *)constituents - buffer > max_fragsize) {
+		if ((void *)constituents + sizeof(*constituents) - buffer > max_fragsize) {
 			pr_err("Memory Region Fragment > Tx Buffer size\n");
 			return -EFAULT;
 		}
@@ -693,7 +692,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 		constituents->pg_cnt = args->sg->length / FFA_PAGE_SIZE;
 		constituents->reserved = 0;
 		constituents++;
-		frag_len += sizeof(struct ffa_mem_region_addr_range);
+		frag_len += sizeof(*constituents);
 	} while ((args->sg = sg_next(args->sg)));
 
 	return ffa_transmit_fragment(func_id, addr, buf_sz, frag_len,
-- 
2.53.0



