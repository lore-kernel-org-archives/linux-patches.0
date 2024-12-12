Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA857223C59;
	Thu, 12 Dec 2024 16:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022163; cv=none; b=CvrbK22O40dQHf1UesGIo0a6wXWxeS5ZOHHemTAk525PXtB12NacXG5mIuKrRwUOCv0JJnl9aRSm/klNyepTYtCC2PFeVcMdRy6x9M7sPOEYqg28s4et1akABl/x2G1P31KVNV3TuH8iDFJGCE9cf1EDUsoySUlU1NySOI4S7WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022163; c=relaxed/simple;
	bh=h5IUFbt7LgXX1xIjewV4zoia7WkB29L9Wv9qHL/ONVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiWyD28z/rog6+l5HoJh6zyLbhbMquSJi4I4qAr4qu70jy6CMJ2jnJP0ThDQr5epeURsa8yOAnfWF4dhXXlcujl0g2mUSMlGX7EMFIp7hMu+gWLDL99bZtg+ZY28N+YgWQrcOtztZF4bCuPw8RwdbbNFplOHmdTg7t1xx3cRv1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkEG1DdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkEG1DdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8D2C4CECE;
	Thu, 12 Dec 2024 16:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022163;
	bh=h5IUFbt7LgXX1xIjewV4zoia7WkB29L9Wv9qHL/ONVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkEG1DdHcmhpBSccj588gykrv/fKD51an8sfJoo54SVxkfyOdI+5DCZpfXO6JloRT
	 zDsnNdcTKTSC7VkrwURpUHrMScY8NxXAJNZdR4E62FAClzU66rN64twzxieUoFhlnT
	 j5gWgTCFGL5LSfdZQGTS5TN0A7A9KfD9ZOCd9ve0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/565] libbpf: fix sym_is_subprog() logic for weak global subprogs
Date: Thu, 12 Dec 2024 15:56:01 +0100
Message-ID: <20241212144318.040192753@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 4073213488be542f563eb4b2457ab4cbcfc2b738 ]

sym_is_subprog() is incorrectly rejecting relocations against *weak*
global subprogs. Fix that by realizing that STB_WEAK is also a global
function.

While it seems like verifier doesn't support taking an address of
non-static subprog right now, it's still best to fix support for it on
libbpf side, otherwise users will get a very confusing error during BPF
skeleton generation or static linking due to misinterpreted relocation:

  libbpf: prog 'handle_tp': bad map relo against 'foo' in section '.text'
  Error: failed to open BPF object file: Relocation failed

It's clearly not a map relocation, but is treated and reported as such
without this fix.

Fixes: 53eddb5e04ac ("libbpf: Support subprog address relocation")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20241009011554.880168-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d201a7356fad6..294fdba9c76f7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3129,7 +3129,7 @@ static bool sym_is_subprog(const GElf_Sym *sym, int text_shndx)
 		return true;
 
 	/* global function */
-	return bind == STB_GLOBAL && type == STT_FUNC;
+	return (bind == STB_GLOBAL || bind == STB_WEAK) && type == STT_FUNC;
 }
 
 static int find_extern_btf_id(const struct btf *btf, const char *ext_name)
-- 
2.43.0



