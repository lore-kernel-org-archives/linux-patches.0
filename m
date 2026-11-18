Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054541;
	b=kwhFJXz0UrgpToVd8yp11DAvWIXedtVvcEhrC/i1YrXFhZhxSkfJRh8EbOf1KqO3gZyK
	 OKK/IUVFOwS1vIgukBL6yqlchnCr+mETnj3WnPQthF+CfIZd0Gi+RD/UEzg/bFWR9W4OY
	 yQi6apFd+IxLL+e0cLZC6EdGhQmM7LBuq7g5d4D5LlyY6tLqJlpuEzHGWwyag0q5KlotH
	 /6xoqDONmrzvkBYDILbe0eF8p6koguhL+BkbtG74hSmSjp7BHxM6FMVr+b+iXd1AKWfbo
	 eUnW1fn26hwucHu74dmFiS0cWUlDcRd3FA1BQ/v0/oKXSH+qn5KNDpgnldCbUNsX2eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hEZBeczoh+FVH50XSgyJ8T62VxqGFuKZhcIMUhvFW9c=;
	b=lI1+Pxravj4L/aoN7EEPti6pZuzYv9/v2UVIFtEWLnwea0UTzxQL9mup3qiUxY1jZllZ
	 2v1sd4mF9Br490O6z/vdXhWaNJwkJ/KLIh6QxFwql2/RCMaZk3/U4G7qK7xS1DncIpUjt
	 guNn8LXrgPF4Bs+MkGCf7+5mo+2phhwUjlqEMFWfiJ1X8kh+vubABu+ijMG01GucyfrkT
	 y15FIFdiW4Klfykdn2ddancrfQm7BsJCxBRZPyltIlvFBiek5BYPLbcbyp0YU5hR/olBr
	 cMUxpFrUlEDVOGe/pVAaDfMkMJmn3RFyApSTO3eE+aqMYIaLphexaJTLk25ALXoFaCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiOnMscv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A706D606A31C;
	Thu, 19 Nov 2026 02:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiOnMscv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08A61F000C5;
	Thu, 19 Nov 2026 02:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054541;
	bh=hEZBeczoh+FVH50XSgyJ8T62VxqGFuKZhcIMUhvFW9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KiOnMscvhAgItz7VQJxVVWpyVjHfthRVGYvwunh+LQY8vR89OEUbQQTet5z77eCH6
	 z7B/2ppxzL3NLn1rjunOfDn9hrEF7TbhzJgU286ScgHFScuJyduUA4kWmA+4VMI+Cf
	 2+ulHxEuTVd5hiXeFoWH48qnoHTv6dNjHc1dG6OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Kanner <andrew.kanner@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Petr Vaganov <petrvaganoff@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1311/2214] selinux: prevent KMSAN warning in selinux_inet_conn_request()
Date: Wed, 18 Nov 2026 15:49:47 +0100
Message-ID: <20261118150103.944656861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6a94b31b54721..e5af391023baf 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -195,6 +195,7 @@ int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
 	struct netlbl_lsm_secattr secattr;
 
 	if (!netlbl_enabled()) {
+		*type = NETLBL_NLTYPE_NONE;
 		*sid = SECSID_NULL;
 		return 0;
 	}
-- 
2.53.0



