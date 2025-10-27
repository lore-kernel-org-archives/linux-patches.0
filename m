Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F24132D0E6;
	Mon, 27 Oct 2025 19:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593242; cv=none; b=J/9buA1muuJzUj5wnsDB1PkBeZoMSyJMU42V89o++tZGI1fdaBlOlSjwWdTDHhnC1K/hKG0EUBhIBRTQ1M0tjDMgT4nJtp+a2SEon10cDsmTTanRaUagGrjjwTiUfRKZmI47StaTrHJY4Nd3hTfvFGExkBIASi0kJALMhC1T5Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593242; c=relaxed/simple;
	bh=iFt+z6H8FD2Vy6nz2Nb5JCZ0MA3zIXXNbcWVQ1vFwgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEwTykg/4DYCYKqDdxjJh0CEQUnVv3oBQxi6MQipa4QNimQXEaujX4RoTRiI6r4liioYGtwPQUoQsMfCAt1L7s+VWrHVB4N7XieBIvd6foPMBpUBCR1S2T1twGpsUWbdiEaWsGfEQRx1TkkgNBCc62jKInQVY10MdfSEJniq6oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1PWnsgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1PWnsgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E7DC4CEF1;
	Mon, 27 Oct 2025 19:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593241;
	bh=iFt+z6H8FD2Vy6nz2Nb5JCZ0MA3zIXXNbcWVQ1vFwgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1PWnsgvaZyuB3u2/0Wkh30pQJhj6B1qb1T3zDzAxXzYyEBmCl4gT0SKlINrYORoO
	 ZgH0A6mKO/CYZlft2Ao45FdxFGG6lE8ffztxLDoOWUIY8ClhTYt1E11W2SusXivKld
	 6kZ4SWHqWK1x1msw252jBS/6w3VPTqhjIDF+aYPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 066/184] virtio-net: zero unused hash fields
Date: Mon, 27 Oct 2025 19:35:48 +0100
Message-ID: <20251027183516.668844792@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit b2284768c6b32aa224ca7d0ef0741beb434f03aa upstream.

When GSO tunnel is negotiated virtio_net_hdr_tnl_from_skb() tries to
initialize the tunnel metadata but forget to zero unused rxhash
fields. This may leak information to another side. Fixing this by
zeroing the unused hash fields.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: a2fb4bc4e2a6a ("net: implement virtio helpers to handle UDP GSO tunneling")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://patch.msgid.link/20251022034421.70244-1-jasowang@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/virtio_net.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 20e0584db1dd..4d1780848d0e 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -401,6 +401,10 @@ virtio_net_hdr_tnl_from_skb(const struct sk_buff *skb,
 	if (!tnl_hdr_negotiated)
 		return -EINVAL;
 
+        vhdr->hash_hdr.hash_value = 0;
+        vhdr->hash_hdr.hash_report = 0;
+        vhdr->hash_hdr.padding = 0;
+
 	/* Let the basic parsing deal with plain GSO features. */
 	skb_shinfo(skb)->gso_type &= ~tnl_gso_type;
 	ret = virtio_net_hdr_from_skb(skb, hdr, true, false, vlan_hlen);
-- 
2.51.1



