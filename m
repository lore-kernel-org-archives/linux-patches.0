Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C71318EFA;
	Fri,  9 Jan 2026 11:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959777; cv=none; b=H/2tjKkpHaji5n1hh2gXuY1GxTPp0E66jkP3viZD4AKnt1Kk0+ZGw2XRK+aL7qfaSH/U98fxCq4r39SYa3w09Z+jrbNYZGe4C9ODVZvbz1rJYRlW47CUg0XsQdvvfHbKYvmGc65ux6uoOQy2QoQ0e5/NjfIJ6bNjgDHyIQIxygQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959777; c=relaxed/simple;
	bh=yaaK/ObV6itFaWhQuJOXHxgb5r2wpAjUu5dmikw9fdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpsZs6hpweV2Xn8yTKrYtVfPIEZH4M0K51yEgkSUNxjwo0ficDts+fhKyM4WLo6qNB4jXcXMpTENYCvpUOPIN0Q8qfLd7Q/8uiV5e0W43wONeLFKCV5PIEK18jrNPI+VWLJvYMWuYzlSe3TUg/rITH2+syUntXhzFuiXW5uZs98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BSicxI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BSicxI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C066BC4CEF1;
	Fri,  9 Jan 2026 11:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959777;
	bh=yaaK/ObV6itFaWhQuJOXHxgb5r2wpAjUu5dmikw9fdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BSicxI7YJ2HDvSsh71AfYABOkmuLeXMkbRQQXU3bmztKetM+qSOyd07x5mUj7zgk
	 Dttd0X8YQBQRrUOMhCMTQ79Sqbg6sap+5kuVY6707HhBB3qBxyOuT81g3kFQxA5hGs
	 anhxAghxmfBa1uOCWF5x4gmG8ALnYW/hXncc72gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/737] powerpc/64s/ptdump: Fix kernel_hash_pagetable dump for ISA v3.00 HPTE format
Date: Fri,  9 Jan 2026 12:35:09 +0100
Message-ID: <20260109112140.388747901@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9a601587836b2..ee5e1dfe7932a 100644
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



