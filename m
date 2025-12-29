Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4033093C1;
	Mon, 29 Dec 2025 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025249; cv=none; b=A+2WHqiNYZVyQq4H4mphzb4S//mZp49Lse0PhA9VMpLsLzIyYalbij+bPAkYPcKHu1L3BUCFNrIQjt+Mnlul1auz7LUiTbN4n8/EyWnIuUZurmbaRbIOWQ/DSnJYhbwaZOZfLWO+aEs0vis7q1GHGE3f8BRM3uRcyPhOFuYFT+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025249; c=relaxed/simple;
	bh=Ueblse956kSb2oqz3Jec/X8Mn/Hjbxtf8Mgfs4GXVJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZAYDmzl9WYXVYofQtbffFo+9BOW0YdA+BrmC7UjGh9uzbc3VDM6GE44sotZpO3IH8qhuiFGJ3E32ix2vkour50kJdQHGI2ekRFLTOkP7XAD+/GXBJgB8eOhA3a49ZSK+GGCVA7r3OImc2TlhI/U9x1DQ17XuoFI1Lt5OCmk3ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ej32H0MB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ej32H0MB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6AAC4CEF7;
	Mon, 29 Dec 2025 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025248;
	bh=Ueblse956kSb2oqz3Jec/X8Mn/Hjbxtf8Mgfs4GXVJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ej32H0MBsuRoo0Z31ZMPwrF/5mRQLZfGICm++tNi/uKyESoad6m7j58h5Mk+loR02
	 iHdUHzmTgOB1MXmQH0jNacFuV06Eo7TYJQKwvPcbP0CWRWy09U0ipAS+7j11+cXsjQ
	 D46MKqrqhgVAh6W37cVDOozoL2slJhWpZAWZEviQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pitust <piotr@stelmaszek.com>,
	Sasha Finkelstein <fnkl.kernel@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 147/430] Input: apple_z2 - fix reading incorrect reports after exiting sleep
Date: Mon, 29 Dec 2025 17:09:09 +0100
Message-ID: <20251229160729.771876322@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Sasha Finkelstein <fnkl.kernel@gmail.com>

commit d579478cee228bdc0029a0c12a1f6a63ea9d1c77 upstream.

Under certain conditions (more prevalent after a suspend/resume cycle),
the touchscreen controller can send the "boot complete" interrupt before
it actually finished booting. In those cases, attempting to read touch
data resuls in a stream of "not ready" messages being read and
interpreted as a touch report. Check that the response is in fact a
touch report and discard it otherwise.

Reported-by: pitust <piotr@stelmaszek.com>
Closes: https://oftc.catirclogs.org/asahi/2025-12-17#34878715;
Fixes: 471a92f8a21a ("Input: apple_z2 - add a driver for Apple Z2 touchscreens")
Signed-off-by: Sasha Finkelstein <fnkl.kernel@gmail.com>
Link: https://patch.msgid.link/20251218-z2-init-fix-v1-1-48e3aa239caf@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/apple_z2.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/input/touchscreen/apple_z2.c
+++ b/drivers/input/touchscreen/apple_z2.c
@@ -21,6 +21,7 @@
 #define APPLE_Z2_TOUCH_STARTED           3
 #define APPLE_Z2_TOUCH_MOVED             4
 #define APPLE_Z2_CMD_READ_INTERRUPT_DATA 0xEB
+#define APPLE_Z2_REPLY_INTERRUPT_DATA    0xE1
 #define APPLE_Z2_HBPP_CMD_BLOB           0x3001
 #define APPLE_Z2_FW_MAGIC                0x5746325A
 #define LOAD_COMMAND_INIT_PAYLOAD        0
@@ -142,6 +143,9 @@ static int apple_z2_read_packet(struct a
 	if (error)
 		return error;
 
+	if (z2->rx_buf[0] != APPLE_Z2_REPLY_INTERRUPT_DATA)
+		return 0;
+
 	pkt_len = (get_unaligned_le16(z2->rx_buf + 1) + 8) & 0xfffffffc;
 
 	error = spi_read(z2->spidev, z2->rx_buf, pkt_len);


