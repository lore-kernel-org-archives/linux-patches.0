Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17271C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035B6C433D6;
	Wed, 23 Nov 2022 09:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196122;
	bh=OP3xTZtj9CsnyaQHPQQEnLm1yDzvAH7Qbs7EJ4k81+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iwd40Myz5IRzVP6C+spvcv5/S90IpOr7V3jStb22hlmK6v5g8bvl89WWcByD1DgM
	 BZR1qEmjRYSLu7JtexTS7ksuV5ekZbq6bd7/kYlPm67xqXqDmMI/Nzat/svDeYps0j
	 IxEVsZCLbnCeL5P8lqvrv6E52ZqLiUyo6BzbKHJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mushahid Hussain <mushi.shar@gmail.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 5.15 124/181] speakup: fix a segfault caused by switching consoles
Date: Wed, 23 Nov 2022 09:51:27 +0100
Message-Id: <20221123084607.738474193@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mushahid Hussain <mushi.shar@gmail.com>

commit 0fc801f8018000c8e64a275a20cb1da7c54e46df upstream.

This patch fixes a segfault by adding a null check on synth in
speakup_con_update(). The segfault can be reproduced as follows:

	- Login into a text console

	- Load speakup and speakup_soft modules

	- Remove speakup_soft

	- Switch to a graphics console

This is caused by lack of a null check on `synth` in
speakup_con_update().

Here's the sequence that causes the segfault:

	- When we remove the speakup_soft, synth_release() sets the synth
	  to null.

	- After that, when we change the virtual console to graphics
	  console, vt_notifier_call() is fired, which then calls
	  speakup_con_update().

	- Inside speakup_con_update() there's no null check on synth,
	  so it calls synth_printf().

	- Inside synth_printf(), synth_buffer_add() and synth_start(),
	  both access synth, when it is null and causing a segfault.

Therefore adding a null check on synth solves the issue.

Fixes: 2610df41489f ("staging: speakup: Add pause command used on switching to graphical mode")
Cc: stable <stable@kernel.org>
Signed-off-by: Mushahid Hussain <mushi.shar@gmail.com>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://lore.kernel.org/r/20221010165720.397042-1-mushi.shar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -1778,7 +1778,7 @@ static void speakup_con_update(struct vc
 {
 	unsigned long flags;
 
-	if (!speakup_console[vc->vc_num] || spk_parked)
+	if (!speakup_console[vc->vc_num] || spk_parked || !synth)
 		return;
 	if (!spin_trylock_irqsave(&speakup_info.spinlock, flags))
 		/* Speakup output, discard */


