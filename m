Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A0E4B7144;
	Mon, 31 Aug 2026 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184661; cv=none; b=mR7pZcF5CO6Va16QrFrB970zDPmN0zPUxhUs9+xNHG+6CnwOgCLgGZ4Y2pNksBURQkNrVJDGaE2+vP1j/ADiBEs7NtxhcmBrrDPAVPj80SoQH7qVGTj9qataxLFuIQ4Jm/nSNctJ9mTS2GW3cQ+vxwJ6lES9OekeBQyRX8XkQA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184661; c=relaxed/simple;
	bh=625qtIl+JxMeaR2dUM0wHlaJwdb/sdg4j6nv1Aw/RlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nm1PbUMKk7hwPFNqbX7uEg+0BV6SMG8iP03x01ku0sw4S37PZn2S7xQ9ZPQY1ZMSF5oLYVUgtMda2PHJ7BrrHeLJOEWc4twE1fi+k/pq4qkYCKxcYj6qPKSh5ApvOYznnziQy55TE/O6gc9eEla+gUk0v75XAsVsvUyJrFRWuFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neZXDTzA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neZXDTzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEB81F000E9;
	Mon, 31 Aug 2026 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184660;
	bh=r46eHr8yc9XPHQLnfG4mdxta4eHvLeOrGJvFXq/mhsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=neZXDTzA2uCGC5lG7HLQ4VfdVp7onzGU9Ln9AnlNhzPg9Vw0W5lfXoiFG0+kKoqCD
	 zo8tvEec6oURYfAuvEuX3zScnd3s/7l8/MYEjLJEWU4st7s+D1pwgRYIizIOCCyfnf
	 NxXar3UI9hEfM4W4V17IOui8ThEa/ZmR/qOYNfgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.6 85/91] usb: core: Strengthen error handling in hub_hub_status()
Date: Mon, 31 Aug 2026 15:35:13 +0200
Message-ID: <20260831133403.920030509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit a29496745aa335d97f617385809583241e118610 upstream.

Add additional error handling after the call to get_hub_status() in
hub_hub_status().

get_hub_status() uses usb_control_msg() which does not verify that the
message is the correct length, substituting it for
usb_control_msg_recv() would also solve this issue but increase memory
allocations.

Instead, error handling is copied from the method used in
hub_ext_port_status(), which shares the same flow of logic as
hub_hub_status().

Assisted-by: gkh_clanker_t1000
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260722-usb_core_patches_2-v3-1-87622252bfdd@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -968,10 +968,12 @@ static int hub_hub_status(struct usb_hub
 
 	mutex_lock(&hub->status_mutex);
 	ret = get_hub_status(hub->hdev, &hub->status->hub);
-	if (ret < 0) {
+	if (ret < (int)sizeof(hub->status->hub)) {
 		if (ret != -ENODEV)
 			dev_err(hub->intfdev,
 				"%s failed (err = %d)\n", __func__, ret);
+		if (ret >= 0)
+			ret = -EIO;
 	} else {
 		*status = le16_to_cpu(hub->status->hub.wHubStatus);
 		*change = le16_to_cpu(hub->status->hub.wHubChange);


