Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515E6359710;
	Tue, 16 Dec 2025 12:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886697; cv=none; b=CtSB8cvqZxpcOB7X/fm1D7L3Jxdk9O6CJN8MH+XBiVgfJnlQ2n1HHIC3+yjOA+bnQstfAM3eeWLnnBTRQ0lKiDKkUiihc80TY+/x1ZgXNodNHyyMif9Cg6xC2U56GJkwZGYHrnBevu8ymoE4A4YtIoZvhwcMHGqZ1eoGIyNb3Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886697; c=relaxed/simple;
	bh=KYbSwHbSysJdXFS/zP8WSe/n2KAiDC9CrcFrDkinC5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8FiRvt4K4iBEd6R/+bbaco4oIVjx+HmikgmM9x1oAb4e+XjPHltdcndpBYuRR3A/X7puxXyuX2VFiOC3gbnbnaIpKYEGfuJVGqLakKX7MtInm8tImm1spC0iPn7grIG3BbdAPhJ6ric24pTwR1Ww05KX9YsZirWIQs7S30uOAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qon+ysE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qon+ysE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AB5C4CEF5;
	Tue, 16 Dec 2025 12:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886697;
	bh=KYbSwHbSysJdXFS/zP8WSe/n2KAiDC9CrcFrDkinC5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qon+ysE/Y6FYxEZuNNU5vCUM5hEC3j/vd+X4MtIfyyBKyQyntMLLLuTG44/nbKw0l
	 OQMPJxMzwWr0tECVEqqOLmkmpNm+DqnzDfOH0MqmpZDuKCt3LeYSHNGs+DaPOvi8Yz
	 S1HHSmCIcz8YTddYJkzJC0Fbm/Ci8m4QddcS40K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Subject: [PATCH 6.17 500/507] usb: phy: Initialize struct usb_phy list_head
Date: Tue, 16 Dec 2025 12:15:41 +0100
Message-ID: <20251216111403.553352345@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


