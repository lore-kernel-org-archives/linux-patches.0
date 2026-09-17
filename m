Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BAF4F96CF;
	Thu, 17 Sep 2026 17:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667284; cv=none; b=f1zWH9pktgTOODYnTr6v7RmpXmigd1JQ6mWthPfnsAzUkFAR7cRyn8Dqwv9p89wA6Vsee9uGb8JCVh//yuiuvH84x0YxUIXoZ7KQ7rFu5PNhqkHq6MbdZT8qAnp0cmAfsCbAJroFV2K+0AZl+iiss9FzIj6g9983DMaCl97hPC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667284; c=relaxed/simple;
	bh=hDkkOVgbl1rW8G+VQeklybREx3UtoICNEupdJDu3vdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUZ4JSZ40SFmGEuFejzb03VUrUa6xTPzx7+bMPjQwoupd/7LesRT9/wOshwi8MOkV+UlNDyA2XjUdIYa5OcRj18Gud9CQwrTtJLX8Ri3om9NPLr9jrBYxiqnwTRkzUUPPEkRHax2nJH/j20J1FUIJFCPBI9qmCV+yDH3gRgFv0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvhEiLMS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvhEiLMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3364F1F000FF;
	Thu, 17 Sep 2026 17:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667283;
	bh=x70QHrOKPAn9vd3NcnWZQU7QBbUDlWpvwfTGmFbFccY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvhEiLMSK0agUIFYruH2JeHNx8V/zVdgWuA4rlm0LluubmeRzIV35rN6DhocmY24H
	 fr7XL682lZm9SB0GMufDioMC1AIWok1eI5YNAB6A2SuiFKcsz4FtgyB8rqK6JyiF1m
	 oeWY0xV9ZIP0E6WfLAqsMzMfYfqNa7HgTknIlB5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0040/1102] thunderbolt: Set tb->root_switch to NULL when domain is stopped
Date: Thu, 17 Sep 2026 15:59:43 +0100
Message-ID: <20260917151540.451660679@linuxfoundation.org>
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
index 5d89a265938ad..1ea020dafeb81 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -2850,6 +2850,7 @@ static void tb_stop(struct tb *tb)
 		tb_tunnel_free(tunnel);
 	}
 	tb_switch_remove(tb->root_switch);
+	tb->root_switch = NULL;
 	tcm->hotplug_active = false; /* signal tb_handle_hotplug to quit */
 }
 
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 0532bbbb49cf8..ea4d5e63504f8 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -754,7 +754,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 
 	mutex_lock(&tb->lock);
 	if (tb->root_switch)
-		uuid = tb->root_switch->uuid;
+		uuid = kmemdup(tb->root_switch->uuid, sizeof(*uuid), GFP_KERNEL);
 	else
 		uuid = NULL;
 	mutex_unlock(&tb->lock);
@@ -868,6 +868,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 	}
 
 out:
+	kfree(uuid);
 	kfree(xw->pkg);
 	kfree(xw);
 
@@ -2330,6 +2331,9 @@ static struct tb_xdomain *switch_find_xdomain(struct tb_switch *sw,
 {
 	struct tb_port *port;
 
+	if (!sw)
+		return NULL;
+
 	tb_switch_for_each_port(sw, port) {
 		struct tb_xdomain *xd;
 
-- 
2.53.0



