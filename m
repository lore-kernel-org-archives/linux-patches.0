Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94123435EF2;
	Fri,  7 Aug 2026 15:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116546; cv=none; b=Z1JHmU1tsTC1gR3wqz1wVniLsLwCwvDc0fnVCnCvTDBylJuUhrTSqravKsbt4ENPezH1P3N49IaOBrSFgQjc2vQoEN0716Yj2FEot5cVE1q2a5V8unh4d6NDRgu7blSgdCPpwu6StmSZTulsQ00i9fe/v5t/7+1n1N6Y3RNlUYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116546; c=relaxed/simple;
	bh=kpv3A8zTbgOaXHWsT/MZILLT37eO72qxhU7+cPlumho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ9C+xHVbo+3ymrepGCYKpeX4z7cu24hOnbV1D01FYER7VYPwDwi5q90K0uMZ60tO8YyreY5aoEYRM0AWlclscTFdzAB0Ggt9wnnAHSKMkKLrORTF0d9mDZ+OLNGCGCGrziNa1MFtoQrlLZRmibj6EmUIJMcYZzA/mbjcCuoXKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnDg9HjX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnDg9HjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FC01F000E9;
	Fri,  7 Aug 2026 15:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116545;
	bh=Q1rC2syMGXrp0r3L3rgy3qYO8JokzdIook2i6hkSGGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnDg9HjXOicgfP51h0zzN+7lgpbmsNHMjIVR4jZf432x0AAJXoNyl962aRyRaCoex
	 xDPz79Tt8yM/vPFdZ8jq7JMbW1YuC61WQ2axlUyWe/jImj8m1eULPmeUhO/p7BsNe1
	 C9+DOpOWxUlYiAgWmk32QfaFgyZhxZ56LBd972qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 261/261] usb: typec: ucsi: Correct teardown ordering in ucsi_init() error path
Date: Fri,  7 Aug 2026 16:40:18 +0200
Message-ID: <20260807143421.055814492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Andrei Kuchynski <akuchynski@chromium.org>

commit fb0bf289f5d529336ef490c8273e88a8a8b29f69 upstream.

The commit 7aa7d4bf9d3f ("usb: typec: ucsi: Fix race condition and
ordering in port unregistration") consolidated port teardown into the
ucsi_unregister_port() helper. However, it introduced an ordering problem
in the ucsi_init() error path.

Fix this by ensuring ucsi_unregister_port() is called before we unregister
their corresponding lockdep keys.

Cc: stable@vger.kernel.org
Fixes: 7aa7d4bf9d3f ("usb: typec: ucsi: Fix race condition and ordering in port unregistration")
Reported-by: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Closes: https://lore.kernel.org/all/22064276-6c56-411a-9f20-6917ceeb865f@intel.com/
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Tested-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260717104614.325250-1-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1548,11 +1548,11 @@ static int ucsi_init(struct ucsi *ucsi)
 	return 0;
 
 err_unregister:
+	for (con = connector; con->port; con++)
+		ucsi_unregister_port(con);
 	for (i = 0; i < ucsi->cap.num_connectors; i++)
 		lockdep_unregister_key(&connector[i].lock_key);
 
-	for (con = connector; con->port; con++)
-		ucsi_unregister_port(con);
 	kfree(connector);
 err_reset:
 	memset(&ucsi->cap, 0, sizeof(ucsi->cap));


