Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E667212BF34;
	Tue, 23 Jan 2024 01:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971743; cv=none; b=gsfLuCJqWvN7wpPDPPlHjGUAj8k7Vkb1tXmQ7Z8PtUb/29ZdKFvXFB9I4bk2fAmuiz88BlqNoicAgpV6xBilsVo01lg+T22d2kQMCvoSb98IuExk4se6MwstY/DVYPJOmV9eCYb68RG8KSrvorKKAqWL7TkveKOykhrP81hlids=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971743; c=relaxed/simple;
	bh=WthfDLQQrCVI0E36OvkzAEGtGa0vZuQvc3mqQPculQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDSkegh1kiCLV7xig+yC7b+vAJht6Y761FNgxAiWm5p0bXG/4QJ04b8sT98GbTyFDebi30o8hiBrxdvLKtpMSOHJ05eI9DhHxdUx2gBmMv6+szVTaWZLmgUHU0CuTiUlPD5g5510ooui7OOSOmQP25GI6FsuS/pmDsEjSnoljG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgMldJFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgMldJFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25824C433F1;
	Tue, 23 Jan 2024 01:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971742;
	bh=WthfDLQQrCVI0E36OvkzAEGtGa0vZuQvc3mqQPculQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgMldJFqj/81RSULycZjE4TkYH2Y9s6Tp/w2qzYukXVTX7SRujsUaK225tUS1RZgm
	 RLVXyXxNxEPwLLCTdt/1+QWanKJFRXuqo31DEXtH59m3liYTUAIwUADc4szUQig78k
	 cCF9COgfmxv/hRT2WhdQv9DuA0Hu6x2w3fE9J3q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 217/286] usb: typec: class: fix typec_altmode_put_partner to put plugs
Date: Mon, 22 Jan 2024 15:58:43 -0800
Message-ID: <20240122235740.440701182@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -190,11 +190,13 @@ static void typec_altmode_put_partner(st
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
@@ -203,7 +205,7 @@ static void typec_altmode_put_partner(st
 	} else {
 		partner->partner = NULL;
 	}
-	put_device(&adev->dev);
+	put_device(&partner_adev->dev);
 }
 
 /**
@@ -424,7 +426,8 @@ static void typec_altmode_release(struct
 {
 	struct altmode *alt = to_altmode(to_typec_altmode(dev));
 
-	typec_altmode_put_partner(alt);
+	if (!is_typec_port(dev->parent))
+		typec_altmode_put_partner(alt);
 
 	altmode_id_remove(alt->adev.dev.parent, alt->id);
 	kfree(alt);


