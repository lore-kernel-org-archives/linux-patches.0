Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EF54F3EB6;
	Tue, 13 Oct 2026 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894535; cv=none; b=GWVK2SuqEa1BvIQ+jE/WcVG7UBGHQSMbMvxEasiTgKyCoZ5zfWdFHF6TAlMeoirYODrMrYymUOTSexS++eRRo3HUzE01sY+8qB7xymBOLfwfeWoZTZ+MPglWUttKJx91nwWUYfZF71HqwWT9Z7k41vloT0bztytq57owJyAc8Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894535; c=relaxed/simple;
	bh=6XI5z0WZ3CjXVVY/ZR1qRvrArs3SHTAAt2e4rvzUE/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u9aIj/iD0fR9EGOAl8fcmWLRUj2PSY99iSB+wp1vPypEcnvRyywPJYeTCLxnHMhUotbvoLyYm8KKCv+FO5E9e/JbA4e44rDPOSHSq9JW4FSwSf1gwF/dSA7h5/6gAul5kZ+MFMJTjBALgzyVtZb/OgyYJRmq7NE03LtpqBaunGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwTsuL9K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwTsuL9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C531F00893;
	Tue, 13 Oct 2026 12:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894534;
	bh=MW3tZPuB7ALgYJIBZz4x7t+n8KCgjcQA05TXIq4RNVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwTsuL9K5P8tI+kuOjCEYvyS4IBqR9WmSVb6Wggwwwzif4Rz/uV769YMa661JLusz
	 OLVAMqBpMHu3NN2volbrW5aH+pa3pq5QFCeSKQktTXTf9e26da+ThPVmhPH9SnQ5Cg
	 Tx5Pf7OryosD7wJxR9O7/VQqjHDTNB8Q82CXbzv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Gao <tianyi@cloudflare.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 594/621] veth: fix peer NETDEV_XDP_ACT_NDO_XMIT after GRO is toggled while down
Date: Tue, 13 Oct 2026 13:39:49 +0200
Message-ID: <20261013112934.898551824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianyi Gao <tianyi@cloudflare.com>

[ Upstream commit 3f090039995f609a8e236f37980dee5712dded61 ]

A veth device advertises NETDEV_XDP_ACT_NDO_XMIT only if its peer has an
XDP program attached or GRO enabled, that is, only if the peer will have
NAPI to receive the frames.

veth_set_features() updates the peer's flag when GRO is toggled, but
returns early if the device is down, and veth_open() only refreshes the
flags of the device being opened. Toggling GRO while the device is down
therefore leaves the peer's flag stale after the device comes up.

If GRO was enabled while down, the device comes up with NAPI but the
peer does not advertise NDO_XMIT, and devmap rejects redirects to the
peer with -EOPNOTSUPP. If GRO was disabled while down, the device comes
up without NAPI but the peer still advertises NDO_XMIT, so redirects are
accepted and then dropped in veth_xdp_xmit() with -ENXIO.

Commit 7a6102aa6df0 ("veth: Update XDP feature set when bringing up
device") made veth_open() refresh the device's own flags. Refresh the
peer's flags there too. The peer's flag depends on this device's XDP
program and GRO setting, not on whether the peer is up, so it is
correct to set it even if the peer is down.

Fixes: 8267fc71abb2 ("veth: take into account peer device for NETDEV_XDP_ACT_NDO_XMIT xdp_features flag")
Signed-off-by: Tianyi Gao <tianyi@cloudflare.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261006173241.65945-2-tianyi@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index fea031d491b34..148114ab85ac3 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1414,6 +1414,7 @@ static int veth_open(struct net_device *dev)
 	}
 
 	veth_set_xdp_features(dev);
+	veth_set_xdp_features(peer);
 
 	return 0;
 }
-- 
2.53.0



