Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEC8383;
	Thu, 30 Jan 2025 14:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246560; cv=none; b=DJBhBudVfel4kLbbTLM5A8ekBKo81nfiChveMK4iXYVo3i0fCRFUXP3EJLjG5LulztH4CujjBT30p9aWR0SmuEi97Gk1tN4ndbiuAT7C/NBELuI8jhVuG8D5hq04n6hcyXiH0SR1x0OkkvNaqxbmmIBXwXoMUAc6y5+H/lK/jDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246560; c=relaxed/simple;
	bh=FCZXFoFN3uabneV4473AjWVUjLKSiorjC6KlYluzm0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1S2asEk6Y9pMEjQ3l/O67ms8jZAzVWqdu84f5aiHavcg1piviAz94OwLqg6Y6vWDwHCwvSSbNfKGogylHqISSCxTmxNANzVXifZDe7ibWRJ1sTskCAYV8MSbDCbtV1LPk34AiRc5GnfLnY2zEdKWdYP9bZvCRZMd6fLvin/hx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=al4ODDLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="al4ODDLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71B2C4CEE0;
	Thu, 30 Jan 2025 14:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246560;
	bh=FCZXFoFN3uabneV4473AjWVUjLKSiorjC6KlYluzm0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=al4ODDLoIyZULP1DgO/E+meyGOmj7dYE3JkRyWaWZ+gm7S+unLXe33G9gFbY7udYt
	 FgPgsZql1hK4YZ+v8C8GKf339oFF80RWDUv6LE7EVKNAXkVNxS01+0/XubZiexW8S2
	 E5bLAUO4OEQWAw85NMnKBDnnHde8Hxgb2YiMtgRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+506479ebf12fe435d01a@syzkaller.appspotmail.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 34/43] USB: serial: quatech2: fix null-ptr-deref in qt2_process_read_urb()
Date: Thu, 30 Jan 2025 14:59:41 +0100
Message-ID: <20250130133500.275018216@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

commit 575a5adf48b06a2980c9eeffedf699ed5534fade upstream.

This patch addresses a null-ptr-deref in qt2_process_read_urb() due to
an incorrect bounds check in the following:

       if (newport > serial->num_ports) {
               dev_err(&port->dev,
                       "%s - port change to invalid port: %i\n",
                       __func__, newport);
               break;
       }

The condition doesn't account for the valid range of the serial->port
buffer, which is from 0 to serial->num_ports - 1. When newport is equal
to serial->num_ports, the assignment of "port" in the
following code is out-of-bounds and NULL:

       serial_priv->current_port = newport;
       port = serial->port[serial_priv->current_port];

The fix checks if newport is greater than or equal to serial->num_ports
indicating it is out-of-bounds.

Reported-by: syzbot <syzbot+506479ebf12fe435d01a@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=506479ebf12fe435d01a
Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
Cc: <stable@vger.kernel.org>      # 3.5
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/quatech2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -503,7 +503,7 @@ static void qt2_process_read_urb(struct
 
 				newport = *(ch + 3);
 
-				if (newport > serial->num_ports) {
+				if (newport >= serial->num_ports) {
 					dev_err(&port->dev,
 						"%s - port change to invalid port: %i\n",
 						__func__, newport);


