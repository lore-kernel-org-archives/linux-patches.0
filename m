Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9368C5218B1;
	Wed, 30 Sep 2026 17:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790617; cv=none; b=QmJJTw3uRIo1bZsn1bv5WJg5ad+CoTk3ZsG0uRY86thfYKL+0I78jdRENsGeH5aoLnRHWoVuaf3U9L1Gwjr25mKFcXj1Pqii/xMd3RJI0PWLv7inkkQlEywAcGevbgV0pASbUf8kB2osRd+YmEtlGLdb2qao6mK+grnBfdAE5jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790617; c=relaxed/simple;
	bh=z4eaH6FNZlQI4qwm5UWRM3E4sEwob8aEtxTuV6VLoEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSOhQWftLx1l4goMdMEF53L4YMd6OD0QLmblpVcdZnZp0VzZ9KHTrti287dvEt21VSCBvgFDp5mLocBtKfgGQg63tw1+Bv3ALBbr7N6zxQ4C53A7alXyHCOv8+oUEEDDwpmednr+eGW1IxQlrcuLevLnVis09e0QuIde4WuGUPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spzQKj8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spzQKj8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBFE1F0089B;
	Wed, 30 Sep 2026 17:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790616;
	bh=gZWADj4mgfvySpX7IX4LefSiHApqXshVb+umneaIXc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=spzQKj8JtEcvCa26zmPvxFAEgHsb9qPgRFxYso2UVSAD4uNcuGJ9JytppJqZTaQf4
	 yggUitTs8GaM7abPqY3/ISwLGvGQrQg/cXlIFE07fJthaw1ngDMDUZ90CiVGOzuLhI
	 dm+5EtI+0JiPvMQ1acrG/NHWoKr5wkU4Kt/pETN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/752] thunderbolt: Set tb->root_switch to NULL when domain is stopped
Date: Wed, 30 Sep 2026 17:18:05 +0200
Message-ID: <20260930152358.479020972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit e56249d8a68e712f3b60e1f3fdbb5b4fea146468 ]

Similarly what we do with the firmware connection manager. This makes
tb_xdp_handle_request() return error to the remote host. However, we
need to make sure we keep the uuid alive so that we can reply until the
whole domain is released.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tb.c      | 1 +
 drivers/thunderbolt/xdomain.c | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index ed001dfd2cb4e..effb8c8a8fd6d 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1366,6 +1366,7 @@ static void tb_stop(struct tb *tb)
 		tb_tunnel_free(tunnel);
 	}
 	tb_switch_remove(tb->root_switch);
+	tb->root_switch = NULL;
 	tcm->hotplug_active = false; /* signal tb_handle_hotplug to quit */
 }
 
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index b5dad78c6b230..aee53c8759acc 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -603,7 +603,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 
 	mutex_lock(&tb->lock);
 	if (tb->root_switch)
-		uuid = tb->root_switch->uuid;
+		uuid = kmemdup(tb->root_switch->uuid, sizeof(*uuid), GFP_KERNEL);
 	else
 		uuid = NULL;
 	mutex_unlock(&tb->lock);
@@ -664,6 +664,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 	}
 
 out:
+	kfree(uuid);
 	kfree(xw->pkg);
 	kfree(xw);
 
@@ -1735,6 +1736,9 @@ static struct tb_xdomain *switch_find_xdomain(struct tb_switch *sw,
 {
 	struct tb_port *port;
 
+	if (!sw)
+		return NULL;
+
 	tb_switch_for_each_port(sw, port) {
 		struct tb_xdomain *xd;
 
-- 
2.53.0



