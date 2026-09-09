Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E2B569F2A;
	Wed,  9 Sep 2026 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963634; cv=none; b=jC12pM08vW8kAmcEJGDZ9hglExLHuaO5NJG8fzmcfDzheHIfhzSV+Jf7lKcNgixREXTyXMJisD1uX8eFTByHxiRlDOcq0+O35duUEIDeK0nOxoCOuPJtvdo0Aq1iJL4aC6/wLWPkDBGBv+QqdCglc/x63AYENiMEMpGy5/lr2yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963634; c=relaxed/simple;
	bh=xBbAWKjGPdCOldwqGDi6UO6iEdl0Us+stY5XFUxvHOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvCd56A1eL2xeX3MwRICG1C1HgI3xGoJmy0F219to5DnQ6LcU0T2oXgoJgri7zBJ+ElYHztV2cpqXL/w9sNeV5oOqXplHoSpuK/ro/stbMtqbGQvjfeBNHDf5wIy2s6nzVZOmV1oG0gDqCqCv7Jv5KOY3aqjAxiMosrtZi6CGbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eABruJ9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eABruJ9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAF51F00A3A;
	Wed,  9 Sep 2026 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963632;
	bh=L7zpsnE1IhkpB7aX/YI5m402lOHGKvZgkXGKJJic9yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eABruJ9nzrUd88Emr9LnS1j1Q5Gyily4ocTtJcCxzz6TmY5Kr2CsS4+aVcy4ZLWck
	 mrFL6Z/SQCTnEMPq6Uo85LWrPz/sB3eyFvvm/Slm9sH1sF6ZXFvZseoPne8No0P+4y
	 yAKEaaRCUHkSpwjzEl7oLPp95+f5uBcA0pNu9swA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 119/583] parisc: eisa: Fix infinite loop when parsing invalid IRQ value
Date: Wed,  9 Sep 2026 15:36:44 +0200
Message-ID: <20260909134242.254100346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

commit 8b585431a16cfb9d8f2955a9fa0787ce3dceb3c2 upstream.

When an invalid value is passed via the "eisa_irq_edge=" kernel
command line parameter (e.g. "eisa_irq_edge=16,5"), eisa_irq_setup()
prints an error message and continues without advancing the current
position.  As a result the same invalid value is parsed again and
again, causing an infinite loop while the kernel boots.

Advance to the next comma-separated entry, or stop parsing when there
is no next entry, before continuing so that the remaining entries are
processed normally.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/eisa.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/parisc/eisa.c
+++ b/drivers/parisc/eisa.c
@@ -442,6 +442,11 @@ static int __init eisa_irq_setup(char *s
 		val = (int) simple_strtoul(cur, &pe, 0);
 		if (val > 15 || val < 0) {
 			printk(KERN_ERR "eisa: EISA irq value are 0-15\n");
+			cur = strchr(cur, ',');
+			if (cur)
+				cur++;
+			else
+				break;
 			continue;
 		}
 		if (val == 2) {


