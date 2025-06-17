Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D082DFF10;
	Tue, 17 Jun 2025 16:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178874; cv=none; b=HhOa9UF5hh1423ygZe2sPepIcRj0E9WGELfa3bNbbrRIJvOJk7ZBNA7kQ2mfqIpMdm/CFI1FnlfBOzb2NdiZR3MQcWX+0VclSeB3rBIC6sFYlXHeD5AgiSyyjiMa4uzNVyw22ElPqcq48AgPt2jNA1vzmYfsywrNzuXj2Oj5hHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178874; c=relaxed/simple;
	bh=9Gn5g37TLaxHAcsj91PnIaNpO5iVj2IpghnH/4ER7xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTMJtdOYzWFDeWX9Rbq/Jt2ARPRhbjntAl15rPxcnPd6M+3AyvpKA2aaQTmuJRcKSbtCDTdU3zCkV44puDtzoYWFiVRAxFa0wf9Lu19afL3Q9PnI9K1oEjqJX2A9QSca8+ZIsh+ggEnEBwdsz2q2H0fsvcITeBQH/lWdzUbEgWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mnxk+YTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mnxk+YTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5076BC4CEE3;
	Tue, 17 Jun 2025 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178873;
	bh=9Gn5g37TLaxHAcsj91PnIaNpO5iVj2IpghnH/4ER7xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mnxk+YTl7b4jntzMzWuBs4nuYIYAW1nYgoRibtpvQqRB+//wCSSX15dzDy81CxvuB
	 GDnw5M6OrgFQbP9mR7pfXZt70EQt9ejRpVZUZMxWOzZ/DItxwNr04jH9XZq9qed1Bd
	 3Lh0UQID2y4JNIu57WUHUkM8RRELERqK8gOzSJ3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 548/780] USB: typec: fix const issue in typec_match()
Date: Tue, 17 Jun 2025 17:24:16 +0200
Message-ID: <20250617152513.827710054@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit ae4432e01dd967a64f6670a152d91d5328032726 ]

typec_match() takes a const pointer, and then decides to cast it away
into a non-const one, which is not a good thing to do overall.  Fix this
up by properly setting the pointers to be const to preserve that
attribute.

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/2025052126-scholar-stainless-ad55@gregkh
Fixes: d69d80484598 ("driver core: have match() callback in struct bus_type take a const *")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/bus.c b/drivers/usb/typec/bus.c
index ae90688d23e40..a884cec9ab7e8 100644
--- a/drivers/usb/typec/bus.c
+++ b/drivers/usb/typec/bus.c
@@ -449,7 +449,7 @@ ATTRIBUTE_GROUPS(typec);
 
 static int typec_match(struct device *dev, const struct device_driver *driver)
 {
-	struct typec_altmode_driver *drv = to_altmode_driver(driver);
+	const struct typec_altmode_driver *drv = to_altmode_driver(driver);
 	struct typec_altmode *altmode = to_typec_altmode(dev);
 	const struct typec_device_id *id;
 
-- 
2.39.5



