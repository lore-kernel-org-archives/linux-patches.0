Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B5B4A99C;
	Mon,  1 Apr 2024 16:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990589; cv=none; b=SLaKYac6aL3qopFZ/u05L8QUOxr44mITSbK30NKEpspX1PPHam3PwLnhJPPOZxqeLPE8DUuFpWXWwKwbvdjQ5/0iKNsK5VNYY4MeNEGuzGh2wbwc18BJ5Ru+4KaR5iuV2278Dhh+BDqfWvtbMdC67uoABTRuS7bQcCJlRF43XZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990589; c=relaxed/simple;
	bh=7nMfq+98GN3Va2kqR5DAP9BtD+OQ9Eu8ctX6F4v0c90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtgkXgLRI0q1WIh4VkSbwciXkgUeEfLNQeJQ1w/bi5lx2jHyeppXETlPSpR6oRsezsobnBqOhttWBa1cYU49d+jTcl4xNMaoyjH5sh3jSMB2zLa6ZH+1yyswtQ7RHxwrJJJwpZkjPj3ISyIDxd2lXg7aRsLbuLpevj7FWdqzDsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ks8f27hb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ks8f27hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2289BC433F1;
	Mon,  1 Apr 2024 16:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990589;
	bh=7nMfq+98GN3Va2kqR5DAP9BtD+OQ9Eu8ctX6F4v0c90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ks8f27hbFmJGQLWGwmcW9FG0DDKLHiuLuuWcoCpLc1nJ+ZVL6VXJkc7FTubzLmndu
	 7XNGoEjPLWoFAvgKy5vGVnBgwWIuMgHjB8oHUq0QHiXCR+bI1GH5tudDoUP1Fd8FMB
	 qF/0WggYlYnT1eObhF3Rrvp7eLEv2WNLyUdYUTg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Tso <kyletso@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 372/396] usb: typec: Return size of buffer if pd_set operation succeeds
Date: Mon,  1 Apr 2024 17:47:01 +0200
Message-ID: <20240401152559.004142205@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Kyle Tso <kyletso@google.com>

commit 53f5094fdf5deacd99b8655df692e9278506724d upstream.

The attribute writing should return the number of bytes used from the
buffer on success.

Fixes: a7cff92f0635 ("usb: typec: USB Power Delivery helpers for ports and partners")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Tso <kyletso@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240319074309.3306579-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1264,6 +1264,7 @@ static ssize_t select_usb_power_delivery
 {
 	struct typec_port *port = to_typec_port(dev);
 	struct usb_power_delivery *pd;
+	int ret;
 
 	if (!port->ops || !port->ops->pd_set)
 		return -EOPNOTSUPP;
@@ -1272,7 +1273,11 @@ static ssize_t select_usb_power_delivery
 	if (!pd)
 		return -EINVAL;
 
-	return port->ops->pd_set(port, pd);
+	ret = port->ops->pd_set(port, pd);
+	if (ret)
+		return ret;
+
+	return size;
 }
 
 static ssize_t select_usb_power_delivery_show(struct device *dev,


