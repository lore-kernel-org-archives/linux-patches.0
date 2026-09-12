Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CB1380FFB;
	Sat, 12 Sep 2026 19:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242119; cv=none; b=t2FTBbtFupufdXdGIkLCK+V0Ue4E7N6UlJfqLnbah0BvUrpHvSdUzDKedRPhepHKVZS+nI+T/d4DxzwO88MechAg6juZpDMX9pssNfkNLV10vMv6SCkvYiZYm7TmdN5hPRaVRxYUWjy5gnW70FKx0YVD/57bqDK8mwG//MoQiA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242119; c=relaxed/simple;
	bh=fUKO18SFxF537jq6QMM2fVqR9Z/ogtHfOHSh1Wsdyr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AT+LTdXOOiLMHcq0knDhJCoPIy3dZUIlnvGcEys/opnxqr7l+0PZ57v8Lky1Q6dsY0ER3a5vOIQfquROYzY7yjgRxdWP+p8nv2jp4rpDjUVs9u1Yrfg/vavNDLaJJ6oZaKoWq9RWPjCubRx3XOdf+IhwF5Uaw37HGtrb7a0S3tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v16BKR0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v16BKR0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62EC1F000FF;
	Sat, 12 Sep 2026 19:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242118;
	bh=Ux1CSN8eTGRM5P+A9JbEMrtCzAabozYuQ4kcmc9gt4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v16BKR0AJn5uJHIrtFxMsJDexAOKrftbUHUmM546DglsXvP3WjupQ+a+FKy0kPg5v
	 4ey8UF+Ui81DKPpyK+NTpsl0Sv2YmJuR19ztgJ6PnCfd3uO/0/1nBEjo6HyrcNq+25
	 tLAnRettA8T5isyH83XiWA7Gfoma6t26Po8V/Rp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 239/798] parisc: eisa: Fix infinite loop when parsing invalid IRQ value
Date: Sat, 12 Sep 2026 08:57:47 +0200
Message-ID: <20260912065522.633424070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -441,6 +441,11 @@ static int __init eisa_irq_setup(char *s
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


