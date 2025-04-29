Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04112475CF;
	Tue, 29 Apr 2025 17:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948338; cv=none; b=qlmxfGv1rqq9Z5OorKu4y48ua0m6c5aXdCLWgUYObQkeOce43U29zvsMgjQG9F4y1b6Vj8GkzEoRpwloHQsB4hpu0U0jysWFJ+sq42/blHyojRsmXtPHntntwz2HBKZwrkhAMJXXFy5dTcxa00egsFZIhJ6QUIjej5xJZKAeoSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948338; c=relaxed/simple;
	bh=FHsAe950Tn90rIsJL5xYymjjIH9lvzg5RkCl1/dOoX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qVLlmMKSZ/LPK54TiYUBSWP0rKk2frznXJEf6Ob3uQ2ROcGDPMrLLGQjkILaokVP8Ogk7UUFVx6hpQBTjv/GO45LiVS0OHKf8PTpbTGMSdy2T5i9odQM5xaiou5Ejy8bmRJOXVxNmy60iJJxFLUQhnhMPkggl9S0u/g3cKoP7BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRhs/0L1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRhs/0L1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82717C4CEE3;
	Tue, 29 Apr 2025 17:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948337;
	bh=FHsAe950Tn90rIsJL5xYymjjIH9lvzg5RkCl1/dOoX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRhs/0L1Fc8wQqBiX54m33dQ7yvMGFLT23qbc9pih9ZztG4nPmW/V8v9CkGALLBML
	 Q7SqS87i1Bk+uBG3/qu/Qma12/OK+j/0hovhZq6I9YXG+T7cYAB9dDg/hhekx+2EK4
	 WemFCqkMdPKNtsiBbJzzgu7WzT9S11JlYIO1qboY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 257/280] selftests/bpf: check program redirect in xdp_cpumap_attach
Date: Tue, 29 Apr 2025 18:43:18 +0200
Message-ID: <20250429161125.649306984@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>

commit d124d984c8a2d677e1cea6740a01ccdd0371a38d upstream.

xdp_cpumap_attach, in its current form, only checks that an xdp cpumap
program can be executed, but not that it performs correctly the cpu
redirect as configured by userspace (bpf_prog_test_run_opts will return
success even if the redirect program returns an error)

Add a check to ensure that the program performs the configured redirect
as well. The check is based on a global variable incremented by a
chained program executed only if the redirect program properly executes.

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Link: https://lore.kernel.org/r/20241009-convert_xdp_tests-v3-3-51cea913710c@bootlin.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c       |    5 ++++-
 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c |    5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
@@ -62,8 +62,11 @@ static void test_xdp_with_cpumap_helpers
 	err = bpf_prog_test_run_opts(prog_redir_fd, &opts);
 	ASSERT_OK(err, "XDP test run");
 
-	/* wait for the packets to be flushed */
+	/* wait for the packets to be flushed, then check that redirect has been
+	 * performed
+	 */
 	kern_sync_rcu();
+	ASSERT_NEQ(skel->bss->redirect_count, 0, "redirected packets");
 
 	err = bpf_xdp_detach(IFINDEX_LO, XDP_FLAGS_SKB_MODE, NULL);
 	ASSERT_OK(err, "XDP program detach");
--- a/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
@@ -12,6 +12,8 @@ struct {
 	__uint(max_entries, 4);
 } cpu_map SEC(".maps");
 
+__u32 redirect_count = 0;
+
 SEC("xdp")
 int xdp_redir_prog(struct xdp_md *ctx)
 {
@@ -27,6 +29,9 @@ int xdp_dummy_prog(struct xdp_md *ctx)
 SEC("xdp/cpumap")
 int xdp_dummy_cm(struct xdp_md *ctx)
 {
+	if (bpf_get_smp_processor_id() == 0)
+		redirect_count++;
+
 	if (ctx->ingress_ifindex == IFINDEX_LO)
 		return XDP_DROP;
 


