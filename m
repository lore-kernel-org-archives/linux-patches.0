Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B733364CB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCAao7+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02849C433CA;
	Wed, 15 Nov 2023 19:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077745;
	bh=33FtohS1U9+aX+SDRGV89FE00NQrcc3zyy1jsrvof/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCAao7+DRhaZQCBkwNyoT0nGyWavo2qrSgbTSkynSd3slYj+NzJ/zunTjeF4bjyL3
	 OSPDpd/239p6P3ScesUwfO7I52ZIVuCC1Co4s+ywg+4P0iksNtvwhG+JSlwhftj1i7
	 Wjh2mVYH+FefJdWfKpJMaQ0USigpi+WzTYix+SbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	gor@linux.ibm.com,
	hca@linux.ibm.com,
	sumanthk@linux.ibm.com,
	svens@linux.ibm.com,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 471/603] perf trace: Use the right bpf_probe_read(_str) variant for reading user data
Date: Wed, 15 Nov 2023 14:16:56 -0500
Message-ID: <20231115191645.106868851@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 5069211e2f0b47e75119805e23ae6352d871e263 ]

Perf test case 111 Check open filename arg using perf trace + vfs_getname
fails on s390. This is caused by a failing function
bpf_probe_read() in file util/bpf_skel/augmented_raw_syscalls.bpf.c.

The root cause is the lookup by address. Function bpf_probe_read()
is used. This function works only for architectures
with ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE.

On s390 is not possible to determine from the address to which
address space the address belongs to (user or kernel space).

Replace bpf_probe_read() by bpf_probe_read_kernel()
and bpf_probe_read_str() by bpf_probe_read_user_str() to
explicity specify the address space the address refers to.

Output before:
 # ./perf trace -eopen,openat -- touch /tmp/111
 libbpf: prog 'sys_enter': BPF program load failed: Invalid argument
 libbpf: prog 'sys_enter': -- BEGIN PROG LOAD LOG --
 reg type unsupported for arg#0 function sys_enter#75
 0: R1=ctx(off=0,imm=0) R10=fp0
 ; int sys_enter(struct syscall_enter_args *args)
 0: (bf) r6 = r1           ; R1=ctx(off=0,imm=0) R6_w=ctx(off=0,imm=0)
 ; return bpf_get_current_pid_tgid();
 1: (85) call bpf_get_current_pid_tgid#14      ; R0_w=scalar()
 2: (63) *(u32 *)(r10 -8) = r0 ; R0_w=scalar() R10=fp0 fp-8=????mmmm
 3: (bf) r2 = r10              ; R2_w=fp0 R10=fp0
 ;
 .....
 lines deleted here
 .....
 23: (bf) r3 = r6              ; R3_w=ctx(off=0,imm=0) R6=ctx(off=0,imm=0)
 24: (85) call bpf_probe_read#4
 unknown func bpf_probe_read#4
 processed 23 insns (limit 1000000) max_states_per_insn 0 \
	 total_states 2 peak_states 2 mark_read 2
 -- END PROG LOAD LOG --
 libbpf: prog 'sys_enter': failed to load: -22
 libbpf: failed to load object 'augmented_raw_syscalls_bpf'
 libbpf: failed to load BPF skeleton 'augmented_raw_syscalls_bpf': -22
 ....

Output after:
 # ./perf test -Fv 111
 111: Check open filename arg using perf trace + vfs_getname          :
 --- start ---
     1.085 ( 0.011 ms): touch/320753 openat(dfd: CWD, filename: \
	"/tmp/temporary_file.SWH85", \
	flags: CREAT|NOCTTY|NONBLOCK|WRONLY, mode: IRUGO|IWUGO) = 3
 ---- end ----
 Check open filename arg using perf trace + vfs_getname: Ok
 #

Test with the sleep command shows:
Output before:
 # ./perf trace -e *sleep sleep 1.234567890
     0.000 (1234.681 ms): sleep/63114 clock_nanosleep(rqtp: \
         { .tv_sec: 0, .tv_nsec: 0 }, rmtp: 0x3ffe0979720) = 0
 #

Output after:
 # ./perf trace -e *sleep sleep 1.234567890
     0.000 (1234.686 ms): sleep/64277 clock_nanosleep(rqtp: \
         { .tv_sec: 1, .tv_nsec: 234567890 }, rmtp: 0x3fff3df9ea0) = 0
 #

