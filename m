Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353FF326927;
	Sat, 12 Sep 2026 13:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221422; cv=none; b=A4SMxtvJQOp8Rc/ySrAcLJsR9HNXFRwKbPzSHR0JAkWVJIP3JuAWKKuZkUQapbGZjncMYH3/FoszXIDcouHsi53i983YnhZE1HYwmEbl9XQM5wYDepOISjljuRh6F1sCAUwrGp5h9B/0sE45z6oWFOYdH/ieEYhcQzD9HxxMg/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221422; c=relaxed/simple;
	bh=PFqy5t3Ko8B5Ez3QD0rEwUS7Jh4n3E+8qUBGb/0S3iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqkh26LJP8T3vXQoUTN6TjJ12NyYXJHCk88Nnad8Vjv00SqXYlTf7leQq+5RSTv0YSeSKvTLxYtlTa0ETX55LTWhqo3Ev8oiB1yxUcBEEpPUtEbAnZ/od7xyANIcVFR03n/kl0PaI63qCvHMqLPKDqHn1w6thDHrVdI5hSTQn0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SH7Vk+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SH7Vk+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C498B1F000FF;
	Sat, 12 Sep 2026 13:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221420;
	bh=MP+MfjV1v1CytueRlaBT2N3a5Bly57O80X0ypAN7Lk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0SH7Vk+m6MyFKE8fNehCaT9WrcI7LUZXCrjyWVS1p/jo0H/GJbPWFBnvb95jjNLZt
	 2mOs1RPDGBKje+4UOHrUiH8cLV8io20T6Vl0A8A2eyQaKpZ3PzN053AQw28NvvV56+
	 2uDerbcRCSeKzlmH9AknZ9W2+gI5QMZYHoOGgn/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0378/1424] parisc: eisa: Fix infinite loop when parsing invalid IRQ value
Date: Sat, 12 Sep 2026 08:46:50 +0200
Message-ID: <20260912065615.756774957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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


