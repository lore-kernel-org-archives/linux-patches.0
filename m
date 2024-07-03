Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630B3174ED0;
	Wed,  3 Jul 2024 11:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006211; cv=none; b=EVofbEEBSdVuzi5jDok8GWvLET7/Z0M7tOUx9+YZWy1sEt6N7xaR1twIGJkkdq477eNGPEef11VLWVDgWEzVhLEDdoYrhyi8xzRTB5aMNNspTEtoQ2y8T/epXgz17Y9kzd5Io3GtwiT/PzceH9MSm34VMslAdTW/0/CMksC7YUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006211; c=relaxed/simple;
	bh=WJLpi8/NjMZKnmF8L9mgSNQPbnyEWjnc1Gne68YpU7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BujhklsvqZmVfonoVmR6iMyzrSMfzqYjK7u65sA4BiS+8j3EX53lomhIKDErvQ91vLx+P8jLcGldHUG5TwSxszyPmqbWsTeTivZTABxyZLwFzWRmG8dVaeLASWwlA/1kYWsFrxL8UcAA1utooaaAdhFinIRi243aE7hJ+e7WeWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7zZP4nY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7zZP4nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCE6C2BD10;
	Wed,  3 Jul 2024 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006211;
	bh=WJLpi8/NjMZKnmF8L9mgSNQPbnyEWjnc1Gne68YpU7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7zZP4nYNRFLfyl0ZKmG8tpC9tvcM4DRY2+0f1SKfMfOjO+80UyQLLD0bZ9/wE9xY
	 PnSOjx4/+q73yafzILJTEvCnowhs2HM1Cp2q7uO6FeGVPbVGBWRTnDQwXoWt/PenxK
	 MKLVj/jU47l4U/ltydmYqGYwvDTHQHkTnSIQAuRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.15 337/356] batman-adv: Dont accept TT entries for out-of-spec VIDs
Date: Wed,  3 Jul 2024 12:41:13 +0200
Message-ID: <20240703102925.859078624@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 537a350d14321c8cca5efbf0a33a404fec3a9f9e upstream.

The internal handling of VLAN IDs in batman-adv is only specified for
following encodings:

* VLAN is used
  - bit 15 is 1
  - bit 11 - bit 0 is the VLAN ID (0-4095)
  - remaining bits are 0
* No VLAN is used
  - bit 15 is 0
  - remaining bits are 0

batman-adv was only preparing new translation table entries (based on its
soft interface information) using this encoding format. But the receive
path was never checking if entries in the roam or TT TVLVs were also
following this encoding.

It was therefore possible to create more than the expected maximum of 4096
+ 1 entries in the originator VLAN list. Simply by setting the "remaining
bits" to "random" values in corresponding TVLV.

Cc: stable@vger.kernel.org
Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Reported-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/originator.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -11,6 +11,7 @@
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
 #include <linux/gfp.h>
+#include <linux/if_vlan.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
@@ -132,6 +133,29 @@ batadv_orig_node_vlan_get(struct batadv_
 }
 
 /**
+ * batadv_vlan_id_valid() - check if vlan id is in valid batman-adv encoding
+ * @vid: the VLAN identifier
+ *
+ * Return: true when either no vlan is set or if VLAN is in correct range,
+ *  false otherwise
+ */
+static bool batadv_vlan_id_valid(unsigned short vid)
+{
+	unsigned short non_vlan = vid & ~(BATADV_VLAN_HAS_TAG | VLAN_VID_MASK);
+
+	if (vid == 0)
+		return true;
+
+	if (!(vid & BATADV_VLAN_HAS_TAG))
+		return false;
+
+	if (non_vlan)
+		return false;
+
+	return true;
+}
+
+/**
  * batadv_orig_node_vlan_new() - search and possibly create an orig_node_vlan
  *  object
  * @orig_node: the originator serving the VLAN
@@ -149,6 +173,9 @@ batadv_orig_node_vlan_new(struct batadv_
 {
 	struct batadv_orig_node_vlan *vlan;
 
+	if (!batadv_vlan_id_valid(vid))
+		return NULL;
+
 	spin_lock_bh(&orig_node->vlan_list_lock);
 
 	/* first look if an object for this vid already exists */


