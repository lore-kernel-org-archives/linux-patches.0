Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636F72F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC55FC433EF;
	Wed, 12 Apr 2023 08:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288590;
	bh=kSfMlW5eVR9DAOMH/2ul2MyNtZv4s5yj5Dne60UaMTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9Nf11iniygY3Bep1/NegabT0QqtjREkxGFiasx16WmHBktp+RvBZtWN40D+8byWv
	 FCXPIzfh6EYNwebKdvHTVaT9gFssotdDm7f2VLIEQEiIeztXQNxBqmb9X+Pi1UOGJ7
	 p65KCOsaJcrBQ0KosmCkEi3GVksb5KjPZ/PPsxmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Ram Kumar Dharuman <quic_ramd@quicinc.com>,
	Sricharan Ramabadhran <quic_srichara@quicinc.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/93] net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT
Date: Wed, 12 Apr 2023 10:33:37 +0200
Message-Id: <20230412082824.636318570@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sricharan Ramabadhran <quic_srichara@quicinc.com>

[ Upstream commit 839349d13905927d8a567ca4d21d88c82028e31d ]

On the remote side, when QRTR socket is removed, af_qrtr will call
qrtr_port_remove() which broadcasts the DEL_CLIENT packet to all neighbours
including local NS. NS upon receiving the DEL_CLIENT packet, will remove
the lookups associated with the node:port and broadcasts the DEL_SERVER
packet.

But on the host side, due to the arrival of the DEL_CLIENT packet, the NS
would've already deleted the server belonging to that port. So when the
remote's NS again broadcasts the DEL_SERVER for that port, it throws below
error message on the host:

"failed while handling packet from 2:-2"

So fix this error by not broadcasting the DEL_SERVER packet when the
DEL_CLIENT packet gets processed."

Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Ram Kumar Dharuman <quic_ramd@quicinc.com>
Signed-off-by: Sricharan Ramabadhran <quic_srichara@quicinc.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index e595079c2cafe..3e40a1ba48f79 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -273,7 +273,7 @@ static struct qrtr_server *server_add(unsigned int service,
 	return NULL;
 }
 
-static int server_del(struct qrtr_node *node, unsigned int port)
+static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
 {
 	struct qrtr_lookup *lookup;
 	struct qrtr_server *srv;
@@ -286,7 +286,7 @@ static int server_del(struct qrtr_node *node, unsigned int port)
 	radix_tree_delete(&node->servers, port);
 
 	/* Broadcast the removal of local servers */
-	if (srv->node == qrtr_ns.local_node)
+	if (srv->node == qrtr_ns.local_node && bcast)
 		service_announce_del(&qrtr_ns.bcast_sq, srv);
 
 	/* Announce the service's disappearance to observers */
@@ -372,7 +372,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 		}
 		slot = radix_tree_iter_resume(slot, &iter);
 		rcu_read_unlock();
-		server_del(node, srv->port);
+		server_del(node, srv->port, true);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -458,10 +458,13 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 		kfree(lookup);
 	}
 
-	/* Remove the server belonging to this port */
+	/* Remove the server belonging to this port but don't broadcast
+	 * DEL_SERVER. Neighbours would've already removed the server belonging
+	 * to this port due to the DEL_CLIENT broadcast from qrtr_port_remove().
+	 */
 	node = node_get(node_id);
 	if (node)
-		server_del(node, port);
+		server_del(node, port, false);
 
 	/* Advertise the removal of this client to all local servers */
 	local_node = node_get(qrtr_ns.local_node);
@@ -566,7 +569,7 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
 	if (!node)
 		return -ENOENT;
 
-	return server_del(node, port);
+	return server_del(node, port, true);
 }
 
 static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
-- 
2.39.2



