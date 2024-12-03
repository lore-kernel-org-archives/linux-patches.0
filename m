Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61631E3DF9;
	Tue,  3 Dec 2024 16:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242431; cv=none; b=HAm/JfcIM2bXtyTvZvgRWcl8ZsZZZ5IPfUmRUKt0QGq0k+CNJEQYKdd+QDVKEfJgHz2yRbh3WzkFVcl7ZgNEhWW+37ajifJAvLBuHzL9PN+dxbsh7oUIcbOkHbczqAIQl9as16/R9RSqGh6Kf0rt2jnxlZNwWS+Mzg6FSlJoXPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242431; c=relaxed/simple;
	bh=zDG9XFWZjKGVu+cNsfcwcYbsqMdWeMAWMrd+aELOF/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZtlYnQZe6h83Rn5rXXrFc+TuRPSgD2pSjQj5kX7q8G6Q8sBGe2YD5l4/yMvKjyaOOYvDZQjT6G9mX4GAlRabAZh0otLOpaE+cfe8Pbb+fQhzrlyJV8W3efiDa/MrfUAeiz5GbbEwPP7pecFnN5tOlyDTFW2qLuNDX2dhCYQ+r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhxsQBy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhxsQBy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B718C4CED6;
	Tue,  3 Dec 2024 16:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242430;
	bh=zDG9XFWZjKGVu+cNsfcwcYbsqMdWeMAWMrd+aELOF/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhxsQBy2AjhcPgMo6kyhAXE9lfKLIjKwQj63NyiwkucBpPfKh1o0kAWqmlq4EEQre
	 WvMSNCs7WXQraF9AfsAKWrg9kVCK/h7WA2Sqf6/GEkzvKvGDAWCKEJ+gzVJkrm/LJD
	 lsfqUZimHuhPtcSU+JLN02PXZ4nIae5xvQX01VH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Taube <jesse@rivosinc.com>,
	Evan Green <evan@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.12 701/826] RISC-V: Scalar unaligned access emulated on hotplug CPUs
Date: Tue,  3 Dec 2024 15:47:08 +0100
Message-ID: <20241203144811.103865115@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jesse Taube <jesse@rivosinc.com>

commit 9c528b5f7927b857b40f3c46afbc869827af3c94 upstream.

The check_unaligned_access_emulated() function should have been called
during CPU hotplug to ensure that if all CPUs had emulated unaligned
accesses, the new CPU also does.

This patch adds the call to check_unaligned_access_emulated() in
the hotplug path.

Fixes: 55e0bf49a0d0 ("RISC-V: Probe misaligned access speed in parallel")
Signed-off-by: Jesse Taube <jesse@rivosinc.com>
Reviewed-by: Evan Green <evan@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241017-jesse_unaligned_vector-v10-2-5b33500160f8@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/unaligned_access_speed.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -191,6 +191,7 @@ static int riscv_online_cpu(unsigned int
 	if (per_cpu(misaligned_access_speed, cpu) != RISCV_HWPROBE_MISALIGNED_SCALAR_UNKNOWN)
 		goto exit;
 
+	check_unaligned_access_emulated(NULL);
 	buf = alloc_pages(GFP_KERNEL, MISALIGNED_BUFFER_ORDER);
 	if (!buf) {
 		pr_warn("Allocation failure, not measuring misaligned performance\n");


