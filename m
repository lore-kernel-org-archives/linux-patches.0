Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1722EDD7A;
	Wed,  3 Dec 2025 16:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778140; cv=none; b=XoWVe6jSZTevs6yXIU53FbGU9s3B/UywhY1eqnMKPf1ygQW9GWGZcBGjsLAVFrxVnj9i8da5pc9oCBlQx6BhlBSmeqeWJUgd3aRkSgloTmbk+4qAWqonQmmaOREazQNdQUEb0LrtZxnaB3g3BslyykmtJHGY4LT3EGhwQOr3Ps8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778140; c=relaxed/simple;
	bh=m3urx/id/4/R+zG56DrFyLjPxmNYFCUe+AwSncgcmxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWVYmTWU74+6U7p4GPeKlQIBAJU8JqaWaeeKzEGfkvNdcTpVkURiUcvWW21fDHlqxCX5TnNUau0OPZKPZ3SvZ1rr9N6crnoZyOE64d/WYxSWEttwF23nXxajywEQO2oI/82KoKuTP4yoIESm0LLf90EWycmlWuKtsX49OTrb3aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEwNpqbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEwNpqbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7E2C4CEF5;
	Wed,  3 Dec 2025 16:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778139;
	bh=m3urx/id/4/R+zG56DrFyLjPxmNYFCUe+AwSncgcmxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEwNpqbchzuS/L5AjPOUlSK8EAv4GNmfItiukY78ATpjKL4Z1nrbBbFcHDJ6aBfF+
	 h7DUh/PaoQ+jkDsJxo1Fgwyc8upOKbqVQaXmclAf/ciDq2MeMEE0SPrznCPbxeKco8
	 oVLeo+L+pDSB4mVCmptkK8JxN1Vim+8p4LhpUHAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Felix Maurer <fmaurer@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 256/392] hsr: Fix supervision frame sending on HSRv0
Date: Wed,  3 Dec 2025 16:26:46 +0100
Message-ID: <20251203152423.589481109@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 503f2064e7323..85537b245aaeb 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -316,6 +316,9 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	}
 
 	hsr_stag = skb_put(skb, sizeof(struct hsr_sup_tag));
+	skb_set_network_header(skb, ETH_HLEN + HSR_HLEN);
+	skb_reset_mac_len(skb);
+
 	set_hsr_stag_path(hsr_stag, (hsr->prot_version ? 0x0 : 0xf));
 	set_hsr_stag_HSR_ver(hsr_stag, hsr->prot_version);
 
-- 
2.51.0



