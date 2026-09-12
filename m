Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FF44BEE38;
	Sat, 12 Sep 2026 16:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229881; cv=none; b=fl+IC5lz7MHDXrAP7DoZvO8ys5mEmw0Xv+01cbsgB9d4Oilm24niK+0r6E/eGJw6d6uxYsD73pTPSIH+8PnH4LIpv7pSIEYmW2M3ca0zpWUi6y9GFz2Uji/9E2HzJ7VdiIw4FqIPkBdY8DD/wQJMGF1Rp5pDF7CxSMT6dkXSYCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229881; c=relaxed/simple;
	bh=wTNJMCoXE0NgsFB8JSWKbjgt6+aLzhrjb0IKAUhMSlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQSRJ/gLmxc22j0i2/9gsvvQC3UOha/AGVO7UUCDYSSGoxsh0RETNtEnzeK0tGBItZZ20cxj7RjtyrlyPR4Eus84PFwysy3QAnBa6YsNdeKtTgIIfD3OAZ5FQBEf8xlY+FsGRlYit1AJGgZlmsP/FNZ/I4YydXKdUL2ShXTIx6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5kBaVsF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5kBaVsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51BB1F000FF;
	Sat, 12 Sep 2026 16:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229880;
	bh=1Z5oQQfKsT8PgWmakweu33MuZfYv+ZfJnojP54x27N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5kBaVsFRvlaP9S/F8oRU9jb6RkDdIRb2LpRpRxJj+joRs0ipLuqjWK4z9Pwpni0r
	 jN2JgOjShyTeZmnle2DPdip11+D32tMCCDC45M0ozFT6k5Kkz4wVrqNm4kIzxt0lkf
	 OlNOUJVRkrhygKtvUQIjigadNie09suFrzwzgpfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0679/1191] libbpf: Search /lib64 and /lib in resolve_full_path()
Date: Sat, 12 Sep 2026 08:56:47 +0200
Message-ID: <20260912065603.508555753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 7b5ae0481efdac040cea72b4fabd1398109f975b ]

attach_probe/uprobe-lib and uprobe_autoattach selftests fail with "failed
to resolve full path for libc.so.6" on older non-usrmerged distros, where
libc.so.6 lives under a top-level /lib64 or /lib rather than /usr/lib64 or
/usr/lib. Add /lib64:/lib to the search paths, alongside the existing
/usr/lib64:/usr/lib and Debian multiarch entries.

Fixes: 1ce3a60e3c28 ("libbpf: auto-resolve programs/libraries when necessary for uprobes")
Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/bpf/20260720-selftests-bpf_fixes-v2-3-b450eda93dfe@suse.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c3de45c739e94..a4ce4258711bc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10735,13 +10735,14 @@ static const char *arch_specific_lib_paths(void)
 /* Get full path to program/shared library. */
 static int resolve_full_path(const char *file, char *result, size_t result_sz)
 {
-	const char *search_paths[3] = {};
+	const char *search_paths[4] = {};
 	int i, perm;
 
 	if (str_has_sfx(file, ".so") || strstr(file, ".so.")) {
 		search_paths[0] = getenv("LD_LIBRARY_PATH");
 		search_paths[1] = "/usr/lib64:/usr/lib";
 		search_paths[2] = arch_specific_lib_paths();
+		search_paths[3] = "/lib64:/lib";
 		perm = R_OK;
 	} else {
 		search_paths[0] = getenv("PATH");
-- 
2.53.0



