Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E363EC83A;
	Mon, 17 Aug 2026 15:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980092; cv=none; b=sL2kRFQPiNMX62B33saHdP8GKpGlvmBAhaEgOgnXobtwmJVuf6WJOIsZtiLJ3PIUySmpQlDBsMjMnRipAFUehkd4Ev13QHMBvNvUpzbvWD0h4tmf1bt7fRcnBwxcPVQFLjbiQezxjkxDQwKvjYk0IA3EdNfstH/eeUqOxvWCPy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980092; c=relaxed/simple;
	bh=LipH5vhOFjEE7iVZCcFg2JMmibgnlkJ7sknVLZVue2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cT22o01VzQYnC4tNEsfnzaaHSZM94KJ/Etdzkr/gVh070dtcNZp37QqmjyMMuq5/n/ebYri/8jPGt8CLygsXUkQl3UI7irTmfK5IbEinEB+Fy03dCj14M8f9t2Isgq1VZUVv8TqtQBKe/l5Nbyw5uAI2NMjczUJOn72nOtJz5Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PgOOUOR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PgOOUOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901D91F00A3A;
	Mon, 17 Aug 2026 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980091;
	bh=P0sWOHdkstU3Fvtv1gAHtGOVku2RESn2o5oVYjuZSJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0PgOOUORQEZFz+tTBpAXh1VbHcAeNRxZeqd9DraaUhOq3Po1U81ofiVwBO1x/Chdq
	 6N+kZPfCbgsyr6FGKdUVss3Ab3w9qXceSJQ5b+6veoAKyHhypCdte0yChXF7DHC2uN
	 R39pN7kDCwzVRaOvS3EfV7hX16V72H6XV5SR+Zjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 454/609] can: kvaser_usb: kvaser_usb_hydra_get_busparams(): fix memory leak in kvaser_usb_hydra_get_busparams()
Date: Mon, 17 Aug 2026 15:32:30 +0200
Message-ID: <20260817132559.232199885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 941eaf9a6d3b33dea49f2c0a1da7546a03b6ff71 upstream.

The memory allocated for cmd is not freed after the call to
kvaser_usb_send_cmd() in both the normal and error paths.
Fix that by adding a kfree() immediately after the call.

Fixes: 39d3df6b0ea8 ("can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260722103906.108571-1-nihaal@cse.iitm.ac.in
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1605,6 +1605,7 @@ static int kvaser_usb_hydra_get_busparam
 	reinit_completion(&priv->get_busparams_comp);
 
 	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
+	kfree(cmd);
 	if (err)
 		return err;
 


