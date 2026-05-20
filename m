Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B8A3FB7E7;
	Wed, 20 May 2026 18:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303037; cv=none; b=PFAGeGgm5l3E2lvFPyGSEo7dVetGuRmbqylkS3srO0hFcA2kjtLQZT1tAsPEoXLfbd61asXTwbwCXrjTU98txSAj+B1rS8OosbNpBe/APrVo9e96puQLLCwm+1Pd6TzbaaXKXQLxsRy2b9kr9LZV5M7lRmJ7V7LUFB1g2WzVaL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303037; c=relaxed/simple;
	bh=F4Iwb2G2gCdutMkOIUq+UtShECaCU0nvDCcqodzHxDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICcVpb6s0CdzcSGSzOLEroGBcdQOLECC1kes67IJi9Q3bFb8sQbMdowpSgy7XjeEy+py9/LsAMm6eFf4AMwaTocqbQl0zKhfBNK7d+hH+3GsfXcuMNn4UqGfuhyDVAPCybGlaoAaTqYwv84woa/R6Bh85C1tpPiVMDHuTSTrs+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1r6U/PVG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1r6U/PVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA91D1F00893;
	Wed, 20 May 2026 18:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303035;
	bh=2aynoT9F/QZRDznZxvtMwsm3hrCjSnPLdTTUys+fs5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1r6U/PVGrj7UMXAt+0E1iBxJsng42QecGVXFNYaghTZ0l3EA5nNnbcNkMp1HFI9ur
	 4987+ROPi22YSpytH4noYCto/22f4yZzNEq7nQAFtqLT5ftyEw4Hl2TYuuNQN3zS7M
	 u9+WAFV9CPVo2Ed61Z69AJw3RbkcgrdyK5mDGzVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 495/508] mptcp: fix rx timestamp corruption on fastopen
Date: Wed, 20 May 2026 18:25:18 +0200
Message-ID: <20260520162109.323086698@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 6254a16d6f0c672e3809ca5d7c9a28a55d71f764 ]

The skb cb offset containing the timestamp presence flag is cleared
before loading such information. Cache such value before MPTCP CB
initialization.

Fixes: 36b122baf6a8 ("mptcp: add subflow_v(4,6)_send_synack()")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260501-net-mptcp-misc-fixes-7-1-rc3-v1-3-b70118df778e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/fastopen.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mptcp/fastopen.c
+++ b/net/mptcp/fastopen.c
@@ -12,6 +12,7 @@ void mptcp_fastopen_subflow_synack_set_p
 	struct sock *sk, *ssk;
 	struct sk_buff *skb;
 	struct tcp_sock *tp;
+	bool has_rxtstamp;
 
 	/* on early fallback the subflow context is deleted by
 	 * subflow_syn_recv_sock()
@@ -39,12 +40,13 @@ void mptcp_fastopen_subflow_synack_set_p
 	 */
 	tp->copied_seq += skb->len;
 	subflow->ssn_offset += skb->len;
+	has_rxtstamp = TCP_SKB_CB(skb)->has_rxtstamp;
 
 	/* Only the sequence delta is relevant */
 	MPTCP_SKB_CB(skb)->map_seq = -skb->len;
 	MPTCP_SKB_CB(skb)->end_seq = 0;
 	MPTCP_SKB_CB(skb)->offset = 0;
-	MPTCP_SKB_CB(skb)->has_rxtstamp = TCP_SKB_CB(skb)->has_rxtstamp;
+	MPTCP_SKB_CB(skb)->has_rxtstamp = has_rxtstamp;
 	MPTCP_SKB_CB(skb)->cant_coalesce = 1;
 
 	mptcp_data_lock(sk);


