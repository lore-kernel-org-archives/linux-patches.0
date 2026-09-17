Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C234D6C36;
	Thu, 17 Sep 2026 16:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661034; cv=none; b=q23V2fkMLdSHx5pLwCqW13wCgJqKld/YEYhPmSf/NpE+28LrI7+mHwaNvpamSCwsR9TUy9s3FbFemV+hgxJtKuTsLBEcItzmM6XAoX0BcA30GgKwkV2UKXZy4fr/7gN2wAGIJDTRXvj0lpp7j6gkPnyrHiVN3227j93drCjldYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661034; c=relaxed/simple;
	bh=vTUyg2YyatHTrahK+sXpQi/yDnCXZ29dWNBtmDFhIqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBnobI38WKe0b1h5k/N4N5k4X9id5oQP2xs1zsJzXlIwD2eUFX4WtwWJNx2ZjufTPMaN4NdFo8h5ffXv+rDmj5zdTWXCknT7OhVrk/+O7jpL0hfaNSRDZrEO2fP++9TCWdYCDUTtCOmZh7B8gd52C/OhMJQBuE6lMfNReZGLHzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJzaHfrO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJzaHfrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB861F000FF;
	Thu, 17 Sep 2026 16:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661033;
	bh=BByRtWPiq3vL45T17CnF1+3QYWcceo4ywj/DWws0mEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJzaHfrORejWMcGqzQrqTXd2LHV1+9uAwHQ1f8LOpy+3moMCmGIHSYoXJVVeMIQVr
	 I1VSNCESLadBiw2diaeOYuL10Tn/7bIFYPUiKz5B2UGmNPf4Dz79Mc7/kD6tmJ5MC8
	 4wE99cBCa0U4Gmci7nFdbZaiuYj3L2UA/0tXCxMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0060/1250] thunderbolt: Set tb->root_switch to NULL when domain is stopped
Date: Thu, 17 Sep 2026 15:57:35 +0100
Message-ID: <20260917151553.570301370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 59a503946c5ef..75367c060695f 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -2952,6 +2952,7 @@ static void tb_stop(struct tb *tb)
 		tb_tunnel_put(tunnel);
 	}
 	tb_switch_remove(tb->root_switch);
+	tb->root_switch = NULL;
 	tcm->hotplug_active = false; /* signal tb_handle_hotplug to quit */
 }
 
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index fed0fae2a6299..1eb149445fa05 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -756,7 +756,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 
 	mutex_lock(&tb->lock);
 	if (tb->root_switch)
-		uuid = tb->root_switch->uuid;
+		uuid = kmemdup(tb->root_switch->uuid, sizeof(*uuid), GFP_KERNEL);
 	else
 		uuid = NULL;
 	mutex_unlock(&tb->lock);
@@ -870,6 +870,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 	}
 
 out:
+	kfree(uuid);
 	kfree(xw->pkg);
 	kfree(xw);
 
@@ -2344,6 +2345,9 @@ static struct tb_xdomain *switch_find_xdomain(struct tb_switch *sw,
 {
 	struct tb_port *port;
 
+	if (!sw)
+		return NULL;
+
 	tb_switch_for_each_port(sw, port) {
 		struct tb_xdomain *xd;
 
-- 
2.53.0



