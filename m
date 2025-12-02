Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0648C2D1F4E;
	Tue,  2 Dec 2025 22:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764713958; cv=none; b=UB5oKqulyJbWlFIzIWCkJtwGirficvkqpNpOidzAFBkP3Pbevn9efWSORK6Y1PlGvuA6zsqOSzvul8EDsagUj3FscLRceLuMVXeUapDRmXTcasd7uX6U0dDoTmzS/6IyDYkP5xDDgC9dosQA/6QBD8nlkBhQ8kseVHNmusysdts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764713958; c=relaxed/simple;
	bh=s67ObscIC5Fdz0gW2PfFJdDD71/iFYepTk0lKClwfAo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=eA0IHNlTU+EKzsvJnM5r0s4LfEynAOad09cKVE3aDtTXi8MWGwWjo85q/Y2FZfHIJLKNFlLa95eLTmk+0Zpn6dUV2PdCk1X2nqPYONHlZMqewahVe2HfbjIt2+0260xBCFJZsbM+mz2r+82i8x/yEzpbdU7gQsV13Mu/s+sMM9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SU8OuIvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SU8OuIvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78C6C4CEF1;
	Tue,  2 Dec 2025 22:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764713957;
	bh=s67ObscIC5Fdz0gW2PfFJdDD71/iFYepTk0lKClwfAo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SU8OuIvRkG5HX9GerzrGCwAD0hZrRjnWxVwHryreN9/1b6sx9XJuSfjg3maCMHpSU
	 GI9c4Z3clmN8OvxPjZdKy61dPS7hc+YkJ9ont2J4xa+Nr2jfoWnOlzOVgnWQxYKJ2F
	 RMmsEyTMNQk9RvqWvBDaPR1NdMjQlmI/k2o77nQ4iBgZvorYlKr/ZggvdSm+ofos5z
	 cfTo89wWUP383IeC/Df0G6hDgvQKlXA/WuEaaEcawvDbdNU5Xri0+4COnl/aM+QoUI
	 xIJpBB5pHoTpyFNxYGd4iLvD8e9maEm89GiBzc0PAO+T5z4Ax8/F7ZR1BwPgMi43tX
	 whNdULGGAXXbQ==
Date: Wed, 3 Dec 2025 07:19:13 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Khannanov Lenar <Lenar.Khannanov@infotecs.ru>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "mhiramat@kernel.org" <mhiramat@kernel.org>, "patches@lists.linux.dev"
 <patches@lists.linux.dev>, "sashal@kernel.org" <sashal@kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>, Ilia Gavrilov
 <Ilia.Gavrilov@infotecs.ru>
Subject: Re: [PATCH 6.12 034/116] tracing: tprobe-events: Fix to clean up
 tprobe correctly when module unload
Message-Id: <20251203071913.ced4edee107af8154c1e3ccd@kernel.org>
In-Reply-To: <4e6535a0-1da9-4a74-9bf0-c551b2b183e7@infotecs.ru>
References: <20250325122150.084780669@linuxfoundation.org>
	<4e6535a0-1da9-4a74-9bf0-c551b2b183e7@infotecs.ru>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 24 Nov 2025 11:06:41 +0000
Khannanov Lenar <Lenar.Khannanov@infotecs.ru> wrote:

