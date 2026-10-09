Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD024E021E;
	Fri,  9 Oct 2026 14:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556165; cv=none; b=HDpUUPpEwLRmomowRBxOXUveB4BEJ4yDrj86PJVCokhprrFxvDO0yYp4ldj0XnCIVupg47uborYJygLSxTsApTt7VH1tnCknpJW78WCHUCiF3P7c63eRHrptL4xik0H//kE5RVbUmdAY6Rkn4ffqyho7eOqqr7BmvfU545m8i9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556165; c=relaxed/simple;
	bh=DZp//XLBjmOgcX4qUZTVi2mAbxgXVl9InaeDxoMvQ7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEape4QYfyS+j4bJ55ZofHwpGdgbuRptD6Ad+h7q2wSKvMfIm/yOQX1Y4Mh5PHz47NRONxlDs22nh2mM3xoUmLYFAv7ZP7Z9FHF0ZHUF/6aYl0m7jBYOUCiuxwLzb0zVHmCwOt76ruFwZ17QtSIjd/RfBFm3ijmquS5zD6A92Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4msNcsa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4msNcsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0DB1F000FF;
	Fri,  9 Oct 2026 14:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556164;
	bh=stLMN6Sn5lXLFysfzguLlPI4uVQ1RIP1+Kb1n22lNb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4msNcsa6fSBZ0GMqciABEHerotr9Mywv51eEMYnhh9VZGPDEXpsIUgw2beEHYU9L
	 s2uL7s3ttuBg/NIQF8qe3qmo7CTH0fX0mo/RJuOBdLH7ICO9nGM40FNio0hfcZbX8C
	 vk33F91O1hCbQzH3OecxiiZrZqz1WQAopUqb1Ne8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 184/403] usb: typec: tipd: fix uninitialized typec_partner_desc in cd321x_update_work()
Date: Fri,  9 Oct 2026 16:09:05 +0200
Message-ID: <20261009140956.425477030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

commit 88c7e458af53ff781a3f1051708395892b325576 upstream.

cd321x_update_work() passes a stack-allocated typec_partner_desc to
typec_register_partner() after initializing only usb_pd, accessory and
identity.

typec_register_partner() copies attach and deattach from the descriptor
into the partner. With those fields left unset, garbage function pointers
may be stored and later invoked from typec_partner_link_device() when a USB
device is linked to the port. Uninitialized pd_revision and usb_capability
similarly leak stack data through partner sysfs.

Zero-initialize the descriptor so optional callbacks remain NULL and the
remaining fields are zero.

Fixes: 82432bbfb9e8 ("usb: typec: tipd: Handle mode transitions for CD321x")
Cc: stable <stable@kernel.org> # 6.18+
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20260906131942.83153-3-radhey.shyam.pandey@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -812,11 +812,10 @@ static void cd321x_update_work(struct wo
 
 	/* Set up partner if we were previously disconnected (or changed). */
 	if (!tps->partner) {
-		struct typec_partner_desc desc;
+		struct typec_partner_desc desc = { };
 
 		desc.usb_pd = is_pd;
 		desc.accessory = TYPEC_ACCESSORY_NONE; /* XXX: handle accessories */
-		desc.identity = NULL;
 
 		if (desc.usb_pd)
 			desc.identity = &st.partner_identity;


