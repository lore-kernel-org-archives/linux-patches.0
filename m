Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EC3321F39;
	Mon, 18 Aug 2025 13:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522986; cv=none; b=qNbo1yh064YF9e4nWd4YOqIZ7fe92qHPmzM5rkQzgBmtdhAFwfc2is8v9u5CoORDXmTzW3EqmTRQUPd6d3eskPG3G7WIKZg3xtJfMi0XSqYlirNPYBGhs8fzvhqNKbZywYQN8vYtdLgdmBzw9DjUNmDJxaQD2LvGyN7EBcWAuJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522986; c=relaxed/simple;
	bh=zPkEzAbXLc/GvWDpd45ikQ/wtHsWw4CerpBbxBgdI3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rFjfjvS8YuW7fyy0zU4VuJuPP8ZT1yxpoqdmD0UeQF42Co3WEo415UnNWJRBED4mR9+x+TgJg26OfkQGXQ4FgN3RMfe8qJJL8XOFaQ1X+8biqXK+CCuBfiO0aIFk1n03ThrZlEDIy//Hm95/T4wd89nmumMTojDRmgisCU8DWKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnvHgHLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnvHgHLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F62C4CEEB;
	Mon, 18 Aug 2025 13:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522985;
	bh=zPkEzAbXLc/GvWDpd45ikQ/wtHsWw4CerpBbxBgdI3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnvHgHLqTla2pJV8mXz8XTb5aTjvWicBpd2hnhWC9LvNbx2eSVUEPuKKFLq4hwWAH
	 lw6eBdCGr/UKRnxb7xfFPf7VUFsN+xDpRKOjvyQ05qAH2FHhBeZeKjl/hrJMjA5YhN
	 xhn1iOP9umySjha/XR9EG+OQYZL0KMMdH4OHFOCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.15 035/515] LoongArch: Dont use %pK through printk() in unwinder
Date: Mon, 18 Aug 2025 14:40:21 +0200
Message-ID: <20250818124459.798159433@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 


