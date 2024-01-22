Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7921C6E2CB;
	Tue, 23 Jan 2024 02:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975409; cv=none; b=Q5ZT1u/YqZm5ROAJOkJcMVbpA+qPI+fQaKQA+swt2NUjTnOKzONTAz5gphTy0QjXxwP27Xm4sEAh+EXaKzBObxvhNR3w/SsY6yx14qrkbsIyrz11sax4eKxiBFzuRD8JnQOiq/bAZpYrEVl21TUvWOq7Cnx47r2DHSP5euHzDw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975409; c=relaxed/simple;
	bh=gAq9B9SLFSAThartCdTipEcKtBp1CXvu3hmkosbk500=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SV0cr1aTV+KuJ0SpWKRPJ/mOy6Z/O6J8LY8fb5hERK5lVa0Z92jszAEJXCkXXrR9OTxOVFvjeI3mUIEN5vjP/SQxCQp/3QawmY4sjeUX9AnNuRXkZ9UIbCrMnQbUiyf9sanRhWuGAEk8UuZMeORd7RtxGNGufczN3Kladf7n7q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxhWELjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxhWELjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29242C433C7;
	Tue, 23 Jan 2024 02:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975409;
	bh=gAq9B9SLFSAThartCdTipEcKtBp1CXvu3hmkosbk500=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxhWELjSlvYfRCYqnCTAdcwFleDNLnMPcGJIaeA+DCJHyN7rGObZTgHkQ18GfU279
	 srcD0SVJwXoMs4zZbn7q9ycrQqunjjH5S4cWqt1p6jDYfWwmTpYJtA2AV6r6xNXV+Z
	 ZzVoBJooTw37TWKl0OUfc+6WMwYiuNByhEsnZCAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 369/583] usb: typec: class: fix typec_altmode_put_partner to put plugs
Date: Mon, 22 Jan 2024 15:57:00 -0800
Message-ID: <20240122235823.304983814@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -262,11 +262,13 @@ static void typec_altmode_put_partner(st
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
@@ -275,7 +277,7 @@ static void typec_altmode_put_partner(st
 	} else {
 		partner->partner = NULL;
 	}
-	put_device(&adev->dev);
+	put_device(&partner_adev->dev);
 }
 
 /**
@@ -496,7 +498,8 @@ static void typec_altmode_release(struct
 {
 	struct altmode *alt = to_altmode(to_typec_altmode(dev));
 
-	typec_altmode_put_partner(alt);
+	if (!is_typec_port(dev->parent))
+		typec_altmode_put_partner(alt);
 
 	altmode_id_remove(alt->adev.dev.parent, alt->id);
 	kfree(alt);


