Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AEB449B04;
	Thu, 30 Jul 2026 16:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427867; cv=none; b=cVjsaMmXVg/Oh7kxs/4YsS9iNLfavcuijwr+VHqNAeIC5ObXn+AgjJk018hD3UdLjofvXUzHH/K8eiladFmFb/AS0c0D2mpswU02njBkI7R26f7O5qVUsxMEQ4eykJbdhJw+qvlWpa19RNdqFF56puPaG0tp1J6qRMQcSGP/uCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427867; c=relaxed/simple;
	bh=pIuJR7oz3ff35gNdlHGtZDUyMJsDgmS4GNUx5VWLEio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzMR6lZ/+/Uk+nkA+D289LbzuLW4MHyctMOvEj/NDGho3PdM02sFwTJvKGEjLoiCOCnrjlqnYIkJq/NzAxLC+KAoda3m9AGNOMsSjC3x2LAYqvix0glQtDjwKAnBE2SH2S6lv8zknXuXLvW86TXkp/h6wJopFeH1DG94DzTD5ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LoHHN7Qd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LoHHN7Qd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4D01F000E9;
	Thu, 30 Jul 2026 16:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427866;
	bh=LWtwjx0Sz8cbyJ4jFPuk2+7jsQuahOKyvg6LmjPM0J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LoHHN7Qd+pIhAGrziwY4D4r5n1mdGRz7fAM04OjxK8f6JdLe6XGeB0kaBVYvfdTpt
	 xbbaKK87hRKZpm6IHCeVpTPH8U8+KTVqLf6ILIAHVbIBErsWhYrP7LM5qqEk8IHq7h
	 NnHOqAyxwfJYSJOx0jGDnxz8rRnV75CiqodptW+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 319/484] geneve: require CAP_NET_ADMIN in the device netns for changelink
Date: Thu, 30 Jul 2026 16:13:36 +0200
Message-ID: <20260730141430.415535396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 8efb8f8bbb353b8f2fdf4f37534c6d96c9f69e01 upstream.

A tunnel changelink() operates on at most two netns, dev_net(dev) and
the sticky underlay netns geneve->net. They differ once the device is
created in or moved to a netns other than the one the request runs in.
The rtnl changelink path checks CAP_NET_ADMIN only against dev_net(dev),
so a caller privileged there but not in geneve->net can rewrite a geneve
device whose underlay lives in geneve->net.

geneve_changelink() applies the new configuration against geneve->net:
geneve_link_config() and the geneve_quiesce()/geneve_unquiesce() pair
reopen the underlay sockets in that netns (geneve_sock_add() uses
geneve->net), so the same reasoning as the tunnel changelink series
applies here.

Gate geneve_changelink() with rtnl_dev_link_net_capable(), at the top of
the op before any attribute is parsed, matching ipgre_changelink() and
the rest of the "require CAP_NET_ADMIN in the device netns for
changelink" series.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: 5b861f6baa3a ("geneve: add rtnl changelink support")
Cc: stable@vger.kernel.org
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260716203500.70573-3-doruk@0sec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/geneve.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1755,6 +1755,9 @@ static int geneve_changelink(struct net_
 	struct geneve_config cfg;
 	int err;
 
+	if (!rtnl_dev_link_net_capable(dev, geneve->net))
+		return -EPERM;
+
 	/* If the geneve device is configured for metadata (or externally
 	 * controlled, for example, OVS), then nothing can be changed.
 	 */


