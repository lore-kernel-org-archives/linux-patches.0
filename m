Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B181E7C22;
	Wed, 15 Jan 2025 11:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938907; cv=none; b=qc8MtnWe/EQoRcZxpFrW4KwrdhNBG1yBKXUAQkWlVG7gu7G6osgkbvHhWgioKpbt5SIHkoAOUfTYjyIWpdABqEdXd3zU3riU4e8yTnQ693/0yQVOytS8a2mzVEdzl9KP2V9WpjuaM47Z6oIKeCy+2MqK1SyR3GHsjn+WX83wTfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938907; c=relaxed/simple;
	bh=ProTtqOo4nGzly4Mgca/r9ub5zfoTX8vCCEkWJ56Sf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6c+cFvhL+qEnUvYOS/Cv/KVxhW3LKkbksI0ZUnYzD3J6oS1ES3OAcouPRiGMGZRPYjHWOoBZFZZma4Eqkm1MgNGufrAeKWSqEZeiWA9medE/JEKOjyowWcD6OdR4MQuobuObHlk4N8nrvrLbzLS+9rGJRRGktuf1wmmQFSpiXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAOOlP//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAOOlP//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA9EC4CEDF;
	Wed, 15 Jan 2025 11:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938907;
	bh=ProTtqOo4nGzly4Mgca/r9ub5zfoTX8vCCEkWJ56Sf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAOOlP//QUwT9F4ohlhZCv4b+HXPwGwmAJuLSeeUk5dPyX0jHBef9BWRWuKfnLGNe
	 B7bDq0lEgZl6OTte+Iep6rqnjT8xCCnLpThd4JIg5xQvovtRPaEj9PYWW9fWOmscGA
	 IgbcxDs1KfqL/XdXI2u6MhPd2Bgh/KAw7XyV1Vt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 113/129] riscv: kprobes: Fix incorrect address calculation
Date: Wed, 15 Jan 2025 11:38:08 +0100
Message-ID: <20250115103558.851975044@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Nam Cao <namcao@linutronix.de>

commit 13134cc949148e1dfa540a0fe5dc73569bc62155 upstream.

p->ainsn.api.insn is a pointer to u32, therefore arithmetic operations are
multiplied by four. This is clearly undesirable for this case.

Cast it to (void *) first before any calculation.

Below is a sample before/after. The dumped memory is two kprobe slots, the
first slot has

  - c.addiw a0, 0x1c (0x7125)
  - ebreak           (0x00100073)

and the second slot has:

  - c.addiw a0, -4   (0x7135)
  - ebreak           (0x00100073)

Before this patch:

(gdb) x/16xh 0xff20000000135000
0xff20000000135000:	0x7125	0x0000	0x0000	0x0000	0x7135	0x0010	0x0000	0x0000
0xff20000000135010:	0x0073	0x0010	0x0000	0x0000	0x0000	0x0000	0x0000	0x0000

After this patch:

(gdb) x/16xh 0xff20000000125000
0xff20000000125000:	0x7125	0x0073	0x0010	0x0000	0x7135	0x0073	0x0010	0x0000
0xff20000000125010:	0x0000	0x0000	0x0000	0x0000	0x0000	0x0000	0x0000	0x0000

Fixes: b1756750a397 ("riscv: kprobes: Use patch_text_nosync() for insn slots")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20241119111056.2554419-1-namcao@linutronix.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
[rebase to v6.6]
Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/probes/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -29,7 +29,7 @@ static void __kprobes arch_prepare_ss_sl
 	p->ainsn.api.restore = (unsigned long)p->addr + offset;
 
 	patch_text_nosync(p->ainsn.api.insn, &p->opcode, 1);
-	patch_text_nosync(p->ainsn.api.insn + offset, &insn, 1);
+	patch_text_nosync((void *)p->ainsn.api.insn + offset, &insn, 1);
 }
 
 static void __kprobes arch_prepare_simulate(struct kprobe *p)


