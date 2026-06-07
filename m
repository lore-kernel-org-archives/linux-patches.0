Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E352D8378;
	Sun,  7 Jun 2026 10:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829239; cv=none; b=KzsYhsiOovCdi/13dsUx6WABNpL6ABLIU2FYwtsCviQizjwsxDAYMlVnY9pW9FTWH+aGm8wUw/ouHkNmjj5F17KZHjVCVvUWm8fRt12glLiOEvJFBiCIfOas1em5TIob+KXAbAIxpQNg7sUuK8KNsXIY34xHTksV83gRdhVESb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829239; c=relaxed/simple;
	bh=heSlknBKk15DZsflWulc2PQdueZd39mO5AdTmTvVkX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNcdecU9uN3a2e/qi7YDBsfBRsFTRj7GIKiiOySQLacwoOZu5RRAIfkuq2zQ7HgvZPB3aXqpHzC5D2bhG1Ki1jSQ8tS7i89NnOzxN5WiFSrtXZ8vCmrDkAho+HbBDqkZe71imwX0W4N942AlSZD6ZTnx3l1KMKA192FiGWBZ0WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Suo3wKMv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Suo3wKMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BFC1F00893;
	Sun,  7 Jun 2026 10:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829238;
	bh=PPZiDLFU4iS24uEp0khFpdB/jovhPdfkPYCtB8hKWCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Suo3wKMv9L4k/4x3Q9ivsVFY5NVOxkEpxIs6EywnKAu6K9tUYu5CrfBs8dNCo5iQ9
	 IMUcL6AWtvc7vLAidbMqise4kBy7En9r29DmXORhI8va3Dtp3BwNz/riVTLiN7B/6K
	 E82Bf90e6n61ousjy1AP1lUDoesfocARXfLvEB8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+abbfd103085885cf16a2@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Michal Pecio <michal.pecio@gmail.com>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.18 228/315] usb: usbtmc: check URB actual_length for interrupt-IN notifications
Date: Sun,  7 Jun 2026 12:00:15 +0200
Message-ID: <20260607095735.949323625@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Heitor Alves de Siqueira <halves@igalia.com>

commit 52f2ad3f7e5eb3b5908e1d685d4342519dc9cfcd upstream.

USBTMC devices can use an optional interrupt endpoint for notification
messages. These typically contain two-byte headers indicating the
payload format, but the driver does not check if these headers are
present before accessing the data buffers. In cases where the URB
actual_length is not enough to fit these headers, the driver will either
cause an out-of-bounds read, or consume stale leftover data from a
previous notification.

Fix by checking if actual_data contains enough bytes for the headers,
otherwise resubmit URB to the interrupt endpoint.

Fixes: dbf3e7f654c0 ("Implement an ioctl to support the USMTMC-USB488 READ_STATUS_BYTE operation.")
Reported-by: syzbot+abbfd103085885cf16a2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=abbfd103085885cf16a2
Cc: stable <stable@kernel.org>
Suggested-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Link: https://patch.msgid.link/20260505-usbtmc-iin-size-v3-1-a36113f62db7@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -2310,6 +2310,14 @@ static void usbtmc_interrupt(struct urb
 
 	switch (status) {
 	case 0: /* SUCCESS */
+		/* ensure at least two bytes of headers were transferred */
+		if (urb->actual_length < 2) {
+			dev_warn(dev,
+				"actual length %d not sufficient for interrupt headers\n",
+				urb->actual_length);
+			goto exit;
+		}
+
 		/* check for valid STB notification */
 		if (data->iin_buffer[0] > 0x81) {
 			data->bNotify1 = data->iin_buffer[0];


