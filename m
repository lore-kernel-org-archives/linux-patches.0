Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417548BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A71C433D2;
	Tue, 28 Mar 2023 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014977;
	bh=EBuVphMgO07SvHhHw7Hw5mLeatlRJ3L+6J6Gr0C28cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSFHZPtq6cE78nQt5MMZFKCwkn1nIgwTqEexZSDkb3WND/b55/qAjme5UnVg/4VwX
	 uh365Ikt+o71qGIn1F4vanJmcKcz8+0EKPMbyB3oJlOFT8hd2F8y6iC6nKIWdOr6Pt
	 YGEi4o7qv8aDYeuzQn8XFrafDKFkEyap1LWT2uOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.2 121/240] thunderbolt: Fix memory leak in margining
Date: Tue, 28 Mar 2023 16:41:24 +0200
Message-Id: <20230328142624.826282340@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit acec726473822bc6b585961f4ca2a11fa7f28341 upstream.

Memory for the usb4->margining needs to be relased for the upstream port
of the router as well, even though the debugfs directory gets released
with the router device removal. Fix this.

Fixes: d0f1e0c2a699 ("thunderbolt: Add support for receiver lane margining")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/debugfs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -942,7 +942,8 @@ static void margining_port_remove(struct
 
 	snprintf(dir_name, sizeof(dir_name), "port%d", port->port);
 	parent = debugfs_lookup(dir_name, port->sw->debugfs_dir);
-	debugfs_remove_recursive(debugfs_lookup("margining", parent));
+	if (parent)
+		debugfs_remove_recursive(debugfs_lookup("margining", parent));
 
 	kfree(port->usb4->margining);
 	port->usb4->margining = NULL;
@@ -967,19 +968,18 @@ static void margining_switch_init(struct
 
 static void margining_switch_remove(struct tb_switch *sw)
 {
+	struct tb_port *upstream, *downstream;
 	struct tb_switch *parent_sw;
-	struct tb_port *downstream;
 	u64 route = tb_route(sw);
 
 	if (!route)
 		return;
 
-	/*
-	 * Upstream is removed with the router itself but we need to
-	 * remove the downstream port margining directory.
-	 */
+	upstream = tb_upstream_port(sw);
 	parent_sw = tb_switch_parent(sw);
 	downstream = tb_port_at(route, parent_sw);
+
+	margining_port_remove(upstream);
 	margining_port_remove(downstream);
 }
 


