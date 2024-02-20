Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BB8151CCC;
	Tue, 20 Feb 2024 21:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464675; cv=none; b=QG0X0sXMzdHXwfO+nf6cYlZ0g2jQUTqwU11yqPYbymc9VGudW2FEbXT3Jqg/NH/nPbupGGc21biG8CLpZafnAgcn1OtoaAHYERB8R0Nxd/Xm2wDwctCfjor2MhRFjJHOHqHVX+vBjFQoegrBkrGEwtOjt0FI7Wbx26KhFi/tjhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464675; c=relaxed/simple;
	bh=SCVOiDjlGRWw/vDT1PUBki3b059dJWxIhLx+cvQ4JQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxn1uHwm8vxhaLJY1+c+6CbA5jHeoqh3E9xOGlb4lW4EkFXVvKqEXmwWOqucd96Rj2fSQBn8GxErt6/mJ+bE0CY/BA9qggJHKX8fZ64wqZcPO0GUgFi7WH67hwW54x9g3U1V34/WfIb9ZPGQUkCM+GPpG3cKHpQ2Y9qHGJRt/ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYHah9NQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYHah9NQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69275C433F1;
	Tue, 20 Feb 2024 21:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464674;
	bh=SCVOiDjlGRWw/vDT1PUBki3b059dJWxIhLx+cvQ4JQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYHah9NQINBjWaLKvUOwCK6bo/ISeqsRMe9YM55ChWLEbJYgXC14THuyh+pt2jxmS
	 KwdMbmpMTa8ANuT9SWCwt1YguoZgK99YbqbIo2Ew9FGCO/IdcMgFcoEBD6Btpgn+/J
	 skMZ9NVDZOZofExDzfBees73jFRDFWwqS1iECrDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udipto Goswami <quic_ugoswami@quicinc.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.7 093/309] usb: core: Prevent null pointer dereference in update_port_device_state
Date: Tue, 20 Feb 2024 21:54:12 +0100
Message-ID: <20240220205636.108467219@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Udipto Goswami <quic_ugoswami@quicinc.com>

commit 12783c0b9e2c7915a50d5ec829630ff2da50472c upstream.

Currently, the function update_port_device_state gets the usb_hub from
udev->parent by calling usb_hub_to_struct_hub.
However, in case the actconfig or the maxchild is 0, the usb_hub would
be NULL and upon further accessing to get port_dev would result in null
pointer dereference.

Fix this by introducing an if check after the usb_hub is populated.

Fixes: 83cb2604f641 ("usb: core: add sysfs entry for usb device state")
Cc: stable@vger.kernel.org
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20240110095814.7626-1-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2047,9 +2047,19 @@ static void update_port_device_state(str
 
 	if (udev->parent) {
 		hub = usb_hub_to_struct_hub(udev->parent);
-		port_dev = hub->ports[udev->portnum - 1];
-		WRITE_ONCE(port_dev->state, udev->state);
-		sysfs_notify_dirent(port_dev->state_kn);
+
+		/*
+		 * The Link Layer Validation System Driver (lvstest)
+		 * has a test step to unbind the hub before running the
+		 * rest of the procedure. This triggers hub_disconnect
+		 * which will set the hub's maxchild to 0, further
+		 * resulting in usb_hub_to_struct_hub returning NULL.
+		 */
+		if (hub) {
+			port_dev = hub->ports[udev->portnum - 1];
+			WRITE_ONCE(port_dev->state, udev->state);
+			sysfs_notify_dirent(port_dev->state_kn);
+		}
 	}
 }
 


