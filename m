Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2F3157E79;
	Mon, 29 Jan 2024 17:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548345; cv=none; b=NMDV2KbwQWhCEF5WPZt7TihHw+rRoVkUVOznhpmTxywSTo+O/cC5rm72vsexdvB4MFOkgZEEmryBpCzB/iuepUme71uDKd8GjHBpMLhELgG9U8bG69owDcqrk/NJ6Gq8DVBIgvI5c58hDI/azOWmd22wYf8f83X8MwrGtGd9BKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548345; c=relaxed/simple;
	bh=EFZXoQ7Fk/pwg+e0dBl3xXRLVuQ3cCVI3gRxf8GZRsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEQOVgjxQcMo3/shSdFCqU/8iT30eHEXpSLlZyrndv+j0Fr9WSmvc10AtQ7Qxzik94M9pz5Cr9QNE0P2z14QlIoV30hMbqI4XPtOHv2Bd9ZroobtpldBRFFkWxMwfBGQw7099wUtJQ+zV8N4r9SexNw5fhyzcYwV1KOfGhvK3jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/gZw3O/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/gZw3O/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D44C43390;
	Mon, 29 Jan 2024 17:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548345;
	bh=EFZXoQ7Fk/pwg+e0dBl3xXRLVuQ3cCVI3gRxf8GZRsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/gZw3O/6omzJCJ/IedRDBdT14Xki8GLdLSAK3ioA+WgKJ1Njho0JuG5MHG+o60uF
	 l6Kv8B+8RqzzSaryyKOTA2jEaVJjprL/fGVd4iC9GY5Nf9Q/1aNkbQUoOG1a/kKkVG
	 voPvOnyoew92eMDsjRFmLWNF8IWE4AYsTrebyEAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/185] tun: add missing rx stats accounting in tun_xdp_act
Date: Mon, 29 Jan 2024 09:04:46 -0800
Message-ID: <20240129170001.367943860@linuxfoundation.org>
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
index af32aa599278..367255bb44cd 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1626,6 +1626,7 @@ static int tun_xdp_act(struct tun_struct *tun, struct bpf_prog *xdp_prog,
 			dev_core_stats_rx_dropped_inc(tun->dev);
 			return err;
 		}
+		dev_sw_netstats_rx_add(tun->dev, xdp->data_end - xdp->data);
 		break;
 	case XDP_TX:
 		err = tun_xdp_tx(tun->dev, xdp);
@@ -1633,6 +1634,7 @@ static int tun_xdp_act(struct tun_struct *tun, struct bpf_prog *xdp_prog,
 			dev_core_stats_rx_dropped_inc(tun->dev);
 			return err;
 		}
+		dev_sw_netstats_rx_add(tun->dev, xdp->data_end - xdp->data);
 		break;
 	case XDP_PASS:
 		break;
-- 
2.43.0



