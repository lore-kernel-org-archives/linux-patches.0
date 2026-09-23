Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5928D5326DD;
	Wed, 23 Sep 2026 14:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174122; cv=none; b=b33LLzv+KmjlpBanaZNtb0Yy4hs+EmzqyrZsUoAh2Vs9R9fHPnT2xTKHILOindPdTG0s8pmQ/78DSN1FSy1FDmjmqhSAuax84T9V2P+QQ27QwNV4AOBb7YFbbOB663tlU259XCwepe/wU29TEPzhr4aPGBXQW0kDjhe2DUzuVjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174122; c=relaxed/simple;
	bh=SZ7T4w6YH5TdFXJTOVlkcYkpU1Vsf5reVYT9QE/g9DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpSlWRUBpqBE9YK55kxrhDx5YeV48Ly90QbiwA2usUDmpGWRk8HltSOfkf7UtoiA96QHOIusxf9YT2eGOk6mZ1eiuSU7FuzpUejPsThvbH3lVkH6v87dgtt7wQ5ebywwmXImFgdZ9iK8lz4k3KSP6V3LQYw+tkinmvILBmwG+CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djyL1sMN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djyL1sMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20CD1F000FF;
	Wed, 23 Sep 2026 14:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174121;
	bh=SNrMhj1hmWcsyKnlIQTuv44Kvmi24mw6DnuzV80fCgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djyL1sMN39bfqN3ZXvjzNeYlaOu55kYKurfNUnq7FnzcWwKcfKl4cwu/AC+mCuXz7
	 6ZfERHvuCZDeigCJGQc0/+ruuPGfiZpO/DfLE59NQIfCYtHz9XYMDNIFFFIGJWqlGp
	 l+OBux2PcO05eiF5VMVEkOKyq5oo8QzgS80XduLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 410/438] drm/amdkfd: Avoid integer underflow in EOP ring size calculation.
Date: Wed, 23 Sep 2026 16:07:11 +0200
Message-ID: <20260923140655.533568865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

commit 8ee521b8b189799e361d4233c5180ba56656d4d4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c |    6 +++++-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c |    5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -299,6 +299,10 @@ static void update_mqd(struct mqd_manage
 		1 << CP_HQD_IB_CONTROL__IB_EXE_DISABLE__SHIFT;
 
 	/*
+	 * The lowest 6 bits of eop_control store the EOP ring size. If
+	 * their value is X, the ring size is 2^(X + 1) dwords, or
+	 * 2^(X + 3) bytes.
+	 *
 	 * HW does not clamp this field correctly. Maximum EOP queue size
 	 * is constrained by per-SE EOP done signal count, which is 8-bit.
 	 * Limit is 0xFF EOP entries (= 0x7F8 dwords). CP will not submit
@@ -310,7 +314,7 @@ static void update_mqd(struct mqd_manage
 	 *
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ?
-		min(0xA, order_base_2(q->eop_ring_buffer_size / 4) - 1) : 0;
+		min(0xA, order_base_2(q->eop_ring_buffer_size / 8)) : 0;
 
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
@@ -208,6 +208,9 @@ static void __update_mqd(struct mqd_mana
 			mtype << CP_HQD_IB_CONTROL__MTYPE__SHIFT;
 
 	/*
+	 * The lowest 6 bits of eop_control store the EOP ring size. If
+	 * their value is X, the ring size is 2^(X + 1) dwords, or
+	 * 2^(X + 3) bytes.
 	 * HW does not clamp this field correctly. Maximum EOP queue size
 	 * is constrained by per-SE EOP done signal count, which is 8-bit.
 	 * Limit is 0xFF EOP entries (= 0x7F8 dwords). CP will not submit
@@ -215,7 +218,7 @@ static void __update_mqd(struct mqd_mana
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control |= q->eop_ring_buffer_size ? min(0xA,
-		order_base_2(q->eop_ring_buffer_size / 4) - 1) : 0;
+		order_base_2(q->eop_ring_buffer_size / 8)) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =


