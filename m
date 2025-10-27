Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5B032ABF1;
	Mon, 27 Oct 2025 19:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592968; cv=none; b=EdP7pX/BH1Vr82i/RMO4JuaCFd/3htfsVsfc471HpKdBtfrDMwlEAJUFv7CxO6ktUb56Zs/cQ/X/zCtmh6nlzaHtedZmpQwBOkBy2V+UVj6ucpMvzgqM+i8WNo7jG/G3FuG1tEc5ppaOe8aJDautTlXsCEMBPSqjJrA8aP9QKMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592968; c=relaxed/simple;
	bh=RhDqRnqvT62pZSzrZEW3oHqkQmEAQO5X1MBzYgcIzH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nThrcV/3x+X6Vc1eY6xsavDtVqkUl/XwV9Lef6rMpillknAYNp4/jyFQtKVWIDWcld1Qp8g4pwTOTocIxGu9SXqkHqaCLOquzHV3K6XBToW/yNhwWiZhvdP7ZDyV55tjBLaEbdhM05cO3TuM239PKXElhOELSxx75GrFvvrgK1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCsppFYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCsppFYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F7FC4CEF1;
	Mon, 27 Oct 2025 19:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592968;
	bh=RhDqRnqvT62pZSzrZEW3oHqkQmEAQO5X1MBzYgcIzH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCsppFYIPHjFXcRVa0iO5xX9FO+OgrJRMR7hD7shOrq7OjgixYUq7lsfndbaMQRC9
	 uDgdUcKl3HciW/GLnfWe9ePl2YfMYW7Mc4OKLA0gQdUYSA1P/ozf1i4noqJ8dXPZZ1
	 9pb4R1C7mXgFGhj6VLogTT+Rz8NJ/uOA+yvMZfac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Green <evan@rivosinc.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/117] riscv: hwprobe: avoid uninitialized variable use in hwprobe_arch_id()
Date: Mon, 27 Oct 2025 19:36:48 +0100
Message-ID: <20251027183456.246080053@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Paul Walmsley <pjw@kernel.org>

[ Upstream commit b7776a802f2f80139f96530a489dd00fd7089eda ]

Resolve this smatch warning:

  arch/riscv/kernel/sys_hwprobe.c:50 hwprobe_arch_id() error: uninitialized symbol 'cpu_id'.

This could happen if hwprobe_arch_id() was called with a key ID of
something other than MVENDORID, MIMPID, and MARCHID.  This does not
happen in the current codebase.  The only caller of hwprobe_arch_id()
is a function that only passes one of those three key IDs.

For the sake of reducing static analyzer warning noise, and in the
unlikely event that hwprobe_arch_id() is someday called with some
other key ID, validate hwprobe_arch_id()'s input to ensure that
'cpu_id' is always initialized before use.

Fixes: ea3de9ce8aa280 ("RISC-V: Add a syscall for HW probing")
Cc: Evan Green <evan@rivosinc.com>
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Link: https://lore.kernel.org/r/cf5a13ec-19d0-9862-059b-943f36107bf3@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/sys_hwprobe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index cea0ca2bf2a25..fc62548888c58 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -25,6 +25,11 @@ static void hwprobe_arch_id(struct riscv_hwprobe *pair,
 	bool first = true;
 	int cpu;
 
+	if (pair->key != RISCV_HWPROBE_KEY_MVENDORID &&
+	    pair->key != RISCV_HWPROBE_KEY_MIMPID &&
+	    pair->key != RISCV_HWPROBE_KEY_MARCHID)
+		goto out;
+
 	for_each_cpu(cpu, cpus) {
 		u64 cpu_id;
 
@@ -55,6 +60,7 @@ static void hwprobe_arch_id(struct riscv_hwprobe *pair,
 		}
 	}
 
+out:
 	pair->value = id;
 }
 
-- 
2.51.0



