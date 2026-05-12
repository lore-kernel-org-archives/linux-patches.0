Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B5834405B;
	Tue, 12 May 2026 18:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609350; cv=none; b=SYng9HmGegBYhuMuNd036/SdaOA8PO7Fy1mvXhN3iscTfsv4bi22DV9RoXzYmgIPcx0wiSp8GmzDu8PVHq59JfqfygDlSKh1kIDVpdBpF5OUFsFZl+gh5QLzTwdBcilfe7HWW4MiFJY4KJhNpxaFde+zoFYcFSl/eoNsfMRi4Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609350; c=relaxed/simple;
	bh=yidKdEa1MhvAKfPJMIIVol9fyN2vbgRHhrhnny+8/kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vnloh31TCoAFE1fBeZjpzDL0iKlxIfl0gUrtz3wjlhwMWx0whNo90IQlRlkCR0tLa3kQRJWOHa6HT0o/yQ80sd47Ve0eUFZfbs2BU+x3EyDubLiZr24J8MIh3dHoL9N4v6cCm2I/t3lQf8CAsyVhQ6QNYmoLEOf4Yyp06uUjB1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=equ02+2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="equ02+2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D625C2BCB0;
	Tue, 12 May 2026 18:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609350;
	bh=yidKdEa1MhvAKfPJMIIVol9fyN2vbgRHhrhnny+8/kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=equ02+2eLCSjUVF3GroOoAAKXntF3DWeqDOtrHxfd05IvWyoSDtQFgorkNTOBT5+U
	 e97/7NzuGu6D9kFQ1ZQ0PMUuFaHjDU0jKO5dvZLLUp2zD0wzCtcud+KaErV7CHYKv3
	 ojiVY5ECNsbZCj6Ju9ehc16FMzIR+YXPfT//ZviU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 119/307] net: libwx: use request_irq for VF misc interrupt
Date: Tue, 12 May 2026 19:38:34 +0200
Message-ID: <20260512173942.638814594@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 7a33345153eeeda195c55f15be27074e4c3b5109 upstream.

Currently, request_threaded_irq() is used with a primary handler but a
NULL threaded handler, while also setting the IRQF_ONESHOT flag. This
specific combination triggers a WARNING since the commit aef30c8d569c
("genirq: Warn about using IRQF_ONESHOT without a threaded handler").

WARNING: kernel/irq/manage.c:1502 at __setup_irq+0x4fa/0x760

Fix the issue by switching to request_irq(), which is the appropriate
interface or a non-threaded interrupt handler, and removing the
unnecessary IRQF_ONESHOT flag.

Fixes: eb4898fde1de ("net: libwx: add wangxun vf common api")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/786DDC7D5CCA6D0A+20260429083743.88961-2-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_vf_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
@@ -98,8 +98,8 @@ int wx_request_msix_irqs_vf(struct wx *w
 		}
 	}
 
-	err = request_threaded_irq(wx->msix_entry->vector, wx_msix_misc_vf,
-				   NULL, IRQF_ONESHOT, netdev->name, wx);
+	err = request_irq(wx->msix_entry->vector, wx_msix_misc_vf,
+			  0, netdev->name, wx);
 	if (err) {
 		wx_err(wx, "request_irq for msix_other failed: %d\n", err);
 		goto free_queue_irqs;


