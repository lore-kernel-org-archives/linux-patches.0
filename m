Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9D473722;
	Mon, 29 Jan 2024 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548540; cv=none; b=XU6hAFw7s480QQDAv+Fs5Uu+G0WhG+aIG7hoqCIZnePJ+9ZBF8VCtjtzw47RhWVS8nBtoMWpOCRBSzS8sT6WWhWShf0O9I5RBcJl/Ckl2LUMOqMjkOzwY9WP2DnfS97WOLUYjc7OFaiKIlIOPgLTlzbcvw2LPSabst9sRBeMA9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548540; c=relaxed/simple;
	bh=RbGb1vLYZKe071E6Qiu/1NM4eUggNxHloA1YwZsTddU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDlErc1RhqDp0TfDWwZN4C8iBRfh7j5HO6NJak51rdHfaxDqHF5rottwBLpdKjeo6Nk66QEtXzfVqDM0cVrxgSgSWVcXwwczOCuEV2F9YBHUZVmmLPKb5kM7cd4Iz+j+opsGdg1S8Gr9MKxlI4Yc0qvULy7fZRlB+aVRv8fMqic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfxLNXL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfxLNXL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EB4C43394;
	Mon, 29 Jan 2024 17:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548540;
	bh=RbGb1vLYZKe071E6Qiu/1NM4eUggNxHloA1YwZsTddU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfxLNXL9GqDh+Xbj/xlzqQnM0sAkuX+FFZQIMq6ogpTatjpQiv4YKN5BNlCnMRoD5
	 fymxKh1DjyZmYQgMvq2zO4wdGHPXVr6vKNNfENiJbHqYRajDdW8jjUthEJILuaGpeO
	 fsdXxtZzbkewhI8XlotPeFNrKpyb93sAwLKsdZdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/331] tun: add missing rx stats accounting in tun_xdp_act
Date: Mon, 29 Jan 2024 09:04:04 -0800
Message-ID: <20240129170020.170437129@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit f1084c427f55d573fcd5688d9ba7b31b78019716 ]

The TUN can be used as vhost-net backend, and it is necessary to
count the packets transmitted from TUN to vhost-net/virtio-net.
However, there are some places in the receive path that were not
taken into account when using XDP. It would be beneficial to also
include new accounting for successfully received bytes using
dev_sw_netstats_rx_add.

Fixes: 761876c857cb ("tap: XDP support")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 237fef557ba5..4a4f8c8e79fa 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1634,6 +1634,7 @@ static int tun_xdp_act(struct tun_struct *tun, struct bpf_prog *xdp_prog,
 			dev_core_stats_rx_dropped_inc(tun->dev);
 			return err;
 		}
+		dev_sw_netstats_rx_add(tun->dev, xdp->data_end - xdp->data);
 		break;
 	case XDP_TX:
 		err = tun_xdp_tx(tun->dev, xdp);
@@ -1641,6 +1642,7 @@ static int tun_xdp_act(struct tun_struct *tun, struct bpf_prog *xdp_prog,
 			dev_core_stats_rx_dropped_inc(tun->dev);
 			return err;
 		}
+		dev_sw_netstats_rx_add(tun->dev, xdp->data_end - xdp->data);
 		break;
 	case XDP_PASS:
 		break;
-- 
2.43.0



