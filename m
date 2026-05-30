Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6284F340293;
	Sat, 30 May 2026 17:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161619; cv=none; b=IrCc1OSkHRzNqEFS0GGBvc6XQmQtPwFRT4wqvciFZVxVVZ3paRsbTZF/n21UhpFfpxH+4RhAwUHpfWDXF6bsRuir+rV7/sFUkyo5YVWOhY6gsX4QfbVMl90WpcfBAb2oYkNm9LplnVrIo4mfmP0THctFHKP0/GeHYkU19azVSrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161619; c=relaxed/simple;
	bh=voC+jjThchTVI8kc4kNRswxQFxwlgIY0w0NLlbG1PFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PMxUMdCEimytxNzfTwNx52QPAaRt/bKz3dM1Uqn/2KL+I1iDlBGkf4vZhHrKoCJrQn27daUgk2whLqW3x+TuFNW7vXZCbCkfa7ytTCJZtaGXR769nQPVTsqNEaLtyNHhlgltWvZ9q3HNu7xICJJb00/ufMH31VDRBslhKou+yCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=st5SrQkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="st5SrQkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77331F00893;
	Sat, 30 May 2026 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161618;
	bh=qhWEmqlGU4a+wjm6wONflIzoM7Mfxom3EgFscZMSJGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=st5SrQkC4wbvB4DgjP1vGWWm5Dx+G/6LXflxgITvuEYPtIE+cDTsz8DtV2DN5S1lC
	 qVLP0AE0DsG6269agzh2/L2GZK3KA+kHJuPtlFSyiOicz+ryiy3yQ/FbhRLBv4lI7a
	 lFYKhKoTNCQqWqLC0JWhpqd6cCcYyy7iESfRn5D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 677/969] PCMCIA: Fix garbled log messages for KERN_CONT
Date: Sat, 30 May 2026 18:03:21 +0200
Message-ID: <20260530160319.191452079@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: René Rebe <rene@exactco.de>

[ Upstream commit bfeaa6814bd3f9a1f6d525b3b35a03b9a0368961 ]

For years the PCMCIA info messages are messed up by superfluous
newlines. While f2e6cf76751d ("pcmcia: Convert dev_printk to
dev_<level>") converted the code to pr_cont(), dev_info enforces a \n
via vprintk_store setting LOG_NEWLINE, breaking subsequent pr_cont.

Fix by logging the device name manually to allow pr_cont to work for
more readable and not \n distorted logs.

Fixes: f2e6cf76751d ("pcmcia: Convert dev_printk to dev_<level>")
Signed-off-by: René Rebe <rene@exactco.de>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/rsrc_nonstatic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 0a4e439d46094..f9baf28bc32b8 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -188,7 +188,7 @@ static void do_io_probe(struct pcmcia_socket *s, unsigned int base,
 	int any;
 	u_char *b, hole, most;
 
-	dev_info(&s->dev, "cs: IO port probe %#x-%#x:", base, base+num-1);
+	pr_info("%s: cs: IO port probe %#x-%#x:", dev_name(&s->dev), base, base+num-1);
 
 	/* First, what does a floating port look like? */
 	b = kzalloc(256, GFP_KERNEL);
@@ -410,8 +410,8 @@ static int do_mem_probe(struct pcmcia_socket *s, u_long base, u_long num,
 	struct socket_data *s_data = s->resource_data;
 	u_long i, j, bad, fail, step;
 
-	dev_info(&s->dev, "cs: memory probe 0x%06lx-0x%06lx:",
-		 base, base+num-1);
+	pr_info("%s: cs: memory probe 0x%06lx-0x%06lx:",
+	       dev_name(&s->dev), base, base+num-1);
 	bad = fail = 0;
 	step = (num < 0x20000) ? 0x2000 : ((num>>4) & ~0x1fff);
 	/* don't allow too large steps */
-- 
2.53.0



