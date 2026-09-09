Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072EB563FB7;
	Wed,  9 Sep 2026 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962103; cv=none; b=iRBlp1siwJVVI+9vbhAT6axh1Vrg1Yj1kIo8JXMSEZi/9IImhBHD7bDD35Hx4S6SW38QMFxpILsW5cUohhc0gTnEQkJpsQ3Eg1+CkpQGvAvg3jeHPf9Nhf6dtoUCNK1EpjfP2bYTWiOoW/MSi4oa7Kl8sG2f8dHu5QXR/2lS6jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962103; c=relaxed/simple;
	bh=sT7GEoW8V3uSm9upzRA7q3RFEaWdR38bef5Zi4sxFWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYH+skAwvQbx+sOz1UY5HKd+JDMsjvpUgWtMTfH210rAN1Y8r/j4LQZzAvvR0xP8PjVSHqk5+eRHu7QLMrbtpJ/5TuAfcOJUYqwA96VRkZnaNrjFyrHJMjl3lEIOqa7S7u5XUsAMfdOmYZQJyBNtleWEfKWLaOmpZ2blfpo1WWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0v5RHAGf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0v5RHAGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8F81F00A3A;
	Wed,  9 Sep 2026 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962101;
	bh=2uUNSk0Kc6NSXRzLy5fch4lLD+gSL63xIPvF/X76Aj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0v5RHAGfgOsP6PPIgloA2xvqZ7aZeC2MnYRSyXFjFuvOWyWNEPUmqoSk4OIIicT/1
	 U3rgwtwjsk9F1ikKYDH81N11Xyj1Px0eISguS4CATfz9yoldfZ8Wp9wBPA7ql0IL3B
	 Hj9jJJT6Hu5gw+rXjkY4aKTR1vDTYjP+DV4Z4ygQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.2 175/556] parisc: eisa: Fix infinite loop when parsing invalid IRQ value
Date: Wed,  9 Sep 2026 15:37:35 +0200
Message-ID: <20260909134236.572457279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


