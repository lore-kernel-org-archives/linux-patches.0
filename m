Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52FD324B06;
	Thu, 16 Jul 2026 14:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212272; cv=none; b=RgYbhupXigHi88TfsqBhLXbcT4FxVabbVYsU30bRVDfn1A2EzFlP/plsBj/1QXF5twIudlMG56I0/4Op0i2avJ/8nSGJdoM8jyYgY8lGNpO6nXudPgZeo2TpumBAHgVx3zh/13lugo+pCjppNqxqIaAidYsFO939xGI9d+5oa/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212272; c=relaxed/simple;
	bh=DorYq905fJj6upzL6WaqCK8D5BqIi1U9F4CdxV7PF9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqQbRPXz25ws3/yJZZeF//b49xZK3V0veIb8YICe4V3p3ofnSwzx8kw1dhlKhPNkVdVUfjBNfl5kHDX2RKO/lrLsJXcxIW0l5I4xkfoH1FFRRbaJ8unb+Th+mWPj38gOdcDMJ4u21xi/v7Co4/fyb69stMkxoGmGAeU+RA4k0Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOc0/in6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOc0/in6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144751F000E9;
	Thu, 16 Jul 2026 14:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212271;
	bh=kVlKOIUfWq7WHWpbbJZo8/LpzaP1OMQ0YU6tmybV7Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOc0/in6JzVtW+yxOLQJf5/8bPwZdYPkvOPaTpe9somfZPaBZ86bjb215XfkeeWGN
	 UJs3nEcL+Ye2jQc5Oo95KkKCYZNLZhb9vDlnx6CjwO3tT8qCsMJHO8dw5sYdBNLjBf
	 UC9sWEhogfh5uBie3PT/+eXafrnsJnQrGoyYydEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 237/349] USB: serial: keyspan_pda: fix information leak
Date: Thu, 16 Jul 2026 15:32:51 +0200
Message-ID: <20260716133038.667023705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -518,7 +518,7 @@ static int keyspan_pda_write_start(struc
 	if (count == room)
 		schedule_work(&priv->unthrottle_work);
 
-	return count;
+	return 0;
 }
 
 static void keyspan_pda_write_bulk_callback(struct urb *urb)


