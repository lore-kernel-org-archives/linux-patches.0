Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4045126A1CF;
	Mon, 13 Apr 2026 16:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096813; cv=none; b=iQ247tnALTQLCE62ipdD9NS8aGDh8dYO1AHJVtnPe+svb+7ZCfwjck2JtpmOjQoMXxPG8mA1NhXUdLcBzs1Aok0tMApQsUeRhN1dpC8EignUd1ww7RW/FJnoAOzBEGWwjWlQfyOkcJApj20kC1O8QzaIKGWPVpIN13oY854hP3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096813; c=relaxed/simple;
	bh=9OJ/xjAKrukhwq1Sk+iyhZl63Oou5CpYtprOlRXKMBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpC+D9TCmgmFEVxlLjMKdMf81I1nQBiv8hffK37FVBvOuRtAyO9CSaig7Ql68E9226Ej27gFxhUDabLKN9cWUUe+UfWv8Ci6mEwY7gjkhBIc/DCpWk2RPfzd6EWfqbvXMhCVf/SEGvQ82cLWWiT+AuaR7I8Za7e3YS6ttKgVf/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FoY2Ecaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoY2Ecaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB99FC2BCAF;
	Mon, 13 Apr 2026 16:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096813;
	bh=9OJ/xjAKrukhwq1Sk+iyhZl63Oou5CpYtprOlRXKMBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FoY2EcajAw5F1GZk6vd+IrEEQsAnP/eHbipnirl4ZCpijApUP3OYNktgGB2XTNRCM
	 IInh8wge6gtwLRHjLlmoVX2fJQ3/ECzv96/lfht2fCDzaCQ23BO30ppPbSILkIucre
	 dXlDbrZux6DOSk39j6fuEQwEr0npRsQLV1MduPC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 52/70] mmc: vub300: fix NULL-deref on disconnect
Date: Mon, 13 Apr 2026 18:00:47 +0200
Message-ID: <20260413155730.127584028@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit dff34ef879c5e73298443956a8b391311ba78d57 upstream.

Make sure to deregister the controller before dropping the reference to
the driver data on disconnect to avoid NULL-pointer dereferences or
use-after-free.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2369,8 +2369,8 @@ static void vub300_disconnect(struct usb
 			usb_set_intfdata(interface, NULL);
 			/* prevent more I/O from starting */
 			vub300->interface = NULL;
-			kref_put(&vub300->kref, vub300_delete);
 			mmc_remove_host(mmc);
+			kref_put(&vub300->kref, vub300_delete);
 			pr_info("USB vub300 remote SDIO host controller[%d]"
 				" now disconnected", ifnum);
 			return;


