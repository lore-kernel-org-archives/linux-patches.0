Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B8482486;
	Mon, 15 Apr 2024 14:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191247; cv=none; b=V2xtNQHhGv2QC1z275TMb2vg4MzLmzNf/ZT/b+LfY4IK3LsL3MgvLOSNyR8Eg8JI95TChYMAxFMHsxoDuy+ug/HlJ/vMNaJ4cmfi135BrM3xJuNk9q/Io8uDxMT2ERMDBg+ML6NJtK0xn6bwbfdfJ5krlJv79JmtUA47Ac7kBJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191247; c=relaxed/simple;
	bh=IyPyn+rZ7j126vqOT1dqMoNkE+gHcLVkT82SPPJtjQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wu63CJgXxUkLk6KmDXJJScZVaYGjVwjiwR8BTRYGa/i2aVfs2CqSY2WBe0zobk3hPHK8QpgoGpAPU+DwRFYXrT+ywankMACKiWV3rRyRCFrLnVTrPfJd/MDTMHNJhfRbMjP/1KMhVrTPAFQzx485j7YuLey/TWNRVHL9RIA2i2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+2dpHt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+2dpHt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E82C113CC;
	Mon, 15 Apr 2024 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191247;
	bh=IyPyn+rZ7j126vqOT1dqMoNkE+gHcLVkT82SPPJtjQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+2dpHt1O2VSPWLy7mAbJoJyp7i3MKNhQOcJIW5GeElSIHQtIMggH7S6bNqdHiUFU
	 S2ZoxSm8/0VDmoETkbb28M6jvake6uvWiJkaCP+q/yLi9ClelN+P66AUR4PGG6fBcn
	 zCIDXb4FT2V3314Lqfil+F/Of6c7XJClkrjp9y6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 079/172] Bluetooth: hci_sock: Fix not validating setsockopt user input
Date: Mon, 15 Apr 2024 16:19:38 +0200
Message-ID: <20240415142002.802285088@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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
index 3e7cd330d731a..3f5f0932330d2 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1946,10 +1946,9 @@ static int hci_sock_setsockopt_old(struct socket *sock, int level, int optname,
 
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
@@ -1958,10 +1957,9 @@ static int hci_sock_setsockopt_old(struct socket *sock, int level, int optname,
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
@@ -1979,11 +1977,9 @@ static int hci_sock_setsockopt_old(struct socket *sock, int level, int optname,
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
@@ -2042,10 +2038,9 @@ static int hci_sock_setsockopt(struct socket *sock, int level, int optname,
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



