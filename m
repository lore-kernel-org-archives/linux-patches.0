Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58221DE4CD;
	Tue,  8 Oct 2024 13:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393067; cv=none; b=cPRI0jQFTS6kU+zBEKKTUXYVY1nL8Qx/d2Z2mJa+AngWsoLnk0gR1eHGw7EPsStAMjacj6jWl/XgPFkrtmeBJ7ZQmMV3Zbt3uThMFmeAKSuVDPyg0QnPM9WO9LVXWJeEkNJsb1mV3iFHP+xvoIPG/Atk/FY5vcvJCaPw/jXqPw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393067; c=relaxed/simple;
	bh=A1NKzNTbJH/znyX5l/Q8NCJrvv6lRptMpmFQfIEJiCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPXXnJeiCsCHxExd+q5rPk7sE4NxFWYbCHjNySBhF/zLDDpD8majYl+NEadEz3RHKWlXSafUXKmgiVXBZI2XkzkyphPFqQQa+6siX6Q/y5PvtipJLga0GOAnUOdlTfDCzik1baHXuwL8SXdf1mMRwjfzwq9btyQfA1q0/Tp5lPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hgj5DeRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hgj5DeRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28225C4CEC7;
	Tue,  8 Oct 2024 13:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393067;
	bh=A1NKzNTbJH/znyX5l/Q8NCJrvv6lRptMpmFQfIEJiCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hgj5DeRm+p4eAil4RKTsOhLFV2mcK9CDmosSApzUz0XkCZ0thIeai59Qzy5WTUUQ2
	 DgXhOsInCSgSJ+5QVjCRfljBOScyyxaSKf2iqNfxAGW2dHD/tAJcXEVKAdSxHpvqDP
	 beRqawKlc24TsSlDgAPIIhMK5Q367uBtJUPTfVWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/386] Bluetooth: hci_sock: Fix not validating setsockopt user input
Date: Tue,  8 Oct 2024 14:04:47 +0200
Message-ID: <20241008115631.129164002@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit b2186061d6043d6345a97100460363e990af0d46 ]

Check user input length before copying data.

Fixes: 09572fca7223 ("Bluetooth: hci_sock: Add support for BT_{SND,RCV}BUF")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sock.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 3d904ca92e9e8..69c2ba1e843eb 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1943,10 +1943,9 @@ static int hci_sock_setsockopt_old(struct socket *sock, int level, int optname,
 
 	switch (optname) {
 	case HCI_DATA_DIR:
-		if (copy_from_sockptr(&opt, optval, sizeof(opt))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opt, sizeof(opt), optval, len);
+		if (err)
 			break;
-		}
 
 		if (opt)
 			hci_pi(sk)->cmsg_mask |= HCI_CMSG_DIR;
@@ -1955,10 +1954,9 @@ static int hci_sock_setsockopt_old(struct socket *sock, int level, int optname,
 		break;
 
 	case HCI_TIME_STAMP:
-		if (copy_from_sockptr(&opt, optval, sizeof(opt))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opt, sizeof(opt), optval, len);
+		if (err)
 			break;
-		}
 
 		if (opt)
 			hci_pi(sk)->cmsg_mask |= HCI_CMSG_TSTAMP;
@@ -1976,11 +1974,9 @@ static int hci_sock_setsockopt_old(struct socket *sock, int level, int optname,
 			uf.event_mask[1] = *((u32 *) f->event_mask + 1);
 		}
 
-		len = min_t(unsigned int, len, sizeof(uf));
-		if (copy_from_sockptr(&uf, optval, len)) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&uf, sizeof(uf), optval, len);
+		if (err)
 			break;
-		}
 
 		if (!capable(CAP_NET_RAW)) {
 			uf.type_mask &= hci_sec_filter.type_mask;
@@ -2039,10 +2035,9 @@ static int hci_sock_setsockopt(struct socket *sock, int level, int optname,
 			goto done;
 		}
 
-		if (copy_from_sockptr(&opt, optval, sizeof(opt))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opt, sizeof(opt), optval, len);
+		if (err)
 			break;
-		}
 
 		hci_pi(sk)->mtu = opt;
 		break;
-- 
2.43.0



