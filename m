Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA0B43D503;
	Tue, 21 Jul 2026 21:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671163; cv=none; b=YTwk1LaLIR+cGh/Hh+WKvv7gqRckmouPqWiN5cVEQSXSvlBLR8cdgsVW/GOo7fOGwayqW/xt82g655TJd0VgTLycdCWIwYeR6tegtHJxqp7TLbMCoBubC5NHc65J+iQ0EvJ4E91p38TMqzQ4J8QPTO740KX8AEJ/u7R8swOWlg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671163; c=relaxed/simple;
	bh=jvcemV2Nt9XTgvzs1OiDeNrP9EdypLgrDecSYzIH7+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhQB8uux/U/C65Mp99aohnW4I8EiXXL5Fvp5Cfes1YlL2vX5P3DtVW1z6xiT9rkn6GAB+l2B9htt9lEux+udJ37Bp2gKUNzwpLgSYUeEXNBLX7TQBJhx4qUAKr9XitjCSbCyEmq5YzCmK5+Hs8jYCDOx4QZOia/iqtVe51RYZ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p46NzaQf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p46NzaQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640821F000E9;
	Tue, 21 Jul 2026 21:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671161;
	bh=c+TAKL28BM0SHmXnXmBAPMpaivoycgCbcsWbMRvv9zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p46NzaQfWgqL3K6K5gvq5NESMYD7hSGePatULwSZfEHoj6MLVJ+1y6kqeU16745eb
	 BUTg1tlzxzBF9Vv5CRY3lrT+0YJFEKXONWf89NnQd55KNlg4NmBeB0F8s9trUWr9bG
	 QwTG82IwGCybfOCLs75C5tSXofGo0sgJJGsWfwZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 143/843] USB: serial: keyspan_pda: fix information leak
Date: Tue, 21 Jul 2026 17:16:18 +0200
Message-ID: <20260721152409.230027857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 6bfc8d01ac4068eced509f8fc74d0cd205e4dcec upstream.

The write() callback is supposed to return the number of characters
accepted or a negative errno. Since the addition of write fifo support
the keyspan_pda implementation will however return the number characters
submitted to the device if the write urb is not already in use. If this
number is larger than the number of characters passed to write(), the
line discipline continues writing data from beyond the tty write buffer.

Fix the information leak by making sure that keyspan_pda_write_start()
returns zero on success as intended.

Fixes: 034e38e8f687 ("USB: serial: keyspan_pda: add write-fifo support")
Cc: stable@vger.kernel.org	# 5.11
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan_pda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -524,7 +524,7 @@ static int keyspan_pda_write_start(struc
 	if (count == room)
 		schedule_work(&priv->unthrottle_work);
 
-	return count;
+	return 0;
 }
 
 static void keyspan_pda_write_bulk_callback(struct urb *urb)


