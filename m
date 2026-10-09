Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEE3455631;
	Fri,  9 Oct 2026 14:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555643; cv=none; b=dSorCrVTx/iy5bLYGPvFsQyeAn/b1fkgcrzrB+eQxcisoduw/tDLcU+6PXATViZZnpj9yxabm/jSkOl9/KdJ/dD91I7b8J7WZb5KvprE/P6wXdEsP+0bzTeHqom0SzU3x26w0qliAVEAAXczDS9EKcNps8Rd57BVotEnJRST0T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555643; c=relaxed/simple;
	bh=6TnX4GOEQMe8SCZlDmAU+Pl83pi6Ettgm2nIvgwahEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2vVEFWA6dCDeixDtTz8vJgZkTod7TBCPBUFpY3OzRC+0AGPg+OFuQxm1Gb5pS1TKPRpl9tp4FWSGG/KgTIVz/dn7DMVscoM6p2qLnJQ+OxTPwedNK8xsVV4d+MayR4+508OSKW1k73rK9C2Hu/JQ7UD0nUOa7NzUI41+ekXYxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SS9k9nTn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SS9k9nTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28B01F00898;
	Fri,  9 Oct 2026 14:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555631;
	bh=zY/BPr8Jg5mPInVJ5+9aji7dVSWzP920xkoYCDylbpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SS9k9nTnj9q98PaCVJmiPk3emcbW99sq7drPcRMbRvDaANJ+bsu+WGjdafhWPGO+7
	 rwKFIWAWwB+DTGDXrwcvheUK97UWpA2R+rdTDUMlWAP7WTV92kJV5Y27PHh4nOMWxb
	 T+iRyk3AydGoFJgUqTkpvD+hzx9EcDO9ZiNJ/LnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 040/428] pfcp: fix socket lifetime on netdevice registration failure
Date: Fri,  9 Oct 2026 16:06:17 +0200
Message-ID: <20261009140946.975434019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 0f17d2e3dd9cda3ee6d94033d5e5489af168920d upstream.

pfcp_newlink() creates the UDP socket before register_netdevice().
If registration fails after pfcp_dev_init() succeeds, the core calls
pfcp_dev_uninit(), which releases the socket and clears pfcp->sk.
The newlink error path then releases it again, causing a NULL pointer
dereference. This was observed with failslab fault injection:

  FAULT_INJECTION: forcing a failure.
  kobject: kobject_add_internal failed for pfcp0 (error: -12 parent: net)
  BUG: KASAN: null-ptr-deref in udp_tunnel_sock_release+0x1c/0x50
  Read of size 8 at addr 0000000000000120 by task ip/1037
  Call trace:
   show_stack+0x18/0x24 (C)
   dump_stack_lvl+0x78/0x90
   print_report+0x468/0x5cc
   kasan_report+0xa4/0xf0
   __asan_load8+0x7c/0xd0
   udp_tunnel_sock_release+0x1c/0x50
   pfcp_newlink+0x128/0x184
   rtnl_newlink+0x848/0xe44
   rtnetlink_rcv_msg+0x468/0x514
   netlink_rcv_skb+0xc0/0x1f0
   rtnetlink_rcv+0x18/0x24
   netlink_unicast+0x4b8/0x558
   netlink_sendmsg+0x2b8/0x584
   ...

Return from pfcp_del_sock() if pfcp->sk is NULL.

Fixes: 76c8764ef36a5 ("pfcp: add PFCP module")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260924055252.33488-1-xuanqiang.luo@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/pfcp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/pfcp.c
+++ b/drivers/net/pfcp.c
@@ -104,6 +104,9 @@ drop:
 
 static void pfcp_del_sock(struct pfcp_dev *pfcp)
 {
+	if (!pfcp->sk)
+		return;
+
 	udp_tunnel_sock_release(pfcp->sk);
 	pfcp->sk = NULL;
 }


