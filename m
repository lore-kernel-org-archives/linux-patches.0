Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20815472558;
	Tue, 21 Jul 2026 22:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672477; cv=none; b=ZXRrNIWgJyUEgORQx+8T3QDSGkVCWxH19n9jrD0MJv3VZ9MJlmOXWram6kcW6VNPXg8fSTOWtTTmYaeP8IOrM/MNDxICVtb7iUt84BWPAw1o6lLOnmlxVivh3aSuIPXrz2EqpZ2xG8dZveNj5xBLIkVozaLVnDsFZl9NUJxf9tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672477; c=relaxed/simple;
	bh=HzAS574EQi1cym1aopaWA4OfCe3m2Fu00mf+5x0QFfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiHWGXvDxO0Z2O7OaCixEXlLsPbTFQ/bxJ/9AFhJDUqzT8JZzbSUYlHFaooIZUZehHVllla9ElUMJjRl1VwPx99K4iElXJlcVRrUMwX+56vSavUF5DhZcOmA/bXCvHkFp89o98SOaRP3/OnZBgiKdAXcYZQsSPDYphg7DpYx3+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ww7KQ6Vz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ww7KQ6Vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8766F1F000E9;
	Tue, 21 Jul 2026 22:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672476;
	bh=1/MyQ9enwjS6hMRZpDV6DkurZRLQ5vVbToGZf1vX7+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ww7KQ6Vzvn6vo9ZetLX1i2dIiUs0j0aWVFV+7M2nGZGIyhvccyCgF18wPVZj/xZR9
	 F4q2wYVnTOEQE8K0k456FontugN0ZSvEpxcrCfEkwRjFvWhETMqUrSGBMoefbhf1N2
	 qXc1QdwSyuK2Iq/8oFhtgCi6fOVZQ0Jk8IsuPMNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 640/843] xfrm: xfrm_interface: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:24:35 +0200
Message-ID: <20260721152420.464998286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
@@ -720,6 +720,9 @@ static int xfrmi_changelink(struct net_d
 	struct net *net = xi->net;
 	struct xfrm_if_parms p = {};
 
+	if (!rtnl_dev_link_net_capable(dev, net))
+		return -EPERM;
+
 	xfrmi_netlink_parms(data, &p);
 	if (!p.if_id) {
 		NL_SET_ERR_MSG(extack, "if_id must be non zero");


