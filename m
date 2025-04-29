Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65FC252284;
	Tue, 29 Apr 2025 17:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949594; cv=none; b=sEM7bYsfv6oAjznL7B142MTwHKpZzBWq0jcYZmMdIe6w5DZJeoMfr/G4pV5HSqAOrFp6j+Ic4ffbW6IgBb8A4Rwr86ywDjHZiDB96DhmW37QlQFYq7St9+hCiJdnHzmD/HbBS2jnFHdYF+SALQOIjhqvSjcbyBflZXJSwdUrZKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949594; c=relaxed/simple;
	bh=6U0FyAaThMMvevzNemwdUcptYXZNxDBUGV5rn+CWjpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t0g8qOsL0ccVPAIF00tJXGg3o2P5dwfE3xF5QrDtd1foa9s14G/iNQvn/j2K9D4kpjtumBEl6Fl6AwG0shdpg72i4+k20EMTzrVuN5mpHdxOGlg/2LI27+Vnfo+ogZWrxipC1noW5DMEboLMGbUU5yF3+Gm+J8dyay+CoeHnnT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nQoBLmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nQoBLmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C6CC4CEE3;
	Tue, 29 Apr 2025 17:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949594;
	bh=6U0FyAaThMMvevzNemwdUcptYXZNxDBUGV5rn+CWjpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1nQoBLmzWzzHYc/lcFhlw76qU5q4v1a00Tzbk8o+M4xdDczTIxH8b98GFUlJphoR9
	 vJMdu62ZszBKJGLo70yvw5nIXN3Wxy63jgZDgeGXBtPXdH86Uru4kr4TUw4rJMkphu
	 IPLOSKn9RDjtHJva4xMb0G6S0LHFxyg+UX9cgoC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=F8iland-J=F8rgensen?= <toke@kernel.org>,
	=?UTF-8?q?Ricardo=20Ca=F1uelo=20Navarro?= <rcn@igalia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5.15 368/373] xdp: Reset bpf_redirect_info before running a xdps BPF prog.
Date: Tue, 29 Apr 2025 18:44:05 +0200
Message-ID: <20250429161138.267799200@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 include/linux/filter.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -800,7 +800,14 @@ static __always_inline u32 bpf_prog_run_
 	 * under local_bh_disable(), which provides the needed RCU protection
 	 * for accessing map entries.
 	 */
-	u32 act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	u32 act;
+
+	if (ri->map_id || ri->map_type) {
+		ri->map_id = 0;
+		ri->map_type = BPF_MAP_TYPE_UNSPEC;
+	}
+	act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
 
 	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
 		if (act == XDP_TX && netif_is_bond_slave(xdp->rxq->dev))


