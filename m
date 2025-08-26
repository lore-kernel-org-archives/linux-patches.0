Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2421A4086A;
	Tue, 26 Aug 2025 13:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215716; cv=none; b=PNTty9WBKAbsvFsXfQTjfIbm+adntdqgcUcnC8/EPD3f7Ga3ir/d3Y2uGbklUI6jYOv+rXefOWh2md7zARL8u85s1eNIiHFKLwJzLbvQMLdbA27h6EoelcAeqHz2M44jKMRLszy//2n3wFgUCGKgKz7tZMNBEgQc8HzcXc6ZHaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215716; c=relaxed/simple;
	bh=wv7i84F1epQxxMiZamirdBChtzgQsAksnkebcIxDL2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l276vGtiEy2nRZdGXczuOLJefizNHbJSrW3CuI7cs3qWRxlGGsPlwc12pmQktiWgCYHNSdyGi2s6x/eIzV7r8EIvlOKiXS/b7AdZOIrUKnwUnrdI/AKyNBCuUYurchu1Thi7CYdU5lJSwi6sswRfYL6c6vBjRm+y4EykD6Jc6Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JBcNKhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JBcNKhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418C5C113D0;
	Tue, 26 Aug 2025 13:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215715;
	bh=wv7i84F1epQxxMiZamirdBChtzgQsAksnkebcIxDL2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JBcNKhy9AodiWFjK67zaY9q9YrRj0w1duYBw4m2HmTtMuyokkXJwV31SGEUaVBrU
	 4h8p1hl4M4R5vNvIC12TkZo/zYF/bIPUC7IPnZ+iohTjtOuWF4cWCt38YATM74Vupz
	 ohPqpswahWJ15mz+tSISkLnuWRqvRuKQz941TOt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/644] caif: reduce stack size, again
Date: Tue, 26 Aug 2025 13:03:50 +0200
Message-ID: <20250826110949.946235591@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b630c781bcf6ff87657146661816d0d30a902139 ]

I tried to fix the stack usage in this function a couple of years ago,
but there is still a problem with the latest gcc versions in some
configurations:

net/caif/cfctrl.c:553:1: error: the frame size of 1296 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]

Reduce this once again, with a separate cfctrl_link_setup() function that
holds the bulk of all the local variables. It also turns out that the
param[] array that takes up a large portion of the stack is write-only
and can be left out here.

Fixes: ce6289661b14 ("caif: reduce stack size with KASAN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20250620112244.3425554-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/caif/cfctrl.c | 294 +++++++++++++++++++++++-----------------------
 1 file changed, 144 insertions(+), 150 deletions(-)

diff --git a/net/caif/cfctrl.c b/net/caif/cfctrl.c
index d8cb4b2a076b..3eec293ab22f 100644
--- a/net/caif/cfctrl.c
+++ b/net/caif/cfctrl.c
@@ -351,17 +351,154 @@ int cfctrl_cancel_req(struct cflayer *layr, struct cflayer *adap_layer)
 	return found;
 }
 
