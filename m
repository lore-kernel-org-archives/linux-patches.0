Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE86F4FD7AD;
	Thu, 17 Sep 2026 17:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667270; cv=none; b=Alh0qazjW0AE/aEHqojvl3nuoQgO+qHcmnh9jH8DS/kgzhvVU1sJLEYd4BIpyzBZggJbc2pUrBOukMR0+W9AnRIy3o0UK/EJgiNp6JNxYWV/28mxbYCTotVTUjH1rZLoodjj6YUWCHTQgj0+mZSzJNoyYOLiSn7Esf0ulP5n+YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667270; c=relaxed/simple;
	bh=Q1HYdw8qfsyoVAHsKMxTfpdhbK1nqpxWLlJtrHXMYI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMJiGtOz0vovePL3zvMSxs5udrDhtQ8w0rK/EetcRB1JvB7H9MaEC56d03CjoM3RU0ClTrTvNT8RVIjpseDeis1DpVa53eSdN5WSsDjCJlFn8fJKjUCrEYp7rznd2KNKaDC2ehj6oTib3FFjHespctL1CRxjsy/C9Hi6jJjNw6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kn+aZ34f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kn+aZ34f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD481F000FF;
	Thu, 17 Sep 2026 17:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667268;
	bh=gFu89DQb/r0JpGtsNWPNYwTd4dLsAXYlqV9iGsrgFQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kn+aZ34f7jLx4TsEqToXm6Ztjd6Gj0nkwosfXGEco+hmSH9dvOIQNtBFhbLXrnzQi
	 uw13x443wqmmIQCtpA97Y7AO47YbRik26cl1ZnxDu2FFQjMoAEJbSSXc8I1gtSKBKN
	 PqSf/19SstqSIEl6xI79W1jTdAkWEluDj9mBNT3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0035/1102] thunderbolt: Avoid reserved fields in path config space for USB4 routers
Date: Thu, 17 Sep 2026 15:59:38 +0100
Message-ID: <20260917151540.322473926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit 7e49bb89df860bb7352974100cd5dd48752bb646 ]

According to USB4 spec, USB4 Connection Manager shall not change value
of any fields that are defined as "RsvdZ" or "VD".  Specifically fields:
Path Credits Allocated, IFC, ISE fields in path config space shall not
be written by CM. To handle this, CM shall first read current path
config space from the hardware, change only the fields that can be
changed, and then write back the path config space.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/path.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/thunderbolt/path.c b/drivers/thunderbolt/path.c
index f760e54cd9bd1..a1632aa6c7ebd 100644
--- a/drivers/thunderbolt/path.c
+++ b/drivers/thunderbolt/path.c
@@ -426,7 +426,8 @@ static int __tb_path_deactivate_hop(struct tb_port *port, int hop_index,
 				 * in the USB4 spec so we clear them
 				 * only for pre-USB4 adapters.
 				 */
-				if (!tb_switch_is_usb4(port->sw)) {
+				if (tb_port_is_null(port) ||
+				    !tb_switch_is_usb4(port->sw)) {
 					hop.ingress_fc = 0;
 					hop.ingress_shared_buffer = 0;
 				}
@@ -544,15 +545,18 @@ int tb_path_activate(struct tb_path *path)
 		__tb_path_deactivate_hop(path->hops[i].in_port,
 				path->hops[i].in_hop_index, path->clear_fc);
 
-		/* dword 0 */
+		/* Needed for USB4 routers, read path config space before write */
+		res = tb_port_read(path->hops[i].in_port, &hop, TB_CFG_HOPS,
+				   2 * path->hops[i].in_hop_index, 2);
+		if (res)
+			goto err;
+
 		hop.next_hop = path->hops[i].next_hop_index;
 		hop.out_port = path->hops[i].out_port->port;
-		hop.initial_credits = path->hops[i].initial_credits;
 		hop.pmps = path->hops[i].pm_support;
 		hop.unknown1 = 0;
 		hop.enable = 1;
 
-		/* dword 1 */
 		out_mask = (i == path->path_length - 1) ?
 				TB_PATH_DESTINATION : TB_PATH_INTERNAL;
 		in_mask = (i == 0) ? TB_PATH_SOURCE : TB_PATH_INTERNAL;
@@ -562,12 +566,21 @@ int tb_path_activate(struct tb_path *path)
 		hop.drop_packages = path->drop_packages;
 		hop.counter = path->hops[i].in_counter_index;
 		hop.counter_enable = path->hops[i].in_counter_index != -1;
-		hop.ingress_fc = path->ingress_fc_enable & in_mask;
 		hop.egress_fc = path->egress_fc_enable & out_mask;
-		hop.ingress_shared_buffer = path->ingress_shared_buffer
-					    & in_mask;
-		hop.egress_shared_buffer = path->egress_shared_buffer
-					    & out_mask;
+		hop.egress_shared_buffer = path->egress_shared_buffer & out_mask;
+		/*
+		 * Protocol adapters IFC and ISE bits, and Path Credits
+		 * Allocated are vendor defined in the USB4 spec so we
+		 * program them only for pre-USB4 and lane adapters.
+		 */
+		if (tb_port_is_null(path->hops[i].in_port) ||
+		    !tb_switch_is_usb4(path->hops[i].in_port->sw)) {
+			hop.initial_credits = path->hops[i].initial_credits;
+			hop.ingress_fc = path->ingress_fc_enable & in_mask;
+			hop.ingress_shared_buffer =
+				path->ingress_shared_buffer & in_mask;
+		}
+
 		hop.unknown3 = 0;
 
 		tb_port_dbg(path->hops[i].in_port, "Writing hop %d\n", i);
-- 
2.53.0



