Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47B7503900;
	Wed, 30 Sep 2026 16:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784110; cv=none; b=H7SHFwareS9XAnYoOSkSmUaPED4O2opwmhBllsk8F0R3/pzVdqJffma2LuKcIF8+vapORGuBuIgWIH8QRsMH/xl6HDMUxcoI+NUTy5ogQnjkXapOsOY+BwaU3BaKTMnXhNhVXer/x2f3j9MJbn0I/bGRQ6QSO8SxCU4kZ405DGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784110; c=relaxed/simple;
	bh=OjhJRJwAOOCpiJ1NakMAyLtLX8lHozipemKO+MVoRFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcCTHnKB9CLg9wnFZBbhVVFeh5hm98ZRQ/kkSJweI7bWSVxGicN4CUHK1cv5XYAL3Tu+dAEO/R8qlCxwAgntONrr+LjbSIcFQOO5U6SXcYcatOCQKiBQY2FaSDU4noWJyT2vsun8wc9pEcgnJB/tgBPRh6ntySZSxBf2kCE/FcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDsfi2wt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDsfi2wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE561F00893;
	Wed, 30 Sep 2026 16:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784105;
	bh=ToHTSPY5xVZ9hBMmt5iXB2P2R2O0fglthPlI0hVxWKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDsfi2wtJYTZec7DHfZWu5EtgCOe9bIc4kX0LDH4TuynPPZwatm0KNaHGXYmuiYaE
	 zV7TH9NnIUOSFmW6NAarcoF3OCJNHcoVasGhPJKDpiQ1lAsxXb8TeUK/gMNXnQKsH1
	 XOU8zU7U7K4U4DgfJg2ctMGSKP8aNLCh2UATg9Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/982] thunderbolt: Set tb->root_switch to NULL when domain is stopped
Date: Wed, 30 Sep 2026 17:12:37 +0200
Message-ID: <20260930152417.248158798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3c993a40c2313..00cedf7c24725 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1515,6 +1515,7 @@ static void tb_stop(struct tb *tb)
 		tb_tunnel_free(tunnel);
 	}
 	tb_switch_remove(tb->root_switch);
+	tb->root_switch = NULL;
 	tcm->hotplug_active = false; /* signal tb_handle_hotplug to quit */
 }
 
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 58c91423e4f07..f0753a0d5b72e 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -755,7 +755,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 
 	mutex_lock(&tb->lock);
 	if (tb->root_switch)
-		uuid = tb->root_switch->uuid;
+		uuid = kmemdup(tb->root_switch->uuid, sizeof(*uuid), GFP_KERNEL);
 	else
 		uuid = NULL;
 	mutex_unlock(&tb->lock);
@@ -869,6 +869,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 	}
 
 out:
+	kfree(uuid);
 	kfree(xw->pkg);
 	kfree(xw);
 
@@ -2223,6 +2224,9 @@ static struct tb_xdomain *switch_find_xdomain(struct tb_switch *sw,
 {
 	struct tb_port *port;
 
+	if (!sw)
+		return NULL;
+
 	tb_switch_for_each_port(sw, port) {
 		struct tb_xdomain *xd;
 
-- 
2.53.0



