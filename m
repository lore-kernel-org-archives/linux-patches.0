Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED4236494B;
	Wed, 20 May 2026 16:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294975; cv=none; b=CMPEmpGv8bPMIUGEUBx3lwDuZUwdM08upP3wQZBAsFUthj2EfWeffsw9BKOidUCtnod03KkstAWLuEsOtNfbw6VFz5IZ+e483ryOqPNo4oZ5BLbJv1nJlf5BYzMZ2pmBHIPTqNOTJ2Rew84LXRDAzmNyMsbsk0sv3n1cQrpya3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294975; c=relaxed/simple;
	bh=VkCUCdby4hI63G9U0RYiSbmVFRE/seDt+ZkIypzMW40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeE1OVBzWzis3ZGOLKU+29CrNaKhLTIA2mx7YKejBHhOv8wCV3NZ7T4t0Egbfc2oJ6Nl+2BS0klb2DB37Yk3Ff5Z15BgBXfoNG0lvgmNkxxJrz/QdSrsMH+F38d2ZkhjQs5uDjmjqSBh3plfI2V0tkgB0/zzyDjwWdTKy+3NrRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGg9zNuo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGg9zNuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B392F1F000E9;
	Wed, 20 May 2026 16:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294974;
	bh=ZtDqVT+ROZtTbTEMdj3c10bE44UkjzJnJu7/alHEqNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGg9zNuoyE7X6K19XrDFMu38Taf4kBgFryjXe68GLImMN1GHMXJ0llVZlY/SZ5nYA
	 bd0u3SJ/JCTbKXQNusF9OgjwbNdXlGxUdkNojHnY8a4xR1s1LgwaPt00PCx5+7wf5q
	 O7UEy0NYFUUP9SIqggm5wMDwCbtYNuZWFbBB8wt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliot Courtney <ecourtney@nvidia.com>,
	Gary Guo <gary@garyguo.net>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0242/1146] gpu: nova-core: gsp: fix improper handling of empty slot in cmdq
Date: Wed, 20 May 2026 18:08:12 +0200
Message-ID: <20260520162153.717143999@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliot Courtney <ecourtney@nvidia.com>

[ Upstream commit f64caf673cb5add9ac2065609a52049e2317c498 ]

The current code hands out buffers that go all the way up to and
including `rx - 1`, but we need to maintain an empty slot to prevent the
ring buffer from wrapping around into having 'tx == rx', which means
empty.

Also add more rigorous no-panic proofs.

Fixes: 75f6b1de8133 ("gpu: nova-core: gsp: Add GSP command queue bindings and handling")
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260129-nova-core-cmdq1-v3-4-2ede85493a27@nvidia.com
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/gsp/cmdq.rs | 34 ++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/nova-core/gsp/cmdq.rs b/drivers/gpu/nova-core/gsp/cmdq.rs
index fc4e7b1074307..5da153c71800a 100644
--- a/drivers/gpu/nova-core/gsp/cmdq.rs
+++ b/drivers/gpu/nova-core/gsp/cmdq.rs
@@ -237,21 +237,27 @@ impl DmaGspMem {
         // PANIC: per the invariant of `cpu_write_ptr`, `tx` is `<= MSGQ_NUM_PAGES`.
         let (before_tx, after_tx) = gsp_mem.cpuq.msgq.data.split_at_mut(tx);
 
-        if rx <= tx {
-            // The area from `tx` up to the end of the ring, and from the beginning of the ring up
-            // to `rx`, minus one unit, belongs to the driver.
-            if rx == 0 {
-                let last = after_tx.len() - 1;
-                (&mut after_tx[..last], &mut [])
-            } else {
-                (after_tx, &mut before_tx[..rx])
-            }
+        // The area starting at `tx` and ending at `rx - 2` modulo MSGQ_NUM_PAGES, inclusive,
+        // belongs to the driver for writing.
+
+        if rx == 0 {
+            // Since `rx` is zero, leave an empty slot at end of the buffer.
+            let last = after_tx.len() - 1;
+            (&mut after_tx[..last], &mut [])
+        } else if rx <= tx {
+            // The area is discontiguous and we leave an empty slot before `rx`.
+            // PANIC:
+            // - The index `rx - 1` is non-negative because `rx != 0` in this branch.
+            // - The index does not exceed `before_tx.len()` (which equals `tx`) because
+            //   `rx <= tx` in this branch.
+            (after_tx, &mut before_tx[..(rx - 1)])
         } else {
-            // The area from `tx` to `rx`, minus one unit, belongs to the driver.
-            //
-            // PANIC: per the invariants of `cpu_write_ptr` and `gsp_read_ptr`, `rx` and `tx` are
-            // `<= MSGQ_NUM_PAGES`, and the test above ensured that `rx > tx`.
-            (after_tx.split_at_mut(rx - tx).0, &mut [])
+            // The area is contiguous and we leave an empty slot before `rx`.
+            // PANIC:
+            // - The index `rx - tx - 1` is non-negative because `rx > tx` in this branch.
+            // - The index does not exceed `after_tx.len()` (which is `MSGQ_NUM_PAGES - tx`)
+            //   because `rx < MSGQ_NUM_PAGES` by the `gsp_read_ptr` invariant.
+            (&mut after_tx[..(rx - tx - 1)], &mut [])
         }
     }
 
-- 
2.53.0



