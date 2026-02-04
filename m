Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC21F3DA7D1;
	Wed,  4 Feb 2026 15:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219270; cv=none; b=NPW6/NCT5JBUcWsT9ZSyb8j7FjkXgJXOG/9pia6Nvp3FWahPQkqSEXOW4mqwiRZDLmAhwb0vaDOmoCROQdRHqdCgDWoE1gCqSvdsirU9ajbMYfUPQ5rj6c2sWjijdUezL1I3zcmhiR095YsprgiU/pLL/gjUa6/7sQu66OsxVdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219270; c=relaxed/simple;
	bh=CyxKtpOyuPtgD7PZBDhv9ea3+1VKDtjTal/PAKFJdV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=suROC/BZv1LL5yxrgFUWCZc7JAokCuLqaQXd7FEkpf564J9Xkochl4pPIm4vDVvWXvoNw8hUP3SP0V8AKb3lOL891+0VTCGHluGHz8Vu1atacHaQf6EeqQciZtSmEg7Tmpaj87NlYpSIxHTB0AFtW6M7uJKgCLazimWg1+ucfrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxtEG0uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxtEG0uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7654CC4CEF7;
	Wed,  4 Feb 2026 15:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219269;
	bh=CyxKtpOyuPtgD7PZBDhv9ea3+1VKDtjTal/PAKFJdV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IxtEG0uvfZhSDTlMXdh9P4/rl0Mp4Z4TZW7RB4uLYXHJSP2RtuF0nsOx5SNiuSQWF
	 p0sWCne7ugAN6Y3CObBYZUsLuwRIhWd5tPuw8gyKMWFWcwKrlakEFscN6TPCoaEuxr
	 chvXFguQ3A6Vcu6wTrpDf/bYDjTVsCgo9PCNiGsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Weimer <fweimer@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.18 117/122] libbpf: Fix -Wdiscarded-qualifiers under C23
Date: Wed,  4 Feb 2026 15:41:39 +0100
Message-ID: <20260204143856.060882371@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
  2.43+ (which adds 'const' qualifier to strstr) ]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/libbpf.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8245,7 +8245,7 @@ static int kallsyms_cb(unsigned long lon
 	struct bpf_object *obj = ctx;
 	const struct btf_type *t;
 	struct extern_desc *ext;
-	char *res;
+	const char *res;
 
 	res = strstr(sym_name, ".llvm.");
 	if (sym_type == 'd' && res)
@@ -11574,7 +11574,8 @@ static int avail_kallsyms_cb(unsigned lo
 		 *
 		 *   [0] fb6a421fb615 ("kallsyms: Match symbols exactly with CONFIG_LTO_CLANG")
 		 */
-		char sym_trim[256], *psym_trim = sym_trim, *sym_sfx;
+		char sym_trim[256], *psym_trim = sym_trim;
+		const char *sym_sfx;
 
 		if (!(sym_sfx = strstr(sym_name, ".llvm.")))
 			return 0;
@@ -12159,7 +12160,7 @@ static int resolve_full_path(const char
 		if (!search_paths[i])
 			continue;
 		for (s = search_paths[i]; s != NULL; s = strchr(s, ':')) {
-			char *next_path;
+			const char *next_path;
 			int seg_len;
 
 			if (s[0] == ':')


