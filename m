Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061414;
	b=PJ7AQ8MCjac8h3uQPcF1Zd5fBr869g9Ieic3NH9sbezXRCTc72k+Ll/xMZZKwira3qUF
	 5jB9zCnerhBKFCp8wjXB4375DWS1gzvtsmSRCt72Z/XV1ipUnHWJ449ifBwAENgIxEVCm
	 VAzPp4kJ6j2qEINk8gy2xFklmzYp4zvCqd/3sIxSkwCpR/m44bNq0Y19rst/d8pywVLVF
	 VAGvVpGATS8JwrDNV37WbvznjDJV/+Ur5yKdkI518O5KgJhPljN5Gvkor8WlkK59Z7N3h
	 ibsFmh7Ar/CyQr2Wzpg3Gym3Rp0CdqZw6ug1Z2F1pUD4R6Ag23lHQHj2gUys4b83jaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NRw9Ffaa0HcIhaeOMxS77zVBqOtkCFTtDz/l43ZO738=;
	b=sAKjY/c5J6g/yK9pyQshpCsTLPyUWq6evhqYoWuKdrbOxZYzmRSqXDZL6Pz50Vd39zl3
	 tpj+jyTJRi84yo025on+dD+11EMKapjmVPJwQjYR2YpIIApFIOgZnz7BRaO3OWr7HXqIk
	 m0aUeO5uimAb5EY4KpQKVIbzskVB7H4aeIDoOG401po1OuYWI8/AKjdrY0qabGlOImf+1
	 PsPuUQAvxQeb8UP7UbAc27Sj1UhiPjJNJt+yX/zftymSqGan1du+gyuoT0rA1flfS99aD
	 C77aJjeh7Ercfdlt4LH7RpchmL3A4j2XNJdZ8s8k/Q/62mh6qFBgANmj5dHoiqHggRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LXvar+5j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB47606A32F;
	Sat,  7 Nov 2026 14:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LXvar+5j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7D21F0089F;
	Sat,  7 Nov 2026 14:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061414;
	bh=NRw9Ffaa0HcIhaeOMxS77zVBqOtkCFTtDz/l43ZO738=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXvar+5jK89TXARdoEh69vCitPuJfVPCQDAwgMNeSYV+r8e5yTmUjbPumJdAkGzY6
	 zKJ5s5zN483YWh5PgCGJwvAnuyJHUo3tOOas+tDLIkOMLtdpoKYpQIZ3Y70ikRsYEH
	 zlLrkluGH8p73j30yFwrjgYXtrrveib5eYMbEFWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0527/1536] drm/amdkfd: Avoid integer underflow in EOP ring size calculation.
Date: Sat,  7 Nov 2026 08:42:23 -0500
Message-ID: <20261107135012.223036391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 6 +++++-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c | 5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index 194a1c79cf042..1e220e8810922 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -271,6 +271,10 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 		1 << CP_HQD_IB_CONTROL__IB_EXE_DISABLE__SHIFT;
 
 	/*
+	 * The lowest 6 bits of eop_control store the EOP ring size. If
+	 * their value is X, the ring size is 2^(X + 1) dwords, or
+	 * 2^(X + 3) bytes.
+	 *
 	 * HW does not clamp this field correctly. Maximum EOP queue size
 	 * is constrained by per-SE EOP done signal count, which is 8-bit.
 	 * Limit is 0xFF EOP entries (= 0x7F8 dwords). CP will not submit
@@ -282,7 +286,7 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 *
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ?
-		min(0xA, order_base_2(q->eop_ring_buffer_size / 4) - 1) : 0;
+		min(0xA, order_base_2(q->eop_ring_buffer_size / 8)) : 0;
 
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
index c55a858d523ab..f0de0893bc597 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
@@ -203,6 +203,9 @@ static void __update_mqd(struct mqd_manager *mm, void *mqd,
 			mtype << CP_HQD_IB_CONTROL__MTYPE__SHIFT;
 
 	/*
+	 * The lowest 6 bits of eop_control store the EOP ring size. If
+	 * their value is X, the ring size is 2^(X + 1) dwords, or
+	 * 2^(X + 3) bytes.
 	 * HW does not clamp this field correctly. Maximum EOP queue size
 	 * is constrained by per-SE EOP done signal count, which is 8-bit.
 	 * Limit is 0xFF EOP entries (= 0x7F8 dwords). CP will not submit
@@ -210,7 +213,7 @@ static void __update_mqd(struct mqd_manager *mm, void *mqd,
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control |= q->eop_ring_buffer_size ? min(0xA,
-		order_base_2(q->eop_ring_buffer_size / 4) - 1) : 0;
+		order_base_2(q->eop_ring_buffer_size / 8)) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
-- 
2.53.0



