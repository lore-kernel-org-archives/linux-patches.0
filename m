Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6E028BAB2;
	Wed, 23 Apr 2025 15:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422575; cv=none; b=p4zkAqenit/u+2A7jFRkdZx78LR9NlIPV27MS9nuRlfroWKLsLO53k8vWY2+av93f+UlOHQo3O20bFN9C9kplccFW4XSqysN1O0mFNAe6nH7H9XruXU20ks9xW69LB2lHURkxsZSSlHx+jH1k0ZQkpB91Xq1QQ6FqHmR26hdYKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422575; c=relaxed/simple;
	bh=jc8RLwoTAEeb6LJbNrM8BE/AFwvTGOk2LwrXvt9F94o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F4Ld5uz+dOhFxEuSwV9lvKjs8k0ycDzgkOwxPEekFE5IOVj/0uybFh8/CBjzKXHcEG3azviCkDMU+WsK5bh/MyZajRjTUlF5vSFNG1EUGZQza3rdWsSe6uD3tuLsfyJIAm/V4CLL94Aw/owld4gDlhtvuPaORutFTLLkv9boJnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9VfW7IE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9VfW7IE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4765C4CEE2;
	Wed, 23 Apr 2025 15:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422575;
	bh=jc8RLwoTAEeb6LJbNrM8BE/AFwvTGOk2LwrXvt9F94o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9VfW7IEjoTIhb+KMSh+bzWsAgjalx+3pZoDRQAePPdLCT+Gbh95bggoFa5ONKtra
	 8qaYPKH0X75C/PjPuMqQCnMWozCVGcqGmMtc0+QYvtBsYZoMfNhupHPqOPkS3WG9tD
	 DIFtGmaU0gQTlo76/vAG83l27V6oFj0qAKCu8RNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
	=?UTF-8?q?Ricardo=20Ca=C3=B1uelo=20Navarro?= <rcn@igalia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6.6 385/393] [PATCH stable] xdp: Reset bpf_redirect_info before running a xdps BPF prog.
Date: Wed, 23 Apr 2025 16:44:41 +0200
Message-ID: <20250423142659.222108420@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 include/net/xdp.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -486,7 +486,14 @@ static __always_inline u32 bpf_prog_run_
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


