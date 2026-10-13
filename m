Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F214F68DD;
	Tue, 13 Oct 2026 11:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892699; cv=none; b=Lk+idZhZDGEl7aj2IOsOL/cy021hgaLh5knWgmeLPU7sML8rVNCIaKykM5bF7rJAYWL9hWw+ks7dXY+0MDEyDARJMeZvF3gnqCpT86ND98V+vgelKhyqf8cVQHO4EhTrDPjDD3MObbtAkn5CxrdP+ad6TqwhIcHnfwfLsFc1eAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892699; c=relaxed/simple;
	bh=9ef0gxvB8w460qSJL48uDs7rDjU/mHZ8nzh+N7ks8sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6S2kszabGdOti3KHVYdyYCyOXZr8NjXjJB6BM4A8mVAr+VIBopeb1v6e7Ycih8dR7fYhOC8RwdVtDv2WDNtbXQtWCPHsHp+r173wNNnwmilSV2PIWpJtEBazBeHknnei89nD0lbYFl61nj4XuM/fhPJW/JBaDUVeimcg0Kb7wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1owAIa4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1owAIa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39891F00893;
	Tue, 13 Oct 2026 11:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892698;
	bh=NlONJvlfS56nZFgqJxoRZrPXqzlDiQN0N9MkeLodb50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1owAIa4aHzeeHiXX7AeusWSUYWkNZmZ/r7NdCo/zUndD10y3hs2R0fkY3sRXEKz8
	 cYwDGTJxm0lNJwS5KXD9Rmp/TdzPXxWp5yNLzupOrRqvV0mqWJXZ/vXhGcQs0Zvv4V
	 6eucqRNd14NNKI68vuA9ozw3HSx1Kj/Fk0YMymXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yu-Chi Liang <leo.liang@sifive.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 258/281] riscv: fix NR_CPUS range leaking 64-bit default onto 32-bit builds
Date: Tue, 13 Oct 2026 13:39:34 +0200
Message-ID: <20261013112901.404292328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Leo Yu-Chi Liang <leo.liang@sifive.com>

[ Upstream commit 07e23d0b6f58eec351e52058b9a0a8af7b019c09 ]

rv32_defconfig is built in two stages:

- the generic (64-bit-oriented) "defconfig" target runs first
  and resolves a concrete NR_CPUS value using the 64BIT default.
- then 32-bit.config is merged on top via merge_config.sh,
  which does not touch NR_CPUS.

The final "make olddefconfig" pass sees NR_CPUS=256 is still within
the "2 512" range therefore never recalculates it against the 32BIT
default of 32, silently keeping the leaked 64-bit-stage value.

The NR_CPUS-scaled regions (percpu areas, ...etc) of the resulting
CONFIG_NR_CPUS=256 on a 32-bit build bloats and does not fit in the
percpu/stack layout for rv32 and hangs early boot on QEMU's virt machine.

Fix this by explicitly specify the range for 32/64 and SBI_V01/!SBI_V01.

Fixes: 0fa749771993 ("riscv: Raise default NR_CPUS for 64BIT to 256")
Signed-off-by: Leo Yu-Chi Liang <leo.liang@sifive.com>
Link: https://patch.msgid.link/20261007045229.36114-1-leo.liang@sifive.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index f7028caaeae06..e5166df510bb6 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -450,9 +450,10 @@ config SMP
 config NR_CPUS
 	int "Maximum number of CPUs (2-512)"
 	depends on SMP
-	range 2 512 if !RISCV_SBI_V01
-	range 2 32 if RISCV_SBI_V01 && 32BIT
+	range 2 512 if !RISCV_SBI_V01 && 64BIT
+	range 2 128 if !RISCV_SBI_V01 && 32BIT
 	range 2 64 if RISCV_SBI_V01 && 64BIT
+	range 2 32 if RISCV_SBI_V01 && 32BIT
 	default "32" if 32BIT
 	default "64" if RISCV_SBI_V01 && 64BIT
 	default "256" if !RISCV_SBI_V01 && 64BIT
-- 
2.53.0



