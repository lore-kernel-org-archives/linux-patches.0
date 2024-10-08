Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C404C190663;
	Tue,  8 Oct 2024 12:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390980; cv=none; b=UyLMQJf+E3E+98mTRLRZ4MrW8ey4dPxtalkUZXX/yJFGNu0HoSYolCB53VOguTOdNVeJ1rcBu5vVabp8paLbtCtjWgEiC7e5Z21sNO8NG7bFBgwE1nPn+e5kdniW4q/DFmrmOa0oix6BVkWG/qCf3fQlzwPikTLTsQWsaIsp4rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390980; c=relaxed/simple;
	bh=+lx7GTgdgyRh+oGQoXlWhl+2tGxeQ9LEzvSdoosD/FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTEDv4+lqSouquoq1NUIWyQOsSU7Vym3udCA/tLinhRV+W6ShMhLOrAhGN0TEVzg3q6MtgQ3d3eQKW9lQCu92AfXEFpBOw1i45UsRZ2ZFSb9+OP0v0EvYOUDDBthP+j3CmoNzNGG9CEV+fQlyQU7kq8Fn7SOspt5WHa2O8rsCOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weoiLyoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weoiLyoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36813C4CECD;
	Tue,  8 Oct 2024 12:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390980;
	bh=+lx7GTgdgyRh+oGQoXlWhl+2tGxeQ9LEzvSdoosD/FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=weoiLyoF6KPG8C0w1bDOBVCCGJ6RciSs/ijlJi3bissq5cj40PN2+ArtFYvEOQy3h
	 BSSPIv7V8kNOL7t79UQORdqi8PFsY4m9BOO21pqOdB+rpt1zmOR9LUii747fnIphlY
	 dBcsapD0Tbl8AODqAr0RmunKLkDvZtgy6bmvYXhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 453/482] build-id: require program headers to be right after ELF header
Date: Tue,  8 Oct 2024 14:08:36 +0200
Message-ID: <20241008115706.345226133@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7954dd92e36c0..e02b5507418b4 100644
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