+static int cfctrl_link_setup(struct cfctrl *cfctrl, struct cfpkt *pkt, u8 cmdrsp)
+{
+	u8 len;
+	u8 linkid = 0;
+	enum cfctrl_srv serv;
+	enum cfctrl_srv servtype;
+	u8 endpoint;
+	u8 physlinkid;
+	u8 prio;
+	u8 tmp;
+	u8 *cp;
+	int i;
+	struct cfctrl_link_param linkparam;
+	struct cfctrl_request_info rsp, *req;
+
+	memset(&linkparam, 0, sizeof(linkparam));
+
+	tmp = cfpkt_extr_head_u8(pkt);
+
+	serv = tmp & CFCTRL_SRV_MASK;
+	linkparam.linktype = serv;
+
+	servtype = tmp >> 4;
+	linkparam.chtype = servtype;
+
+	tmp = cfpkt_extr_head_u8(pkt);
+	physlinkid = tmp & 0x07;
+	prio = tmp >> 3;
+
+	linkparam.priority = prio;
+	linkparam.phyid = physlinkid;
+	endpoint = cfpkt_extr_head_u8(pkt);
+	linkparam.endpoint = endpoint & 0x03;
+
+	switch (serv) {
+	case CFCTRL_SRV_VEI:
+	case CFCTRL_SRV_DBG:
+		if (CFCTRL_ERR_BIT & cmdrsp)
+			break;
+		/* Link ID */
+		linkid = cfpkt_extr_head_u8(pkt);
+		break;
+	case CFCTRL_SRV_VIDEO:
+		tmp = cfpkt_extr_head_u8(pkt);
+		linkparam.u.video.connid = tmp;
+		if (CFCTRL_ERR_BIT & cmdrsp)
+			break;
+		/* Link ID */
+		linkid = cfpkt_extr_head_u8(pkt);
+		break;
+
+	case CFCTRL_SRV_DATAGRAM:
+		linkparam.u.datagram.connid = cfpkt_extr_head_u32(pkt);
+		if (CFCTRL_ERR_BIT & cmdrsp)
+			break;
+		/* Link ID */
+		linkid = cfpkt_extr_head_u8(pkt);
+		break;
+	case CFCTRL_SRV_RFM:
+		/* Construct a frame, convert
+		 * DatagramConnectionID
+		 * to network format long and copy it out...
+		 */
+		linkparam.u.rfm.connid = cfpkt_extr_head_u32(pkt);
+		cp = (u8 *) linkparam.u.rfm.volume;
+		for (tmp = cfpkt_extr_head_u8(pkt);
+		     cfpkt_more(pkt) && tmp != '\0';
+		     tmp = cfpkt_extr_head_u8(pkt))
+			*cp++ = tmp;
+		*cp = '\0';
+
+		if (CFCTRL_ERR_BIT & cmdrsp)
+			break;
+		/* Link ID */
+		linkid = cfpkt_extr_head_u8(pkt);
+
+		break;
+	case CFCTRL_SRV_UTIL:
+		/* Construct a frame, convert
+		 * DatagramConnectionID
+		 * to network format long and copy it out...
+		 */
+		/* Fifosize KB */
+		linkparam.u.utility.fifosize_kb = cfpkt_extr_head_u16(pkt);
+		/* Fifosize bufs */
+		linkparam.u.utility.fifosize_bufs = cfpkt_extr_head_u16(pkt);
+		/* name */
+		cp = (u8 *) linkparam.u.utility.name;
+		caif_assert(sizeof(linkparam.u.utility.name)
+			     >= UTILITY_NAME_LENGTH);
+		for (i = 0; i < UTILITY_NAME_LENGTH && cfpkt_more(pkt); i++) {
+			tmp = cfpkt_extr_head_u8(pkt);
+			*cp++ = tmp;
+		}
+		/* Length */
+		len = cfpkt_extr_head_u8(pkt);
+		linkparam.u.utility.paramlen = len;
+		/* Param Data */
+		cp = linkparam.u.utility.params;
+		while (cfpkt_more(pkt) && len--) {
+			tmp = cfpkt_extr_head_u8(pkt);
+			*cp++ = tmp;
+		}
+		if (CFCTRL_ERR_BIT & cmdrsp)
+			break;
+		/* Link ID */
+		linkid = cfpkt_extr_head_u8(pkt);
+		/* Length */
+		len = cfpkt_extr_head_u8(pkt);
+		/* Param Data */
+		cfpkt_extr_head(pkt, NULL, len);
+		break;
+	default:
+		pr_warn("Request setup, invalid type (%d)\n", serv);
+		return -1;
+	}
+
+	rsp.cmd = CFCTRL_CMD_LINK_SETUP;
+	rsp.param = linkparam;
+	spin_lock_bh(&cfctrl->info_list_lock);
+	req = cfctrl_remove_req(cfctrl, &rsp);
+
+	if (CFCTRL_ERR_BIT == (CFCTRL_ERR_BIT & cmdrsp) ||
+		cfpkt_erroneous(pkt)) {
+		pr_err("Invalid O/E bit or parse error "
+				"on CAIF control channel\n");
+		cfctrl->res.reject_rsp(cfctrl->serv.layer.up, 0,
+				       req ? req->client_layer : NULL);
+	} else {
+		cfctrl->res.linksetup_rsp(cfctrl->serv.layer.up, linkid,
+					  serv, physlinkid,
+					  req ?  req->client_layer : NULL);
+	}
+
+	kfree(req);
+
+	spin_unlock_bh(&cfctrl->info_list_lock);
+
+	return 0;
+}
+
 static int cfctrl_recv(struct cflayer *layer, struct cfpkt *pkt)
 {
 	u8 cmdrsp;
 	u8 cmd;
-	int ret = -1;
-	u8 len;
-	u8 param[255];
+	int ret = 0;
 	u8 linkid = 0;
 	struct cfctrl *cfctrl = container_obj(layer);
-	struct cfctrl_request_info rsp, *req;
-
 
 	cmdrsp = cfpkt_extr_head_u8(pkt);
 	cmd = cmdrsp & CFCTRL_CMD_MASK;
@@ -374,150 +511,7 @@ static int cfctrl_recv(struct cflayer *layer, struct cfpkt *pkt)
 
 	switch (cmd) {
 	case CFCTRL_CMD_LINK_SETUP:
-		{
-			enum cfctrl_srv serv;
-			enum cfctrl_srv servtype;
-			u8 endpoint;
-			u8 physlinkid;
-			u8 prio;
-			u8 tmp;
-			u8 *cp;
-			int i;
-			struct cfctrl_link_param linkparam;
-			memset(&linkparam, 0, sizeof(linkparam));
-
-			tmp = cfpkt_extr_head_u8(pkt);
-
-			serv = tmp & CFCTRL_SRV_MASK;
-			linkparam.linktype = serv;
-
-			servtype = tmp >> 4;
-			linkparam.chtype = servtype;
-
-			tmp = cfpkt_extr_head_u8(pkt);
-			physlinkid = tmp & 0x07;
-			prio = tmp >> 3;
-
-			linkparam.priority = prio;
-			linkparam.phyid = physlinkid;
-			endpoint = cfpkt_extr_head_u8(pkt);
-			linkparam.endpoint = endpoint & 0x03;
-
-			switch (serv) {
-			case CFCTRL_SRV_VEI:
-			case CFCTRL_SRV_DBG:
-				if (CFCTRL_ERR_BIT & cmdrsp)
-					break;
-				/* Link ID */
-				linkid = cfpkt_extr_head_u8(pkt);
-				break;
-			case CFCTRL_SRV_VIDEO:
-				tmp = cfpkt_extr_head_u8(pkt);
-				linkparam.u.video.connid = tmp;
-				if (CFCTRL_ERR_BIT & cmdrsp)
-					break;
-				/* Link ID */
-				linkid = cfpkt_extr_head_u8(pkt);
-				break;
-
-			case CFCTRL_SRV_DATAGRAM:
-				linkparam.u.datagram.connid =
-				    cfpkt_extr_head_u32(pkt);
-				if (CFCTRL_ERR_BIT & cmdrsp)
-					break;
-				/* Link ID */
-				linkid = cfpkt_extr_head_u8(pkt);
-				break;
-			case CFCTRL_SRV_RFM:
-				/* Construct a frame, convert
-				 * DatagramConnectionID
-				 * to network format long and copy it out...
-				 */
-				linkparam.u.rfm.connid =
-				    cfpkt_extr_head_u32(pkt);
-				cp = (u8 *) linkparam.u.rfm.volume;
-				for (tmp = cfpkt_extr_head_u8(pkt);
-				     cfpkt_more(pkt) && tmp != '\0';
-				     tmp = cfpkt_extr_head_u8(pkt))
-					*cp++ = tmp;
-				*cp = '\0';
-
-				if (CFCTRL_ERR_BIT & cmdrsp)
-					break;
-				/* Link ID */
-				linkid = cfpkt_extr_head_u8(pkt);
-
-				break;
-			case CFCTRL_SRV_UTIL:
-				/* Construct a frame, convert
-				 * DatagramConnectionID
-				 * to network format long and copy it out...
-				 */
-				/* Fifosize KB */
-				linkparam.u.utility.fifosize_kb =
-				    cfpkt_extr_head_u16(pkt);
-				/* Fifosize bufs */
-				linkparam.u.utility.fifosize_bufs =
-				    cfpkt_extr_head_u16(pkt);
-				/* name */
-				cp = (u8 *) linkparam.u.utility.name;
-				caif_assert(sizeof(linkparam.u.utility.name)
-					     >= UTILITY_NAME_LENGTH);
-				for (i = 0;
-				     i < UTILITY_NAME_LENGTH
-				     && cfpkt_more(pkt); i++) {
-					tmp = cfpkt_extr_head_u8(pkt);
-					*cp++ = tmp;
-				}
-				/* Length */
-				len = cfpkt_extr_head_u8(pkt);
-				linkparam.u.utility.paramlen = len;
-				/* Param Data */
-				cp = linkparam.u.utility.params;
-				while (cfpkt_more(pkt) && len--) {
-					tmp = cfpkt_extr_head_u8(pkt);
-					*cp++ = tmp;
-				}
-				if (CFCTRL_ERR_BIT & cmdrsp)
-					break;
-				/* Link ID */
-				linkid = cfpkt_extr_head_u8(pkt);
-				/* Length */
-				len = cfpkt_extr_head_u8(pkt);
-				/* Param Data */
-				cfpkt_extr_head(pkt, &param, len);
-				break;
-			default:
-				pr_warn("Request setup, invalid type (%d)\n",
-					serv);
-				goto error;
-			}
-
-			rsp.cmd = cmd;
-			rsp.param = linkparam;
-			spin_lock_bh(&cfctrl->info_list_lock);
-			req = cfctrl_remove_req(cfctrl, &rsp);
-
-			if (CFCTRL_ERR_BIT == (CFCTRL_ERR_BIT & cmdrsp) ||
-				cfpkt_erroneous(pkt)) {
-				pr_err("Invalid O/E bit or parse error "
-						"on CAIF control channel\n");
-				cfctrl->res.reject_rsp(cfctrl->serv.layer.up,
-						       0,
-						       req ? req->client_layer
-						       : NULL);
-			} else {
-				cfctrl->res.linksetup_rsp(cfctrl->serv.
-							  layer.up, linkid,
-							  serv, physlinkid,
-							  req ? req->
-							  client_layer : NULL);
-			}
-
-			kfree(req);
-
-			spin_unlock_bh(&cfctrl->info_list_lock);
-		}
+		ret = cfctrl_link_setup(cfctrl, pkt, cmdrsp);
 		break;
 	case CFCTRL_CMD_LINK_DESTROY:
 		linkid = cfpkt_extr_head_u8(pkt);
@@ -544,9 +538,9 @@ static int cfctrl_recv(struct cflayer *layer, struct cfpkt *pkt)
 		break;
 	default:
 		pr_err("Unrecognized Control Frame\n");
+		ret = -1;
 		goto error;
 	}
-	ret = 0;
 error:
 	cfpkt_destroy(pkt);
 	return ret;
-- 
2.39.5



