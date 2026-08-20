Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D4037CD47;
	Thu, 20 Aug 2026 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238898; cv=none; b=ml3aDSgLO9F7S9j+2134jy6vvl2fAQFPvpPqoN1Oc/PgvOrsyqE4lt+JHbMGe/egHpjADiilNpk5Whnp1SvhGJZ0Z8tsJrSM0RZSsOKn/hnCP1oG/UuiQ2TM5ovsxtDR49j6vytD/SwEECbq6ou94+jF1TKFuPcE18s716as16E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238898; c=relaxed/simple;
	bh=hiDbVmp1aoDObZowJACTnPaOsqKKlxHuMm4vRmxsslM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8FRRMKS+TAq6uXJkPwXnUQa3JnUlbi3th+IWWy2P/3gNZQCaVUiIAJf5qiP/mSaglW8SqjkBPc5+y62CLv6QM3NUhha+YlhFq72MlngaLmkhnNGDRV/GMk+XASw5JlDjln1DcFRcug3CS7Co2cOmtgzOvYIqp0K3kgH/C6eEaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OprwB3Ay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OprwB3Ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E49D1F000E9;
	Thu, 20 Aug 2026 15:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238897;
	bh=CUQZ2UJ9Zsjq/a4rpsDbePiGi7TXJtgmwpvC3xXRUzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OprwB3AyhJx8YvpwoVNLncpJXCPcAFdu1J/HXJ45dcmG49PjavASa0Tez8xhSbxmj
	 elDyB2YDsZmGMMrJjnZk6nEEUrDK3L0cvMYDWOr25M+2DsyHW8h83obyH4K9h/z1bd
	 uuaddE3LovOPwd14cAK+y0aYwWaQMA0xz7J7glu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 040/217] Input: byd - synchronize timer deletion before freeing private data
Date: Thu, 20 Aug 2026 16:53:28 +0200
Message-ID: <20260820145238.824934472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

commit c83e79c0842ed29860648bcce5022ef0ba5001c6 upstream.

byd_disconnect() uses timer_delete() before freeing the driver's private
data.  This does not wait for a running byd_clear_touch() callback, which
dereferences the private data and its psmouse pointer.  A callback racing
with disconnect can therefore access the private data after it has been
freed.  The timer can also still be re-armed by byd_process_byte() while
the disconnect is in progress.

Use timer_shutdown_sync() before freeing the private data: it waits for
a running callback and turns any later re-arm attempt into a no-op.

Fixes: 2d5f5611dd0d ("Input: byd - enable absolute mode")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260720061259.1601281-1-lilinmao@kylinos.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/byd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/byd.c
+++ b/drivers/input/mouse/byd.c
@@ -425,7 +425,7 @@ static void byd_disconnect(struct psmous
 	struct byd_data *priv = psmouse->private;
 
 	if (priv) {
-		timer_delete(&priv->timer);
+		timer_shutdown_sync(&priv->timer);
 		kfree(psmouse->private);
 		psmouse->private = NULL;
 	}


