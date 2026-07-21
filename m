Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C732646EF6C;
	Tue, 21 Jul 2026 18:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658902; cv=none; b=g01VeCI4+Cww31/zwMIT0yvAE0C/eRT8ylgXpetJvFYG7sZGI1U5Ywt3SdJCrPtx3T48F/BrIMUWit6DOj2L4eNseojrqweVWWH/tiDxHPwzzrNj2XdmRrNs2rHtTr6XnhWyVHgNIPpLgqX7STQ+lBw91aY7mztfJ73qPEyAH3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658902; c=relaxed/simple;
	bh=IaaoPdPoPS+kqjANvZFxuDdOCGpTg2tJBdWHV8WvHTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7nk6s1VJoykwzHObvQGU746oNBpBnEWvRL7+pyh8v6RobXEWF9cwWgT+oUrqZlkGRDmZDtG8OUEDX7q2z3SojU6rOXU9kDlLHCP67FwsnMRZ2dUESeBEg0gJZf2+ULSEG/9yRXNAKEjbs0rX8Oq77in2Oa+SS70v2JTgXidkOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xm7OT4Ii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xm7OT4Ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383F91F000E9;
	Tue, 21 Jul 2026 18:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658901;
	bh=KAAZuipjwmf9t654Joc1R7ELegCSeilkFtRKC9A+Tpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xm7OT4IiIGlIEyjTn10rGElPW4cRD02HLNRfs9lpcgXBPWLrdSHT9Wc5Vja134MmL
	 IQOka7B4Ni19kFgHS9hQ4chWMHHY4aSQSyjjuo+2g57nAdxlM3+bkkxprE6IxAepY7
	 MiZiCnBv33oOSet7VuZ+M3B5TXZZxPQWJUwchRdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1319/1611] xfrm: xfrm_interface: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:23:55 +0200
Message-ID: <20260721152545.124109703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -869,6 +869,9 @@ static int xfrmi_changelink(struct net_d
 	struct net *net = xi->net;
 	struct xfrm_if_parms p = {};
 
+	if (!rtnl_dev_link_net_capable(dev, net))
+		return -EPERM;
+
 	xfrmi_netlink_parms(data, &p);
 	if (!p.if_id) {
 		NL_SET_ERR_MSG(extack, "if_id must be non zero");


