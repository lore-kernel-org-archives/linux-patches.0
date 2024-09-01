Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D31517C;
	Sun,  1 Sep 2024 17:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210120; cv=none; b=rpu3HP187puLbz0bN5gwxqQlTw+XNSq/g7IH88P/yl32zASzGAOsHwuM7w+WNhSmYQCzeQdpLpK47GzJAXlv/BWRJ9GSN0jTH7kAox8tRY5b85KtvXNnp7taXhdKaQ7ZYPcieODaKRXtHeFRgsJY56lHrLeXWEsydMhwlJJ5j4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210120; c=relaxed/simple;
	bh=8LMrs6We4La9lJ4s/nncp1RTjbxeSLHWXBaLtjYwffI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+ieVuAx+w71FYmMO96jPOkKaH5sgFTTln7WgVfzwVF+y5NvokPHvLEZOCUdZyDEolsVbNgZGvUd+MMjdT2/oytTUjlCd1dFZ4ynnkZgJ/Q48oAUjGAPgAoUkC7uHtfuG3Gm5t8vEl6rN8XnTHvmpdH/e9br+mHEkv/fGVzwAdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIjuuLTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIjuuLTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C092BC4CEC3;
	Sun,  1 Sep 2024 17:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210120;
	bh=8LMrs6We4La9lJ4s/nncp1RTjbxeSLHWXBaLtjYwffI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIjuuLTl2FfLUAwxgfj8JNRNcQPm5jSpk3qqfbheV6MoE86hJssRBpX+n+DXAkwVU
	 3XH9tpGgAv0JfkL2W58zoUTLsOADAf/kH1jZKwO12an9hKyxxRiTfuqh/VHHFw2h9x
	 1PBraQVP56W0FBKJzBc/wQQsEBtK1td3LUUuYGAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/215] Bluetooth: bnep: Fix out-of-bound access
Date: Sun,  1 Sep 2024 18:16:46 +0200
Message-ID: <20240901160826.904415119@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 0f0639b4d6f649338ce29c62da3ec0787fa08cd1 ]

This fixes attempting to access past ethhdr.h_source, although it seems
intentional to copy also the contents of h_proto this triggers
out-of-bound access problems with the likes of static analyzer, so this
instead just copy ETH_ALEN and then proceed to use put_unaligned to copy
h_proto separetely.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/bnep/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index a796d72c7dbaa..8bb6c8ad11313 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -385,7 +385,8 @@ static int bnep_rx_frame(struct bnep_session *s, struct sk_buff *skb)
 
 	case BNEP_COMPRESSED_DST_ONLY:
 		__skb_put_data(nskb, skb_mac_header(skb), ETH_ALEN);
-		__skb_put_data(nskb, s->eh.h_source, ETH_ALEN + 2);
+		__skb_put_data(nskb, s->eh.h_source, ETH_ALEN);
+		put_unaligned(s->eh.h_proto, (__be16 *)__skb_put(nskb, 2));
 		break;
 
 	case BNEP_GENERAL:
-- 
2.43.0



