Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC5020F090;
	Tue, 17 Jun 2025 15:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174711; cv=none; b=Ko+0OuqwvUf5M6OgANp/IMnh5jcj6NDsWxQO5me9auDky2w5On23ArRpbJe5L9MjWQYla9DxG/rd13Lrlc6jzEeAfcypZ3vYM7ecgri6tfvEcZ1pItDe0APkx34/udEm3gOCgjnAPMQxrPIOcn8zB5TJETN1byJPGayWhHB60C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174711; c=relaxed/simple;
	bh=ftvq6xEFXV2ozITj5tjUH7mvPMgy6/v0F2xxuSs37zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiQr+3FrgYnkHJZbSXIK2dwrcAlpA5+YJpZaqi7L/h+S5Mlxrn3vIqvr19/wl9H6yNdkCOF0a1nxa0CZH6DOcsWWOFKLhTbFrNJLhAwpCxCaGrs+dG2raabe2sOWtG/rSZY6RVuZ7QjighDx7LkmYo2Vxc+vvIa4ud05M6tlnv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILo6rzIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILo6rzIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DFBC4CEE3;
	Tue, 17 Jun 2025 15:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174711;
	bh=ftvq6xEFXV2ozITj5tjUH7mvPMgy6/v0F2xxuSs37zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILo6rzIC8kMKMBXrl2PZhoUio0Sptjcn/Q6Ln1FF7VKF7unx/9WNE+whVpDsiQ6wK
	 kKwHUE/yBWIlxDbRerurejaAmCkuyJR+k9Ib84Czwl26c4jQ19Ku5IZ2eGvruFqer8
	 2bOPjGr6GV9Gt7Hyl1obddKViEZsZ2I87FB1AYyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/356] libbpf: Use proper errno value in linker
Date: Tue, 17 Jun 2025 17:23:39 +0200
Message-ID: <20250617152342.409348163@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit 358b1c0f56ebb6996fcec7dcdcf6bae5dcbc8b6c ]

Return values of the linker_append_sec_data() and the
linker_append_elf_relos() functions are propagated all the
way up to users of libbpf API. In some error cases these
functions return -1 which will be seen as -EPERM from user's
point of view. Instead, return a more reasonable -EINVAL.

Fixes: faf6ed321cf6 ("libbpf: Add BPF static linker APIs")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250430120820.2262053-1-a.s.protopopov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index a3a190d13db8a..e1b3136643aa8 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1187,7 +1187,7 @@ static int linker_append_sec_data(struct bpf_linker *linker, struct src_obj *obj
 		} else {
 			if (!secs_match(dst_sec, src_sec)) {
 				pr_warn("ELF sections %s are incompatible\n", src_sec->sec_name);
-				return -1;
+				return -EINVAL;
 			}
 
 			/* "license" and "version" sections are deduped */
@@ -2034,7 +2034,7 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 			}
 		} else if (!secs_match(dst_sec, src_sec)) {
 			pr_warn("sections %s are not compatible\n", src_sec->sec_name);
-			return -1;
+			return -EINVAL;
 		}
 
 		/* shdr->sh_link points to SYMTAB */
-- 
2.39.5



