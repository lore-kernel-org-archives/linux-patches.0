Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67BB39BEA4;
	Tue, 16 Dec 2025 12:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888678; cv=none; b=sA1vvv6TInLgkjDOIEOhNHaOM7zWfpHUcU3RmkhXzBxxrTWeW5G1uf5Lwj6pmHitIiwpb2CgXH2kIxQQaLlKATiQAnx9n7l35AiTchG1qglinhQVDkKYFQJMsP5pM8hp4lnPy1xEIvktvDtnfnkaHijpjm2xq8e2r4x+ZTWipmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888678; c=relaxed/simple;
	bh=N2xx641WKZjLHRmGEYp/9XFjHkFLWQOWS7ypOUuMmfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6B7HK37MKCQNkgO+eNVVBEoKid+0EUQwspEekv7u8u6ZfDGxtRazKG56ahmEKIYO4OaramxEtT0hi888wurxlW0+9p94GxPpxDi5sNYaf31qiM5ZCIrf+FJXgY1s8yHgOppgbPZXh0eehAwsh17Q02TMRhccink3EEvZ2OTRyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uO2miDy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uO2miDy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEC2C4CEF1;
	Tue, 16 Dec 2025 12:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888678;
	bh=N2xx641WKZjLHRmGEYp/9XFjHkFLWQOWS7ypOUuMmfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uO2miDy3zDij9QESLpRylq4wlDDovP3WpNWPkBxKXUhejtOUib/qMT72rxWD4MHPw
	 6Kn/kvALh52KUe5/32+3ntwe1iIADhUbnb4tBNN/NDEKxw4CFDbtiLIT0pNa14yyv1
	 kyb8cU7zVEHhC9kPLnbAJnLPceUY4I/r0uIe+X1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Subject: [PATCH 6.18 606/614] usb: phy: Initialize struct usb_phy list_head
Date: Tue, 16 Dec 2025 12:16:13 +0100
Message-ID: <20251216111423.350503151@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>

commit c69ff68b097b0f53333114f1b2c3dc128f389596 upstream.

As part of the registration of a new 'struct usb_phy' with the USB PHY core
via either usb_add_phy(struct usb_phy *x, ...) or usb_add_phy_dev(struct
usb_phy *x) these functions call list_add_tail(&x->head, phy_list) in
order for the new instance x to be stored in phy_list, a static list
kept internally by the core.

After 7d21114dc6a2 ("usb: phy: Introduce one extcon device into usb phy")
when executing either of the registration functions above it is possible
that usb_add_extcon() fails, leading to either function returning before
the call to list_add_tail(), leaving x->head uninitialized.

Then, when a driver tries to undo the failed registration by calling
usb_remove_phy(struct usb_phy *x) there will be an unconditional call to
list_del(&x->head) acting on an uninitialized variable, and thus a
possible NULL pointer dereference.

Fix this by initializing x->head before usb_add_extcon() has a
chance to fail. Note that this was not needed before 7d21114dc6a2 since
list_add_phy() was executed unconditionally and it guaranteed that x->head
was initialized.

Fixes: 7d21114dc6a2 ("usb: phy: Introduce one extcon device into usb phy")
Cc: stable <stable@kernel.org>
Signed-off-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Link: https://patch.msgid.link/20251121-diogo-smaug_typec-v2-1-5c37c1169d57@tecnico.ulisboa.pt
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -646,6 +646,8 @@ int usb_add_phy(struct usb_phy *x, enum
 		return -EINVAL;
 	}
 
+	INIT_LIST_HEAD(&x->head);
+
 	usb_charger_init(x);
 	ret = usb_add_extcon(x);
 	if (ret)
@@ -696,6 +698,8 @@ int usb_add_phy_dev(struct usb_phy *x)
 		return -EINVAL;
 	}
 
+	INIT_LIST_HEAD(&x->head);
+
 	usb_charger_init(x);
 	ret = usb_add_extcon(x);
 	if (ret)


