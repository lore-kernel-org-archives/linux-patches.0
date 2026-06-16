Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F2B32B138;
	Tue, 16 Jun 2026 16:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628474; cv=none; b=dQcvny6YLw8UqjZ9+OHRI4TKV0R5K7A0VGFVS50psdEz3YP3067k929IRbIFXMB3ErgvgvdwZnhm+3wmZoqszXSEnHWujfrsTomUrlkYUzkFuLR7gPRpxr/2N55vyX9N1FdQ+n16XCpjMibliNnZOLfdn5/Ebha41mBqmQfNwMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628474; c=relaxed/simple;
	bh=jaulM1O2Q9Ya1CGtdsJsLT8LFtWj79nxTQLAMKLRfW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkpOwhmikjN76tlEqDUa9KyruvnGe/LRiykdgEoSRq3ZPCeU/aWSYG8XhftOgKTuqjDzV+vj3pvNa9AMX12lpLvR/KxoMp6w07eayZymddk8mI0tnHf1r8Gg8oLaRMY+lpO6s7PeBtFZBdV/vMZYfsCU16yg9XTKCCKvlYWedK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1MXq1Aw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1MXq1Aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6771F000E9;
	Tue, 16 Jun 2026 16:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628473;
	bh=Vf51AqiiDne+SOa5KZHV7Zrr7u1ZoMIpL7jvfiEYNqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1MXq1AwZEF+UtbTdR3j6YGrU5GPgFrWTUv4NUn7RMBwLeVXBKhEEQL3OochXmpL8
	 paj5sLVsIKtc9gHz6Zl6KrVUTZbwOxWziwb8HUk8a+hwdo7gJWJ1Rj/x/NHHXCrz/A
	 nBfqO/hnu43UZCU/UvaLQtJhP5aYKCWJy4jiOc+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 102/452] Input: xpad - fix out-of-bounds access for Share button
Date: Tue, 16 Jun 2026 20:25:29 +0530
Message-ID: <20260616145123.141680631@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 6cdc46b38cf146ce81d4831b6472dbf7731849a2 upstream.

xpadone_process_packet() receives len directly from urb->actual_length
and uses it to index the share-button byte at data[len - 18] or
data[len - 26]. Since both len and data[0] are under the device's
control, a broken controller can send a GIP_CMD_INPUT packet with
actual_length < 18 (e.g. 5 bytes) and reach this code path, causing
accesses beyond the actual array.

Fix this by calculating the offset and checking bounds against the
packet length.

Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 4ef46367073b ("Input: xpad - fix Share button on Xbox One controllers")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -1079,10 +1079,10 @@ static void xpadone_process_packet(struc
 		input_report_key(dev, BTN_START,  data[4] & BIT(2));
 		input_report_key(dev, BTN_SELECT, data[4] & BIT(3));
 		if (xpad->mapping & MAP_SHARE_BUTTON) {
-			if (xpad->mapping & MAP_SHARE_OFFSET)
-				input_report_key(dev, KEY_RECORD, data[len - 26] & BIT(0));
-			else
-				input_report_key(dev, KEY_RECORD, data[len - 18] & BIT(0));
+			u32 offset = (xpad->mapping & MAP_SHARE_OFFSET) ? 26 : 18;
+
+			if (len >= offset)
+				input_report_key(dev, KEY_RECORD, data[len - offset] & BIT(0));
 		}
 
 		/* buttons A,B,X,Y */


