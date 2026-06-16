Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6687C44BC8E;
	Tue, 16 Jun 2026 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623382; cv=none; b=TqBFTWa/Kn+Sy8nFBVaAo7UqW9SDbdnATouW0+e5Mo3qB8aSJzbqsdjKGczY2GSfMxdBdGMjK6W+BL193yOElL6z5t657NfyMws7Tiv3+n9Kpfs/ltnXKVGqNbr08AvY87kF/vBeYD4ffOZZYK2zJ9qAceiWDz8GEH+KDIuBc28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623382; c=relaxed/simple;
	bh=SbUMs9vh7QufIdd0AqcLPz01ePEsKdXiylmONYC5NtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8Nz+wZMsZi8/rfG3Ibi2ooaDDAQHXNFOy0zW37/cDCvQukFtgDEkaTPgTvfTALPTIMWYAZ9XUKaGaobtCzO4CCoqQAtcCRxpcnDKJ9bzOMXF70kwf1A3HObutaesBN6UTP0x3Sw571l5ut+8OKcLTuGj/I28oOpvJCh6Mx5c8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udXfNRTl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udXfNRTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270B81F000E9;
	Tue, 16 Jun 2026 15:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623381;
	bh=+M4HbCwR83aHAsshQmaLzO2bbKPUwl7//5QHuUeTIHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=udXfNRTlno6r0VyTPIiDbEgyLVJXb/CXPMO2YsItioiSNHEQPRGhDh85IQo68Mz70
	 pf/9H5RybgkDKF7cV/XsPe1DCK78eobEod3rRkRsfyCj7MOQUTjsFa2fwdWVYh3om+
	 UJ2k2vsw56fSxnnD4jZt+Z5g68QFYKx13LtUOZm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 136/378] tun: zero the whole vnet header in tun_put_user()
Date: Tue, 16 Jun 2026 20:26:07 +0530
Message-ID: <20260616145117.456063046@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 7f2fcff15e99bb852f6967396ed12b38376e2c8d ]

tun_put_user() declares an on-stack struct virtio_net_hdr_v1_hash_tunnel
without zeroing it. For a non-tunnel skb, virtio_net_hdr_tnl_from_skb()
only initializes the first 10 bytes (sizeof(struct virtio_net_hdr)),
leaving bytes 10..23 (num_buffers and the hash/tunnel fields) as stack
garbage.

An unprivileged user can set the vnet header size to 24 with
TUNSETVNETHDRSZ, so __tun_vnet_hdr_put() copies all 24 bytes of the
partially-initialized struct to userspace, leaking 14 bytes of kernel
stack on every read of a non-tunnel packet.

Fix it the same way tun_get_user() already does by zeroing the whole
header right after declaration.

Fixes: 288f30435132 ("tun: enable gso over UDP tunnel support.")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260607054428.3050243-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ca0ae5df73af78..a0bd803e5fb4d5 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2068,6 +2068,7 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 		struct virtio_net_hdr_v1_hash_tunnel hdr;
 		struct virtio_net_hdr *gso;
 
+		memset(&hdr, 0, sizeof(hdr));
 		ret = tun_vnet_hdr_tnl_from_skb(tun->flags, tun->dev, skb,
 						&hdr);
 		if (ret)
-- 
2.53.0



