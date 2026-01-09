Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5327535A92E;
	Fri,  9 Jan 2026 12:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961125; cv=none; b=qdTg9XbzOZW78K0eEM5upSPT4FLz6EGkLmzkslCcBHnGTxmRL6SaPfyWMcE0sDHD+1yt7vleeRV1U2CAejUL4PeFL1SeomgZCZDnx4CvHw5eJnINGYpbeStvWXYnfwO+KXLGG4b7i9PPefbs6eMRa1v79fIaCKLalVC+oboelkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961125; c=relaxed/simple;
	bh=8QbpwWBlRFOghThDDNlgM1fNnIdAyjqDwJ3ebaXiFn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka1/zk2rqKTjmws88SEVu+dZglgg4JUv2kFhZSGerK7JQ27QNLMvGnZjbXrRY5gvS8vJOcLOBUtV+BNI4neVL9D+uN6w7poy7dlPQL9/IumKGyXOyUpNryzT5or5gh+3fZW8srVQ9KL9liJKvBquY4eO2p5K9+IZUA95DO/vDKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktpCIUTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktpCIUTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40F1C4CEF1;
	Fri,  9 Jan 2026 12:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961125;
	bh=8QbpwWBlRFOghThDDNlgM1fNnIdAyjqDwJ3ebaXiFn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktpCIUTUAA45gpWxlKjR4qTxKgJJpXbKtzO+OYXZosLluBXxaTC16/B1/Kbpv7TKs
	 lLtTGfVp3euTb7OJoHRpkEyGuCvtFyCzJOr6LcqY67vb2ti01EGkKTv7+JnOT/W71+
	 Mse5uUdxVp16AEBcf4fGQ0FwWdzEN5w2YPJSqlBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 600/737] LoongArch: Use unsigned long for _end and _text
Date: Fri,  9 Jan 2026 12:42:19 +0100
Message-ID: <20260109112156.579110936@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -141,7 +141,7 @@ static inline void __init *determine_rel
 	if (kaslr_disabled())
 		return destination;
 
-	kernel_length = (long)_end - (long)_text;
+	kernel_length = (unsigned long)_end - (unsigned long)_text;
 
 	random_offset = get_random_boot() << 16;
 	random_offset &= (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1);
@@ -190,7 +190,7 @@ unsigned long __init relocate_kernel(voi
 	early_memunmap(cmdline, COMMAND_LINE_SIZE);
 
 	if (random_offset) {
-		kernel_length = (long)(_end) - (long)(_text);
+		kernel_length = (unsigned long)(_end) - (unsigned long)(_text);
 
 		/* Copy the kernel to it's new location */
 		memcpy(location_new, _text, kernel_length);


