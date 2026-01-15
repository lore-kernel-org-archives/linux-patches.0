Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A240D3BFE22;
	Thu, 15 Jan 2026 17:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497778; cv=none; b=lcGma/1YrjR2Y+nOyFiasMDQTT2nS5Tb4HlMM+vciCNl4L4TWCOPXQEiR8o7l/jsMvUr5AG5gJJ5uStENm9vWXOp599KXypMKihGrDF+6E031x2ValzCmxlxy9xi6chgq9P3a6/GNoV7xiYHa5kIzFTyU0MfVrpPxb40hFNt6PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497778; c=relaxed/simple;
	bh=eRk/p7Pvg0Amh/U1YKm4RsL/zhhONEG4csrA91P+WP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMhA/QN++aiND0hZVlRXj1nWdjxVGACmIXruylLJcijCq4TDb/JmilSwegzB5sG8MycRpZr2dTHnDO4NHeTQqptph5Ql9X4o2g7LLz/GOeUGX0aQ89hgmpYbqTHMVXW15ovQepeBZQfJOhpCBK/EXXovKT7da+VHK/A5DEmMFN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1VgIDyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1VgIDyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31796C116D0;
	Thu, 15 Jan 2026 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497778;
	bh=eRk/p7Pvg0Amh/U1YKm4RsL/zhhONEG4csrA91P+WP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1VgIDyT73liQBR9NvUMCxWYX11iwCPYt9gc8Xpjv3h1mcSyPefwZfWDyJnObfOAX
	 DdnC0+hOyKVu5PiVP8s0ZVjIl3KaPMp4d/tMLUaHNhEpP6uL+ChRSO9ktZsnhbJIEi
	 a7p9X1yDrpE1idGs17YBTi57c1Prehq9nHVmjKmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Subject: [PATCH 5.15 199/554] usb: phy: Initialize struct usb_phy list_head
Date: Thu, 15 Jan 2026 17:44:25 +0100
Message-ID: <20260115164253.459758966@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


