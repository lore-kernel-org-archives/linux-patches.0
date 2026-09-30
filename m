Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C39501F21;
	Wed, 30 Sep 2026 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782356; cv=none; b=Armcfla9e/x1P8ZmLt/aO2+8Kv6WL3eb9SkVqvBd3RcfJHIW+ZaA5TCGXk6sslCG8Kcl6knRywT+t0ZLIk2oxlcejAQqTvY54fPcfu4UvbCt7rC83+8rcWQRc9y6phfxAgkk+3iWSB2cgpEqyUrFFVBNHxxNG9CjUw4RsP+UfuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782356; c=relaxed/simple;
	bh=iaBYTi5pI7Oq9mM49lMZ49s53ce4e6T8Qlx0FAaRjpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwIe7sVCQYvIkFcCKbtcGGqgEswnjLGnzuOjf0DN+D3t5FDt7WbGs9kQUNNhduoYLb8PLtqvibMYsGcJuHzEH3RsW0rKqdCbRTaBTW5157n2f33dKGud9WylIRpCrotNq8KbxWwBSE5OCC6+d2MjJVRXpC9RC8v+yZtooIQwC1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CG4JZ+pP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CG4JZ+pP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EACC1F0089A;
	Wed, 30 Sep 2026 15:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782343;
	bh=8USLj5QAF7a+t5KveEdYxJcvXs9aWOF0opaAmCm6fAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CG4JZ+pP/Bj1N7HC2xttNF40v6oH8zY3mMsao/1KQ5DRlgZ4OLPNnVpDOAuR1j+en
	 n1iYC1mrmcHOdPbkFwBEFRxykeBCJOtygErt5VFlOnfyITwfB5L4BImMuOvJ1RIqT4
	 vRITq2hlyI8hqZ6Q2lnzO4+QW5vzDEOpjmvqef7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/595] thunderbolt: Set tb->root_switch to NULL when domain is stopped
Date: Wed, 30 Sep 2026 17:18:27 +0200
Message-ID: <20260930152348.027981448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 01a8485ab8f7e..2584e05d06b42 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1264,6 +1264,7 @@ static void tb_stop(struct tb *tb)
 		tb_tunnel_free(tunnel);
 	}
 	tb_switch_remove(tb->root_switch);
+	tb->root_switch = NULL;
 	tcm->hotplug_active = false; /* signal tb_handle_hotplug to quit */
 }
 
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index a354532988fb2..eeff6b1b498e2 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -577,7 +577,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 
 	mutex_lock(&tb->lock);
 	if (tb->root_switch)
-		uuid = tb->root_switch->uuid;
+		uuid = kmemdup(tb->root_switch->uuid, sizeof(*uuid), GFP_KERNEL);
 	else
 		uuid = NULL;
 	mutex_unlock(&tb->lock);
@@ -638,6 +638,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 	}
 
 out:
+	kfree(uuid);
 	kfree(xw->pkg);
 	kfree(xw);
 
@@ -1496,6 +1497,9 @@ static struct tb_xdomain *switch_find_xdomain(struct tb_switch *sw,
 {
 	struct tb_port *port;
 
+	if (!sw)
+		return NULL;
+
 	tb_switch_for_each_port(sw, port) {
 		struct tb_xdomain *xd;
 
-- 
2.53.0



