Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692ED183CD4;
	Mon, 12 Aug 2024 16:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479388; cv=none; b=bS6PPCJS9unyiINQYxL8RxbyQ+tXXP7u+GTPvJ7DbEYhKiIPs+z+5GkI9AH12HhItsv6UBsLPG4u+WOvYDZ2OpAED5e/SAYXQsBg2y0+nbkkneFtjED0fFwXJqem7qjrU65AYIgayEsf02ei4IfHB+CMR7L4hvh7Fw6KBfNDdu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479388; c=relaxed/simple;
	bh=9bNrIrofmegg2SAVEMSjIpRjWUEHOHp9i/wb5n+rqvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqEnK5gs4YJzDSY2bFPbUqrwrI8xrgufdVDxylZ7P/7v3DgHJYM6xUrbB+1GiE4Z6iJtLVKFQ7L4Uq18WVHsdvY9ep2DtKXpJZby4B1gig7Y3r7JQg2tgu4z0BF9QLLIS/60yZq+StQxKPAphkLCQaZIVTtJiX9g8O7V8JNKC14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUmqEpOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUmqEpOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51BAC32782;
	Mon, 12 Aug 2024 16:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479388;
	bh=9bNrIrofmegg2SAVEMSjIpRjWUEHOHp9i/wb5n+rqvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUmqEpOhi0M1REPw/rcLFAFhqcOjV7g1yGszioE/mLXxZFBmZRJ9SkZVSXOxs7zOJ
	 FmUziGm9UAMyCtwUVrqRmhZyA/H0kUefaFIi+cpTMOvCHKP/nfsuzQPEBM+4Ad9dPc
	 GlNRoyaELCXC/f7EXrufNEL8Cz30umYP3MVFphGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Zucheng <zhengzucheng@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 072/189] sched/cputime: Fix mul_u64_u64_div_u64() precision for cputime
Date: Mon, 12 Aug 2024 18:02:08 +0200
Message-ID: <20240812160134.915367086@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Zheng Zucheng <zhengzucheng@huawei.com>

commit 77baa5bafcbe1b2a15ef9c37232c21279c95481c upstream.

In extreme test scenarios:
the 14th field utime in /proc/xx/stat is greater than sum_exec_runtime,
utime = 18446744073709518790 ns, rtime = 135989749728000 ns

In cputime_adjust() process, stime is greater than rtime due to
mul_u64_u64_div_u64() precision problem.
before call mul_u64_u64_div_u64(),
stime = 175136586720000, rtime = 135989749728000, utime = 1416780000.
after call mul_u64_u64_div_u64(),
stime = 135989949653530

unsigned reversion occurs because rtime is less than stime.
utime = rtime - stime = 135989749728000 - 135989949653530
		      = -199925530
		      = (u64)18446744073709518790

Trigger condition:
  1). User task run in kernel mode most of time
  2). ARM64 architecture
  3). TICK_CPU_ACCOUNTING=y
      CONFIG_VIRT_CPU_ACCOUNTING_NATIVE is not set

Fix mul_u64_u64_div_u64() conversion precision by reset stime to rtime

Fixes: 3dc167ba5729 ("sched/cputime: Improve cputime_adjust()")
Signed-off-by: Zheng Zucheng <zhengzucheng@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20240726023235.217771-1-zhengzucheng@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cputime.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -595,6 +595,12 @@ void cputime_adjust(struct task_cputime
 	}
 
 	stime = mul_u64_u64_div_u64(stime, rtime, stime + utime);
+	/*
+	 * Because mul_u64_u64_div_u64() can approximate on some
+	 * achitectures; enforce the constraint that: a*b/(b+c) <= a.
+	 */
+	if (unlikely(stime > rtime))
+		stime = rtime;
 
 update:
 	/*


