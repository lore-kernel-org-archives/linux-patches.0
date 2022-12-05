Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C75A15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943FDC433C1;
	Mon,  5 Dec 2022 19:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268611;
	bh=Kh01NS1R61ihkdJ/apa4Yuj6Q6emMMif66drvmpnWH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tisTEYXsvZZBZJOhJi3fvX2FBeANvIxK+i6ad6Dq7JD8kQjfJWuQxckyaRyDAxdEg
	 aMx/3i1lr3vOiSsRkojLJJqOKJAzz/4y7DPmNzwcePvItJBB69gBIvGDlCtwSU2HRU
	 EQw6enAcO1/Zfyzj92b+p+iTgA5SJE0uTyoM5E98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/92] bpf, perf: Use subprog name when reporting subprog ksymbol
Date: Mon,  5 Dec 2022 20:09:26 +0100
Message-Id: <20221205190803.936802443@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 47df8a2f78bc34ff170d147d05b121f84e252b85 ]

Since commit bfea9a8574f3 ("bpf: Add name to struct bpf_ksym"), when
reporting subprog ksymbol to perf, prog name instead of subprog name is
used. The backtrace of bpf program with subprogs will be incorrect as
shown below:

  ffffffffc02deace bpf_prog_e44a3057dcb151f8_overwrite+0x66
  ffffffffc02de9f7 bpf_prog_e44a3057dcb151f8_overwrite+0x9f
  ffffffffa71d8d4e trace_call_bpf+0xce
  ffffffffa71c2938 perf_call_bpf_enter.isra.0+0x48

overwrite is the entry program and it invokes the overwrite_htab subprog
through bpf_loop, but in above backtrace, overwrite program just jumps
inside itself.

Fixing it by using subprog name when reporting subprog ksymbol. After
the fix, the output of perf script will be correct as shown below:

  ffffffffc031aad2 bpf_prog_37c0bec7d7c764a4_overwrite_htab+0x66
  ffffffffc031a9e7 bpf_prog_c7eb827ef4f23e71_overwrite+0x9f
  ffffffffa3dd8d4e trace_call_bpf+0xce
  ffffffffa3dc2938 perf_call_bpf_enter.isra.0+0x48

Fixes: bfea9a8574f3 ("bpf: Add name to struct bpf_ksym")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20221114095733.158588-1-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0e01216f4e5a..e9b354d521a3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8740,7 +8740,7 @@ static void perf_event_bpf_emit_ksymbols(struct bpf_prog *prog,
 				PERF_RECORD_KSYMBOL_TYPE_BPF,
 				(u64)(unsigned long)subprog->bpf_func,
 				subprog->jited_len, unregister,
-				prog->aux->ksym.name);
+				subprog->aux->ksym.name);
 		}
 	}
 }
-- 
2.35.1



