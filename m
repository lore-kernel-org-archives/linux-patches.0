Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A0529B200;
	Thu, 15 Jan 2026 17:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497527; cv=none; b=dqR1bfc0yjVJukaz2PWvt/kj110zOBqOrvQdkiUxc4Dpbc/3av7R06cvOIXS5byBhxxTK2Lxx4fL+SviX7YlX3a81bZbdYi4NQSF1Z3LqPtxosopNR7HwgQ1tSJsrceEtfvZykiCW49xEZ28GaNJEV68FaHoRJY7j5Sj7D9Xqa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497527; c=relaxed/simple;
	bh=P2GuxaHqnALAn7t1/wKndSK//6GN/bWPnVNGR3TXp6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rnzxt2mfHoRLViJqsYcujEQz1bXqJ/4qTkEZ3pddc41pnnStQgihixjtEea+hGL/bk5ln5SmyQrJyBfnk0xgZvxi6rrGzGhEWy/d8hpnhNCztG0lDas6/wl7icYWf6sNxd61ih8ipGWPolBubA7kbX6vr4NyEVJzgUn4+HryA54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AymHVOWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AymHVOWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737CBC116D0;
	Thu, 15 Jan 2026 17:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497526;
	bh=P2GuxaHqnALAn7t1/wKndSK//6GN/bWPnVNGR3TXp6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AymHVOWOsKdvVyHWsN5nTEgSUbChH+McOOn8We4jeY55DjA98T13msWLPW4keiIkJ
	 sTp+XAbBxtMPkM7e9t288zfC2Ryjf6IwOUCQpkio5fW0HAX2tDp0pmqqe2SAJyFJ09
	 67KGPudsvIX7lM3no3SMaX1CwKJlQTAcrcVBnqoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/554] powerpc/64s/ptdump: Fix kernel_hash_pagetable dump for ISA v3.00 HPTE format
Date: Thu, 15 Jan 2026 17:42:59 +0100
Message-ID: <20260115164250.343093469@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit eae40a6da63faa9fb63ff61f8fa2b3b57da78a84 ]

HPTE format was changed since Power9 (ISA 3.0) onwards. While dumping
kernel hash page tables, nothing gets printed on powernv P9+. This patch
utilizes the helpers added in the patch tagged as fixes, to convert new
format to old format and dump the hptes. This fix is only needed for
native_find() (powernv), since pseries continues to work fine with the
old format.

Fixes: 6b243fcfb5f1e ("powerpc/64: Simplify adaptation to new ISA v3.00 HPTE format")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/4c2bb9e5b3cfbc0dd80b61b67cdd3ccfc632684c.1761834163.git.ritesh.list@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/ptdump/hashpagetable.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/mm/ptdump/hashpagetable.c b/arch/powerpc/mm/ptdump/hashpagetable.c
index c7f824d294b25..5e482b90c4007 100644
--- a/arch/powerpc/mm/ptdump/hashpagetable.c
+++ b/arch/powerpc/mm/ptdump/hashpagetable.c
@@ -216,6 +216,8 @@ static int native_find(unsigned long ea, int psize, bool primary, u64 *v, u64
 	vpn  = hpt_vpn(ea, vsid, ssize);
 	hash = hpt_hash(vpn, shift, ssize);
 	want_v = hpte_encode_avpn(vpn, psize, ssize);
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
+		want_v = hpte_old_to_new_v(want_v);
 
 	/* to check in the secondary hash table, we invert the hash */
 	if (!primary)
@@ -229,6 +231,10 @@ static int native_find(unsigned long ea, int psize, bool primary, u64 *v, u64
 			/* HPTE matches */
 			*v = be64_to_cpu(hptep->v);
 			*r = be64_to_cpu(hptep->r);
+			if (cpu_has_feature(CPU_FTR_ARCH_300)) {
+				*v = hpte_new_to_old_v(*v, *r);
+				*r = hpte_new_to_old_r(*r);
+			}
 			return 0;
 		}
 		++hpte_group;
-- 
2.51.0



