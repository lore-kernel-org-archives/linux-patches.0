Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE3B30FF1D;
	Fri,  9 Jan 2026 12:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961751; cv=none; b=pzxEbcqMIvkZUCgpzxG1Pu22oVTIUbdfyZjD84+QAsNrhX3pYhZ4TFDsskt/bgBbxGferlnRWxW4lseVSVyLwB7kq3xDGERpNRblnueQjm86Gzq1vLoVY+MwOq11ZB+K55sdW++F2NVVSR+GqoP5yRr/xpRRtMb1kRABAwz8c08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961751; c=relaxed/simple;
	bh=bg9zqfclVmKLi2gnL7/vV0gkhIBKN0iNGuqvLsxZCfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBMnpBak8sS3EeKOM79+nhs/g/nZVI8kPnWYx1jtQ3QnX1wbgLkDnXUuGzSjw+7NFakqBimTeVNIU6HZKk11jA+lEribk/VB3eDNmeXBsQkHXBmAbwfL+kDMoZTwATwdl9s5seHpY0hG2kt44KLKX1fXduqDbElAAqJ5WghE8xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gs06NAuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gs06NAuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC39C19421;
	Fri,  9 Jan 2026 12:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961751;
	bh=bg9zqfclVmKLi2gnL7/vV0gkhIBKN0iNGuqvLsxZCfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gs06NAuzS0C40DixcJH8IozY3H0OBN0VkcV5aIdxMr/6lvVcpo/IeMoxQU/jmEq1p
	 jgBE2Q03132CnF20ecskz+e6PrenW17ixgugCiXyVslIXyE+ZIjoVit93FAZ/1kl9l
	 BGBlCva9/fLDKgL3uSajOzcVaRxOGrueAMyusnXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/634] powerpc/64s/ptdump: Fix kernel_hash_pagetable dump for ISA v3.00 HPTE format
Date: Fri,  9 Jan 2026 12:36:41 +0100
Message-ID: <20260109112122.072487855@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



