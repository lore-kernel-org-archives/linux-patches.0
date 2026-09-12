Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCE23F3283;
	Sat, 12 Sep 2026 07:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198108; cv=none; b=ukrfVXtNi0Ib4BEqAvghpIol1nCN5etlxoe39694I0vLAHhQFb5qsZbhzHiMl0Qn9AbHyk7rFhniwZuj8fHE+5z3ZxbF1PqGPPfqXyW6QxSc0j03kOLP546ruEe9FFasqruPtWvB1LB/m5BLoCWuD7iIh1VmgQRrFWEcHsB6HMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198108; c=relaxed/simple;
	bh=ijNx+hw+0l2um0gfTNMkMzVVyy3FGVVmBJbv/UghHoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsC8RByikhuWFX1sIKyjKUyWQSM/X3CyMklCW8kWFY7gTsqJhtzoN0CpSPVZYq05BFJEj4fNqUtKdVRr6hCZ++HbbYKnC0PqPZa7KObTEF2bXPOmsk3pm5tu5GCm0UZqbEN8+6wJOiIAiZH1szHgREQUewnnuQoY+xiNE4TPArI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Drga1qHv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Drga1qHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AEF1F000FF;
	Sat, 12 Sep 2026 07:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198105;
	bh=MNRXWjcMam3jEAc692fgI4frMVgBHCYWY1uHc8nMl5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Drga1qHvlmdKjQ9mVtJdhgy40id68qfX12IBqjq9FXmAePsj106jj7TsIZv13d3xI
	 YtRtxedVxdnGJg299SNBmIBQ4tIRz1rsuNBlWguvt6z6J48dswTm6JBspTIH7RkRgw
	 tSlO+D4C5w9xt496IrDQJaeMjMoncFPsZRlRF6PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <qmo@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0275/1815] bpftool: Check EVP_Digest when computing excl_prog_hash
Date: Sat, 12 Sep 2026 08:33:45 +0200
Message-ID: <20260912065655.423267172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 576bcaa1f5c208af0f590c9622247da87b49c05f ]

bpftool_prog_sign() ignores the return value of EVP_Digest(). If the
digest computation fails (context allocation failure, or a digest
fetch failure under OpenSSL), EVP_Digest() returns 0 and leaves the
output buffer untouched, but the function still reports success.

Fixes: 40863f4d6ef2 ("bpftool: Add support for signing BPF programs")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20260708075343.358712-5-daniel@iogearbox.net
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/sign.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/sign.c b/tools/bpf/bpftool/sign.c
index f9b742f4bb104..1257dba8ef2fd 100644
--- a/tools/bpf/bpftool/sign.c
+++ b/tools/bpf/bpftool/sign.c
@@ -175,8 +175,11 @@ int bpftool_prog_sign(struct bpf_load_and_run_opts *opts)
 		goto cleanup;
 	}
 
-	EVP_Digest(opts->insns, opts->insns_sz, opts->excl_prog_hash,
-		   &opts->excl_prog_hash_sz, EVP_sha256(), NULL);
+	if (EVP_Digest(opts->insns, opts->insns_sz, opts->excl_prog_hash,
+		       &opts->excl_prog_hash_sz, EVP_sha256(), NULL) != 1) {
+		err = -EIO;
+		goto cleanup;
+	}
 
 		bd_out = BIO_new(BIO_s_mem());
 	if (!bd_out) {
-- 
2.53.0



