Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E7E2F260C;
	Thu, 28 May 2026 20:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998747; cv=none; b=kyWWQWQUoyCMkVxP1HDavSh9GoBYKsbRr8GO8xX8AGHBv+yprEcBxlbsNUTuOLOsZtNWL62moPJeRQf2TWSHzVCDDj5VaBgv8L0LEFXxk1/E/EIJZ8JvNo9AuGA4/BQrMGEIbVr1F2Ydm+gdcShb7ZJgN54drpda8OEguQE7ZP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998747; c=relaxed/simple;
	bh=6oSv66TpEE2Q9aGptwOOT/arO6ko+IpWE2BWuYrzKV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkamhNa5/+Ndf+//kxSkPE7rldkR+wcD5+KuRyU+GF5pIsS+U1aLADv9tCGxHiaZRuwT1SAHRCRkRBHlgYCNO6voJGh+wznnevDLHUtb9nmXNtQkEegLzWnTR4maZb+QYBWzdLJuYVpYZzEWsN2VpmkvRi5zVuRhJSmapUyQZ00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtyBlbUC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtyBlbUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D131F1F000E9;
	Thu, 28 May 2026 20:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998746;
	bh=K7v1kv5ZFf/gAKh794I/BmXQWrsw6CuBpGqYCoL2O8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtyBlbUC2IDayhvTGOSC5T7l8z0wGr4GH8VP16Lh5yt1xEbTuf/giJQMVrZwogIDG
	 LpntOyT9SNF+pqjIXoQkOFvyOgY2EXZcl931mMidXxWvkaFXHm4UocJru2QF31qtha
	 Rqp/59fPV9Dzmqf2Q2MG8K52CcIFm/29NpkoFgtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 284/461] net: shaper: reject handle IDs exceeding internal bit-width
Date: Thu, 28 May 2026 21:46:53 +0200
Message-ID: <20260528194655.415018028@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8d5806c600fddb907ebe378f9c366d4b52ac3a39 ]

net_shaper_parse_handle() reads the user-supplied handle ID via
nla_get_u32(), accepting the full u32 range. However, the xarray key
is built by net_shaper_handle_to_index() using
FIELD_PREP(NET_SHAPER_ID_MASK, handle->id), where NET_SHAPER_ID_MASK
is GENMASK(25, 0) - only 26 bits wide. FIELD_PREP silently masks off
the upper bits at runtime. A user-supplied NODE id like 0x04000123
becomes id 0x123.

Additionally, a user-supplied id equal to NET_SHAPER_ID_UNSPEC
(0x03FFFFFF, which is NET_SHAPER_ID_MASK itself) would collide with
the sentinel used internally by the group operation to signal
"allocate a new NODE id".

Reject user-supplied IDs >= NET_SHAPER_ID_MASK (i.e., >= 0x03FFFFFF)
in the policy.

Fixes: 4b623f9f0f59 ("net-shapers: implement NL get operation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260510192904.3987113-9-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/net_shaper.yaml | 7 +++++++
 net/shaper/shaper.c                         | 4 +++-
 net/shaper/shaper_nl_gen.c                  | 7 ++++++-
 net/shaper/shaper_nl_gen.h                  | 2 ++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/net_shaper.yaml b/Documentation/netlink/specs/net_shaper.yaml
index 3f2ad772b64b1..de01f922040a5 100644
--- a/Documentation/netlink/specs/net_shaper.yaml
+++ b/Documentation/netlink/specs/net_shaper.yaml
@@ -33,6 +33,11 @@ doc: |
   @cap-get operation.
 
 definitions:
+  -
+    type: const
+    name: max-handle-id
+    value: 0x3fffffe
+    scope: kernel
   -
     type: enum
     name: scope
@@ -140,6 +145,8 @@ attribute-sets:
       -
         name: id
         type: u32
+        checks:
+          max: max-handle-id
         doc: |
           Numeric identifier of a shaper. The id semantic depends on
           the scope. For @queue scope it's the queue id and for @node
diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index 08fde2d9e8aa8..eb049847fed65 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -21,6 +21,8 @@
 
 #define NET_SHAPER_ID_UNSPEC NET_SHAPER_ID_MASK
 
+static_assert(NET_SHAPER_ID_UNSPEC == NET_SHAPER_MAX_HANDLE_ID + 1);
+
 struct net_shaper_hierarchy {
 	struct xarray shapers;
 };
@@ -360,7 +362,7 @@ static int net_shaper_pre_insert(struct net_shaper_binding *binding,
 	    handle->id == NET_SHAPER_ID_UNSPEC) {
 		u32 min, max;
 
-		handle->id = NET_SHAPER_ID_MASK - 1;
+		handle->id = NET_SHAPER_MAX_HANDLE_ID;
 		max = net_shaper_handle_to_index(handle);
 		handle->id = 0;
 		min = net_shaper_handle_to_index(handle);
diff --git a/net/shaper/shaper_nl_gen.c b/net/shaper/shaper_nl_gen.c
index 9b29be3ef19a8..76eff85ec66df 100644
--- a/net/shaper/shaper_nl_gen.c
+++ b/net/shaper/shaper_nl_gen.c
@@ -11,10 +11,15 @@
 
 #include <uapi/linux/net_shaper.h>
 
+/* Integer value ranges */
+static const struct netlink_range_validation net_shaper_a_handle_id_range = {
+	.max	= NET_SHAPER_MAX_HANDLE_ID,
+};
+
 /* Common nested types */
 const struct nla_policy net_shaper_handle_nl_policy[NET_SHAPER_A_HANDLE_ID + 1] = {
 	[NET_SHAPER_A_HANDLE_SCOPE] = NLA_POLICY_MAX(NLA_U32, 3),
-	[NET_SHAPER_A_HANDLE_ID] = { .type = NLA_U32, },
+	[NET_SHAPER_A_HANDLE_ID] = NLA_POLICY_FULL_RANGE(NLA_U32, &net_shaper_a_handle_id_range),
 };
 
 const struct nla_policy net_shaper_leaf_info_nl_policy[NET_SHAPER_A_WEIGHT + 1] = {
diff --git a/net/shaper/shaper_nl_gen.h b/net/shaper/shaper_nl_gen.h
index 42c46c52c7751..2406652a9014a 100644
--- a/net/shaper/shaper_nl_gen.h
+++ b/net/shaper/shaper_nl_gen.h
@@ -12,6 +12,8 @@
 
 #include <uapi/linux/net_shaper.h>
 
+#define NET_SHAPER_MAX_HANDLE_ID	67108862
+
 /* Common nested types */
 extern const struct nla_policy net_shaper_handle_nl_policy[NET_SHAPER_A_HANDLE_ID + 1];
 extern const struct nla_policy net_shaper_leaf_info_nl_policy[NET_SHAPER_A_WEIGHT + 1];
-- 
2.53.0



