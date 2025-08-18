Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4034032039C;
	Mon, 18 Aug 2025 12:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521466; cv=none; b=GGWQKA5XDuzUAiZOBnH6LDE1VKANSPoz07hq6z4fBgEgIZhKr72dfKd6WU+PJpwLhIum7/SNY6bVNXjx26XEuLvBfJd8me4up6IBzGqvXrT8DYnrztVCybABSj0JgZ+re1BOGaM32Vh+WJf+xWvK3jTeWcI91l5dqSVsNzAaIJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521466; c=relaxed/simple;
	bh=00/TVWgUtX5ldseYGsMq20pDZm57L0ipJr+yveWm1zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7sTc3KeYwiC2jLPf99H8TUx7Jex1xd7LdBVsRzTZaCtP7xVZSvgAGa88G+QJeJuvxM49pES02Clp+5Fc5c8lImRsEgNacJl/pZYaSM/Hl7hXiUsqlg8EBkuseKQE9Hl42i8V0OXvY7eCCDaqMwCRMghCkMlsn00kaMMITJoKKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2qq5efu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2qq5efu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EF7C4CEF1;
	Mon, 18 Aug 2025 12:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521465;
	bh=00/TVWgUtX5ldseYGsMq20pDZm57L0ipJr+yveWm1zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2qq5efudZ6zwKTokWHcQ+gQWfuVkxMXw+dGvDnpH0TAqZqiGs2Om0BxVtQOPgZ0Z
	 D4CnRMrS/SZeSVX6Via7DbLhUQluuk2G4gWppFDW2LZXEDB0me0KUqOpB5MkwlqAiW
	 sgMGfuW5qkUGswuuyGxB6Ie2s8MXpbn0Sbc9PSB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 028/444] LoongArch: Dont use %pK through printk() in unwinder
Date: Mon, 18 Aug 2025 14:40:54 +0200
Message-ID: <20250818124449.986230575@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 2362e8124ed21445c6886806e5deaee717629ddd upstream.

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log.

Since commit ad67b74d2469 ("printk: hash addresses printed with %p")
the regular %p has been improved to avoid this issue.

Furthermore, restricted pointers ("%pK") were never meant to be used
through printk(). They can still unintentionally leak raw pointers or
acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and easier to
reason about.

Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/unwind_orc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kernel/unwind_orc.c
+++ b/arch/loongarch/kernel/unwind_orc.c
@@ -507,7 +507,7 @@ bool unwind_next_frame(struct unwind_sta
 
 	state->pc = bt_address(pc);
 	if (!state->pc) {
-		pr_err("cannot find unwind pc at %pK\n", (void *)pc);
+		pr_err("cannot find unwind pc at %p\n", (void *)pc);
 		goto err;
 	}
 


