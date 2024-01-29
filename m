Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FE515703F;
	Mon, 29 Jan 2024 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548329; cv=none; b=VLaElDJNlzn8gCaMawU2Zg+yNDyKzSVggvOEBy+vZFO38qnHy19xM0RwNEv+WJDNnGMJdIY1BW0gZ51EBGNz+3ibe4IXAdY0I8Fbe/sXUte4hlGiuVWcPCdGD4yHJHaYXCg1PzpTIKSNHO9CKZ40goaH0N4bniv961UEme4R40c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548329; c=relaxed/simple;
	bh=7Mu6ImZrmVQ1OQ/mym6pF57aXYmwuXq54W1WVyf2zaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfwz/UjX5oVPDVYeNMSV+K5Bv9ifRo9yoiwVESDYJ5W2UrDuAR4/7hFfrQ6OXg+25jEWwT6Ak9h0w4hB8lSFMFI6WsVpeGTji3BApGIcpeMptYqKygl2RWVaeDncKHHwt1GBuFQYNtACXZ/QlAqgAA4f0G6mmRQingfek1DxSn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j77KH7bQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j77KH7bQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5561C43394;
	Mon, 29 Jan 2024 17:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548329;
	bh=7Mu6ImZrmVQ1OQ/mym6pF57aXYmwuXq54W1WVyf2zaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j77KH7bQgYpSV5KzvrAZJBTA8UBnhmhliU3JAWw3okYK+dl9Bq3Xcttj6S6SSs7k8
	 IMlkAioDvdxQDK+rDn7JFqDCl9SHUuE1HR9Ei1J6+XuE3Zy3MBCAV1GImncDmObRmk
	 nDjg7ZnZ0FH9WaplaT5lQZ7bHwKkiCrtOWDS6DKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/185] tun: fix missing dropped counter in tun_xdp_act
Date: Mon, 29 Jan 2024 09:04:45 -0800
Message-ID: <20240129170001.334550947@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 5744ba05e7c4bff8fec133dd0f9e51ddffba92f5 ]

The commit 8ae1aff0b331 ("tuntap: split out XDP logic") includes
dropped counter for XDP_DROP, XDP_ABORTED, and invalid XDP actions.
Unfortunately, that commit missed the dropped counter when error
occurs during XDP_TX and XDP_REDIRECT actions. This patch fixes
this issue.

Fixes: 8ae1aff0b331 ("tuntap: split out XDP logic")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d373953ddc30..af32aa599278 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1622,13 +1622,17 @@ static int tun_xdp_act(struct tun_struct *tun, struct bpf_prog *xdp_prog,
 	switch (act) {
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(tun->dev, xdp, xdp_prog);
-		if (err)
+		if (err) {
+			dev_core_stats_rx_dropped_inc(tun->dev);
 			return err;
+		}
 		break;
 	case XDP_TX:
 		err = tun_xdp_tx(tun->dev, xdp);
-		if (err < 0)
+		if (err < 0) {
+			dev_core_stats_rx_dropped_inc(tun->dev);
 			return err;
+		}
 		break;
 	case XDP_PASS:
 		break;
-- 
2.43.0



