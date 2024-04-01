Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2244B1CA8F;
	Mon,  1 Apr 2024 16:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987716; cv=none; b=p2P/0tmnF0LFOvdsuuUZK7J3DXdTe9mKnFwg8JJEPtGUoFHxQpAg9dH1oGqcUwRPpdIzIs6XQ7hTv/SpPx59FrEL6wf937Q4XHqp5HEGOvW5MbyMDu1BAgWCoZfqYg5GKjG3LBImjROvq7VIMmW2sUbZl+xKVghT5QxZqLmJNfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987716; c=relaxed/simple;
	bh=4xO2AZ8bgV5yn3u3DKYKDS1e5VrcTyGjKo+V7fhxV/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQHI4H9UFc8Oiz+RbIqfUjPHs1oPwTRqMfJ2dMnn++LpgmfKIjAtA+noXRi2ceheinpsSonqDh7BQKLmjDF27FpYdYJ/wMXtPzQIoB2XA35dRU0aGBOtRtKv7TBBZ/cTBW245slN/rzsIeN28aZmo/xIuD1y+5+jQaKpxL5IyGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2JMf0K0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2JMf0K0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2A6C433C7;
	Mon,  1 Apr 2024 16:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987716;
	bh=4xO2AZ8bgV5yn3u3DKYKDS1e5VrcTyGjKo+V7fhxV/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2JMf0K07zvBbsSpxLvQMtAV+HOIEWO61AFnJTBNPKwMmzQyHAVv1r1VFo6KGb7ef
	 qSSQFSxgFOVRor5RIFEuG9f0EDtv9acVyYVq39r5ptEFG69bswb92paGjsLgnGCJHC
	 Ty3RdQMthsYJ0EYyHXvbfdCqBZ+r8upWL6UQrxHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Tso <kyletso@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.8 371/399] usb: typec: Return size of buffer if pd_set operation succeeds
Date: Mon,  1 Apr 2024 17:45:37 +0200
Message-ID: <20240401152600.250435533@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1310,6 +1310,7 @@ static ssize_t select_usb_power_delivery
 {
 	struct typec_port *port = to_typec_port(dev);
 	struct usb_power_delivery *pd;
+	int ret;
 
 	if (!port->ops || !port->ops->pd_set)
 		return -EOPNOTSUPP;
@@ -1318,7 +1319,11 @@ static ssize_t select_usb_power_delivery
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


