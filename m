Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB7A2EC09B;
	Sat, 12 Sep 2026 11:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212120; cv=none; b=NPG9f4JOibMOdcFtEeNGPbFXNVUKiNY1JwF+ybpanPU9P6PcKj0u3D7FSnF2N31EA2QTCk8FA+svrI8yt7dXSuPqMkTah5AYgR3d6F3GzPsD5naDA3uT8WqX/0c5iw21+XP/Y4thQQ0/jvLv/yYMy2vD5qFWwKKazJPBG3JI2JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212120; c=relaxed/simple;
	bh=WtGo5gpxV7piXDVdtGywKzrSvpSP6GT8Kx8O3mWcCIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xo6mJPl6W4DeSwp405o+dU7qwj/w3m52yN9cB262GZQkYS21+8nGT0MCQGCkxsUWpsvEWqN3BQNgQjDJzcWGReQYH0hPL258eLibMd6c/aiDaxMP5Q26wxSfx6cxude0IumGyuob2ZkMh1BClt6Q6JRWUK/LAFdedStrh6fee7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1V1mkT0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1V1mkT0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7201F000FF;
	Sat, 12 Sep 2026 11:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212119;
	bh=99BoCYTo+VSf6cg6jS0MpionHcfIYBqjbsVI96Idl8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1V1mkT0AjZI03j+ZhxkvjQNV8fqTzrkpiGuCLUAogitFUDHrjbtRfgwPrNVoS1k+E
	 GRKaKFAZcZ+m8v84DPEcZXf1IXa9y62kgs8nFqAhxxdLogbi418QprNtA6X+IsbsKF
	 s5DnY6JtbYL+j7gMzBKehcjsbhgSYi1Jdttgpbss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1334/1518] devlink: Introduce switchdev_inactive eswitch mode
Date: Sat, 12 Sep 2026 08:58:23 +0200
Message-ID: <20260912065653.707377963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 0e535824d0bcf7c9bb0532d902283c31c78cd6f3 ]

Adds DEVLINK_ESWITCH_MODE_SWITCHDEV_INACTIVE attribute to UAPI and
documentation.

Before having traffic flow through an eswitch, a user may want to have the
ability to block traffic towards the FDB until FDB is fully programmed and
the user is ready to send traffic to it. For example: when two eswitches
are present for vports in a multi-PF setup, one eswitch may take over the
traffic from the other when the user chooses.
Before this take over, a user may want to first program the inactive
eswitch and then once ready redirect traffic to this new eswitch.

switchdev modes transition semantics:

legacy->switchdev_inactive: Create switchdev mode normally, traffic not
  allowed to flow yet.

switchdev_inactive->switchdev: Enable traffic to flow.

switchdev->switchdev_inactive: Block traffic on the FDB, FDB and
  representros state and content is preserved.

When eswitch is configured to this mode, traffic is ignored/dropped on
this eswitch FDB, while current configuration is kept, e.g FDB rules and
netdev representros are kept available, FDB programming is allowed.

Example:
 # start inactive switchdev
devlink dev eswitch set pci/0000:08:00.1 mode switchdev_inactive
 # setup TC rules, representors etc ..
 # activate
devlink dev eswitch set pci/0000:08:00.1 mode switchdev

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20251108070404.1551708-2-saeed@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: ff0f9b7aa1c7 ("net/mlx5: E-Switch, use state lock for vport state changes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/devlink.yaml            |  2 ++
 .../networking/devlink/devlink-eswitch-attr.rst     | 13 +++++++++++++
 include/uapi/linux/devlink.h                        |  1 +
 net/devlink/netlink_gen.c                           |  2 +-
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/devlink.yaml b/Documentation/netlink/specs/devlink.yaml
index 3db59c9658694..426d5aa7d9551 100644
--- a/Documentation/netlink/specs/devlink.yaml
+++ b/Documentation/netlink/specs/devlink.yaml
@@ -99,6 +99,8 @@ definitions:
         name: legacy
       -
         name: switchdev
+      -
+        name: switchdev-inactive
   -
     type: enum
     name: eswitch-inline-mode
diff --git a/Documentation/networking/devlink/devlink-eswitch-attr.rst b/Documentation/networking/devlink/devlink-eswitch-attr.rst
index 08bb39ab15286..eafe09abc40c2 100644
--- a/Documentation/networking/devlink/devlink-eswitch-attr.rst
+++ b/Documentation/networking/devlink/devlink-eswitch-attr.rst
@@ -39,6 +39,10 @@ The following is a list of E-Switch attributes.
          rules.
        * ``switchdev`` allows for more advanced offloading capabilities of
          the E-Switch to hardware.
+       * ``switchdev_inactive`` switchdev mode but starts inactive, doesn't allow traffic
+         until explicitly activated. This mode is useful for orchestrators that
+         want to prepare the device in switchdev mode but only activate it when
+         all configurations are done.
    * - ``inline-mode``
      - enum
      - Some HWs need the VF driver to put part of the packet
@@ -74,3 +78,12 @@ Example Usage
 
     # enable encap-mode with legacy mode
     $ devlink dev eswitch set pci/0000:08:00.0 mode legacy inline-mode none encap-mode basic
+
+    # start switchdev mode in inactive state
+    $ devlink dev eswitch set pci/0000:08:00.0 mode switchdev_inactive
+
+    # setup switchdev configurations, representors, FDB entries, etc..
+    ...
+
+    # activate switchdev mode to allow traffic
+    $ devlink dev eswitch set pci/0000:08:00.0 mode switchdev
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index bcad11a787a55..157f11d3fb72f 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -181,6 +181,7 @@ enum devlink_sb_threshold_type {
 enum devlink_eswitch_mode {
 	DEVLINK_ESWITCH_MODE_LEGACY,
 	DEVLINK_ESWITCH_MODE_SWITCHDEV,
+	DEVLINK_ESWITCH_MODE_SWITCHDEV_INACTIVE,
 };
 
 enum devlink_eswitch_inline_mode {
diff --git a/net/devlink/netlink_gen.c b/net/devlink/netlink_gen.c
index 9fd00977d59e3..5ad435aee29de 100644
--- a/net/devlink/netlink_gen.c
+++ b/net/devlink/netlink_gen.c
@@ -229,7 +229,7 @@ static const struct nla_policy devlink_eswitch_get_nl_policy[DEVLINK_ATTR_DEV_NA
 static const struct nla_policy devlink_eswitch_set_nl_policy[DEVLINK_ATTR_ESWITCH_ENCAP_MODE + 1] = {
 	[DEVLINK_ATTR_BUS_NAME] = { .type = NLA_NUL_STRING, },
 	[DEVLINK_ATTR_DEV_NAME] = { .type = NLA_NUL_STRING, },
-	[DEVLINK_ATTR_ESWITCH_MODE] = NLA_POLICY_MAX(NLA_U16, 1),
+	[DEVLINK_ATTR_ESWITCH_MODE] = NLA_POLICY_MAX(NLA_U16, 2),
 	[DEVLINK_ATTR_ESWITCH_INLINE_MODE] = NLA_POLICY_MAX(NLA_U8, 3),
 	[DEVLINK_ATTR_ESWITCH_ENCAP_MODE] = NLA_POLICY_MAX(NLA_U8, 1),
 };
-- 
2.53.0



