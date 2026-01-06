Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7008D342CA1;
	Tue,  6 Jan 2026 17:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721074; cv=none; b=pCtygDj8/LaQn0mJ9Ol8tiBekjw0Ktrgba0gXUlIRYmaZQedAeRr6WktZ4q0pPghos+2HsZ2zJ1wfS2VUA9HfhLS5Vj0stoaewLoqPA3BeDknrvW3r4gmsoAOWF8ofewztqPRpAw3iE5Y4SKIO7P9u+DCTqBjAzCW6y6Wnx1izI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721074; c=relaxed/simple;
	bh=KXQN3aj2MusNy+VxIakQ21eDNNWi+M8U7PYm81XfugM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3/oZ9UgcBfuwEcZqXFxkz5DNHtuJIJPFzEX7vjIDJsBlY+dARzaH6ZDY+J0Y9Vk9h4DYM6gz2mxickAmKjolPr/DkRy4OzYUtbCuviC2T3uDwyy2xfKiutYWMjNgECFfCa9DCbs2LhocIrLqSY0N0VLbfd30oCUtm/sZ8KYGlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psZl8XEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psZl8XEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8441DC116C6;
	Tue,  6 Jan 2026 17:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721074;
	bh=KXQN3aj2MusNy+VxIakQ21eDNNWi+M8U7PYm81XfugM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psZl8XEUlewWBCGMeGUGjk8xYHjFaZO+4I7W8uRgQJZy43XtDTd8T155JzJAdVbBQ
	 KBBj9bymWMyd7PksicqXJaLYmkRga79b2eZhS8SC+YyDFWBlIwqfZHjm3YlFzg1g2x
	 tOXKgaXt+FRTgfN9riUM24x8K7qGxE6st+2/r7g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 420/567] LoongArch: Use unsigned long for _end and _text
Date: Tue,  6 Jan 2026 18:03:22 +0100
Message-ID: <20260106170506.877369363@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit a258a3cb1895e3acf5f2fe245d17426e894bc935 upstream.

It is better to use unsigned long rather than long for _end and _text to
calculate the kernel length.

Cc: stable@vger.kernel.org # v6.3+
Fixes: e5f02b51fa0c ("LoongArch: Add support for kernel address space layout randomization (KASLR)")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/relocate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -183,7 +183,7 @@ static inline void __init *determine_rel
 	if (kaslr_disabled())
 		return destination;
 
-	kernel_length = (long)_end - (long)_text;
+	kernel_length = (unsigned long)_end - (unsigned long)_text;
 
 	random_offset = get_random_boot() << 16;
 	random_offset &= (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1);
@@ -232,7 +232,7 @@ unsigned long __init relocate_kernel(voi
 	early_memunmap(cmdline, COMMAND_LINE_SIZE);
 
 	if (random_offset) {
-		kernel_length = (long)(_end) - (long)(_text);
+		kernel_length = (unsigned long)(_end) - (unsigned long)(_text);
 
 		/* Copy the kernel to it's new location */
 		memcpy(location_new, _text, kernel_length);


