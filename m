Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061402;
	b=xHOXXhW4JHswQTkXbPo7r7Ebfw7qL+hDuHvUX1LNDQRGU+ZkpSgyiDdt1oaDTZ4Xshzr
	 64/8gcMsZAbkAUcaN1xbCNt9DjO50f4O7H+1CQnK9hEbtpZKcv9zy65IjYPzNDQK3XdYv
	 YAjzbAn88mxXzRVw6gRYLxZTQRcGrRCpkCqphcawrYfMoCioeOLOE8PBK8O6T3UBwZ4OO
	 E81LZtbrH+M6+iM1jlTstuJOEKo47h9cvNvTdZSAMH25Fh67mMlbpXIOSi2oabGbkkKUg
	 y4M7AHT1sJPbZA0kIMIcM13vEE2m3ZCTCzBxUnr+pB8tvDX47WkfCm/uHTVrATLa81w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6pIfaxZv69DWDykNfZ6dp0aACbp+o8itwNs7MMMQs+Q=;
	b=t08KOGnWTIcl/Z564DwF9yUdnJG5rr4qxyjHoQxMt9SvbqgAzvPwVmt6Hbz9RonKHz6S
	 QwUVFlkZjiV8p6feLumaJcFf3CC1Igmh4QS9X6HgwjGyiMhHHtdfnVUu/ejvx7LHENOcx
	 7QdeI5I2v6LmlocV6+h8XreSYeTl9zOpJ5Z1k35o7EUUk9OgXLmsoRFUwytLAUhL81I0c
	 zVkrvvGES2KzgthFDjJcRP3xUFtWQiOk+umYGTv2WGHLIp36kdWWHhKIi1zfUlxs6BY6a
	 KBEELHVkseAb3F9KX64E1DtvBCENatGw/wHy/XkulpZ7B7/CMwVrO1lvn5fxf4Jn41A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WW1aY3GS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82386606A332;
	Sat,  7 Nov 2026 14:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WW1aY3GS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC911F0089F;
	Sat,  7 Nov 2026 14:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061402;
	bh=6pIfaxZv69DWDykNfZ6dp0aACbp+o8itwNs7MMMQs+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WW1aY3GS4p5sfyZ1N+BX4Z/wiUy1dJQtKr0QQGniQyvACwFO+ygZPkKjT9N7js5h/
	 gWwW3nAfCUwM/e3XaLRYDNIXTaTnE6uMCpyd2zbFILxuWIJ4300/3XsCNt+UD7qkRv
	 wwRJATyubB9ykkMqQmMO4LgwDMwsX2buMg9R7NPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0520/1536] RISC-V: KVM: Fix sdata leak and stale snapshot_addr in snapshot_set_shmem
Date: Sat,  7 Nov 2026 08:42:16 -0500
Message-ID: <20261107135012.034984953@linuxfoundation.org>
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
[ sashal: Dropped the __GFP_ACCOUNT flag from the kzalloc context line, since this tree lacks it, and inserted the same 8-line clear block before the GFP_ATOMIC allocation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_pmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 147fc0d107ca9..516a0570bdf6a 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -435,6 +435,14 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long s
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



