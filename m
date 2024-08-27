Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2491C8FBD;
	Tue, 27 Aug 2024 14:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770785; cv=none; b=TrUqYY2pKinwpU+b7XCQ5Jwa7/rSYFsOC57QO0VWUqLmlg6Cyl67uIj+x6rA1LvXU1QEt5PNR5AWxLP4UVfiS19cQN0ozQmE8f0xs8+9rySTkuLlP4JFOAPwM2UEv+z5SaNKXS+tyeRAnglYApUxkWhM04xu/ku8+DQViTBw4eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770785; c=relaxed/simple;
	bh=/OUrT9Wdn2UOUE8T2NWO+ZOwsAGyhy04axXk+pF1XZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+okdpdKpOwwLzpm5uvLHvKHZNa9N2aqRV0l06m7w5uH1Sms9lMkdHQzj1xf5seuD1xvDEmW3fkxUIhUOXYtsmWoPecrUU0HiBRh2NDytDawlaQv/hWoenlBj+J3nHWCyEXBJSBJmv8NVhnPzJSUTTP0yf2Iy12fI2KuDmuoL1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0uXkrDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0uXkrDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B008FC4AF5F;
	Tue, 27 Aug 2024 14:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770785;
	bh=/OUrT9Wdn2UOUE8T2NWO+ZOwsAGyhy04axXk+pF1XZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0uXkrDLQQ7jitwLi3rBHRmJCZtY9sxGF54CE/CMgMLTXy9YYGoPjAXXv95Hnp1fi
	 ayqIx1RvPu1YbViEJyrh+rG6SRFF4Dnga59Na7gK8Hcv23YY63rANr1X3w6ptUK6NJ
	 gGmf28589AGoz+ax0LbmbE7NgPJysRMKYC81dIMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 334/341] selftests/bpf: Add a test to verify previous stacksafe() fix
Date: Tue, 27 Aug 2024 16:39:25 +0200
Message-ID: <20240827143856.104495082@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

commit 662c3e2db00f92e50c26e9dc4fe47c52223d9982 upstream.

A selftest is added such that without the previous patch,
a crash can happen. With the previous patch, the test can
run successfully. The new test is written in a way which
mimics original crash case:
  main_prog
    static_prog_1
      static_prog_2
where static_prog_1 has different paths to static_prog_2
and some path has stack allocated and some other path
does not. A stacksafe() checking in static_prog_2()
triggered the crash.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20240812214852.214037-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/iters.c |   54 ++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

--- a/tools/testing/selftests/bpf/progs/iters.c
+++ b/tools/testing/selftests/bpf/progs/iters.c
@@ -1411,4 +1411,58 @@ __naked int checkpoint_states_deletion(v
 	);
 }
 
+__u32 upper, select_n, result;
+__u64 global;
+
+static __noinline bool nest_2(char *str)
+{
+	/* some insns (including branch insns) to ensure stacksafe() is triggered
+	 * in nest_2(). This way, stacksafe() can compare frame associated with nest_1().
+	 */
+	if (str[0] == 't')
+		return true;
+	if (str[1] == 'e')
+		return true;
+	if (str[2] == 's')
+		return true;
+	if (str[3] == 't')
+		return true;
+	return false;
+}
+
+static __noinline bool nest_1(int n)
+{
+	/* case 0: allocate stack, case 1: no allocate stack */
+	switch (n) {
+	case 0: {
+		char comm[16];
+
+		if (bpf_get_current_comm(comm, 16))
+			return false;
+		return nest_2(comm);
+	}
+	case 1:
+		return nest_2((char *)&global);
+	default:
+		return false;
+	}
+}
+
+SEC("raw_tp")
+__success
+int iter_subprog_check_stacksafe(const void *ctx)
+{
+	long i;
+
+	bpf_for(i, 0, upper) {
+		if (!nest_1(select_n)) {
+			result = 1;
+			return 0;
+		}
+	}
+
+	result = 2;
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";


