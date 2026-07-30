Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EBA37A85D;
	Thu, 30 Jul 2026 15:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426386; cv=none; b=CWucQH2UZ4k6ob/dmMbGGLyNvTEKI19s3JJzICl+3tTewBzv11XLdv74QwCxqAae09PAyipMQIems9LiUcmxSg6pHXfzDcSplXiLJ+Dx+15jtdQnPDGwb9nuLD07PWuDQQCL/TvJ/4lcYTh12L6JDorohRzfMm/58OvG9hBe+vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426386; c=relaxed/simple;
	bh=KrzX5/mFoJ8ggz1wXTYE2RI77aCtKdZNJSKXp8/DVu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djef8rtcP89GIIQEtD9qbqS0r4e9eX625038wnryNFe/WxaeaEEzDSrKjqDPDZFQ4tal3GpBEk97m7cHh9Ex7plEPL2VXWIyUwc5t963+9K1i3ClYJuLB6bSN0mpv99a7IA7AlFU1esR2hPjTlnDt57VrtGSZ3/SgrQiPEO+k7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qu1bzY/b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qu1bzY/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF041F000E9;
	Thu, 30 Jul 2026 15:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426385;
	bh=dXky5a1nI9xWenW/iYR2nS0np3Yprv+6spi347ZxSrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qu1bzY/blLYwt/LZmDmZs51IvdLj+Wbjyp37Phdk3QIhuZOCYxTwp8bvXP3RdFOCp
	 HbXG0b1HKwfXed3xsdIroo5RXPPsHuGExcG0Ymgtq35b4UQO+2p0q+hgnhAoCjA7n/
	 T1aOPLK01s4EhpV/o+f9XUPKjchCbr6DtwP3VY/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 401/602] binfmt_elf_fdpic: only honour the first PT_INTERP
Date: Thu, 30 Jul 2026 16:13:13 +0200
Message-ID: <20260730141444.388595970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 3349ef6a366a61d631f6a263d12cea240957719d upstream.

The program header scan handles PT_INTERP from a switch nested in the
scan loop, so its break leaves the switch and not the loop. A binary
carrying more than one PT_INTERP runs the case again and overwrites both
interpreter_name and interpreter. The previous name allocation leaks and
so does the previous interpreter reference, along with the write denial
open_exec() took on it. The denial is never released, so the file stays
unwritable for as long as the system runs.

An unprivileged caller reaches this with a crafted binary and repeats it
at will. binfmt_elf stops at the first PT_INTERP. Do the same here.

The flaw dates back to the driver's introduction in the pre-git history
tree introduced in v2.6.11 by 91808d6ebe39 ("[PATCH] FRV: Add FDPIC ELF
binary format driver").

Link: https://patch.msgid.link/20260721-gezittert-medium-kreide-b41fc1f0277e@brauner
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf_fdpic.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -231,6 +231,10 @@ static int load_elf_fdpic_binary(struct
 	for (i = 0; i < exec_params.hdr.e_phnum; i++, phdr++) {
 		switch (phdr->p_type) {
 		case PT_INTERP:
+			/* elf ABI allows only one interpreter */
+			if (interpreter_name)
+				continue;
+
 			retval = -ENOMEM;
 			if (phdr->p_filesz > PATH_MAX)
 				goto error;