> We found the kernel crashed when running kselftest (ftrace:ftracetest-ktap) in kernel 6.12.52 with the next trace:
> 
> 
> [  321.365532] ------------[ cut here ]------------
> [  321.368124] WARNING: CPU: 0 PID: 1132 at kernel/trace/ftrace.c:378 __unregister_ftrace_function+0x12a/0x1c0
> [  321.373445] Modules linked in: intel_rapl_msr(E) intel_rapl_common(E) crct10dif_pclmul(E) ghash_clmulni_intel(E) sha512_ssse3(E) sha256_ssse3(E) sha1_ssse3(E) aesni_intel(E) crypto_simd(E) cryptd(E) rapl(E) snd_pcm(E) snd_timer(E) vmw_balloon(E) snd(E) vmwgfx(E) soundcore(E) drm_ttm_helper(E) vga16fb(E) ttm(E) vgastate(E) pcspkr(E) drm_kms_helper(E) vmw_vmci(E) ac(E) button(E) joydev(E) serio_raw(E) sg(E) openvswitch(E) nsh(E) nf_conncount(E) drm(E) dm_mod(E) fuse(E) autofs4(E) sd_mod(E) ata_generic(E) hid_generic(E) mptspi(E) ata_piix(E) mptscsih(E) mptbase(E) i2c_piix4(E) scsi_transport_spi(E) crc32_pclmul(E) libata(E) crc32c_intel(E) psmouse(E) ehci_pci(E) uhci_hcd(E) i2c_smbus(E) e1000(E) scsi_mod(E) ehci_hcd(E) scsi_common(E) [last unloaded: trace_events_sample(E)]
> [  321.404373] CPU: 0 UID: 0 PID: 1132 Comm: ftracetest Tainted: G            E      6.12.52 #4
> [  321.408625] Tainted: [E]=UNSIGNED_MODULE
> [  321.410729] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
> [  321.416039] RIP: 0010:__unregister_ftrace_function+0x12a/0x1c0
> [  321.419046] Code: 00 48 8b 1d 48 7e ac 02 48 81 fb e0 09 df bd 0f 84 90 00 00 00 48 39 dd 0f 85 1d ff ff ff 48 c7 c0 b0 09 df bd e9 36 ff ff ff <0f> 0b b8 f0 ff ff ff e9 8a 03 ea 00 be ff ff ff ff 48 c7 c7 68 23
> [  321.429097] RSP: 0018:ffffa0ba8106fb90 EFLAGS: 00010246
> [  321.431997] RAX: 0000000000000000 RBX: ffff92a988808418 RCX: 0000000000000000
> [  321.435654] RDX: 0000000000000000 RSI: ffffffffbc1be80c RDI: ffff92a988808418
> [  321.439480] RBP: 00000000ffffffea R08: 0000000000000001 R09: 0000000000000000
> [  321.443158] R10: ffffa0ba8106fb98 R11: 0000000080000000 R12: ffff92a988808620
> [  321.446896] R13: ffffffffbb3905b0 R14: ffff92a985c012c0 R15: 00000000000041ed
> [  321.450646] FS:  00007efce9408740(0000) GS:ffff92a9b9600000(0000) knlGS:0000000000000000
> [  321.454781] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  321.457970] CR2: 00007fdc3c2d64c0 CR3: 000000010c79a000 CR4: 0000000000752ef0
> [  321.462499] PKRU: 55555554
> [  321.464322] Call Trace:
> [  321.466060]  <TASK>
> [  321.467592]  unregister_ftrace_function+0x35/0x170
> [  321.470541]  ? __pfx_dyn_event_open+0x10/0x10
> [  321.473070]  unregister_fprobe+0x4e/0x90
> [  321.475486]  trace_fprobe_release+0x118/0x160
> [  321.478052]  dyn_events_release_all+0xba/0xe0
> [  321.480961]  dyn_event_open+0x46/0x50
> [  321.483330]  do_dentry_open+0x160/0x460
> [  321.485611]  vfs_open+0x30/0xf0
> [  321.487524]  path_openat+0x66d/0xc60
> [  321.489674]  do_filp_open+0xac/0x150
> [  321.491860]  ? rcu_is_watching+0xd/0x50
> [  321.494179]  ? _raw_spin_unlock+0x29/0x50
> [  321.496489]  ? trace_preempt_on+0x80/0xc0
> [  321.498966]  ? preempt_count_sub+0x92/0xd0
> [  321.501451]  ? _raw_spin_unlock+0x29/0x50
> [  321.503836]  do_sys_openat2+0x91/0xc0
> [  321.505932]  __x64_sys_openat+0x6a/0xa0
> [  321.508307]  do_syscall_64+0x87/0x140
> [  321.510619]  ? do_syscall_64+0x93/0x140
> [  321.512889]  ? do_syscall_64+0x93/0x140
> [  321.515095]  ? trace_hardirqs_on_prepare+0x38/0xd0
> [  321.517782]  ? syscall_exit_to_user_mode+0x80/0x170
> [  321.520563]  ? do_syscall_64+0x93/0x140
> [  321.522916]  ? do_syscall_64+0x93/0x140
> [  321.525047]  ? clear_bhb_loop+0x60/0xb0
> [  321.527358]  ? clear_bhb_loop+0x60/0xb0
> [  321.529568]  ? clear_bhb_loop+0x60/0xb0
> [  321.531867]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  321.534549] RIP: 0033:0x7efce9502f01
> [  321.536647] Code: 75 57 89 f0 25 00 00 41 00 3d 00 00 41 00 74 49 80 3d ea 26 0e 00 00 74 6d 89 da 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 93 00 00 00 48 8b 54 24 28 64 48 2b 14 25
> [  321.545776] RSP: 002b:00007ffee609e920 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
> [  321.549681] RAX: ffffffffffffffda RBX: 0000000000000241 RCX: 00007efce9502f01
> [  321.553486] RDX: 0000000000000241 RSI: 000056032f3378e8 RDI: 00000000ffffff9c
> [  321.557137] RBP: 000056032f3378e8 R08: 000000000000000f R09: 0000000000000001
> [  321.561025] R10: 00000000000001b6 R11: 0000000000000202 R12: 0000000000000000
> [  321.564879] R13: 0000000000000003 R14: 000056032f337898 R15: 000056032f3378c0
> [  321.568737]  </TASK>
> [  321.570407] irq event stamp: 0
> [  321.572420] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [  321.575750] hardirqs last disabled at (0): [<ffffffffbb18ad04>] copy_process+0xad4/0x2bf0
> [  321.579887] softirqs last  enabled at (0): [<ffffffffbb18ad04>] copy_process+0xad4/0x2bf0
> [  321.584131] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [  321.587407] ---[ end trace 0000000000000000 ]---
> [  321.590005] BUG: kernel NULL pointer dereference, address: 000000000000002e
> [  321.594462] #PF: supervisor read access in kernel mode
> [  321.597485] #PF: error_code(0x0000) - not-present page
> [  321.600377] PGD 0 P4D 0
> [  321.602138] Oops: Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
> [  321.605966] CPU: 2 UID: 0 PID: 1132 Comm: ftracetest Tainted: G        W   E      6.12.52 #4
> [  321.610759] Tainted: [W]=WARN, [E]=UNSIGNED_MODULE
> [  321.613608] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
> [  321.625523] RIP: 0010:trace_fprobe_release+0x135/0x160
> [  321.628287] Code: e9 5a ff ff ff 48 89 ef e8 78 e9 ff ff 31 c0 b9 3e 00 00 00 48 89 ef f3 48 ab 48 8b bb 10 02 00 00 48 85 ff 0f 84 27 ff ff ff <48> 8b 77 30 31 d2 e8 c0 a6 f8 ff 48 c7 83 10 02 00 00 00 00 00 00
> [  321.638446] RSP: 0018:ffffa0ba8106fbf0 EFLAGS: 00010282
> [  321.641267] RAX: 0000000000000000 RBX: ffff92a988808400 RCX: 0000000000000000
> [  321.644913] RDX: 0000000000000000 RSI: ffffffffbcabc8e0 RDI: fffffffffffffffe
> [  321.648727] RBP: ffff92a988808418 R08: 0000000000000001 R09: 0000000000000000
> [  321.652390] R10: 0000000000000000 R11: 0000000080000000 R12: ffff92a988808620
> [  321.656067] R13: ffffffffbb3905b0 R14: ffff92a985c012c0 R15: 00000000000041ed
> [  321.659841] FS:  00007efce9408740(0000) GS:ffff92a9b9680000(0000) knlGS:0000000000000000
> [  321.663892] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  321.666927] CR2: 000000000000002e CR3: 000000010c79a000 CR4: 0000000000752ef0
> [  321.671048] PKRU: 55555554
> [  321.672617] Call Trace:
> [  321.674080]  <TASK>
> [  321.675439]  dyn_events_release_all+0xba/0xe0
> [  321.677796]  dyn_event_open+0x46/0x50
> [  321.679875]  do_dentry_open+0x160/0x460
> [  321.681973]  vfs_open+0x30/0xf0
> [  321.683816]  path_openat+0x66d/0xc60
> [  321.685805]  do_filp_open+0xac/0x150
> [  321.687823]  ? rcu_is_watching+0xd/0x50
> [  321.689933]  ? _raw_spin_unlock+0x29/0x50
> [  321.692269]  ? trace_preempt_on+0x80/0xc0
> [  321.694623]  ? preempt_count_sub+0x92/0xd0
> [  321.696919]  ? _raw_spin_unlock+0x29/0x50
> [  321.699104]  do_sys_openat2+0x91/0xc0
> [  321.701098]  __x64_sys_openat+0x6a/0xa0
> [  321.703233]  do_syscall_64+0x87/0x140
> [  321.705229]  ? do_syscall_64+0x93/0x140
> [  321.707314]  ? do_syscall_64+0x93/0x140
> [  321.709748]  ? trace_hardirqs_on_prepare+0x38/0xd0
> [  321.712646]  ? syscall_exit_to_user_mode+0x80/0x170
> [  321.715242]  ? do_syscall_64+0x93/0x140
> [  321.717292]  ? do_syscall_64+0x93/0x140
> [  321.719373]  ? clear_bhb_loop+0x60/0xb0
> [  321.721412]  ? clear_bhb_loop+0x60/0xb0
> [  321.723602]  ? clear_bhb_loop+0x60/0xb0
> [  321.725925]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  321.728644] RIP: 0033:0x7efce9502f01
> [  321.730619] Code: 75 57 89 f0 25 00 00 41 00 3d 00 00 41 00 74 49 80 3d ea 26 0e 00 00 74 6d 89 da 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 93 00 00 00 48 8b 54 24 28 64 48 2b 14 25
> [  321.739534] RSP: 002b:00007ffee609e920 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
> [  321.743467] RAX: ffffffffffffffda RBX: 0000000000000241 RCX: 00007efce9502f01
> [  321.747137] RDX: 0000000000000241 RSI: 000056032f3378e8 RDI: 00000000ffffff9c
> [  321.750552] RBP: 000056032f3378e8 R08: 000000000000000f R09: 0000000000000001
> [  321.753932] R10: 00000000000001b6 R11: 0000000000000202 R12: 0000000000000000
> [  321.757373] R13: 0000000000000003 R14: 000056032f337898 R15: 000056032f3378c0
> [  321.761149]  </TASK>
> [  321.762475] Modules linked in: intel_rapl_msr(E) intel_rapl_common(E) crct10dif_pclmul(E) ghash_clmulni_intel(E) sha512_ssse3(E) sha256_ssse3(E) sha1_ssse3(E) aesni_intel(E) crypto_simd(E) cryptd(E) rapl(E) snd_pcm(E) snd_timer(E) vmw_balloon(E) snd(E) vmwgfx(E) soundcore(E) drm_ttm_helper(E) vga16fb(E) ttm(E) vgastate(E) pcspkr(E) drm_kms_helper(E) vmw_vmci(E) ac(E) button(E) joydev(E) serio_raw(E) sg(E) openvswitch(E) nsh(E) nf_conncount(E) drm(E) dm_mod(E) fuse(E) autofs4(E) sd_mod(E) ata_generic(E) hid_generic(E) mptspi(E) ata_piix(E) mptscsih(E) mptbase(E) i2c_piix4(E) scsi_transport_spi(E) crc32_pclmul(E) libata(E) crc32c_intel(E) psmouse(E) ehci_pci(E) uhci_hcd(E) i2c_smbus(E) e1000(E) scsi_mod(E) ehci_hcd(E) scsi_common(E) [last unloaded: trace_events_sample(E)]
> [  321.793650] CR2: 000000000000002e
> [  321.795444] ---[ end trace 0000000000000000 ]---
> [  321.797783] RIP: 0010:trace_fprobe_release+0x135/0x160
> [  321.800487] Code: e9 5a ff ff ff 48 89 ef e8 78 e9 ff ff 31 c0 b9 3e 00 00 00 48 89 ef f3 48 ab 48 8b bb 10 02 00 00 48 85 ff 0f 84 27 ff ff ff <48> 8b 77 30 31 d2 e8 c0 a6 f8 ff 48 c7 83 10 02 00 00 00 00 00 00
> [  321.809544] RSP: 0018:ffffa0ba8106fbf0 EFLAGS: 00010282
> [  321.812136] RAX: 0000000000000000 RBX: ffff92a988808400 RCX: 0000000000000000
> [  321.815574] RDX: 0000000000000000 RSI: ffffffffbcabc8e0 RDI: fffffffffffffffe
> [  321.819020] RBP: ffff92a988808418 R08: 0000000000000001 R09: 0000000000000000
> [  321.822463] R10: 0000000000000000 R11: 0000000080000000 R12: ffff92a988808620
> [  321.825928] R13: ffffffffbb3905b0 R14: ffff92a985c012c0 R15: 00000000000041ed
> [  321.829385] FS:  00007efce9408740(0000) GS:ffff92a9b9680000(0000) knlGS:0000000000000000
> [  321.833218] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  321.836153] CR2: 000000000000002e CR3: 000000010c79a000 CR4: 0000000000752ef0
> [  321.839711] PKRU: 55555554
> [  321.841241] Kernel panic - not syncing: Fatal exception
> [  321.844568] Kernel Offset: 0x3a000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [  331.783046] ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> 
> This panic was bisected to this particular commit and can be reproduced by running this specific subtest:
> 
> 
> ./ftracetest test.d/dynevent/add_remove_tprobe_module.tc

This might be fixed by the series of:

https://lore.kernel.org/all/176244792552.155515.3285089581362758469.stgit@devnote2/

Thanks,

> 
> 
> Regards,
> 
> Lenar Khannanov


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
