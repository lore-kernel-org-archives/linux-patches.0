Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C88423A89;
	Tue, 31 Mar 2026 16:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974690; cv=none; b=su3sdCFRi7CQjA++6Clqe0JyI/D6YEnH8WmSfcgjWvb9iMqkXMHrvi2ZlYoMAmayqZQbn8n3fsX0Lqlq7CPaRLFJbUocupTyS6rwHHtmvEvHJS/6EpoWsbwGiFscJOl0aAl3LD0+k5qp3tJbdUKWy0oE4440Xi4/Hc4MjSKMYMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974690; c=relaxed/simple;
	bh=A2He0M+FDvs+Cg3ddeZQJ1XSQW9GHzSoH3NpEwsORc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G4GxrHxVw0HbQ6ELEzL6DxR9ptEnPbdbpnRKgPWdudkNlN2TdcqH+rvGaT/j7+LYsGWPXT17rQoZ0Z1+AG75S+MkLJwjIrw+1pjCtpHwBvjQve7FUmwyMlRqG1mO5Wl0VdUzC936i4/BgNFRSDempTZrwyVtB2CQOp5oA1Vo9l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCjXgpu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCjXgpu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28396C19423;
	Tue, 31 Mar 2026 16:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974690;
	bh=A2He0M+FDvs+Cg3ddeZQJ1XSQW9GHzSoH3NpEwsORc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCjXgpu5j8A1Y55QIfBBVEwzpv124PFJfgOSRun6xDXJgENOfVhOpXOu8BsB/oUGz
	 gBDGFXAy1CuVWZZViJltRoNwqCbZOji9Tlg+uSb47xugG0p4k/0gyqs9+/Ft5DKP2n
	 zzkzRjyAs98mpDZqows5akhFcidKUDt1oxGt6x2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Weimer <fweimer@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Jonas Rebmann <kernel@schlaraffenlan.de>
Subject: [PATCH 6.6 153/175] libbpf: Fix -Wdiscarded-qualifiers under C23
Date: Tue, 31 Mar 2026 18:22:17 +0200
Message-ID: <20260331161735.414448614@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

commit d70f79fef65810faf64dbae1f3a1b5623cdb2345 upstream.

glibc ≥ 2.42 (GCC 15) defaults to -std=gnu23, which promotes
-Wdiscarded-qualifiers to an error.

In C23, strstr() and strchr() return "const char *".

Change variable types to const char * where the pointers are never
modified (res, sym_sfx, next_path).

[ shung-hsi.yu: needed to fix kernel build failure due to libbpf since glibc
  2.43+ (which adds 'const' qualifier to strstr) ]
[ Jonas Rebmann: down to one declaration on 6.6 to resolve build error
  with glibc 2.43 ]

Suggested-by: Florian Weimer <fweimer@redhat.com>
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Link: https://lore.kernel.org/r/20251206092825.1471385-1-mikhail.v.gavrilov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jonas Rebmann <kernel@schlaraffenlan.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/libbpf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11247,7 +11247,7 @@ static int resolve_full_path(const char
 		if (!search_paths[i])
 			continue;
 		for (s = search_paths[i]; s != NULL; s = strchr(s, ':')) {
-			char *next_path;
+			const char *next_path;
 			int seg_len;
 
 			if (s[0] == ':')


