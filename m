Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0A326E6F4;
	Fri, 21 Nov 2025 13:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731187; cv=none; b=j7JrNGcxSSxyiGL9Wxtkpm3xOMJseT/UspGOxGSyvsyMbxllEQHguE9elc2jUMDyVwVnAjPO/a0HGkibTpGdiKpQUrpLWitWVCwzPCs6YY2zOPSKFLPjokom+3UmV+QwIn3bEtJynlpGbXaUoLdtnEt+YXQsMkmtDrbYgWOP1QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731187; c=relaxed/simple;
	bh=3eLXLqes1peR43hA99gZ4i0kCxjdVOssv7L3j2UnkTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DO2aMWc7+RXOGUW0YDdchg30g8HXCUTq8KKeO/DakUFaymCorRlLufb6/N6qGfQ0AyG5mJhbni7RpSKGFi2UE/CgfFfTkC7Td2Hfz8lfOmbDDHf0sQn/qR6fQeWK8mTtFdxu1pwboBtKWDzxZ/35WOyu4u9rhUGzqwvnI8UthhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUEW55ij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUEW55ij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8A0C4CEF1;
	Fri, 21 Nov 2025 13:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731187;
	bh=3eLXLqes1peR43hA99gZ4i0kCxjdVOssv7L3j2UnkTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUEW55ijIxaQPyPiEiLLmhwKySEVd3QCcW4r0/QcRzm/RobPWYu28eHvTpsZpO85l
	 fcvfUlJlyINtVPCYfNp5VyB3f/oSNwF18tH3H/WiCzy/7MfdA9q301QN5zquO8AGpB
	 BaQB6u1guV/seLQglq2p7dmYkFnNrG/HjYuYRc1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Felix Maurer <fmaurer@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 086/247] hsr: Fix supervision frame sending on HSRv0
Date: Fri, 21 Nov 2025 14:10:33 +0100
Message-ID: <20251121130157.682292283@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Felix Maurer <fmaurer@redhat.com>

[ Upstream commit 96a3a03abf3d8cc38cd9cb0d280235fbcf7c3f7f ]

On HSRv0, no supervision frames were sent. The supervison frames were
generated successfully, but failed the check for a sufficiently long mac
header, i.e., at least sizeof(struct hsr_ethhdr), in hsr_fill_frame_info()
because the mac header only contained the ethernet header.

Fix this by including the HSR header in the mac header when generating HSR
supervision frames. Note that the mac header now also includes the TLV
fields. This matches how we set the headers on rx and also the size of
struct hsrv0_ethhdr_sp.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Closes: https://lore.kernel.org/netdev/aMONxDXkzBZZRfE5@fedora/
Fixes: 9cfb5e7f0ded ("net: hsr: fix hsr_init_sk() vs network/transport headers.")
Signed-off-by: Felix Maurer <fmaurer@redhat.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/4354114fea9a642fe71f49aeeb6c6159d1d61840.1762876095.git.fmaurer@redhat.com
Tested-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index fbbc3ccf9df64..1235abb2d79fa 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -320,6 +320,9 @@ static void send_hsr_supervision_frame(struct hsr_port *port,
 	}
 
 	hsr_stag = skb_put(skb, sizeof(struct hsr_sup_tag));
+	skb_set_network_header(skb, ETH_HLEN + HSR_HLEN);
+	skb_reset_mac_len(skb);
+
 	set_hsr_stag_path(hsr_stag, (hsr->prot_version ? 0x0 : 0xf));
 	set_hsr_stag_HSR_ver(hsr_stag, hsr->prot_version);
 
-- 
2.51.0



