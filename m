Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F4644AB91;
	Tue, 21 Jul 2026 21:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670164; cv=none; b=gCg8SrO5RsGjvKwHTvA+eDM8kPFkPfJM2CkRVIMIUO2Aj9wi2WCK1bBzXk3qjJJ+RPvtJmbb4Vbl0Q7yvWayjObzjqtpL/mknfp0y5ZZq3Wba+qZtCds5Jbk07cCO2GyEkfvhJOr8/pprsb2nXACyIs4+XqOptjwCZZh3oO5LE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670164; c=relaxed/simple;
	bh=RyxTspbBQwpHQSdCdZ3HtGoIHz64Jer2/vbzGm4xKwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZGgr1LxZxWCdqV/Cn8rj16CcJoIvtOPzPc1VKjQEkmCcgNqsX6rzhFbxL2TeRrikhaOQd4qAaLjUFByhi19rmGZfTOdVi3Jwo1hWo2HAsd5GLXj7sXD6u9sU8FI/AwaAMOpHVt5U4QSudWItid8zTufdtcUbvfg7j4QDnteDhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXJh17KC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXJh17KC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A661F000E9;
	Tue, 21 Jul 2026 21:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670163;
	bh=aTvvw75xIVxV5y9ziRU5LLPOI4ChK+mMTlvGigNN7cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXJh17KCY/M0U/Bz/Lwu5Uzt/ah/RW24L79IEp/Yt+/eyFPRGaFI8HXxhK/L1phju
	 6DSwul+lWQ1PjKsu9F7lM1QGl6lZWW/oj/XQxgAQswg/emUETi+B4Man3DUyGbrAZo
	 FFxfywesemnOXe0c8YrB5FU7GE4A00kY1zfLr5Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0828/1067] xfrm: xfrm_interface: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:23:49 +0200
Message-ID: <20260721152443.071054133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 095515d89b19b6cc19dfcdc846f97403ed1ebce3 upstream.

xfrmi_changelink() operates on at most two netns, dev_net(dev) and the
interface link netns xi->net. They differ once the device is created in
or moved to a netns other than the one the request runs in. The rtnl
changelink path checks CAP_NET_ADMIN only against dev_net(dev), so a
caller privileged there but not in xi->net can rewrite an interface that
lives in xi->net.

Gate xfrmi_changelink() on rtnl_dev_link_net_capable() at its top,
before any attribute is parsed.

Reported-by: Xiao Liang <shaw.leon@gmail.com>
Closes: https://lore.kernel.org/netdev/CABAhCOSzP1vaThGV35_VnsRCb=87_CPjPVsTHbq905k8A+BuUg@mail.gmail.com/
Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260612085941.3158249-8-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_interface_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -865,6 +865,9 @@ static int xfrmi_changelink(struct net_d
 	struct net *net = xi->net;
 	struct xfrm_if_parms p = {};
 
+	if (!rtnl_dev_link_net_capable(dev, net))
+		return -EPERM;
+
 	xfrmi_netlink_parms(data, &p);
 	if (!p.if_id) {
 		NL_SET_ERR_MSG(extack, "if_id must be non zero");


