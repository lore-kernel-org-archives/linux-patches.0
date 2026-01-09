Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DAF31E107;
	Fri,  9 Jan 2026 12:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962029; cv=none; b=stRIPw2+svf09vWBVtnBPnh2tsxqwZaBsQGj7nk4wuGRhISGvAmNWh5EfwjcJX8IGo9ggE6atMPklIzlPw2XjxCipsEdPdpTZ5i4NqMoUR5B4aluqdkz8xEs7BZ5/REbJvAaj/7mWhzhXlIUqZ9+QVIaS+POiPv/fd3iScrQP7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962029; c=relaxed/simple;
	bh=Mu9qPlnzTbpA5Dt/ixntFStxqvzS3P4Y4bW/ZXr0CwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vq/1oH1H9Ju9eQyrS46pQBmWuHak5fdKZ1aBKGkSu8ywL9RDWGEt7rdpEBxh3Fn4x+5jWqfMWVK73jTKDkE7AzUNC3Ul6ViCHUFiTCi6pU4VAA2TxmqtuKAPaEkgiHAvFtfG4XblbTgguD7n1KIY5L0Z1mnC9llOXNULgbxPlms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orQJT6A1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orQJT6A1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BB8C4CEF1;
	Fri,  9 Jan 2026 12:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962029;
	bh=Mu9qPlnzTbpA5Dt/ixntFStxqvzS3P4Y4bW/ZXr0CwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orQJT6A1urZG4pdqulgwWLMO+WF8e6W1cKyCNFhCYjGmInmky8ARy+RUcQrPs+KnU
	 RrWKvLloX2icEs8VIoLL0twCjeG4tyS46sbnchHxXxCkUj+zAEgQByvIvsx5Lt3aVV
	 s5krzeJm4ovMzfeLQr1IsK/R7RIlvuwGSQXGQkG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Subject: [PATCH 6.1 222/634] usb: phy: Initialize struct usb_phy list_head
Date: Fri,  9 Jan 2026 12:38:20 +0100
Message-ID: <20260109112125.786899310@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
@@ -672,6 +672,8 @@ int usb_add_phy(struct usb_phy *x, enum
 		return -EINVAL;
 	}
 
+	INIT_LIST_HEAD(&x->head);
+
 	usb_charger_init(x);
 	ret = usb_add_extcon(x);
 	if (ret)
@@ -722,6 +724,8 @@ int usb_add_phy_dev(struct usb_phy *x)
 		return -EINVAL;
 	}
 
+	INIT_LIST_HEAD(&x->head);
+
 	usb_charger_init(x);
 	ret = usb_add_extcon(x);
 	if (ret)


