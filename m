Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B329A13B2B4;
	Tue, 27 Feb 2024 14:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043884; cv=none; b=RWh64f1gS12SVvXZU4QvZHuBbuvLGy6hMFmVCBAaCp/I6L1uxuAkmwpDEfYnitm0ikxSb1DQpsYvvo82/UARJSa0IfU08g8BplP23pIgrZ6sxcug6/KX1Qw/5TVbyfssaJFAmpGXmuf03pWTiD0mfNuZYqCaLlB7XfcqNtCIgQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043884; c=relaxed/simple;
	bh=J8UoQyh6MyWS26gmqvfixyLcyjVA8zmnom8OMSmC4HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tY7GNfrqTG28LkJsKhFFhjyQ7Jb3KpJEuxAw3T7zs7iwZCm6QNysylCV/aeR80BBibq9G8hqmL2sccx3SoAxCYT4534k4367Th3apY89zswBF2LYGRmEC921KexRrT9U/VOf2OFAPVrAPEoZMaVC5mZL0mXUsBZKFzjDak6gYA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDSnlcsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDSnlcsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCC8C43394;
	Tue, 27 Feb 2024 14:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043884;
	bh=J8UoQyh6MyWS26gmqvfixyLcyjVA8zmnom8OMSmC4HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDSnlcsgY2xwsmebWZm8HJm2leUlSROmTOeFZLEGxWse2ro/2UPi2oKTfwmaILDTq
	 F5xJkjka32RuOkW7NwNMsC82xt6/X4jDAvD0WoNeCHu2XISMU9kZeJdumUtjndzh3M
	 IApME596HQfpIRZHG/sHcRc3+qtENUhsWQx3qOs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Luke Nelson <luke.r.nels@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/84] selftests/bpf: Avoid running unprivileged tests with alignment requirements
Date: Tue, 27 Feb 2024 14:27:09 +0100
Message-ID: <20240227131554.242956588@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn.topel@gmail.com>

[ Upstream commit c77b0589ca29ad1859fe7d7c1ecd63c0632379fa ]

Some architectures have strict alignment requirements. In that case,
the BPF verifier detects if a program has unaligned accesses and
rejects them. A user can pass BPF_F_ANY_ALIGNMENT to a program to
override this check. That, however, will only work when a privileged
user loads a program. An unprivileged user loading a program with this
flag will be rejected prior entering the verifier.

Hence, it does not make sense to load unprivileged programs without
strict alignment when testing the verifier. This patch avoids exactly
that.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Luke Nelson <luke.r.nels@gmail.com>
Link: https://lore.kernel.org/bpf/20201118071640.83773-3-bjorn.topel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_verifier.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 43224c5ec1e9b..1bd285dc55e94 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -1091,6 +1091,19 @@ static void get_unpriv_disabled()
 
 static bool test_as_unpriv(struct bpf_test *test)
 {
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	/* Some architectures have strict alignment requirements. In
+	 * that case, the BPF verifier detects if a program has
+	 * unaligned accesses and rejects them. A user can pass
+	 * BPF_F_ANY_ALIGNMENT to a program to override this
+	 * check. That, however, will only work when a privileged user
+	 * loads a program. An unprivileged user loading a program
+	 * with this flag will be rejected prior entering the
+	 * verifier.
+	 */
+	if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
+		return false;
+#endif
 	return !test->prog_type ||
 	       test->prog_type == BPF_PROG_TYPE_SOCKET_FILTER ||
 	       test->prog_type == BPF_PROG_TYPE_CGROUP_SKB;
-- 
2.43.0



