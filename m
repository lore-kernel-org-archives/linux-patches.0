Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B067E24E000;
	Tue, 29 Apr 2025 17:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947437; cv=none; b=tYOkuxgLkmx42KiMf1VXzBheB3ymH0y83M7Ss5E8UV1RsTbw5vdv61akcayI8gPYTU6DOqZVLxIQQGnx9o56PmxZk2fGNoCoY3J1zDYBldzWwDxE3n56vLpGbxGlGfQS4Xmk7Nml1F1nij6BM7KJIqLxE6e1g7W6jBbOs+Zt1Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947437; c=relaxed/simple;
	bh=eyLGp2IvQM7Qdo8YZBJ42v/ChpCP19sgkNmI4atQM3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVe8iMG4eXbkuiiPn9zI0M0QQBVdLgOi2hAmTPPpPx2lCRLeQWzzesrKY9TT80Ltd83GNhjfh8oKjBBlD1KTPZvfAJs1YRtTkGRILHKK518DGMHxhMireh/rleJM/vMEZVZKbby9RhsPVhgmkl0T4M1Ewkf2hEXNyrrmaofV5fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsBITRNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsBITRNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3722AC4CEE3;
	Tue, 29 Apr 2025 17:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947437;
	bh=eyLGp2IvQM7Qdo8YZBJ42v/ChpCP19sgkNmI4atQM3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsBITRNF3c2plG5Cp/VT32nnFkW8qRH4XNMcQ/Mfy75tZLpRf7gmH3zlk2VdATWFF
	 skg9DE86pph8jZlOjutrp3I5iRWk/2jPkki3W7mNW3zTelprl4uJBwtobmWixaZmOL
	 WB6y3g/KFXflzB3cuckgsmGabQhlFBZ7WQqVk1u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=F8iland-J=F8rgensen?= <toke@kernel.org>,
	=?UTF-8?q?Ricardo=20Ca=F1uelo=20Navarro?= <rcn@igalia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5.10 280/286] xdp: Reset bpf_redirect_info before running a xdps BPF prog.
Date: Tue, 29 Apr 2025 18:43:04 +0200
Message-ID: <20250429161119.429013565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Ricardo reported a KASAN discovered use after free in v6.6-stable.

The syzbot starts a BPF program via xdp_test_run_batch() which assigns
ri->tgt_value via dev_hash_map_redirect() and the return code isn't
XDP_REDIRECT it looks like nonsense. So the output in
bpf_warn_invalid_xdp_action() appears once.
Then the TUN driver runs another BPF program (on the same CPU) which
returns XDP_REDIRECT without setting ri->tgt_value first. It invokes
bpf_trace_printk() to print four characters and obtain the required
return value. This is enough to get xdp_do_redirect() invoked which
then accesses the pointer in tgt_value which might have been already
deallocated.

This problem does not affect upstream because since commit
	401cb7dae8130 ("net: Reference bpf_redirect_info via task_struct on PREEMPT_RT.")

the per-CPU variable is referenced via task's task_struct and exists on
the stack during NAPI callback. Therefore it is cleared once before the
first invocation and remains valid within the RCU section of the NAPI
callback.

Instead of performing the huge backport of the commit (plus its fix ups)
here is an alternative version which only resets the variable in
question prior invoking the BPF program.

Acked-by: Toke Høiland-Jørgensen <toke@kernel.org>
Reported-by: Ricardo Cañuelo Navarro <rcn@igalia.com>
Closes: https://lore.kernel.org/all/20250226-20250204-kasan-slab-use-after-free-read-in-dev_map_enqueue__submit-v3-0-360efec441ba@igalia.com/
Fixes: 97f91a7cf04ff ("bpf: add bpf_redirect_map helper routine")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/filter.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -758,6 +758,10 @@ static __always_inline u32 bpf_prog_run_
 	 * already takes rcu_read_lock() when fetching the program, so
 	 * it's not necessary here anymore.
 	 */
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+	if (ri->map)
+		ri->map = NULL;
 	return __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
 }
 


