Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77218442373;
	Mon, 17 Aug 2026 14:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977109; cv=none; b=WQ1sRJq33A3gp18FiLeqkykWR/C0tnGHe31LU1khN9Kl2N8H/zapbKWDKCgz15CPf9bNTyoUuPb5YpjHOAMNUh4dKgYAZTo0f3IcgqdwYTa4jLT75s59K8ADVoBYfnMovID4b+TpAmveJ71JXS8D0HVVyLytjDEBBr8n1wHdbPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977109; c=relaxed/simple;
	bh=w4hFokrVx3yRvpUVkk7JDzfPgRYW/2aawEm5sDbJr/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fw+fpHH/sRF3RDghWwpKZMIFaMXe4kdVIwER0oPgoz7FMb8TzsaDGmlUHUeiskXp/rnxV/RkV63Hts3bIVIUCtMNACLwhJ7HIYNsviHnQkj6VxFVvih0ViRO2PQ3dASBL0dypbB32P2PEik1YjKhY86IPqxj1zjFYYLP7cBFw8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIQqkA3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIQqkA3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4851F00A3D;
	Mon, 17 Aug 2026 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977108;
	bh=wrTk8lTBcXf+ayLEfbXGM8TlSME9Y2Sw4l4oJBjs6Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIQqkA3eBa5a03q+sh/gTFmFM/v+K8w/vd3irGAbOL1gDX/hoyFrgOPw9N53lecN4
	 6B7stVN+nm6jteagBFTHSzvO8uI99awbn2jyI6Giu65PaG2LnT2HoktWtCFXLE6wZd
	 8UyrvGWVb/eQWC4wstznvcW18/xZXlLM2PfxAKJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 214/456] geneve: require CAP_NET_ADMIN in the device netns for changelink
Date: Mon, 17 Aug 2026 15:30:04 +0200
Message-ID: <20260817132548.559544599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -1754,6 +1754,9 @@ static int geneve_changelink(struct net_
 	struct geneve_config cfg;
 	int err;
 
+	if (!rtnl_dev_link_net_capable(dev, geneve->net))
+		return -EPERM;
+
 	/* If the geneve device is configured for metadata (or externally
 	 * controlled, for example, OVS), then nothing can be changed.
 	 */


