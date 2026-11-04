Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831259;
	b=f3mvUQzrsIJXJ0hs/t2Uhx3p+23iHAxR68PWYP1NyC+3hlRL3ADcmaSxbFmQDijXQGk4
	 41jv4GBeEqGzwoojFuPOA5iBT31igMDogvPXo0AhT08QyQw+1xS95hkaay4/0xhL9wgYd
	 3PDGUg7Ctk5g2w1fPjYIBDmcWgzH+tEfk+a1IFJ+XEAUTnbt7aIgi+vtymwGmZ/4OJKV4
	 1EinYeI7CYlyfGy8ARpqf2GjEADjY/mp7eiazuSsdIIgjKMSQKlVzH0b6DgBveB3bkfzJ
	 mJU67QVIbJLCFYVFdWAeKBFNMlx5HKC8a24KiKKl0+UdseR4TRRAWNMBAbUUHlGkFAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HnJppgtbZOGa3HVcRG3ydTFrs5q1wf8UqE06Uk6c9iM=;
	b=sG7hUkol5J/BNpbg3WIuDQFvODZSHdshapkqgBJGEzFJHrT01ocMCKRng7soBQhdeecE
	 TTsgI6PMA5DMzdtTD+3lXqptz/ueNgzOED2Ah5qPGvSXvksT56HuhqjvZopFrxhe4B4QG
	 YLFrU7LjtwIDEHJ96ZzLIxsMi0FCXJLOIPcClLHpymtiKd24r1BEMbC3WkdbWn9ehGX5K
	 lDD0At6eck2TSPpk99v4vh3mgeyq9ngeKRfF5DVAzPrjq02Qlm0I6MTHPOU2x8lTy6B8l
	 9HTIB03ciI9DVgqLmR+geyXvirdV3NVCSp83aTkvQkK3m1FnMbXuTKy7BKI9DgCESWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1yUIaWJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FAC606A33E;
	Wed,  4 Nov 2026 22:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1yUIaWJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3361F000C1;
	Wed,  4 Nov 2026 22:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831258;
	bh=HnJppgtbZOGa3HVcRG3ydTFrs5q1wf8UqE06Uk6c9iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1yUIaWJWCchsqeEhy7oFgTI0RwrU1xORBrkACRmXBGJBx4fz9PvkAOdnYBcvdWXj
	 spgDjgunxetxppyn9P9bQtyJ7Ldm359VJIfcFLR8Eu180LjAllGTAiDLCQMdt8LITI
	 VDKwraE7lAVnqOGAE+kfxGQ4j5oIRAU5elNw8eXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0589/1005] RISC-V: KVM: Fix sdata leak and stale snapshot_addr in snapshot_set_shmem
Date: Wed,  4 Nov 2026 16:05:22 -0500
Message-ID: <20261104211100.364639155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit b7749531a9b195f4fd7db92ca3cc49bda1a4dc8d ]

A guest may call SBI_PMU_SNAPSHOT_SET_SHMEM repeatedly. Each call
overwrites kvpmu->sdata without freeing the old buffer (memory leak),
and if a later kvm_vcpu_write_guest() fails, the error path frees
sdata but leaves snapshot_addr stale. A subsequent
SBI_PMU_COUNTER_START then passes the INVALID_GPA check and crashes
the host with a NULL buffer in kvm_vcpu_read_guest().

Fix this by clearing the previously installed snapshot area before
installing a new one, which keeps sdata and snapshot_addr consistent.
The SBI spec suggests a single invocation but defines no error code
for repeated calls, so KVM must tolerate them.

Fixes: c2f41ddbcdd756 ("RISC-V: KVM: Implement SBI PMU Snapshot feature")
Cc: stable@vger.kernel.org
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260826064117.58029-1-min_halo@163.com
Signed-off-by: Anup Patel <anup@brainfault.org>
[ sashal: Kept the existing GFP_ATOMIC in the kzalloc context line, since __GFP_ACCOUNT isn't present here, and added the snapshot-area clear block unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_pmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index be0c7ecc38e79..d5a0a3a33f6b2 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -437,6 +437,14 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long s
 		goto out;
 	}
 
+	/*
+	 * Clear any previously installed snapshot area to avoid leaking
+	 * the old sdata and to keep sdata/snapshot_addr consistent if
+	 * the re-install fails below.
+	 */
+	if (kvpmu->snapshot_addr != INVALID_GPA)
+		kvm_pmu_clear_snapshot_area(vcpu);
+
 	kvpmu->sdata = kzalloc(snapshot_area_size, GFP_ATOMIC);
 	if (!kvpmu->sdata) {
 		sbiret = SBI_ERR_FAILURE;
-- 
2.53.0



