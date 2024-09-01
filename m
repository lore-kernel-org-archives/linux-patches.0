Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E1944393;
	Sun,  1 Sep 2024 16:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209544; cv=none; b=ERPsvHFQKCYkiWAjh58sFrUD+PmGKSpRJHwKsqt36P4YUOu+ovPxnrrjedYUzJfURwIwqZzCzXM5KvLzLrwmGklB/AnJT+zttdzwn82rvW1wgbCejgOqevpuyW/xRsnh9Ju9EXWpZgZ1dfLKF1/eke79r3eNDE+ElAsbCLakBqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209544; c=relaxed/simple;
	bh=VBH2mCcDRb3p8Nz9PkHQ6vAgDcQ6HUc4ENJu8nTxC6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYPGt9+Ei/EVgOQjqnKhgFhanVbeVeLZbQ467xvwONSwpw88BImqdcXkbRnChu6hlPikgodFozhs6YmNAo6rGtKS08F2hBgZC0IxAKbSy3NprQC8OwCrlg9gOHyUc42C63g9PBOIo50b4wKAHAb/AzQOKkYF+imbqCLUp77lWcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/rcYBlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/rcYBlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BC7C4CEC3;
	Sun,  1 Sep 2024 16:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209544;
	bh=VBH2mCcDRb3p8Nz9PkHQ6vAgDcQ6HUc4ENJu8nTxC6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/rcYBlD5zv4xUNOMwhQJ2L7gzhl8y10yMRz0wlFzfQ9/1QXNJCz62T686lrIwH4G
	 dY+f4NAuxw0ySC164lPlfaohLyykU9NsnDDj4A7AYbTIgOPTIdIe7lXLloN5psOdRT
	 KiMQNyOY0+7+VDY0Tuw+SaPUBMxydHgg0YE4nxR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/151] Bluetooth: bnep: Fix out-of-bound access
Date: Sun,  1 Sep 2024 18:17:10 +0200
Message-ID: <20240901160816.751003212@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 09b6d825124ee..f749904272961 100644
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



