Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBB44C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E0DC433D7;
	Mon, 14 Nov 2022 12:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430408;
	bh=RKvN1kyaBatJ+467RcUCZfzWCDYAj7wqRw0ImaeHN5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEMcuXv0xWN0a3uyeS0umB2XbSJr6sd6/ua7P+M49lDNRF4vQQ1NLXUCZrpsQP+1o
	 1MPwK57XMx8fB2FOegj/vKboL0k7fR0NylNlKxgGLe9DcEEJS+5efc9of3LaOC4pz+
	 xQrbJSj3fg9C5dlLXwo5SnHc9swfUvmy0FDh62bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay R Mehta <sanju.mehta@amd.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Renjith Pananchikkal <Renjith.Pananchikkal@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 002/131] thunderbolt: Add DP OUT resource when DP tunnel is discovered
Date: Mon, 14 Nov 2022 13:44:31 +0100
Message-Id: <20221114124448.848423682@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sanjay R Mehta <sanju.mehta@amd.com>

commit b60e31bf18a7064032dbcb73dcb5b58f8a00a110 upstream.

If the boot firmware implements a connection manager of its own it may
create a DisplayPort tunnel and will be handed off to Linux connection
manager, but the DP OUT resource is not saved in the dp_resource list.

This patch adds tunnelled DP OUT port to the dp_resource list once the
DP tunnel is discovered.

Signed-off-by: Sanjay R Mehta <sanju.mehta@amd.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Tested-by: Renjith Pananchikkal <Renjith.Pananchikkal@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -105,6 +105,32 @@ static void tb_remove_dp_resources(struc
 	}
 }
 
+static void tb_discover_dp_resource(struct tb *tb, struct tb_port *port)
+{
+	struct tb_cm *tcm = tb_priv(tb);
+	struct tb_port *p;
+
+	list_for_each_entry(p, &tcm->dp_resources, list) {
+		if (p == port)
+			return;
+	}
+
+	tb_port_dbg(port, "DP %s resource available discovered\n",
+		    tb_port_is_dpin(port) ? "IN" : "OUT");
+	list_add_tail(&port->list, &tcm->dp_resources);
+}
+
+static void tb_discover_dp_resources(struct tb *tb)
+{
+	struct tb_cm *tcm = tb_priv(tb);
+	struct tb_tunnel *tunnel;
+
+	list_for_each_entry(tunnel, &tcm->tunnel_list, list) {
+		if (tb_tunnel_is_dp(tunnel))
+			tb_discover_dp_resource(tb, tunnel->dst_port);
+	}
+}
+
 static void tb_switch_discover_tunnels(struct tb_switch *sw,
 				       struct list_head *list,
 				       bool alloc_hopids)
@@ -1396,6 +1422,8 @@ static int tb_start(struct tb *tb)
 	tb_scan_switch(tb->root_switch);
 	/* Find out tunnels created by the boot firmware */
 	tb_discover_tunnels(tb);
+	/* Add DP resources from the DP tunnels created by the boot firmware */
+	tb_discover_dp_resources(tb);
 	/*
 	 * If the boot firmware did not create USB 3.x tunnels create them
 	 * now for the whole topology.


