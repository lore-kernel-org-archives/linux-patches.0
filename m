Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795B7450903;
	Tue, 16 Jun 2026 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625489; cv=none; b=QjNNEqVPP6exwc5FujpCEKD0ALNn/vY0s0p/uzw406cOBtt6s6LLQGxiWJ8SOjdz4iDtoMQsK5DJs01mrsG1Sytx0Tw3tx3JZqp9H4ctJDG0doyCVQYuwq+xpCDoy+ojGxCUF5Aac3pmQA/Nz0EkB/4e0a2uAs99m+yxG4W/reM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625489; c=relaxed/simple;
	bh=xuEiAjwZ020NUh/BDUDYJdkf2CFqai8fWb9DIzxgv3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Chme9xTL296fdLWaNjTr/Hccck3XT2n4Bij/Te0XeasjKDL6fg33XETnG1CdrxjuVR72tnDb4aDXGAjtlMBYYHGw4dpjSyB5mOnAE+RGUyfKGx6t8xOLb7yls2DTfxv3FPCxV3CIgKBZmLAOxzzNoXrRv46H+FHc4UnOUe67J8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCKmjgzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCKmjgzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7751F000E9;
	Tue, 16 Jun 2026 15:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625488;
	bh=ZsuGtyayaX736xm2j/mGcpb8+NDfRDLB6WY6BJQanNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCKmjgzw3g9Y28LT5EEPC2Nh76VMQhDqVWSCHn+X32tzP98igwTvTxVfpd1we3jfm
	 oRjEopC2LqkKvrs46talOeUp4ZyvDoqheSCmhQMiLlK7qXEaHFKeYN/SRs/rSrVMLv
	 IKsZ/VHAyQZJXBGg6rp7Tn0LfhcnltQqHw+juQkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/325] tun: zero the whole vnet header in tun_put_user()
Date: Tue, 16 Jun 2026 20:28:36 +0530
Message-ID: <20260616145103.690217179@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9a767da38c71e7..d27c3229465ad9 100644
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



