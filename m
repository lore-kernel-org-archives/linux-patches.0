Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFD238837C;
	Sat, 12 Sep 2026 15:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228088; cv=none; b=CEbR8L8RXjPpYrtDsMbGwFdgcrkTxZvdr4IE0H7dpDerdWtg0X1RUmOuYs5kMrNw3XxMG7oKb2WabN/bDhzrt0+j7dbaQR29wUjozkOOWtwF7DxJzpqq0tDugRdicmpmuDcKRq6IQW+evuDxYxmVbeJLjMb92llbyeFnUpe7hsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228088; c=relaxed/simple;
	bh=uyTmc1QF24ODX4YFlrCmZwbuy1Hlr8n/SLHJHUrup4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mO5JxTA+gPIMA0qjeh+b27OJz/w5RbwdtQXtGkr2CWePng+gnjS5q9aC6ng2nqj2sviQFyeatTXS39syRe0QRQx4195DEfcHDAVGb81bSHXgDxiWRKpAxOxyFAY0fG7QMtuQpQJQ1XkH0bFM82Prc6cZI+w3seYZvSE/JTusfM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSpft5Zv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSpft5Zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B971F000FF;
	Sat, 12 Sep 2026 15:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228087;
	bh=FGvv0z+ghpOe8P9ximFzLm0Bx+gDOtIB703XPy7s6fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSpft5ZvipA8aIqDwxDDLw1oxcb+Bcm4WK+ZZpnxEBjrf3eHRvQ9uG4zoQvf//NJT
	 fAL1ddAEFCJ3dmoCos2ek+nknEKtrN1dt3QPtwqWayVvk/sFqy2OxV44yT09SYFEQf
	 m7SZFFheEP5frhBq9NZLvRD1ZiXS2fZ1P74TWLIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0313/1191] parisc: eisa: Fix infinite loop when parsing invalid IRQ value
Date: Sat, 12 Sep 2026 08:50:41 +0200
Message-ID: <20260912065555.261746665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


