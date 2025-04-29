Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10F824C098;
	Tue, 29 Apr 2025 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947691; cv=none; b=qZPrDVv4zSkL/oTr5b1unD5qrYH+4AqLk0XiMo6rQEHwda48TOvk7mw91wALJZh9QT6c3BA3B+8kI7zHQ6/F1fd1byQKANJh5AluZBs0XfII2zlDsqVLdf16CrcuqvO4V43UrIyPD2NuYTLpzepIj97QWDy3Ic+UC3V7IglnrNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947691; c=relaxed/simple;
	bh=p8gbg2jOKpX6fxMe4XPINKyc41oLkJX6C4HYv6WC8Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAVsh9lMyL21rIYQKIu91tyIc2rCL/8flbEW7iskoop6UDaa6f3UrP9D8CxLirqu3H/nw+nxrh2h9JjK/HthTf3UUYKMpPFM4QE1QyNJpiQFkC4xaHv+V/FWNValz4IBFNl0mi3fkZ+s4/3uX7ItUJRBETkN0UKnw1E4OPfjT74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiCIzmYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiCIzmYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E06C4CEEE;
	Tue, 29 Apr 2025 17:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947691;
	bh=p8gbg2jOKpX6fxMe4XPINKyc41oLkJX6C4HYv6WC8Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiCIzmYXULBlIxQKFoijgKDicEiT9DsSNnWiTT43AuO4MuFYVacns5YDsexTiTH3c
	 RSYo7lW0aELo6kroGocHQs2iDpnVD+EXItCZnxLUJ0PVSb0q4g1MjZ45jp1O8JteSG
	 XSA+W1iKyDtAKmrWx/+mmNOViIapO5HBaOHyW7fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/280] ksmbd: add netdev-up/down event debug print
Date: Tue, 29 Apr 2025 18:39:38 +0200
Message-ID: <20250429161116.639916303@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 5f3f274e2ce68999b49901de4794c4b04125b154 ]

Add netdev-up/down event debug print to find what netdev is connected or
disconnected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 21a4e47578d4 ("ksmbd: fix use-after-free in __smb2_lease_break_noti()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index cc77ad4f765a9..0d9007285e30b 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -521,6 +521,8 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 				found = 1;
 				if (iface->state != IFACE_STATE_DOWN)
 					break;
+				ksmbd_debug(CONN, "netdev-up event: netdev(%s) is going up\n",
+					    iface->name);
 				ret = create_socket(iface);
 				if (ret)
 					return NOTIFY_OK;
@@ -531,6 +533,8 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 			iface = alloc_iface(kstrdup(netdev->name, KSMBD_DEFAULT_GFP));
 			if (!iface)
 				return NOTIFY_OK;
+			ksmbd_debug(CONN, "netdev-up event: netdev(%s) is going up\n",
+				    iface->name);
 			ret = create_socket(iface);
 			if (ret)
 				break;
@@ -540,6 +544,8 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 		list_for_each_entry(iface, &iface_list, entry) {
 			if (!strcmp(iface->name, netdev->name) &&
 			    iface->state == IFACE_STATE_CONFIGURED) {
+				ksmbd_debug(CONN, "netdev-down event: netdev(%s) is going down\n",
+						iface->name);
 				tcp_stop_kthread(iface->ksmbd_kthread);
 				iface->ksmbd_kthread = NULL;
 				mutex_lock(&iface->sock_release_lock);
-- 
2.39.5



