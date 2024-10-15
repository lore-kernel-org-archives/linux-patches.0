Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572441CFEA9;
	Tue, 15 Oct 2024 12:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993957; cv=none; b=j6egeGOBUvWprBUE03QLuFmtYi9eEH3im/cFVOUZaUyBAfFt6Yjn2zuwsHEEiw0Waa8lcd3tU9v+vYAhtVC3y0i5oWzHCW5p3UyJn3u+EBIeX0Ts+Tkrt+5vzqCb6on7AX97BGRk3w/Te8nfvVBvbVEjYog2vt9bvpulO9+lyPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993957; c=relaxed/simple;
	bh=RKew/3VWH/KQ2rRYQn+8xj/BUB2QqohDvmnMdbjaFx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4Us4dnL0DTu13DUyZYtKJF6cGoZ2ozjdfQMwLXoD/0yGvJy/iBleQJi96phrfX3jKvvKlrmZVoesCk+eVqeGAikBopjXf8icqkXTBpxWUjUtBlZZJPCVOke8TCUiDKLfxT0yODd4ZNnktEICSKNwOffGcn3GmyO9DrSP53jhzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idB0RsUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idB0RsUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6325BC4CECF;
	Tue, 15 Oct 2024 12:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993956;
	bh=RKew/3VWH/KQ2rRYQn+8xj/BUB2QqohDvmnMdbjaFx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idB0RsUF3JqvGjqhwtyJtNZ1hjiVwlADQOCtf8O4Q2RI2VBp5EStJCrzH/iHU0dVX
	 3cPQO+7AqjPN9HyfJlYy1+zLvUeR5m5UD9F/v4W1Z3hTFzUzvIN4RN+Z/lKTFX21W0
	 v+MFi/yY/pDg+SfQZzPzjddpIeLpN0kvFsAh9kMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 565/691] build-id: require program headers to be right after ELF header
Date: Tue, 15 Oct 2024 13:28:33 +0200
Message-ID: <20241015112502.767463836@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 961a2851324561caed579764ffbee3db82b32829 ]

Neither ELF spec not ELF loader require program header to be placed right
after ELF header, but build-id code very much assumes such placement:

See

	find_get_page(vma->vm_file->f_mapping, 0);

line and checks against PAGE_SIZE.

Returns errors for now until someone rewrites build-id parser
to be more inline with load_elf_binary().

Link: https://lkml.kernel.org/r/d58bc281-6ca7-467a-9a64-40fa214bd63e@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 905415ff3ffb ("lib/buildid: harden build ID parsing logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/buildid.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/lib/buildid.c b/lib/buildid.c
index dfc62625cae4e..493537344fc81 100644
--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -73,6 +73,13 @@ static int get_build_id_32(const void *page_addr, unsigned char *build_id,
 	Elf32_Phdr *phdr;
 	int i;
 
+	/*
+	 * FIXME
+	 * Neither ELF spec nor ELF loader require that program headers
+	 * start immediately after ELF header.
+	 */
+	if (ehdr->e_phoff != sizeof(Elf32_Ehdr))
+		return -EINVAL;
 	/* only supports phdr that fits in one page */
 	if (ehdr->e_phnum >
 	    (PAGE_SIZE - sizeof(Elf32_Ehdr)) / sizeof(Elf32_Phdr))
@@ -98,6 +105,13 @@ static int get_build_id_64(const void *page_addr, unsigned char *build_id,
 	Elf64_Phdr *phdr;
 	int i;
 
+	/*
+	 * FIXME
+	 * Neither ELF spec nor ELF loader require that program headers
+	 * start immediately after ELF header.
+	 */
+	if (ehdr->e_phoff != sizeof(Elf64_Ehdr))
+		return -EINVAL;
 	/* only supports phdr that fits in one page */
 	if (ehdr->e_phnum >
 	    (PAGE_SIZE - sizeof(Elf64_Ehdr)) / sizeof(Elf64_Phdr))
-- 
2.43.0



