Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3749C2D3A69;
	Sun,  7 Jun 2026 10:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828579; cv=none; b=tw5QxE6z8IyEAj2jF6sxUXDUCik+m19RqIqdGR7+zZMdWUnAfOWvhSu1af1rI1oPYrnSOhEBBtAexducZRg5SA4RxhN2LfEy9OJKNLz3BhzjMXfxgf0tfD6exDcQt2qxawYz4+iIG+qE96zfsWPSmZjsoknW+juig0J+euJWzsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828579; c=relaxed/simple;
	bh=McylQNd1GvpJTfwRgqRv0DxP/SU8j4htkU/hRPoy9tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1MIUsvzeV9AATabStqLVWSsMmUCGDP1xC10tM7wn3XA311K8nLzOP629xUWB0YqJkO9mPQooyzDg6fcADkpa3BMfUZHT+RIs6rmPZ+D6cSqKzp4pJYPJb1pQ8Nj1vu1nNaqMUA9JZiwwQb/RMv4otX6u1WYtF1SyLV8+6SmE0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjBhH/wA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjBhH/wA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482C81F00893;
	Sun,  7 Jun 2026 10:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828578;
	bh=0XxCih5J20vg3yfPPTudKnMTh/jAc5DL4s27ya/p5ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YjBhH/wAUMBrwQpK3evAstHF8XZC2XL7IE+0NlSMkPIt4y+yluvp/G6OUdfUNIi7B
	 vYtbCkVzik8x12VIBASLCcQzFdf7RvKT0Fg1PXcxu0ZN4QPOqTz/cT5GiQ6erww9Vg
	 j9NQ+Y3BoB8ZZKC/EqGMuEbkJpbTx8inxPiRiajk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 149/307] Input: xpad - fix out-of-bounds access for Share button
Date: Sun,  7 Jun 2026 11:59:06 +0200
Message-ID: <20260607095733.198791924@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
@@ -1081,10 +1081,10 @@ static void xpadone_process_packet(struc
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


