Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00F51272B5;
	Tue, 23 Jan 2024 00:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968502; cv=none; b=NIHFOIUM13azT/YK/v02KTIzzmUCQN2gw94NT7oTi+0lZ2xzivEP7EiMjNxy4Hw8ysiu149rRkEhbKAf35QTInIKaAqGLu0QLZY9wxbNSpiI/NLpgariT6DTsJCXnstHPYBvF1nTHwaBvB92wbJk84RsjHV75/GuJv3YkTgrI2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968502; c=relaxed/simple;
	bh=7PGwSF136yCOh5GlJ/KRr7CPoLN4HX/GDfyDraJZw5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fE1EknrV1s2bnLIrRmuJjkn+cXxxY6xAvqWRA8Q1FLZjBzBt7bkc+rJnKCvM7mT8VdcEq2nMQX1TgtvBneanT0J93aoDtPo3PaV+TlYwwopJ+Vo6cO01w4ChUz18cv7D0wB3/sIIi8mGutCsMJtsvmzfe3tMSM+LGue7ddBSpfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezrh1N4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezrh1N4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31304C433C7;
	Tue, 23 Jan 2024 00:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968502;
	bh=7PGwSF136yCOh5GlJ/KRr7CPoLN4HX/GDfyDraJZw5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezrh1N4uH3FXrZtRqznmPKPTRAlyRdJCWMnaOSpfgVGVuQncLqk//uREFMj8ng5Y0
	 PJAFP9THzUQmWCu6nTyNWgFx8q+5NL6DAt5uv7QppCQx7rf61N4mWU0fq3MpAh/Mst
	 xPzjL6r1oKd51/LVV4v6oiPfypOnn8x345t24LaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 4.19 125/148] usb: typec: class: fix typec_altmode_put_partner to put plugs
Date: Mon, 22 Jan 2024 15:58:01 -0800
Message-ID: <20240122235717.582030140@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

From: RD Babiera <rdbabiera@google.com>

commit 5962ded777d689cd8bf04454273e32228d7fb71f upstream.

When typec_altmode_put_partner is called by a plug altmode upon release,
the port altmode the plug belongs to will not remove its reference to the
plug. The check to see if the altmode being released is a plug evaluates
against the released altmode's partner instead of the calling altmode, so
change adev in typec_altmode_put_partner to properly refer to the altmode
being released.

Because typec_altmode_set_partner calls get_device() on the port altmode,
add partner_adev that points to the port altmode in typec_put_partner to
call put_device() on. typec_altmode_set_partner is not called for port
altmodes, so add a check in typec_altmode_release to prevent
typec_altmode_put_partner() calls on port altmode release.

Fixes: 8a37d87d72f0 ("usb: typec: Bus type for alternate modes")
Cc:  <stable@vger.kernel.org>
Co-developed-by: Christian A. Ehrhardt <lk@c--e.de>
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Signed-off-by: RD Babiera <rdbabiera@google.com>
Tested-by: Christian A. Ehrhardt <lk@c--e.de>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240103181754.2492492-2-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -188,11 +188,13 @@ static void typec_altmode_put_partner(st
 {
 	struct altmode *partner = altmode->partner;
 	struct typec_altmode *adev;
+	struct typec_altmode *partner_adev;
 
 	if (!partner)
 		return;
 
-	adev = &partner->adev;
+	adev = &altmode->adev;
+	partner_adev = &partner->adev;
 
 	if (is_typec_plug(adev->dev.parent)) {
 		struct typec_plug *plug = to_typec_plug(adev->dev.parent);
@@ -201,7 +203,7 @@ static void typec_altmode_put_partner(st
 	} else {
 		partner->partner = NULL;
 	}
-	put_device(&adev->dev);
+	put_device(&partner_adev->dev);
 }
 
 static int __typec_port_match(struct device *dev, const void *name)
@@ -459,7 +461,8 @@ static void typec_altmode_release(struct
 {
 	struct altmode *alt = to_altmode(to_typec_altmode(dev));
 
-	typec_altmode_put_partner(alt);
+	if (!is_typec_port(dev->parent))
+		typec_altmode_put_partner(alt);
 
 	altmode_id_remove(alt->adev.dev.parent, alt->id);
 	kfree(alt);


