Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E478330D35;
	Thu, 16 Jul 2026 13:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210081; cv=none; b=bHn6Vx0brkxOdap86aHXxAU/CUSqjqMOp4My5ppr99QjOOWJpLvKEmawNjA3Fqh0IVKHsZiNJQ6JeUZeWAo9tPGFDF4Ir6dmQtRTsGgysHriUPI0AsNWSkm+k+aAEQ3oSD/oLXoXtUqoo+P5UsZ89diy252MgVkSM1lg0tFunuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210081; c=relaxed/simple;
	bh=KwzSYk63ApxnM3ML3IlS8kH98OCLZ2wBOZ4iYMrjzdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C55m/RxifrpJh6hI6GNO5cHtoapTGwvFzeBpAB3Bg5rZIElB3h03KBIHooALyc+IiWoFQ8r35lN9Uzx15Qrs+HrM9R7vkG6pgjVfYcaz4icywEXimo18Gcgnk10wiaZ2gVm6Sw62gnflnsrH2m5pgtafi6Y18AjifVWOAfoqkZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRVrp1CX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRVrp1CX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B3E1F00A3A;
	Thu, 16 Jul 2026 13:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210080;
	bh=M5rVNk1wzs3SnxmGWKWnvrwKzBQ574RGKkSUhaP1Qxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fRVrp1CXtCy0G9F14D5CuuFstFekY8EruRQanPevXXHq7sV6Fny3vZZEHm99En0Tq
	 wyjRkFZF4LXOPc1H3HW0PaodX2Snc8TQHY03UtvE2dpqJWkIjreirLT9Oj2dM/t/bU
	 vkbdg6F4ZJAs5loJhjaXpdwLuIIi0Mv0NuH7XNcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.1 429/518] nouveau/vmm: fix another SPT/LPT race
Date: Thu, 16 Jul 2026 15:31:37 +0200
Message-ID: <20260716133057.227982039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 6763a0aea6d658d69b9215ab9151d7bd4c1c314b upstream.

We've had an unknown Turing issue for a while with page faults since
large pages and compression.

I've got a patch series that syncs all our L2 handling with ogkm and it
made this fault happen more.

After writing a bunch of debugging patches, I spotted an invalid LPT
entry where there should have been a valid one.

A 64K MAP succeeds on a range, but a subsequent SPT put drops SPT refs
across multiple ranges,

We shouldn't assume all ranges where SPTEs go away will have the same
sparse/invalid/valid state, just iterate over each instead and do the
right thing.

Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Fixes: d19512f5abb1 ("nouveau/vmm: start tracking if the LPT PTE is valid. (v6)")
Link: https://patch.msgid.link/20260615044737.3419585-1-airlied@gmail.com
[ Properly format commit message. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
(cherry picked from commit d008141ed4ce924167a03d46fbce9ad1fe4efa29)
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c |   31 +++++++++++---------------
 1 file changed, 14 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c
@@ -230,29 +230,26 @@ nvkm_vmm_unref_sptes(struct nvkm_vmm_ite
 		 * covered by a number of LPTEs, the LPTEs once again take
 		 * control over their address range.
 		 *
-		 * Determine how many LPTEs need to transition state.
+		 * Transition each LPTE individually as each may have a
+		 * different target state (sparse, invalid, or valid).
 		 */
-		pgt->pte[ptei].s.spte_valid = false;
-		for (ptes = 1, ptei++; ptei < lpti; ptes++, ptei++) {
+		for (ptei++; ptei < lpti; ptei++) {
 			if (pgt->pte[ptei].s.sptes)
 				break;
-			pgt->pte[ptei].s.spte_valid = false;
 		}
 
-		if (pgt->pte[pteb].s.sparse) {
-			TRA(it, "LPTE %05x: U -> S %d PTEs", pteb, ptes);
-			pair->func->sparse(vmm, pgt->pt[0], pteb, ptes);
-		} else if (!pgt->pte[pteb].s.lpte_valid) {
-			if (pair->func->invalid) {
-				/* If the MMU supports it, restore the LPTE to the
-				 * INVALID state to tell the MMU there is no point
-				 * trying to fetch the corresponding SPTEs.
-				 */
-				TRA(it, "LPTE %05x: U -> I %d PTEs", pteb, ptes);
-				pair->func->invalid(vmm, pgt->pt[0], pteb, ptes);
+		while (pteb < ptei) {
+			pgt->pte[pteb].s.spte_valid = false;
+			if (pgt->pte[pteb].s.sparse) {
+				TRA(it, "LPTE %05x: U -> S", pteb);
+				pair->func->sparse(vmm, pgt->pt[0], pteb, 1);
+			} else if (!pgt->pte[pteb].s.lpte_valid) {
+				if (pair->func->invalid) {
+					TRA(it, "LPTE %05x: U -> I", pteb);
+					pair->func->invalid(vmm, pgt->pt[0], pteb, 1);
+				}
 			}
-		} else {
-			TRA(it, "LPTE %05x: V %d PTEs", pteb, ptes);
+			pteb++;
 		}
 	}
 }


