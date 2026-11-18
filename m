Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047661;
	b=1/3iJVKqKdNJJ574od79bon2iUf+468LkeJw/TpCSuNCpS0loazy48qEZ+lot8a4DObz
	 otecuZQJ8IOJ7VVxirlryowa66p4Z8IDkTrs2VTTEXhTowuELEvlmjTOXR/caYxAIcplu
	 0/lAo1xMcsasPvtU95e9UHHO6LFrWWpYbKf/VoI4bqxQtn0b5s10xwCZ1vX4tHh114GpW
	 VNjIHrakeb4KIy43rjaL1kqE4HU52i8g7bCc9RSG//sikDTy9DZZxd4QiL56bQ5FAzZJJ
	 8mJ9WsqPV88rzTbAUzAJtu/MZWzYoxJMjlx8fcDtw5pShQoJS3kfyV7oCE7CWWSJdAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3f4UqjI3fCFhE994XIZRpFNImkgpLwpqm2daUg+ABtk=;
	b=vOwmCcSdpgkrzwHJuXDvFYPr6+49tBi4qxZbFo4624mice1yf/mjwt8WmdLNwXq4rgHw
	 hhqigwF9cTyEWovoFlJajIz30zkwHpIFFgKBhVAE9+xQdLjIEBNNTEiSWW5dNGr34Bytv
	 CP1GH3Rq0plg7+kjBc+nMkWkjXHV6X1o3OnjGw7jQpFhgicd1Ogp5PQVvUW5xOc3df80G
	 Kaq/x8+8AmgSixd1PUBXrbJ2NWSRgguqMYrqAci3n/WFjv0vp4Lbj+RRuS+wL7RaxEGrP
	 ChzK57M31BW7cEd9txiSUtMdvU6rH0TjPwatPwqa+YzL/7m8wxh97pT0uqv/ERHd2fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O/035LSC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15477606A333;
	Thu, 19 Nov 2026 00:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O/035LSC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C361F000CD;
	Thu, 19 Nov 2026 00:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047660;
	bh=3f4UqjI3fCFhE994XIZRpFNImkgpLwpqm2daUg+ABtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/035LSCiUnyfzAewRQXNWznaZ4Ozz+EoNcCLj4baqPVnCNLiofOILFo3a0TLoeW+
	 5SCmCINypfZLgp9X8Pe0PlmNATDl7DAVS+0ukqSm78TgVNsxwZY5aINpwL3wsZlbBT
	 lNzE83gZekmO/8enH66mZ88pWDN41oFC7E9WzgNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Kanner <andrew.kanner@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Petr Vaganov <petrvaganoff@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1717/2857] selinux: prevent KMSAN warning in selinux_inet_conn_request()
Date: Wed, 18 Nov 2026 15:45:51 +0100
Message-ID: <20261118150303.149128534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Kanner <andrew.kanner@gmail.com>

commit 1df83cbf23a27174aee6ea5e52462f03f7e48a10 upstream.

KMSAN reports the following issue:
[   81.822503] =====================================================
[   81.823222] BUG: KMSAN: uninit-value in selinux_inet_conn_request+0x2c8/0x4b0
[   81.823891]  selinux_inet_conn_request+0x2c8/0x4b0
[   81.824385]  security_inet_conn_request+0xc0/0x160
[   81.824886]  tcp_v4_route_req+0x30e/0x490
[   81.825343]  tcp_conn_request+0xdc8/0x3400
[   81.825813]  tcp_v4_conn_request+0x134/0x190
[   81.826292]  tcp_rcv_state_process+0x1f4/0x3b40
[   81.826797]  tcp_v4_do_rcv+0x9ca/0xc30
[   81.827236]  tcp_v4_rcv+0x3bf5/0x4180
[   81.827670]  ip_protocol_deliver_rcu+0x822/0x1230
[   81.828174]  ip_local_deliver_finish+0x259/0x370
[   81.828667]  ip_local_deliver+0x1c0/0x450
[   81.829105]  ip_sublist_rcv+0xdc1/0xf50
[   81.829534]  ip_list_rcv+0x72e/0x790
[   81.829941]  __netif_receive_skb_list_core+0x10d5/0x1180
[   81.830499]  netif_receive_skb_list_internal+0xc41/0x1190
[   81.831064]  napi_complete_done+0x2c4/0x8b0
[   81.831532]  e1000_clean+0x12bf/0x4d90
[   81.831983]  __napi_poll+0xa6/0x760
[   81.832391]  net_rx_action+0x84c/0x1550
[   81.832831]  __do_softirq+0x272/0xa6c
[   81.833239]  __irq_exit_rcu+0xb7/0x1a0
[   81.833654]  irq_exit_rcu+0x17/0x40
[   81.834044]  common_interrupt+0x8d/0xa0
[   81.834494]  asm_common_interrupt+0x2b/0x40
[   81.834949]  default_idle+0x17/0x20
[   81.835356]  arch_cpu_idle+0xd/0x20
[   81.835766]  default_idle_call+0x43/0x70
[   81.836210]  do_idle+0x258/0x800
[   81.836581]  cpu_startup_entry+0x26/0x30
[   81.837002]  __pfx_ap_starting+0x0/0x10
[   81.837444]  secondary_startup_64_no_verify+0x17a/0x17b
[   81.837979]
[   81.838166] Local variable nlbl_type.i created at:
[   81.838596]  selinux_inet_conn_request+0xe3/0x4b0
[   81.839078]  security_inet_conn_request+0xc0/0x160

KMSAN warning is reproducible with:
* netlabel_mgmt_protocount is 0 (e.g. netlbl_enabled() returns 0)
* CONFIG_SECURITY_NETWORK_XFRM may be set or not
* CONFIG_KMSAN=y
* `ssh USER@HOSTNAME /bin/date`

selinux_skb_peerlbl_sid() will call selinux_xfrm_skb_sid(), then fall
to selinux_netlbl_skbuff_getsid() which will not initialize nlbl_type,
but it will be passed to:

    err = security_net_peersid_resolve(nlbl_sid,
                                       nlbl_type, xfrm_sid, sid);

and checked by KMSAN, although it will not be used inside
security_net_peersid_resolve() (at least now), since this function
will check either (xfrm_sid == SECSID_NULL) or (nlbl_sid ==
SECSID_NULL) first and return before using uninitialized nlbl_type.

Signed-off-by: Andrew Kanner <andrew.kanner@gmail.com>
[PM: subject line tweak, removed 'fixes' tag as code is not broken]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Petr Vaganov <petrvaganoff@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/netlabel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index 800ab4b4239eb..1c316af68bf3b 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -196,6 +196,7 @@ int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
 	struct netlbl_lsm_secattr secattr;
 
 	if (!netlbl_enabled()) {
+		*type = NETLBL_NLTYPE_NONE;
 		*sid = SECSID_NULL;
 		return 0;
 	}
-- 
2.53.0



