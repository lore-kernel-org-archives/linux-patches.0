Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774306;
	b=3pjcgNd3hCQQ+91ks17Eg9ACTxCDNrkE7drQLLfIX6XTVTa0dRCeSMQWDYgssY7/TKTG
	 9z3o1XDsxgrXT8ZtZSA3cEJuHqtpAbU93SLaJoF+0fSLF8hXGAPVDqUjFYFXXIDzOILtz
	 /v6ieoI/U5FuxwKWKGKScQXm+i17gbDzmw5x/gYMxdS+CUHE9ICwPqFUN9dE+d3lwEvFt
	 wCmR2SmE+DZdinxzVM+TLh93tezkIaRwOF+3RJIxyh6Rx6WWQjp3/6txHU+IyBOoK5xbD
	 dNiZnLpPPaoSUvzM6K6cet250GbbmtnwzQWvMAonZTLGwM+5NKGF9wuNiTzPKtaFTgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GEF1+QWPY/IX5vqpooRzt4mpovlZjtHO3D5y01kAzBY=;
	b=ndAoe5718mjRkOXE/x9r003pHJKWNWQ3gjYYN6PKC8DnBq3qAi9HfoISMnphfkhhEmZo
	 1S3/uFd9XeL4/OM0CnmJQTOZUopcIaQud1O7jpXOH/mVDIPa1fjZ6+EJfe1Oo72w2m77G
	 Mb+xuQRKLmvBrvXc1tnLUcNOUz0iF5Nirewrc5j/LKxfAH4/6a6XrYn1aUMjJrPh+QtkT
	 VBwnzRPi3vvkU0C6Y3fO5gV4+GaTx1hq4LRFC7oh3unk6uM02R82aUhHAMNG8wBLCn6Lq
	 QpYk/2h/IF5bunVdTBz0TqfLBVmWvd1CAZDRirk19NxO6M2Xsr19l2AhZAl1ztqVyKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bon6L106;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A69D606A31B;
	Fri, 23 Oct 2026 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bon6L106
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD321F01825;
	Fri, 23 Oct 2026 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774306;
	bh=GEF1+QWPY/IX5vqpooRzt4mpovlZjtHO3D5y01kAzBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bon6L106ihlupzIxZfeuk1ZCOjVfPp160ClywkYWj9ZF+/LHniH+s2WlVVRnUDRrK
	 +MMEAw3tSHxJg2zKLPlHXkV6vWLhBXv8vRZG2eXzdIuhQ5tN6Cv3qhcGgAOn2TT0cH
	 V07R7kBI6c/Sv1KhTf99Jz03QUW3tyu3hq36xkJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Slepecki <jakub.slepecki@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 191/193] ice: fix broken Rx on VFs
Date: Fri, 23 Oct 2026 18:37:48 +0200
Message-ID: <20261023163718.738683851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

commit 436fa8e7d1a119ec90f39e7c2ce0f3a146652899 upstream.

Since the tagged commit, ice stopped respecting Rx buffer length
passed from VFs.
At that point, the buffer length was hardcoded in ice, so VFs still
worked up to some point (until, for example, a VF wanted an MTU
larger than its PF).
The next commit 93f53db9f9dc ("ice: switch to Page Pool"), broke
Rx on VFs completely since ice started accounting per-queue buffer
lengths again, but now VF queues always had their length zeroed, as
ice was already ignoring what iavf was passing to it.

Restore the line that initializes the buffer length on VF queues
basing on the virtchnl messages.

Fixes: 3a4f419f7509 ("ice: drop page splitting and recycling")
Reported-by: Jakub Slepecki <jakub.slepecki@intel.com>
Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Jakub Slepecki <jakub.slepecki@intel.com>
Link: https://patch.msgid.link/20251124170735.3077425-1-aleksander.lobakin@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/virt/queues.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/intel/ice/virt/queues.c
+++ b/drivers/net/ethernet/intel/ice/virt/queues.c
@@ -863,6 +863,9 @@ int ice_vc_cfg_qs_msg(struct ice_vf *vf,
 			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
 			     qpi->rxq.databuffer_size < 128))
 				goto error_param;
+
+			ring->rx_buf_len = qpi->rxq.databuffer_size;
+
 			if (qpi->rxq.max_pkt_size > max_frame_size ||
 			    qpi->rxq.max_pkt_size < 64)
 				goto error_param;


