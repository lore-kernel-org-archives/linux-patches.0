Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BC63EEAD6;
	Wed, 20 May 2026 16:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296338; cv=none; b=PPGS3S9l7kExeim2/k+Y60gomXttRLYLWgt6sou8qlicYa8D1B8wfZB+2D0Wh7DjwDP/LgzaPmD40IFnuFpdEKHEtYNQNf0y24dDi3S0+KwoylO5p+1cDzTfMXfRQbbNC3K/N2v5PVKAl24bfZn/3Bz/+3Mqi5JPXT2dYklLAMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296338; c=relaxed/simple;
	bh=3i+9lN0IROsKPJbZQuKV+dW2vWfEhss94flXF6ei7MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qufTJA9f1HQ4yyeQ8WaJHX6EqgwduJ3kkl/feCefOOsfFftTz4H/cxPhQP5CDBKRta4YNa7T7iojqilILYt/OZrTmWDyMPvgYuVQRJM9YaYFtN+keqdC89uxOXscvXBXDFe1M67msZfV1FT7I1QVaNTFr0R0B9vfCE9g87kI8og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpTA0D+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpTA0D+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE981F00893;
	Wed, 20 May 2026 16:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296337;
	bh=/OzLn5+zKUiQP6wa4KLSeB1uLaE5aKR8kHOQilyARF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KpTA0D+LbzHdeC8RBNz2bmbRshf8cmBAYoMYAOqSl3ldZFonYRE1PvTFgudPi5U2Y
	 KQ73PeAmFH4RwmMqqcDAs7nJWYLeyYL73RPGL6r74QKu1c1bTe2KHFI8rSg67kmsZ+
	 YSnCEIO4SofT+sP2QySXsTyM7QB8u3hoOH+v/bUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0761/1146] PCMCIA: Fix garbled log messages for KERN_CONT
Date: Wed, 20 May 2026 18:16:51 +0200
Message-ID: <20260520162205.433689614@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 0679dd434719d..b28d754ba414f 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -187,7 +187,7 @@ static void do_io_probe(struct pcmcia_socket *s, unsigned int base,
 	int any;
 	u_char *b, hole, most;
 
-	dev_info(&s->dev, "cs: IO port probe %#x-%#x:", base, base+num-1);
+	pr_info("%s: cs: IO port probe %#x-%#x:", dev_name(&s->dev), base, base+num-1);
 
 	/* First, what does a floating port look like? */
 	b = kzalloc(256, GFP_KERNEL);
@@ -409,8 +409,8 @@ static int do_mem_probe(struct pcmcia_socket *s, u_long base, u_long num,
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



