Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6278F1F957
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D643DC433C8;
	Tue,  1 Aug 2023 09:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882597;
	bh=UP9HvCUR7vB/WPAzwB92Wnz5jo7cvdsxeYTqtQF+00Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eb/9+6xwZl4VqYEonKukSHjNylnVgxjRijzJHrb+3M3RUvP3Vp62yH+bzVulhCoQZ
	 YtawNNEdFy9GilW0kT7o5+40lGMLhMXa6g9cdg6K45Dt/oO65FbZ4+TExyzusXDpjQ
	 ceUQeL/JSN8997D9l+oSjwqsktAOlks3ufXv4sVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Tso <kyletso@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 162/228] usb: typec: Iterate pds array when showing the pd list
Date: Tue,  1 Aug 2023 11:20:20 +0200
Message-ID: <20230801091928.731945864@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kyle Tso <kyletso@google.com>

commit 4b642dc9829507e4afabc03d32a18abbdb192c5e upstream.

The pointers of each usb_power_delivery handles are stored in "pds"
array returned from the pd_get ops but not in the adjacent memory
calculated from "pd". Get the handles from "pds" array directly instead
of deriving them from "pd".

Fixes: a7cff92f0635 ("usb: typec: USB Power Delivery helpers for ports and partners")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Tso <kyletso@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230623151036.3955013-3-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1258,8 +1258,7 @@ static ssize_t select_usb_power_delivery
 {
 	struct typec_port *port = to_typec_port(dev);
 	struct usb_power_delivery **pds;
-	struct usb_power_delivery *pd;
-	int ret = 0;
+	int i, ret = 0;
 
 	if (!port->ops || !port->ops->pd_get)
 		return -EOPNOTSUPP;
@@ -1268,11 +1267,11 @@ static ssize_t select_usb_power_delivery
 	if (!pds)
 		return 0;
 
-	for (pd = pds[0]; pd; pd++) {
-		if (pd == port->pd)
-			ret += sysfs_emit(buf + ret, "[%s] ", dev_name(&pd->dev));
+	for (i = 0; pds[i]; i++) {
+		if (pds[i] == port->pd)
+			ret += sysfs_emit(buf + ret, "[%s] ", dev_name(&pds[i]->dev));
 		else
-			ret += sysfs_emit(buf + ret, "%s ", dev_name(&pd->dev));
+			ret += sysfs_emit(buf + ret, "%s ", dev_name(&pds[i]->dev));
 	}
 
 	buf[ret - 1] = '\n';


