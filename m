Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044075;
	b=Myf5RcejZhCu7DKUqU4P36k4QgXoJL3tuT6g8ZiuDksznzDcUfKl48F4X5Oc9LZON2+l
	 snKlDO2UJCowcInvcmnP1IyKBV415VijbOc/jGAkyORk5SJR551iH/Amj8twhM6+5H1rP
	 jBgpTRLMB91rs7gARNFA00fDQmD9r1cKvU+ZgTGk/an1cDIivWPM+NDE0z3L9QnGIw3GO
	 etCwclP18osNgMVURyGlD6suj1ckSX3sWaw8g2ajX8MEU7/tY7+MZRjpaseOFwPdIqPJs
	 DC/eRmfAZeV2I68hzBr80Gl6WVkfzG1ATC4770JDElv7LGIGPvm5q5cBunW/aa8qleQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sQ+F5PRQyjdsI3KNfSmksYizzr04EZpaZw62bNYMr+A=;
	b=rDr5M7BGW/ZLR5cUVBHsqA2MfKBZ9DKvU4NjvfDkG4nVRPLfMMmHR9j7ohQyHCD8IS5Y
	 NV1P72E+46W+xqo3RguXDj8LkS4fa058MiBVH8Avp+TIEUryQ4XqC7L33pjpwv07Uv4i0
	 XXU5kdiA1ViDOoQP/QTy5fNoyDfs9ealOJpfGhq43hHYr8As7fQczFff5/LnM72J8J2T4
	 a7UhrTVqj2U91qlrwUwTXC9fOyHuRRk8DtBwBfVSVnsb9sjABKAwcuvSwWHGP/KzCjUUO
	 S1GBDkcr+bQK2XE7CWQSitVKdIOXtQRzdglyY37k7g/NAn2DDzIfn1uxmT8/d+dHaVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vDNc0r7C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3444E606A31C;
	Wed, 18 Nov 2026 23:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vDNc0r7C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851191F000C4;
	Wed, 18 Nov 2026 23:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044075;
	bh=sQ+F5PRQyjdsI3KNfSmksYizzr04EZpaZw62bNYMr+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDNc0r7CTqNaMB+XaA5q/NTYnE+mrQWmXp8vBdiRahNOSANyr71nVU6k/h4ih+9OW
	 yCeIZoinBvweK/weIry5bNc9WDWaqWZwYzbIfGSy1q8ELWAhJjuROQaCz1HdiLOLye
	 Z6yQ764GtKUGFCLA/Ck7yT9C+jxaS8tPbjqjVJrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0438/2857] drm/amdkfd: Avoid integer underflow in EOP ring size calculation.
Date: Wed, 18 Nov 2026 15:24:32 +0100
Message-ID: <20261118150217.149393852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

[ Upstream commit 8ee521b8b189799e361d4233c5180ba56656d4d4 ]

The low 6 bits of cp_hqd_eop_control store the base-2 logarithm
of the EOP ring size. This was calculated as

order_base_2(q->eop_ring_buffer_size / 4) - 1

But order_base_2 can in theory return 0, so this could underflow
(although in practice the ring buffer size cannot be less than 4096).

Change this to

order_base_2(q->eop_ring_buffer_size / 8)

using properties of logarithms.

Also add to the above comment to make the mathematics more clear.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f0f43fcf8b2b3a924cad9444340921c96ed5f634)
Cc: stable@vger.kernel.org
[ sashal: Dropped the q->eop_ring_buffer_size ? size-zero guard from the context, since this tree lacks it, and applied only the order_base_2(size / 8) fix plus the comment in the v9 and vi files. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 6 +++++-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c | 5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index eaf084acb706f..8d6b022d4af17 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -237,6 +237,10 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 		1 << CP_HQD_IB_CONTROL__IB_EXE_DISABLE__SHIFT;
 
 	/*
+	 * The lowest 6 bits of eop_control store the EOP ring size. If
+	 * their value is X, the ring size is 2^(X + 1) dwords, or
+	 * 2^(X + 3) bytes.
+	 *
 	 * HW does not clamp this field correctly. Maximum EOP queue size
 	 * is constrained by per-SE EOP done signal count, which is 8-bit.
 	 * Limit is 0xFF EOP entries (= 0x7F8 dwords). CP will not submit
@@ -244,7 +248,7 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control = min(0xA,
-		order_base_2(q->eop_ring_buffer_size / 4) - 1);
+		order_base_2(q->eop_ring_buffer_size / 8));
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
index 530ba6f5b57ea..fc9dffd20d466 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
@@ -204,6 +204,9 @@ static void __update_mqd(struct mqd_manager *mm, void *mqd,
 			mtype << CP_HQD_IB_CONTROL__MTYPE__SHIFT;
 
 	/*
+	 * The lowest 6 bits of eop_control store the EOP ring size. If
+	 * their value is X, the ring size is 2^(X + 1) dwords, or
+	 * 2^(X + 3) bytes.
 	 * HW does not clamp this field correctly. Maximum EOP queue size
 	 * is constrained by per-SE EOP done signal count, which is 8-bit.
 	 * Limit is 0xFF EOP entries (= 0x7F8 dwords). CP will not submit
@@ -211,7 +214,7 @@ static void __update_mqd(struct mqd_manager *mm, void *mqd,
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control |= min(0xA,
-		order_base_2(q->eop_ring_buffer_size / 4) - 1);
+		order_base_2(q->eop_ring_buffer_size / 8));
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
-- 
2.53.0



