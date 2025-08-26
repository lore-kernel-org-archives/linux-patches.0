Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555861946BC;
	Tue, 26 Aug 2025 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215697; cv=none; b=Bv5iN2IvclM3E8V70kGfEip1Mk7QB013FnMhwE5fskB7XFDeyCZnmch2W2rBCeATeZ8mEnyrEJkjyQprV8yXnteKU+rwdi1isoKJIT+MdMyK3HbTj+3navMEJrJcSViC3p9WuIcdJVdReAfzc177Fz5zzGgFh0xOMpvXCzjh6pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215697; c=relaxed/simple;
	bh=PKLdf/EgZlGyQx+RMZ2hQIe5olc+s3pplB7JxQ64zjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lh3H+fWBqYuzpX8Iy/ZMjf33rV6pxsOEj6Bza7qFGxOTF/r6p51Mh0EM4UM3Jg6dw/aQEVyVVLf7kxr4soD9A8c1w5tpNxFPN7E5yFmdpHHqbwn7M+hz+Ukd28x88lt0yYo9qiRtHKvT/C2ezUqcSyjMpN4EBR6p08LGyopnbe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rl92LR8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rl92LR8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73CAC116D0;
	Tue, 26 Aug 2025 13:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215697;
	bh=PKLdf/EgZlGyQx+RMZ2hQIe5olc+s3pplB7JxQ64zjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rl92LR8+AcXU+OdWy2CxeNTG6xnOLkQgBQEjAjm7GSrckopk+3kyL17Ah5ygd5wpj
	 AKBZwEsB+RQWKrNlmBFEZpUZrbnZgpz2v5PP7YcPnkXC2vykmO6BabcwdPVF3jXv6m
	 QB8ZjXaqHIsSogpHCeSABmKt16/GR+fjr778RM4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/644] usb: typec: tcpm: allow to use sink in accessory mode
Date: Tue, 26 Aug 2025 13:03:11 +0200
Message-ID: <20250826110948.988443586@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 64843d0ba96d3eae297025562111d57585273366 upstream.

Since the function tcpm_acc_attach is not setting the data and role for
for the sink case we extend it to check for it first.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250404-ml-topic-tcpm-v1-1-b99f44badce8@pengutronix.de
Stable-dep-of: bec15191d523 ("usb: typec: tcpm: apply vbus before data bringup in tcpm_src_attach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -3794,12 +3794,17 @@ static void tcpm_snk_detach(struct tcpm_
 static int tcpm_acc_attach(struct tcpm_port *port)
 {
 	int ret;
+	enum typec_role role;
+	enum typec_data_role data;
 
 	if (port->attached)
 		return 0;
 
-	ret = tcpm_set_roles(port, true, TYPEC_SOURCE,
-			     tcpm_data_role_for_source(port));
+	role = tcpm_port_is_sink(port) ? TYPEC_SINK : TYPEC_SOURCE;
+	data = tcpm_port_is_sink(port) ? tcpm_data_role_for_sink(port)
+				       : tcpm_data_role_for_source(port);
+
+	ret = tcpm_set_roles(port, true, role, data);
 	if (ret < 0)
 		return ret;
 


