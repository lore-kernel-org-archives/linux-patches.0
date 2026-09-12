Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6513ACEFB;
	Sat, 12 Sep 2026 18:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237486; cv=none; b=Bql0YuJo7XcKkA5wNkDIWUXvEQxH48MDrAd8FPll0cpOrtQcCbmVSEGb1MIVwv5llZpYHf+Fcyas6JoUIpyUxE5w6rxvZ16uSX+fCMRXik3aN9wE4lgS5BAwfUxrNDOwR1ItdAqEEwERoq0AnBqumNCZvCcY5xBwCsNZyXBNNbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237486; c=relaxed/simple;
	bh=yTOHDSDeBR4a5mp62dfiBW6JeUuNsZqWL3IxadLXBv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eqn+iuNUGAIzZJc9hzH24ve21CvRK2EMWEho0KO9NrqugtvpYrwRUJuwVqNw2lLrhnESh/OaN/1opYDH1CU4p3zlAk0TpKyUVt/8owJ2v9uS/97IXMwkKD2yENYkF28uh3wtsrb7/O/MGBDwWgVj25dD6OHmtreNkTRvKXiNJ60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inuK3UkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inuK3UkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062DD1F000FF;
	Sat, 12 Sep 2026 18:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237484;
	bh=gaGeBGAx0h97pboAg4gij8x/2NMluMTFiBgGYJqJoJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=inuK3UkN4ftdM99slMjJKDjNtXtBLirM2b31nGGafo6UTo/WSn2N30rFs0O8PZFUz
	 v+aKdDHJXEOyqKUaWwBCtORwqIR5dlyuz7hat/H05K4myUzJYesIskvSXKNktgCnje
	 zjeYFqsLEx/Peh011a9HnPtCi2FuEJurtc2Jca3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 269/935] parisc: eisa: Fix infinite loop when parsing invalid IRQ value
Date: Sat, 12 Sep 2026 08:54:59 +0200
Message-ID: <20260912065532.991208161@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


