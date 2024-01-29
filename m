Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7A0158D68;
	Mon, 29 Jan 2024 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548133; cv=none; b=broguorhVkOVllnAvwJ1uhkQK9+FWuHNc4Ue6rx3rIUGdCYsBQQjvmkWSq9+JCi4EL3PZmHWpLJ6o+XDVC3lwvI1SwMLFkmVt7mV44pVXrgoSWaJ7hu21UPV9ymjGwe7rcm4ggY42upS9MRLYuNhYoV6Vl5hsLCr4v2VJNFoaNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548133; c=relaxed/simple;
	bh=gjpEqC1XdTNefOjhHgWVi/9ynStN2mKjvTfRx4U6lno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5jGpaRtHkTNnVnfosLS0UF7jHGqspAC4cja1tXDAxK9RiFu2ea/Oye+ySrihXVxXUHwZLyHcpirX/jrf9a1A204XjXFDpPNCA3Pb6i01cIxvXmuCljFFz9PRMgVo+Mt5IxiTu5uxSDVFOdECI6lFaOWRDzeOs91r7vQA79H8u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCyWqHfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCyWqHfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07489C43390;
	Mon, 29 Jan 2024 17:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548133;
	bh=gjpEqC1XdTNefOjhHgWVi/9ynStN2mKjvTfRx4U6lno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCyWqHfkM6u2yyInsp0eiriNRorILOaxbAi/vbzxqC0jXuo+Jz3NWKzPDBFkgSZ/1
	 Wx1eUbHeKsQJlNZC4qh6ldLmzXdR81x8c1T7+br4i8etCtR6PLv8WkaOysJBKg938v
	 n2VSl3hIjSj0SRoL8NM4+pJ47/gYm+/q71nZvQGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Glaza <jan.glaza@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 163/346] dpll: fix userspace availability of pins
Date: Mon, 29 Jan 2024 09:03:14 -0800
Message-ID: <20240129170021.195122618@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit db2ec3c94667eaeecc6a74d96594fab6baf80fdc ]

If parent pin was unregistered but child pin was not, the userspace
would see the "zombie" pins - the ones that were registered with
a parent pin (dpll_pin_on_pin_register(..)).
Technically those are not available - as there is no dpll device in the
system. Do not dump those pins and prevent userspace from any
interaction with them. Provide a unified function to determine if the
pin is available and use it before acting/responding for user requests.

Fixes: 9d71b54b65b1 ("dpll: netlink: Add DPLL framework base functions")
Reviewed-by: Jan Glaza <jan.glaza@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_netlink.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 4c64611d32ac..7cc99d627942 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -525,6 +525,24 @@ __dpll_device_change_ntf(struct dpll_device *dpll)
 	return dpll_device_event_send(DPLL_CMD_DEVICE_CHANGE_NTF, dpll);
 }
 
+static bool dpll_pin_available(struct dpll_pin *pin)
+{
+	struct dpll_pin_ref *par_ref;
+	unsigned long i;
+
+	if (!xa_get_mark(&dpll_pin_xa, pin->id, DPLL_REGISTERED))
+		return false;
+	xa_for_each(&pin->parent_refs, i, par_ref)
+		if (xa_get_mark(&dpll_pin_xa, par_ref->pin->id,
+				DPLL_REGISTERED))
+			return true;
+	xa_for_each(&pin->dpll_refs, i, par_ref)
+		if (xa_get_mark(&dpll_device_xa, par_ref->dpll->id,
+				DPLL_REGISTERED))
+			return true;
+	return false;
+}
+
 /**
  * dpll_device_change_ntf - notify that the dpll device has been changed
  * @dpll: registered dpll pointer
@@ -551,7 +569,7 @@ dpll_pin_event_send(enum dpll_cmd event, struct dpll_pin *pin)
 	int ret = -ENOMEM;
 	void *hdr;
 
-	if (WARN_ON(!xa_get_mark(&dpll_pin_xa, pin->id, DPLL_REGISTERED)))
+	if (!dpll_pin_available(pin))
 		return -ENODEV;
 
 	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
@@ -1102,6 +1120,10 @@ int dpll_nl_pin_id_get_doit(struct sk_buff *skb, struct genl_info *info)
 	}
 	pin = dpll_pin_find_from_nlattr(info);
 	if (!IS_ERR(pin)) {
+		if (!dpll_pin_available(pin)) {
+			nlmsg_free(msg);
+			return -ENODEV;
+		}
 		ret = dpll_msg_add_pin_handle(msg, pin);
 		if (ret) {
 			nlmsg_free(msg);
@@ -1151,6 +1173,8 @@ int dpll_nl_pin_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 
 	xa_for_each_marked_start(&dpll_pin_xa, i, pin, DPLL_REGISTERED,
 				 ctx->idx) {
+		if (!dpll_pin_available(pin))
+			continue;
 		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
 				  cb->nlh->nlmsg_seq,
 				  &dpll_nl_family, NLM_F_MULTI,
@@ -1413,7 +1437,8 @@ int dpll_pin_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
 	}
 	info->user_ptr[0] = xa_load(&dpll_pin_xa,
 				    nla_get_u32(info->attrs[DPLL_A_PIN_ID]));
-	if (!info->user_ptr[0]) {
+	if (!info->user_ptr[0] ||
+	    !dpll_pin_available(info->user_ptr[0])) {
 		NL_SET_ERR_MSG(info->extack, "pin not found");
 		ret = -ENODEV;
 		goto unlock_dev;
-- 
2.43.0



