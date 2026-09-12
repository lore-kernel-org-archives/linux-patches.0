Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087AA36A36A;
	Sat, 12 Sep 2026 09:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206766; cv=none; b=fY791maFUNMga3psDCmrQeHyviCdROm3n5Hjy5vMEDgPi6kYLmAtuHiqEMPDVUSKYrfYfJPmbAa3IJXw/6SP6A173HmCC4xjuTQ8CxIZmlg/YhixwNNztgYKcT7ob4/5eGEl+VF9qZpiyKskpyZGsh+hbG/cpcsRQIuvkEnFdZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206766; c=relaxed/simple;
	bh=Dc210JKVkALYRaOTE/C7DjHR+yvvjhr+Oa3FyH9baJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntd1GjPy16IKFyv4lvr2ZHXOFdatNTTyAiqxqOUevDybGb4tq6V8LHOA/R/5x0yva7pbW2bgLZ8NSXqhxj1FAzXk2Altmh97G4WFYz6thP1kItjFjxp5p88gQK7GqZOi34tdbBDQIXwd2A376hD80YxT/wL6nHJ9N8xJDfKhP2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOK/LQgP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOK/LQgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB2B1F000FF;
	Sat, 12 Sep 2026 09:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206764;
	bh=9hzeT6lw//vpQV6DYtDD7VF1CJeFc2HbGS3p/nmdDqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOK/LQgPtFpliUZt/gx4jos/4Q+FTkVnpAQ8ZAbyisxV9wVE2k8ugIcb/nyGkjwpr
	 2fUrQqajVwpUHIpt9lqnlL+VP87rYgviJGSmQv/YimUbdtsdGU+UHS6EVbn2d/2leD
	 DWykTJcAWkQDLukPzJ5CSj7U1BUh728zqTkhnPiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <qmo@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0272/1518] bpftool: Check EVP_Digest when computing excl_prog_hash
Date: Sat, 12 Sep 2026 08:40:41 +0200
Message-ID: <20260912065629.639698428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



