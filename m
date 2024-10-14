Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF3B1AB536;
	Mon, 14 Oct 2024 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918733; cv=none; b=MpNHaYcr+Me9tyyKrHPpHeWR+9yQWWyxnNpwFoQ7mgvt9l+MmykwakD5wktgCxS7P6et32ZaG043UqICbOZMNQ44RGqXgp8SdYRqhQ9WuYBPFl6mgSEpvMcqsiIzR7pPQ+kPFvRZEQbH82ten1gsGPtwGOTw4jf2bR9bUfF/MoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918733; c=relaxed/simple;
	bh=RcFdWNQ4JYv8rp6p4WYflzD9ueEIzvp7RPuMoSTKDtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q49JlIkVYuXYkspIy7QiYLGAOiaFsmF9Q5MPrf9rauwzkvP0nGS3AwsPhiI0a2XUQv8E0FHTcaFcGML4bR3DJa6n8YAACMlxbm8IF/TrVSMfMU09FMablUqfoB9iVHcjfBfBJxVCbhMGz+1bSdOAbc/8GzmWaZYbuunPZE02d7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdeZeSC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdeZeSC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E44C4CEC3;
	Mon, 14 Oct 2024 15:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918733;
	bh=RcFdWNQ4JYv8rp6p4WYflzD9ueEIzvp7RPuMoSTKDtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdeZeSC1lfLvQheCIJwfPICj8S8PmC/zhmjPdeDo5UYaG+8SZxdWnwOJcsnmyl8B/
	 IrxqxLnLe1hq2Mjj258pGdhbRUrnO+BvfHZynf1smz9s/4b0ftE59wFrtKT9+VtqSO
	 fOybDn57396J9YVRshg9i8eXzLQn7gPG9Lrj8kh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 408/798] Bluetooth: hci_sock: Fix not validating setsockopt user input
Date: Mon, 14 Oct 2024 16:16:02 +0200
Message-ID: <20241014141233.977925963@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 730e569cae36d..e7ec68fa3ad3c 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1883,10 +1883,9 @@ static int hci_sock_setsockopt_old(struct socket *sock, int level, int optname,
 
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
@@ -1895,10 +1894,9 @@ static int hci_sock_setsockopt_old(struct socket *sock, int level, int optname,
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
@@ -1916,11 +1914,9 @@ static int hci_sock_setsockopt_old(struct socket *sock, int level, int optname,
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
@@ -1979,10 +1975,9 @@ static int hci_sock_setsockopt(struct socket *sock, int level, int optname,
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



