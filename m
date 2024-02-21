Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD05B779F8;
	Wed, 21 Feb 2024 13:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521625; cv=none; b=m6W4+8DaaEDLJGFY1dDYyIMD2tuVDnOGBTOS0zfAeyjfLvScfSoLHgRCUn5KzB3XN1zTscYwF/qKmpo1OiUJpTUunSMvekR2G6oLGD89NxQit1z+DdRZSic2LkXfi6PPpTPxZ9xh0bVrDvNbEuHbLCnBGPZ2VQu/wxupuqiFfKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521625; c=relaxed/simple;
	bh=/xE8ljW95fiZHcN6kwIz4H0my6ahGieTQSz0UOmH310=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAw7HaE6xbbowWKfwtwxWTD3aBvjsptbS9CIyUWbyRUe2EULJu4QwfWUOAJ2YnKyPj20kupcnKEPfQFZceG0fLEuhGl7epti5HhWOq24V6VcrlbkKSyCh3efXYeBmv1RFIC2CBMewR4oWGOgwFC9K5q1TkRtZgx2lBu5CJyr1EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPKNxCuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPKNxCuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3268EC433C7;
	Wed, 21 Feb 2024 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521625;
	bh=/xE8ljW95fiZHcN6kwIz4H0my6ahGieTQSz0UOmH310=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPKNxCuY9BMlWxq+RaCCovap+pmdhx/rf7vSJHmBjszbjp659ndn8/uamGgO0kr5A
	 n1xhL2wkGVooYiZ+Z4zWEI26vs6Ma4gTuD6axBwwNMP1jGqRGHzx6f4aH6YMcluCyW
	 4OHBvAMy66olwQqAt0VmKvPoHFuUltCOMoQ/yxaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 162/202] Input: atkbd - skip ATKBD_CMD_SETLEDS when skipping ATKBD_CMD_GETID
Date: Wed, 21 Feb 2024 14:07:43 +0100
Message-ID: <20240221125936.960246750@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 683cd8259a9b883a51973511f860976db2550a6e upstream.

After commit 936e4d49ecbc ("Input: atkbd - skip ATKBD_CMD_GETID in
translated mode") the keyboard on Dell XPS 13 9350 / 9360 / 9370 models
has stopped working after a suspend/resume.

The problem appears to be that atkbd_probe() fails when called
from atkbd_reconnect() on resume, which on systems where
ATKBD_CMD_GETID is skipped can only happen by ATKBD_CMD_SETLEDS
failing. ATKBD_CMD_SETLEDS failing because ATKBD_CMD_GETID was
skipped is weird, but apparently that is what is happening.

Fix this by also skipping ATKBD_CMD_SETLEDS when skipping
ATKBD_CMD_GETID.

Fixes: 936e4d49ecbc ("Input: atkbd - skip ATKBD_CMD_GETID in translated mode")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/linux-input/0aa4a61f-c939-46fe-a572-08022e8931c7@molgen.mpg.de/
Closes: https://bbs.archlinux.org/viewtopic.php?pid=2146300
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218424
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2260517
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240126160724.13278-2-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -763,7 +763,6 @@ static int atkbd_probe(struct atkbd *atk
 {
 	struct ps2dev *ps2dev = &atkbd->ps2dev;
 	unsigned char param[2];
-	bool skip_getid;
 
 /*
  * Some systems, where the bit-twiddling when testing the io-lines of the
@@ -777,6 +776,11 @@ static int atkbd_probe(struct atkbd *atk
 				 "keyboard reset failed on %s\n",
 				 ps2dev->serio->phys);
 
+	if (atkbd_skip_getid(atkbd)) {
+		atkbd->id = 0xab83;
+		return 0;
+	}
+
 /*
  * Then we check the keyboard ID. We should get 0xab83 under normal conditions.
  * Some keyboards report different values, but the first byte is always 0xab or
@@ -785,18 +789,17 @@ static int atkbd_probe(struct atkbd *atk
  */
 
 	param[0] = param[1] = 0xa5;	/* initialize with invalid values */
-	skip_getid = atkbd_skip_getid(atkbd);
-	if (skip_getid || ps2_command(ps2dev, param, ATKBD_CMD_GETID)) {
+	if (ps2_command(ps2dev, param, ATKBD_CMD_GETID)) {
 
 /*
- * If the get ID command was skipped or failed, we check if we can at least set
+ * If the get ID command failed, we check if we can at least set
  * the LEDs on the keyboard. This should work on every keyboard out there.
  * It also turns the LEDs off, which we want anyway.
  */
 		param[0] = 0;
 		if (ps2_command(ps2dev, param, ATKBD_CMD_SETLEDS))
 			return -1;
-		atkbd->id = skip_getid ? 0xab83 : 0xabba;
+		atkbd->id = 0xabba;
 		return 0;
 	}
 


