Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3808BFF;
	Thu, 30 Jan 2025 14:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247449; cv=none; b=meRnmGFa227mrVwznJz50LWCp6R9NsTqa844o5bxwbPESkYQ9H4Hvdak4mQO+fGHSzOr2k6EYRylam97pOAmIgco8AlJoQvu7rjHdvfAzLjHKvf51v4X4OhSfakpiCgWHjlhhibB7OnEQRO689Y5RKW2Yno51ni9eVuDE2ZXt8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247449; c=relaxed/simple;
	bh=LXzBgQ/t9VxWgQbdawCX0GNxPKYldM9Tv4QUORZPSH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni73u15YeWr5cRmdXNs+PryUu07aVav84EGp5Az907Gx9JB7M0A6uveJCWZ5h/BK0EGSZV/zj3Y9/dXpahGNr15UF4ybUdXBXmXZ/YzZVFAFmGkcIE7Z/l2rL2F/0Dyp8oXJqVjamKTvRk7OBqn3g34JBHC2sex5nIf2jiy7olc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJwTnz1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJwTnz1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B21C4CEE3;
	Thu, 30 Jan 2025 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247449;
	bh=LXzBgQ/t9VxWgQbdawCX0GNxPKYldM9Tv4QUORZPSH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJwTnz1onTrsxJSyqQ2aCGu6tg3V7TqOCuDq7ypUxBVY2eVknthm06Ma6L9M16E3R
	 vHpVtsOr4Elg5cV6w4qCqixZFaZN5hntY2GhiVHjSUhQbzS42TC6NhcPOg2k0Knt31
	 3HegrdNPRRthaHBIE0eMFdobnjIM0IIqdKBVMBpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+506479ebf12fe435d01a@syzkaller.appspotmail.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 42/49] USB: serial: quatech2: fix null-ptr-deref in qt2_process_read_urb()
Date: Thu, 30 Jan 2025 15:02:18 +0100
Message-ID: <20250130140135.517060947@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -511,7 +511,7 @@ static void qt2_process_read_urb(struct
 
 				newport = *(ch + 3);
 
-				if (newport > serial->num_ports) {
+				if (newport >= serial->num_ports) {
 					dev_err(&port->dev,
 						"%s - port change to invalid port: %i\n",
 						__func__, newport);


