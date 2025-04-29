Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A3F22A81D;
	Tue, 29 Apr 2025 17:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946219; cv=none; b=jMHphOI41wk8NdtoBJBxW+J+4ArOtxJBQxVTRbuZZ6BlAr2jJRklptoU6CaCScYToFzvWXw6SWeNUwEeuC6sJHt37CC66fQa4S5IBLf9e6v640n8kKPTt+EDknwwGJtUFelA5lctnkGW3Ngj69XguT9y0VQIudFfO5OZwAiOJw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946219; c=relaxed/simple;
	bh=T1369clMFG+ZSsGy83dsxZP6kihDj2G6sv1MA+emMmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jobOU/cfxtDwva8iAUsHelCpiEc5sGye9DYaO0IhxlpcK8JZl+SW8Kqwt4ItZ1v6GnPGfr4vLzlV664/f1/UWj/5qI4zz8AvUmSUFTs22vfccKQFAqK2vFMMLXTswtThHmvL60TV2hNPbV7kJh9YOcx77crYqVAB9ksiwLaeI/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Lz8vrxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Lz8vrxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7C4C4CEE3;
	Tue, 29 Apr 2025 17:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946218;
	bh=T1369clMFG+ZSsGy83dsxZP6kihDj2G6sv1MA+emMmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Lz8vrxnEVS01/8U34IxFgXPxNR7alFhznS2cqs4Gt1mI23BzaWMNHFQQRQsyWrTz
	 jVEmkYTX59yHcGjTtjWICUHFv2Orm+kVTq3jjzsrYyOLVXl/NRUfQfbFxETCwVjeQF
	 fV8Z3j1kYQq6fkafy70hDQ4SVXpp2EeU80/XvVUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 195/311] bpf: Reject attaching fexit/fmod_ret to __noreturn functions
Date: Tue, 29 Apr 2025 18:40:32 +0200
Message-ID: <20250429161129.003200671@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit cfe816d469dce9c0864062cf65dd7b3c42adc6f8 ]

If we attach fexit/fmod_ret to __noreturn functions, it will cause an
issue that the bpf trampoline image will be left over even if the bpf
link has been destroyed. Take attaching do_exit() with fexit for example.
The fexit works as follows,

  bpf_trampoline
  + __bpf_tramp_enter
    + percpu_ref_get(&tr->pcref);

  + call do_exit()

  + __bpf_tramp_exit
    + percpu_ref_put(&tr->pcref);

Since do_exit() never returns, the refcnt of the trampoline image is
never decremented, preventing it from being freed. That can be verified
with as follows,

  $ bpftool link show                                   <<<< nothing output
  $ grep "bpf_trampoline_[0-9]" /proc/kallsyms
  ffffffffc04cb000 t bpf_trampoline_6442526459    [bpf] <<<< leftover

In this patch, all functions annotated with __noreturn are rejected, except
for the following cases:
- Functions that result in a system reboot, such as panic,
  machine_real_restart and rust_begin_unwind
- Functions that are never executed by tasks, such as rest_init and
  cpu_startup_entry
- Functions implemented in assembly, such as rewind_stack_and_make_dead and
  xen_cpu_bringup_again, lack an associated BTF ID.

With this change, attaching fexit probes to functions like do_exit() will
be rejected.

$ ./fexit
libbpf: prog 'fexit': BPF program load failed: -EINVAL
libbpf: prog 'fexit': -- BEGIN PROG LOAD LOG --
Attaching fexit/fmod_ret to __noreturn functions is rejected.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Link: https://lore.kernel.org/r/20250318114447.75484-2-laoar.shao@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c6f3b5f4ff2be..db95b76f5c139 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -22863,6 +22863,33 @@ BTF_ID(func, __rcu_read_unlock)
 #endif
 BTF_SET_END(btf_id_deny)
 
+/* fexit and fmod_ret can't be used to attach to __noreturn functions.
+ * Currently, we must manually list all __noreturn functions here. Once a more
+ * robust solution is implemented, this workaround can be removed.
+ */
+BTF_SET_START(noreturn_deny)
+#ifdef CONFIG_IA32_EMULATION
+BTF_ID(func, __ia32_sys_exit)
+BTF_ID(func, __ia32_sys_exit_group)
+#endif
+#ifdef CONFIG_KUNIT
+BTF_ID(func, __kunit_abort)
+BTF_ID(func, kunit_try_catch_throw)
+#endif
+#ifdef CONFIG_MODULES
+BTF_ID(func, __module_put_and_kthread_exit)
+#endif
+#ifdef CONFIG_X86_64
+BTF_ID(func, __x64_sys_exit)
+BTF_ID(func, __x64_sys_exit_group)
+#endif
+BTF_ID(func, do_exit)
+BTF_ID(func, do_group_exit)
+BTF_ID(func, kthread_complete_and_exit)
+BTF_ID(func, kthread_exit)
+BTF_ID(func, make_task_dead)
+BTF_SET_END(noreturn_deny)
+
 static bool can_be_sleepable(struct bpf_prog *prog)
 {
 	if (prog->type == BPF_PROG_TYPE_TRACING) {
@@ -22951,6 +22978,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	} else if (prog->type == BPF_PROG_TYPE_TRACING &&
 		   btf_id_set_contains(&btf_id_deny, btf_id)) {
 		return -EINVAL;
+	} else if ((prog->expected_attach_type == BPF_TRACE_FEXIT ||
+		   prog->expected_attach_type == BPF_MODIFY_RETURN) &&
+		   btf_id_set_contains(&noreturn_deny, btf_id)) {
+		verbose(env, "Attaching fexit/fmod_ret to __noreturn functions is rejected.\n");
+		return -EINVAL;
 	}
 
 	key = bpf_trampoline_compute_key(tgt_prog, prog->aux->attach_btf, btf_id);
-- 
2.39.5



