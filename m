Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFE12E22B0;
	Mon, 18 Aug 2025 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524705; cv=none; b=U03JJr36XF2KsXdrOAb+vBxpUwGoC/Hg1JjJTXYt/AUgqFFzn1Gtj8gZkxgDKzUnQxfPzHJa+Iv4ET6XT1cV1NoL2qyQNp00NPVkecGuQLJtBQ4CWB7QTBtnzDgRUBRRGnj1eOtOypr/7ITXfifRXER7J9E2QcKGl+AJIJOhfhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524705; c=relaxed/simple;
	bh=gCDC4mBB2h3UrxbC4KbqE5R7TXO0G5TdbJ+WeH/SHBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AN9fEBeyWxxPMAERIm50yEsH3R7TRHKgfGn7Yu95lrPAbOM2hfnAcVs8mFeR8rmtR1p0q3Phq35axMzjpkvTg77SgaJYvhZoYVYIZFLbjiHv8E/H9rwadgQm03e3BqxiurNBALfayVEhQlcPygpe2oI2Xuy+wyg4lQvRHhZE2W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSLH3tOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSLH3tOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7428FC4CEEB;
	Mon, 18 Aug 2025 13:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524704;
	bh=gCDC4mBB2h3UrxbC4KbqE5R7TXO0G5TdbJ+WeH/SHBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSLH3tOzsdcP/JFkAPU6DMAOpIo0nuVwIg1TInF03wrs2mbqwkg41HE9VWAXCg9TT
	 805eoFDvyRMds8OW+JaIrKJKpnxWAvJiOqHi9Pp8tuuernnRksY3n/3i6syNK5kLaR
	 r4w/pjpPowYvHT5LnhaEAMMgoDZGSL3Mjr9s36BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 037/570] LoongArch: Dont use %pK through printk() in unwinder
Date: Mon, 18 Aug 2025 14:40:24 +0200
Message-ID: <20250818124507.244784191@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -508,7 +508,7 @@ bool unwind_next_frame(struct unwind_sta
 
 	state->pc = bt_address(pc);
 	if (!state->pc) {
-		pr_err("cannot find unwind pc at %pK\n", (void *)pc);
+		pr_err("cannot find unwind pc at %p\n", (void *)pc);
 		goto err;
 	}
 


