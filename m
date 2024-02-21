Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C13F7992D;
	Wed, 21 Feb 2024 13:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523095; cv=none; b=fvfEQk3CZDptiXMNdkpTkEg1EbfGEfsd0s1MROhVdllVf2BGjWu5C1S++JDEh5sU4cR2v3PhjYQZ32Ve0O1PTcMjDMUpb+qWMXfDQY6QGAROMk/uXV7CQuVhoYGHigICe3BpzBPPdxWpXCvL/Uz1Ki3gtkg4Kw6TZuSfZSXsoUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523095; c=relaxed/simple;
	bh=yBkIbr99ZXDzYNVQmrBY2cU6NhfJ0gSmYcypqwiyjYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLeD/ZVzFpSW7w7URhW1Fy3SuwZ1XzNNpHznByJ2b7g5TEcn8a13Na1zQ7EzLSxN7gfcedE440eaSWsLBf+9fO0j1GizLL9B0lqPYe7gWmet9HENVKWyf+AxkH3L9vqX+WnISr3bHCvDpNQs8y4ahIGnAam+5xaiy/fJOhVJu2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Gax7n60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Gax7n60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3CDC433C7;
	Wed, 21 Feb 2024 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523095;
	bh=yBkIbr99ZXDzYNVQmrBY2cU6NhfJ0gSmYcypqwiyjYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Gax7n60O3SNmcoUJ7H1WJB/53ravMvVAEVw8sM9Kh/kDUwZt4dF7c7TlOQsQzHVh
	 x17sRTdOjRMBRtmeP/nKZvqegyCyjZvsj9wSt+pt/SJew+ANYqGwp7c72wBosk4LqV
	 BX5YK0XUb/hctm5GtULUyIrqeeLmcqJbzcjemDJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 338/476] Input: atkbd - skip ATKBD_CMD_SETLEDS when skipping ATKBD_CMD_GETID
Date: Wed, 21 Feb 2024 14:06:29 +0100
Message-ID: <20240221130020.525335001@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -802,7 +802,6 @@ static int atkbd_probe(struct atkbd *atk
 {
 	struct ps2dev *ps2dev = &atkbd->ps2dev;
 	unsigned char param[2];
-	bool skip_getid;
 
 /*
  * Some systems, where the bit-twiddling when testing the io-lines of the
@@ -816,6 +815,11 @@ static int atkbd_probe(struct atkbd *atk
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
@@ -824,18 +828,17 @@ static int atkbd_probe(struct atkbd *atk
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
 


