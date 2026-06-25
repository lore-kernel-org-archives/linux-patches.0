Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAD1292B4B;
	Thu, 25 Jun 2026 13:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393154; cv=none; b=NZSjyliM47XMDamQTdvzcZ3pfBcTgUHdYf42GbeLTLYE6Ycr35yYDhT3+8BL7axwwgem3KfEr/QYwpb6lrI0Fg3ysaxpryIzVcuxK8Ak+7DTPVdq9yvKfpjYIm015y5EtpPIx90sGSHBR2aPuHXLYDbgMsGvswzYbg9NCc/8idM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393154; c=relaxed/simple;
	bh=usZmfC8u7pl71oeZfEmmhPv2m/xnjmsKCYQ4HS4xcEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I14lxfv4SUR+624TBjUk1sZEcD40lxitXF623AN9NSGP02ofcT356ITuph4cjuNx7mfp9/XyczjhFPoCl1CWcXBth0E3bLfVbrHJuQdd97CffSdUpc1kjhxXIPbHQzOUsY8QYC4ojRsZhbdkdNP12zQ5cZYBKJLIWu7eEYlrQ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvLkSC2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvLkSC2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC081F000E9;
	Thu, 25 Jun 2026 13:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393153;
	bh=t6Z0Sk4o4Ss4ykn0Dp+hZayhqTQvDRRpYShA1k7SMKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvLkSC2q53y4lFJA/EFQg0+dxU7UUVooWOuHj293zWoSPI3/CRdB5dsMa0tWEgiAT
	 d+Lltu3dlcudCw+rfputUzs1/gGnap/yrWirBIMt8NmtgvXFpnels/5phE8/RLxOlm
	 IiHha5U4fHuENG+iV8EuEbn+GddfrGfqtWXSVflU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 7.1 15/21] vc_screen: fix null-ptr-deref in vcs_notifier() during concurrent vcs_write
Date: Thu, 25 Jun 2026 14:04:07 +0100
Message-ID: <20260625125615.386571785@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

commit a287620312dc6dcb9a093417a0e589bf30fcf38a upstream.

A KASAN null-ptr-deref was observed in vcs_notifier():

BUG: KASAN: null-ptr-deref in vcs_notifier+0x98/0x130
Read of size 2 at addr qmp_cmd_name: qmp_capabilities, arguments: {}

The issue is a race condition in vcs_write(). When the console_lock is
temporarily dropped (to copy data from userspace), the vc_data pointer
obtained from vcs_vc() may become stale. After re-acquiring the lock,
vcs_vc() is called again to re-validate the pointer. If the vc has been
deallocated in the meantime, vcs_vc() returns NULL, and the while loop
breaks (with written > 0). However, after the loop, vcs_scr_updated(vc)
is still called with the now-NULL vc pointer, leading to a null pointer
dereference in the notifier chain (vcs_notifier dereferences param->vc).

Fix this by adding a NULL check for vc before calling vcs_scr_updated().

Fixes: 8fb9ea65c9d1 ("vc_screen: reload load of struct vc_data pointer in vcs_write() to avoid UAF")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260604060734.2914976-1-yiyang13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vc_screen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -686,7 +686,7 @@ vcs_write(struct file *file, const char
 	}
 	*ppos += written;
 	ret = written;
-	if (written)
+	if (written && vc)
 		vcs_scr_updated(vc);
 
 	return ret;


