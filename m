Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E70533F59A;
	Sat, 12 Sep 2026 11:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213431; cv=none; b=Wp3qopcIfDKCynPqhNRBNJCbippWUv85VIyEwT2cxgk0Dc61i8jMvv3gGkpVmwqNtjLnnDNnP4TXc/SpSeTPbRH6LIwZrT19+tbjkC1IcJXzQSTMhyJ5Gy7rWdJCy3INkWBK6OwMa7ZolCnlfxhaL8/ZcH+aREKjnvjjx3sY+Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213431; c=relaxed/simple;
	bh=MdtbDw+OwJ8ZR2ttcIbLvg3AOijgLEOYbVcfo0MpQ0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmkHNZXkQGpCAY1NtPIjQgfSAqIOO6P//PgKhaPliYyQtWzCOZzEJKZMUjuDExvkB3rsniYwr6W0Y4T+909MgPG+WJgW+ZMKOBKTcFwFdsRqG2jx8pKxjL/es/FF+ut/1bkzwibbhzhhHm0MIobcL13N3q27MnVg91BPAWoR5vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHxMhU8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHxMhU8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192E61F000FF;
	Sat, 12 Sep 2026 11:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213430;
	bh=8O19Fc2aUWgywKNYHUmB0WrhUNu31oYOlfXsXpOAKlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHxMhU8+NLNLDJTKqYz2QMa+VsDUugfZcenAAguWN24f/XqF9KK26/wLkC+c+goqW
	 +qELWkmY57mwi4QjRzRxHlFvx60O7ZFxtYLY6vMJCSCpVvnxeTgvtfetwG1Cvdd+sX
	 Ryf7SjkBY5oeZLzIztNiK28NqXmsqK9MJaNpr19k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0093/1376] parisc: eisa: Fix infinite loop when parsing invalid IRQ value
Date: Sat, 12 Sep 2026 08:41:59 +0200
Message-ID: <20260912065609.635043504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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


