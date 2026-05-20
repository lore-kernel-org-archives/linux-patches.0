Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA6E343880;
	Wed, 20 May 2026 18:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301859; cv=none; b=Hna4/zFoiOLl7w4yEXAdpRW7T/8mf8VUWCPFRDZTr8wnDZF5pAPJzhScld/ZSWyRzn8zIy35zW7+xf6gJnshezGAeUicg6E8u4l138UxxkSwNxcRkpLKiRVbTg9qjRqgrYk8G8jRzeVjWZZ0vwrsuf7TKnfCpIuolOgoK7eWahE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301859; c=relaxed/simple;
	bh=yEmYS3weftUjkMRpzSplNbfJFZSfL15WyUAboaL/71E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLp+ezOEpf6PBq2PlXH4OOTbHhne85yJlLF4G2tPM+MGkcbI+0ORr8jmJfmN7isFoYIO/5++4tdtIQFAwijlxAJ5CqvbNMx6saOcdGrnzJUZcUBqgDqxtlc2TTKYuMxd7N6EPGrTqyauP3eMLNM9T9Jp0mojaFa7v+8b9Ec4lRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJsMLdyt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJsMLdyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6251F000E9;
	Wed, 20 May 2026 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301858;
	bh=jmBMr1au7sQViUF1SZ+YMxqxU4fBX5Ae34m9ptg3JCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJsMLdytme6Os+eHiiJEsSuoJYMjM5k+b8HMXCwDDv3Tip8JO5emY94m3GchJ/qKj
	 UgCU4K4U7HLpXE1OecwIfaN40zHHQJLoSaVc/Qfo+6EaS5jmkkFX6/ZBrdZlb7vwuw
	 CmppYcsw16RfMFXSWsY8o8MuNmqq0EpKu36PVBVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MingTao Huang <mintaohuang@tencent.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/508] bpf: Fix stale offload->prog pointer after constant blinding
Date: Wed, 20 May 2026 18:17:51 +0200
Message-ID: <20260520162059.636386153@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MingTao Huang <mintaohuang@tencent.com>

[ Upstream commit a1aa9ef47c299c5bbc30594d3c2f0589edf908e6 ]

When a dev-bound-only BPF program (BPF_F_XDP_DEV_BOUND_ONLY) undergoes
JIT compilation with constant blinding enabled (bpf_jit_harden >= 2),
bpf_jit_blind_constants() clones the program. The original prog is then
freed in bpf_jit_prog_release_other(), which updates aux->prog to point
to the surviving clone, but fails to update offload->prog.

This leaves offload->prog pointing to the freed original program. When
the network namespace is subsequently destroyed, cleanup_net() triggers
bpf_dev_bound_netdev_unregister(), which iterates ondev->progs and calls
__bpf_prog_offload_destroy(offload->prog). Accessing the freed prog
causes a page fault:

BUG: unable to handle page fault for address: ffffc900085f1038
Workqueue: netns cleanup_net
RIP: 0010:__bpf_prog_offload_destroy+0xc/0x80
Call Trace:
__bpf_offload_dev_netdev_unregister+0x257/0x350
bpf_dev_bound_netdev_unregister+0x4a/0x90
unregister_netdevice_many_notify+0x2a2/0x660
...
cleanup_net+0x21a/0x320

The test sequence that triggers this reliably is:

1. Set net.core.bpf_jit_harden=2 (echo 2 > /proc/sys/net/core/bpf_jit_harden)
2. Run xdp_metadata selftest, which creates a dev-bound-only XDP
   program on a veth inside a netns (./test_progs -t xdp_metadata)
3. cleanup_net -> page fault in __bpf_prog_offload_destroy

Dev-bound-only programs are unique in that they have an offload structure
but go through the normal JIT path instead of bpf_prog_offload_compile().
This means they are subject to constant blinding's prog clone-and-replace,
while also having offload->prog that must stay in sync.

Fix this by updating offload->prog in bpf_jit_prog_release_other(),
alongside the existing aux->prog update. Both are back-pointers to
the prog that must be kept in sync when the prog is replaced.

Fixes: 2b3486bc2d23 ("bpf: Introduce device-bound XDP programs")
Signed-off-by: MingTao Huang <mintaohuang@tencent.com>
Link: https://lore.kernel.org/r/tencent_BCF692F45859CCE6C22B7B0B64827947D406@qq.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 3011add7c4a88..d708cf3e6207f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1422,6 +1422,8 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other)
 	 * know whether fp here is the clone or the original.
 	 */
 	fp->aux->prog = fp;
+	if (fp->aux->offload)
+		fp->aux->offload->prog = fp;
 	bpf_prog_clone_free(fp_other);
 }
 
-- 
2.53.0