Fixes: 14e4b9f4289a ("perf trace: Raw augmented syscalls fix libbpf 1.0+ compatibility")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Co-developed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ian Rogers <irogers@google.com>
Cc: gor@linux.ibm.com
Cc: hca@linux.ibm.com
Cc: sumanthk@linux.ibm.com
Cc: svens@linux.ibm.com
Link: https://lore.kernel.org/r/20231019082642.3286650-1-tmricht@linux.ibm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../util/bpf_skel/augmented_raw_syscalls.bpf.c   | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/bpf_skel/augmented_raw_syscalls.bpf.c b/tools/perf/util/bpf_skel/augmented_raw_syscalls.bpf.c
index 939ec769bf4a5..52c270330ae0d 100644
--- a/tools/perf/util/bpf_skel/augmented_raw_syscalls.bpf.c
+++ b/tools/perf/util/bpf_skel/augmented_raw_syscalls.bpf.c
@@ -153,7 +153,7 @@ static inline
 unsigned int augmented_arg__read_str(struct augmented_arg *augmented_arg, const void *arg, unsigned int arg_len)
 {
 	unsigned int augmented_len = sizeof(*augmented_arg);
-	int string_len = bpf_probe_read_str(&augmented_arg->value, arg_len, arg);
+	int string_len = bpf_probe_read_user_str(&augmented_arg->value, arg_len, arg);
 
 	augmented_arg->size = augmented_arg->err = 0;
 	/*
@@ -203,7 +203,7 @@ int sys_enter_connect(struct syscall_enter_args *args)
 	_Static_assert(is_power_of_2(sizeof(augmented_args->saddr)), "sizeof(augmented_args->saddr) needs to be a power of two");
 	socklen &= sizeof(augmented_args->saddr) - 1;
 
-	bpf_probe_read(&augmented_args->saddr, socklen, sockaddr_arg);
+	bpf_probe_read_user(&augmented_args->saddr, socklen, sockaddr_arg);
 
 	return augmented__output(args, augmented_args, len + socklen);
 }
@@ -221,7 +221,7 @@ int sys_enter_sendto(struct syscall_enter_args *args)
 
 	socklen &= sizeof(augmented_args->saddr) - 1;
 
-	bpf_probe_read(&augmented_args->saddr, socklen, sockaddr_arg);
+	bpf_probe_read_user(&augmented_args->saddr, socklen, sockaddr_arg);
 
 	return augmented__output(args, augmented_args, len + socklen);
 }
@@ -311,7 +311,7 @@ int sys_enter_perf_event_open(struct syscall_enter_args *args)
         if (augmented_args == NULL)
 		goto failure;
 
-	if (bpf_probe_read(&augmented_args->__data, sizeof(*attr), attr) < 0)
+	if (bpf_probe_read_user(&augmented_args->__data, sizeof(*attr), attr) < 0)
 		goto failure;
 
 	attr_read = (const struct perf_event_attr_size *)augmented_args->__data;
@@ -325,7 +325,7 @@ int sys_enter_perf_event_open(struct syscall_enter_args *args)
                 goto failure;
 
 	// Now that we read attr->size and tested it against the size limits, read it completely
-	if (bpf_probe_read(&augmented_args->__data, size, attr) < 0)
+	if (bpf_probe_read_user(&augmented_args->__data, size, attr) < 0)
 		goto failure;
 
 	return augmented__output(args, augmented_args, len + size);
@@ -347,7 +347,7 @@ int sys_enter_clock_nanosleep(struct syscall_enter_args *args)
 	if (size > sizeof(augmented_args->__data))
                 goto failure;
 
-	bpf_probe_read(&augmented_args->__data, size, rqtp_arg);
+	bpf_probe_read_user(&augmented_args->__data, size, rqtp_arg);
 
 	return augmented__output(args, augmented_args, len + size);
 failure:
@@ -385,7 +385,7 @@ int sys_enter(struct syscall_enter_args *args)
 	if (augmented_args == NULL)
 		return 1;
 
-	bpf_probe_read(&augmented_args->args, sizeof(augmented_args->args), args);
+	bpf_probe_read_kernel(&augmented_args->args, sizeof(augmented_args->args), args);
 
 	/*
 	 * Jump to syscall specific augmenter, even if the default one,
@@ -406,7 +406,7 @@ int sys_exit(struct syscall_exit_args *args)
 	if (pid_filter__has(&pids_filtered, getpid()))
 		return 0;
 
-	bpf_probe_read(&exit_args, sizeof(exit_args), args);
+	bpf_probe_read_kernel(&exit_args, sizeof(exit_args), args);
 	/*
 	 * Jump to syscall specific return augmenter, even if the default one,
 	 * "!raw_syscalls:unaugmented" that will just return 1 to return the
-- 
2.42.0



