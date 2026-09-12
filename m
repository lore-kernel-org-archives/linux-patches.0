Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468B1374E6F;
	Sat, 12 Sep 2026 09:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205065; cv=none; b=mdH6OE5rxaGrxwquk+uBTgXobeYwAQN6/TivrdnCMuuSz+eO542qdtF4OgR4c4CvRn10LXNBvZ7TpAjQbcC7BKeir4wchuJm/E6HTZpCVfwr4pMahnEWvzvP3FIvwtqgaE8Ue0DXui99/y725jeeUujl7ZyARI+34Ab7ysXU7Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205065; c=relaxed/simple;
	bh=bIpx7f0FPqTs20HZ0Tpr/rPylNmtKsLLlVd50DHtiuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9DqRaJuCDLerTJTCPeh8qbNeGJpB6na5QbeooqOmgY5Bl+xTrSzrRNbRXLuapxfZBldVcxRewEx2+ohRNxrdieC1vZVZKN77f7dwojml3WPJWCy6fmz1nA95MO4PXxJbsxDcfOsuCAKstY5FtOdnl47LHWRUDaoPR0VCBG/3lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChzvCGys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChzvCGys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C481F000FF;
	Sat, 12 Sep 2026 09:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205063;
	bh=6nhKz185eaHZHgAOEr9kIQG3MRHrt3aM+wL+/8RPd+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ChzvCGyscyFEk7Hvy29oQEM7M/PePi/1ltBHJN8KV74G6GlKjqGV+pHUFTEU3I+uv
	 6LZ5sr1BwmFWqTN9dufmbzOqZ7lTmP5d+2vtG+xaGanCLGbRGja5bBGTHdVkdzc7iF
	 gVJ0DmWdJuG9hGfg1EALck/Wyw/Eovr27iuwqXlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1698/1815] net: microchip: vcap: use port number instead of netdev name for debugfs
Date: Sat, 12 Sep 2026 08:57:28 +0200
Message-ID: <20260912065728.843235458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit b7adcc56fd3db4f5ddaf8c01069d26136d61e5c8 ]

sparx5_vcap_init() runs before sparx5_register_netdevs() in probe, and
its debugfs setup calls vcap_port_debugfs() for every port using
netdev_name(ndev) as the debugfs file name. At that point the netdevs
have only been allocated, not registered, so dev->name still holds the
"eth%d" template and netdev_name() returns "(unnamed net_device)".
Every port tries to create the same file under vcaps/, producing a
flood of warnings at boot:

  debugfs: '(unnamed net_device)' already exists in 'vcaps'
  debugfs: '(unnamed net_device)' already exists in 'vcaps'
  ...

Add vcap_port_debugfs_portno(), a variant of vcap_port_debugfs() that
takes the port's stable hardware port number and uses "p%u" as the
debugfs file name instead of netdev_name(ndev). This makes the file
name independent of registration order; the file still stores and
later dereferences the netdev itself, same as before. sparx5 already
reports the same "p%d" string via ndo_get_phys_port_name(), so the
debugfs name now matches that.

Only sparx5 (and lan969x, which shares this code) is switched to the
new function. lan966x keeps calling vcap_port_debugfs() unchanged, so
this fix does not rename any of its existing debugfs files.

Fixes: b8909aad5b8d ("net: sparx5: move netdev and notifier block registration to probe")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20260817-misc-fixes-sparx5-lan969x-v3-1-c7c7fef723a8@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../microchip/sparx5/sparx5_vcap_impl.c       |  5 +++--
 .../microchip/vcap/vcap_api_debugfs.c         | 21 +++++++++++++++++++
 .../microchip/vcap/vcap_api_debugfs.h         | 14 +++++++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index cf332de6bf736..2dee2ce19fce7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -2077,8 +2077,9 @@ int sparx5_vcap_init(struct sparx5 *sparx5)
 	dir = vcap_debugfs(sparx5->dev, sparx5->debugfs_root, ctrl);
 	for (idx = 0; idx < consts->n_ports; ++idx)
 		if (sparx5->ports[idx])
-			vcap_port_debugfs(sparx5->dev, dir, ctrl,
-					  sparx5->ports[idx]->ndev);
+			vcap_port_debugfs_portno(sparx5->dev, dir, ctrl,
+						 sparx5->ports[idx]->ndev,
+						 sparx5->ports[idx]->portno);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index e0c65c7ab23e1..476f7496a9d44 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -400,6 +400,27 @@ void vcap_port_debugfs(struct device *dev, struct dentry *parent,
 }
 EXPORT_SYMBOL_GPL(vcap_port_debugfs);
 
+void vcap_port_debugfs_portno(struct device *dev,
+			      struct dentry *parent,
+			      struct vcap_control *vctrl,
+			      struct net_device *ndev,
+			      unsigned int portno)
+{
+	struct vcap_port_debugfs_info *info;
+	char name[16];
+
+	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return;
+
+	info->vctrl = vctrl;
+	info->ndev = ndev;
+
+	snprintf(name, sizeof(name), "p%u", portno);
+	debugfs_create_file(name, 0444, parent, info, &vcap_port_debugfs_fops);
+}
+EXPORT_SYMBOL_GPL(vcap_port_debugfs_portno);
+
 /* Show the full VCAP instance data (rules with all fields) */
 static int vcap_debugfs_show(struct seq_file *m, void *unused)
 {
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.h b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.h
index 9f2c59b5f6f53..7dc6e3411a4d9 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.h
@@ -18,6 +18,12 @@ void vcap_port_debugfs(struct device *dev, struct dentry *parent,
 		       struct vcap_control *vctrl,
 		       struct net_device *ndev);
 
+void vcap_port_debugfs_portno(struct device *dev,
+			      struct dentry *parent,
+			      struct vcap_control *vctrl,
+			      struct net_device *ndev,
+			      unsigned int portno);
+
 /* Create a debugFS entry for a vcap instance */
 struct dentry *vcap_debugfs(struct device *dev, struct dentry *parent,
 			    struct vcap_control *vctrl);
@@ -30,6 +36,14 @@ static inline void vcap_port_debugfs(struct device *dev, struct dentry *parent,
 {
 }
 
+static inline void vcap_port_debugfs_portno(struct device *dev,
+					    struct dentry *parent,
+					    struct vcap_control *vctrl,
+					    struct net_device *ndev,
+					    unsigned int portno)
+{
+}
+
 static inline struct dentry *vcap_debugfs(struct device *dev,
 					  struct dentry *parent,
 					  struct vcap_control *vctrl)
-- 
2.53.0



