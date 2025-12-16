Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2D93446AF;
	Tue, 16 Dec 2025 11:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884489; cv=none; b=NO7NS6005rfTKKr/qpvoMpXVkFyMK+ejRkTVK5B24bjTmVRoqaUayyMQrGP2i1muMjBpQJ2bbn+2uu9GBomY6Ulu96684L70by7lmXGwJ//XdNsaIRdIdqeYANMYv3AHcQ3cag0xEkQPJjithYezgtfbXckWtKirzN7oi1TCUa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884489; c=relaxed/simple;
	bh=JzkU7a8zoYHisBVgzI8cdGOQEt7sx50dkEYLfZZzm2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khI1Ye4OdH5GFp6zYo5mMbA8giUCnoHvG9I3ocb3OXYw7n2T5nIEpl63jb7rdT9xgqW5caAgDi59DvYEy9J86tMo6NFqndQbqzOCqPheF8MwrknpAadCqbXvmSOlPZ+D3GgSjKmj+zHqFLnlJYmo8sTTbeER/QYhq6G+9eMYKjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/sxIg2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/sxIg2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552D7C4CEF1;
	Tue, 16 Dec 2025 11:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884489;
	bh=JzkU7a8zoYHisBVgzI8cdGOQEt7sx50dkEYLfZZzm2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/sxIg2EUntOdhNwhm/LiRVpoNWNxXC2pMvr3crjN9wXaBJDBsxJz0707AfZjVEez
	 ypaSeejXPP3Pngfkt7oNnmghW5lDAbs18W9FM99MSt6/Ikp/IM+wJHChqTjodQLw91
	 BMkrJCD4fnj/Y/KWkdyKv7948fWbefIqwzxDiZlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/354] powerpc/64s/ptdump: Fix kernel_hash_pagetable dump for ISA v3.00 HPTE format
Date: Tue, 16 Dec 2025 12:12:23 +0100
Message-ID: <20251216111327.289030171@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index a6baa6166d940..671d0dc00c6d0 100644
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



