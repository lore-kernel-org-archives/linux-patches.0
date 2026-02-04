Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAC1221F17;
	Wed,  4 Feb 2026 15:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218825; cv=none; b=p9JBK3Iy+380mIUrjP9cjODrSXRCFAswCIMIMyQUxDgVtvN9EMswi4p1M/JmQnRbJp5+P6R2K45PJ8vy+gVaGyqmbmzlf6xQC3wMS3X++KwNGWILQrAU2NEft1m8eYAwDdNXNqQMaW5lJiB3poqvocJOgl59H2iIBhiYmZJlm60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218825; c=relaxed/simple;
	bh=hBwyWkIibevi9ibnl4ebi5YXJvVV2xAU29aLSjEpc/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GT1Q+50QAGbrXywzOXdkfxh+86IxmsxT3UnQcRBsJmaSvfGTHCChlBKevJfdKo4yPZF+d4WS6qP7A14nBL8GytxmdWwwZHEyzd6CBCRZ/mJKpSEu6VNq7HmTJzljYQykMX9PkQyQbjUQwtMdpWvfQ5D0iY2lLjczpqwl4QEpZHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yqbc5xrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yqbc5xrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BE6C4CEF7;
	Wed,  4 Feb 2026 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218825;
	bh=hBwyWkIibevi9ibnl4ebi5YXJvVV2xAU29aLSjEpc/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yqbc5xrMZpgR1dVCOHTKWKyczzHPPwOaqWzDgS63HYUr56m1QjVQ35b4Wa6ytLpYD
	 VsEW7kTZJO38XjHyv3+rvX44ZlPvzh5Uivg1x9RuHVFs3qHjkwFtDa4/fjouhS5/+d
	 2gjaPlE4YLMZccq87lcwaaTn4ah5gwO1ux6GXP+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Weimer <fweimer@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 72/87] libbpf: Fix -Wdiscarded-qualifiers under C23
Date: Wed,  4 Feb 2026 15:41:10 +0100
Message-ID: <20260204143849.510379380@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

commit d70f79fef65810faf64dbae1f3a1b5623cdb2345 upstream.

glibc ≥ 2.42 (GCC 15) defaults to -std=gnu23, which promotes
-Wdiscarded-qualifiers to an error.

In C23, strstr() and strchr() return "const char *".

Change variable types to const char * where the pointers are never
modified (res, sym_sfx, next_path).

Suggested-by: Florian Weimer <fweimer@redhat.com>
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Link: https://lore.kernel.org/r/20251206092825.1471385-1-mikhail.v.gavrilov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ shung-hsi.yu: needed to fix kernel build failure due to libbpf since glibc
  2.43+ (which adds 'const' qualifier to strstr). 'sym_sfx' hunk dropped because
  commit f8a05692de06 ("libbpf: Work around kernel inconsistently stripping
  '.llvm.' suffix") is not present. ]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/libbpf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8174,7 +8174,7 @@ static int kallsyms_cb(unsigned long lon
 	struct bpf_object *obj = ctx;
 	const struct btf_type *t;
 	struct extern_desc *ext;
-	char *res;
+	const char *res;
 
 	res = strstr(sym_name, ".llvm.");
 	if (sym_type == 'd' && res)
@@ -11959,7 +11959,7 @@ static int resolve_full_path(const char
 		if (!search_paths[i])
 			continue;
 		for (s = search_paths[i]; s != NULL; s = strchr(s, ':')) {
-			char *next_path;
+			const char *next_path;
 			int seg_len;
 
 			if (s[0] == ':')


