Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33502E403;
	Tue, 11 Nov 2025 01:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822903; cv=none; b=f4I9hBwJyYr+7EB6x8J06b/UNvHAwQnnT57EtghqFSlRAWw0L1oDa8gpWzfYEiZPOHb8IxMSQ/wQzjr7+h0+M4KYHFcKLffg1iIsDSg/Hot+ydanmlrbViH2Bb+1YsI3rWIYQ3rhU+4imLTrZnBZxufzyU8YVKO+Aw2AMMldeIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822903; c=relaxed/simple;
	bh=Znj7EszgYmZTE58lJHhQXoQCkfxRw3LYIjGZGnkCPdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccpLWgFdLhWkzb126ZMj0w+FhN4cuzSvpqba4HXuKYe+cP0olO6YqTD2RD/+2n0PuteIRy+ZCVvw+GPEUb4E01xVCC5ourUlyyWOcm2VjSRrkkZC2XxQ+aiqbW1WEAA0ZQdxo9wTGj38Idhixy2ukzqQw7IVvJ5XlVR9zQKapr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdI8rn8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdI8rn8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425B0C116B1;
	Tue, 11 Nov 2025 01:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822903;
	bh=Znj7EszgYmZTE58lJHhQXoQCkfxRw3LYIjGZGnkCPdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdI8rn8fEe1Dt7WE5lnkxqvtRqM/aF1IjxALbGJq3wx6SHIO1eLQ8zE0VAX9YHDfl
	 LG2IvUBJ2uue//9Pir3DFZDYJV2je8WCZWQ8XDXwhvcHyLMx00zRmF0XUs2me2yLs3
	 TghMmztlTaZek4aUj7ggUMynn+/nxDJPyNLkzC/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Stellard <tstellar@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 193/849] bpftool: Fix -Wuninitialized-const-pointer warnings with clang >= 21
Date: Tue, 11 Nov 2025 09:36:03 +0900
Message-ID: <20251111004541.109201805@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Stellard <tstellar@redhat.com>

[ Upstream commit 5612ea8b554375d45c14cbb0f8ea93ec5d172891 ]

This fixes the build with -Werror -Wall.

btf_dumper.c:71:31: error: variable 'finfo' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
   71 |         info.func_info = ptr_to_u64(&finfo);
      |                                      ^~~~~

prog.c:2294:31: error: variable 'func_info' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
 2294 |         info.func_info = ptr_to_u64(&func_info);
      |

v2:
  - Initialize instead of using memset.

Signed-off-by: Tom Stellard <tstellar@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20250917183847.318163-1-tstellar@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf_dumper.c | 2 +-
 tools/bpf/bpftool/prog.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 4e896d8a2416e..ff12628593aec 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -38,7 +38,7 @@ static int dump_prog_id_as_func_ptr(const struct btf_dumper *d,
 	__u32 info_len = sizeof(info);
 	const char *prog_name = NULL;
 	struct btf *prog_btf = NULL;
-	struct bpf_func_info finfo;
+	struct bpf_func_info finfo = {};
 	__u32 finfo_rec_size;
 	char prog_str[1024];
 	int err;
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 9722d841abc05..a89629a9932b5 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2262,7 +2262,7 @@ static void profile_print_readings(void)
 
 static char *profile_target_name(int tgt_fd)
 {
-	struct bpf_func_info func_info;
+	struct bpf_func_info func_info = {};
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
 	const struct btf_type *t;
-- 
2.51.0



