Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CCA1E0DD8;
	Wed, 30 Sep 2026 16:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786012; cv=none; b=uFSGMGaeHsodgnXY+NG2/CrQfDw19D0wRi9VhQGphf1Uu9ixyJpqB0b7qzQghx1dF1tLQoGBiinCyZLSab2yaJhx+No8/GfwXO0nAr4pY9Qie2scB2PGvOhuDfZW78vMqsNnPvc0Ok91YsKkLaAZeD28R+Ujdnly94/kjMOyvAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786012; c=relaxed/simple;
	bh=bmjXGq5xkV+OEBT+iNJBulecFFRKQQBerU61UUroqvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sW0VwS6vpUZ/Y7vPeoMvSh3Hg0cRURFQ6AHAlrycndk8bdY4kqVlS5LdMS3PMHTO5tAf5WGwcz8Hy75xIkGKwKeefpBViZLjubmIdhl1Paw23BJ6b0ufWuXVphUGAdQS0+1n9a7h6UhB1vgQLlzhkLJ7g6SN7ApQmEK479QgMVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UwzaZNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UwzaZNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EA01F000FF;
	Wed, 30 Sep 2026 16:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786010;
	bh=2s+/JLKNIqDA6DYtnpUDQz3Cc8OvM+XKkSeCKg/JZnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2UwzaZNqmiq4XSRZZQvgcjOulzfmmDT8SwRrtMwN7QzJiDgS1e8QBwUUZjW8ybf+I
	 PocxHF0/d2CeD6hqj/hhZ5P9glUjCA4iYhKb71I+TpVf9c3XBTT1YFJ4y/LBvRDZ25
	 Ih+gEP2Rt39xybhi8ETJxsycyL6iJa4FS6crFjqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 711/982] Bluetooth: hci_codec: validate vendor codec count length
Date: Wed, 30 Sep 2026 17:24:07 +0200
Message-ID: <20260930152432.028362268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

commit d0795cfd6f655f4de84868a4f4bb41a03f037b3d upstream.

The Read Local Supported Codecs parsers consume the variable-sized
standard codec array before parsing the vendor codec count.  Although the
initial reply-size check includes a vendor count byte in the fixed layout,
it does not guarantee that the byte remains after the standard codec array.

If a controller reply ends immediately after that array, calculating the
vendor codec array size reads vnd_codecs->num beyond the skb data.  Use
skb_pull_data() to validate and consume each codec header before using its
count in both command variants.

Fixes: 8961987f3f5f ("Bluetooth: Enumerate local supported codec and cache details")
Fixes: 9ae664028a9e ("Bluetooth: Add support for Read Local Supported Codecs V2")
Cc: stable@vger.kernel.org
Suggested-by: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_codec.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/net/bluetooth/hci_codec.c
+++ b/net/bluetooth/hci_codec.c
@@ -145,11 +145,12 @@ void hci_read_supported_codecs(struct hc
 
 	skb_pull(skb, sizeof(rp->status));
 
-	std_codecs = (void *)skb->data;
+	std_codecs = skb_pull_data(skb, sizeof(*std_codecs));
+	if (!std_codecs)
+		goto error;
 
 	/* validate codecs length before accessing */
-	if (skb->len < flex_array_size(std_codecs, codec, std_codecs->num)
-	    + sizeof(std_codecs->num))
+	if (skb->len < flex_array_size(std_codecs, codec, std_codecs->num))
 		goto error;
 
 	/* enumerate codec capabilities of standard codecs */
@@ -161,15 +162,14 @@ void hci_read_supported_codecs(struct hc
 					    LOCAL_CODEC_ACL_MASK | LOCAL_CODEC_SCO_MASK, &caps);
 	}
 
-	skb_pull(skb, flex_array_size(std_codecs, codec, std_codecs->num)
-		 + sizeof(std_codecs->num));
+	skb_pull(skb, flex_array_size(std_codecs, codec, std_codecs->num));
 
-	vnd_codecs = (void *)skb->data;
+	vnd_codecs = skb_pull_data(skb, sizeof(*vnd_codecs));
+	if (!vnd_codecs)
+		goto error;
 
 	/* validate vendor codecs length before accessing */
-	if (skb->len <
-	    flex_array_size(vnd_codecs, codec, vnd_codecs->num)
-	    + sizeof(vnd_codecs->num))
+	if (skb->len < flex_array_size(vnd_codecs, codec, vnd_codecs->num))
 		goto error;
 
 	/* enumerate vendor codec capabilities */
@@ -214,11 +214,12 @@ void hci_read_supported_codecs_v2(struct
 
 	skb_pull(skb, sizeof(rp->status));
 
-	std_codecs = (void *)skb->data;
+	std_codecs = skb_pull_data(skb, sizeof(*std_codecs));
+	if (!std_codecs)
+		goto error;
 
 	/* check for payload data length before accessing */
-	if (skb->len < flex_array_size(std_codecs, codec, std_codecs->num)
-	    + sizeof(std_codecs->num))
+	if (skb->len < flex_array_size(std_codecs, codec, std_codecs->num))
 		goto error;
 
 	memset(&caps, 0, sizeof(caps));
@@ -229,15 +230,14 @@ void hci_read_supported_codecs_v2(struct
 					    &caps);
 	}
 
-	skb_pull(skb, flex_array_size(std_codecs, codec, std_codecs->num)
-		 + sizeof(std_codecs->num));
+	skb_pull(skb, flex_array_size(std_codecs, codec, std_codecs->num));
 
-	vnd_codecs = (void *)skb->data;
+	vnd_codecs = skb_pull_data(skb, sizeof(*vnd_codecs));
+	if (!vnd_codecs)
+		goto error;
 
 	/* check for payload data length before accessing */
-	if (skb->len <
-	    flex_array_size(vnd_codecs, codec, vnd_codecs->num)
-	    + sizeof(vnd_codecs->num))
+	if (skb->len < flex_array_size(vnd_codecs, codec, vnd_codecs->num))
 		goto error;
 
 	for (i = 0; i < vnd_codecs->num; i++) {


