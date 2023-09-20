Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5F91D6A7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97CEC433C9;
	Wed, 20 Sep 2023 11:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211028;
	bh=Rw8bkXwHgyPeh6sEbpT612P5Cly2wrLJeE34UT9Ft2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIyV+SmL4MLag6iimMolK84v8l9IfHm0aMWLm2Vlk8jT0AZCjwJODraFQe0SnTWfY
	 Gcl4kIxefo8epxgBjl9atW+ANSRxjeI2tVn2lu8neVE6Ho25GraUr0qzFXpLS4CmI4
	 p+HW2Sm6m5QNex/qG4Ifz/SpU9BcSvA744MZW2PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Luo <haoluo@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/139] libbpf: Free btf_vmlinux when closing bpf_object
Date: Wed, 20 Sep 2023 13:29:32 +0200
Message-ID: <20230920112837.049830899@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Luo <haoluo@google.com>

[ Upstream commit 29d67fdebc42af6466d1909c60fdd1ef4f3e5240 ]

I hit a memory leak when testing bpf_program__set_attach_target().
Basically, set_attach_target() may allocate btf_vmlinux, for example,
when setting attach target for bpf_iter programs. But btf_vmlinux
is freed only in bpf_object_load(), which means if we only open
bpf object but not load it, setting attach target may leak
btf_vmlinux.

So let's free btf_vmlinux in bpf_object__close() anyway.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20230822193840.1509809-1-haoluo@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index eeb2693128d8a..10f15a3e3a95e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8173,6 +8173,7 @@ void bpf_object__close(struct bpf_object *obj)
 	bpf_object__elf_finish(obj);
 	bpf_object_unload(obj);
 	btf__free(obj->btf);
+	btf__free(obj->btf_vmlinux);
 	btf_ext__free(obj->btf_ext);
 
 	for (i = 0; i < obj->nr_maps; i++)
-- 
2.40.1



