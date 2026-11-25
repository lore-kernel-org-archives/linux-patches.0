Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623865;
	b=KLPYUi2ZE75vngsq9mPMcNKR8D1fkyFLVCGZ1D14CkOPw+jVwKTx/6O5p0Bz11ribTge
	 lOoGe1314XYc37KQIhH/9+6wsYwJHvr4aIU5Ep4jAkGmZ0ZftIBKUjjGRAIi3Tx6Zdqh7
	 hX37csp70FgBwJ9GF1aNTgmLAfmGcxcSprodCAk65YEHvCIKibe9bDYga+nDi0FKEg5Mi
	 OgkVnY3rdPnePsPtv/GqDISwhwd105gbPP6ep1OgQW3DldJJwsjq9N86upvpkiHb7j1Ti
	 z6dIlFDXAgabf0wUp2PSnFP0OvTbMKa/dJtaIMYtX53E+KOcdPyGE+tzABO9m5LCB7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zsMRqezp+5FLLU2zLi2BDBKgqtdzOdsLtzuO5dAEssk=;
	b=kqQv89SNzJS6wb2nIBWYHlSB4PIsfXuFPRZ38c4c4QHIxTEmytlEWXe1xEBiXrkLxU+Z
	 S0prxx6TUc7ZSNsDfzY9tW6s+h/FkcFWMihRNmWjjWsJpfYzA3fZ6E3ePFTutQH+FgYFh
	 VPfms4i3+d4Y8UpEyD2JyP32IsjSCh/Z/Xyoa5yZQWZOKrCHeHtp+Pa8fRJhCej3yrug/
	 aG+voSOPRjvWZWnkBrzCgsMg9ypHdWFksVZ3Vy9hqHMT3EbNSnq+khA+RJJPBZnbRvwVC
	 e/8GSR1kSH4ZUprE9C9n64AnONU1I8mjQqhaFiWxbxA9muwQLXzIV2WbFynliA3w0ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e3QnNNGy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78E6606A323;
	Wed, 25 Nov 2026 16:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e3QnNNGy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AAD1F000D0;
	Wed, 25 Nov 2026 16:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623865;
	bh=zsMRqezp+5FLLU2zLi2BDBKgqtdzOdsLtzuO5dAEssk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3QnNNGyza+lWUFauYv73uO7XUWIzpX932Em4+locqWDkmvb8hLW9PMmHDGSHhTzW
	 8Ikx7TfRakGnJNqh7tm4+SWwO5akrv6HVFQTmPaA2mN3jugW6jRoZ5VEyg0IT94qF8
	 fWxlLyT1L6Q57FE1rQfEJ90XHRdnQScvqDSORGRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 984/990] net: bridge: vlan: fix bugs caused by switchdev deletion errors
Date: Wed, 25 Nov 2026 15:39:11 +0100
Message-ID: <20261125143845.027958240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

commit 2842ce397dd09882530b42f7fdb0c855767eb24e upstream.

Allowing switchdev to prevent vlan deletion and error out in __vlan_del
could cause multiple different issues - inconsistent state, memory leaks
when flushing, NULL pointer dereference on bridge error when flushing.
It doesn't make sense to allow it to stop __vlan_del, so log the error
and continue with software vlan deletion. This is also consistent with
8021q behaviour.

Suggested-by: Ido Schimmel <idosch@nvidia.com>
Fixes: bf361ad38165 ("net: bridge: check __vlan_vid_del for error")
Fixes: 5454f5c28eca ("net: bridge: vlan: check for errors from __vlan_del in __vlan_flush")
Fixes: 2594e9064a57 ("bridge: vlan: add per-vlan struct and move to rhashtables")
Fixes: 9c86ce2c1ae3 ("net: bridge: Notify about bridge VLANs")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260914105258.3436918-1-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_vlan.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -387,12 +387,12 @@ out_filt:
 	goto out;
 }
 
-static int __vlan_del(struct net_bridge_vlan *v)
+static void __vlan_del(struct net_bridge_vlan *v)
 {
 	struct net_bridge_vlan *masterv = v;
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_port *p = NULL;
-	int err = 0;
+	int err;
 
 	if (br_vlan_is_master(v)) {
 		vg = br_vlan_group(v->br);
@@ -406,12 +406,16 @@ static int __vlan_del(struct net_bridge_
 	if (p) {
 		err = __vlan_vid_del(p->dev, p->br, v);
 		if (err)
-			goto out;
+			br_warn(p->br,
+				"port %u(%s) failed to delete vlan %u from switchdev: %pe\n",
+				(unsigned int)p->port_no, p->dev->name,
+				v->vid, ERR_PTR(err));
 	} else {
 		err = br_switchdev_port_vlan_del(v->br->dev, v->vid);
 		if (err && err != -EOPNOTSUPP)
-			goto out;
-		err = 0;
+			br_warn(v->br,
+				"failed to delete bridge vlan %u from switchdev: %pe\n",
+				v->vid, ERR_PTR(err));
 	}
 
 	if (br_vlan_should_use(v)) {
@@ -431,8 +435,6 @@ static int __vlan_del(struct net_bridge_
 	}
 
 	br_vlan_put_master(masterv);
-out:
-	return err;
 }
 
 static void __vlan_group_free(struct net_bridge_vlan_group *vg)
@@ -449,7 +451,6 @@ static void __vlan_flush(const struct ne
 {
 	struct net_bridge_vlan *vlan, *tmp;
 	u16 v_start = 0, v_end = 0;
-	int err;
 
 	__vlan_delete_pvid(vg, vg->pvid);
 	list_for_each_entry_safe(vlan, tmp, &vg->vlan_list, vlist) {
@@ -463,13 +464,7 @@ static void __vlan_flush(const struct ne
 		}
 		v_end = vlan->vid;
 
-		err = __vlan_del(vlan);
-		if (err) {
-			br_err(br,
-			       "port %u(%s) failed to delete vlan %d: %pe\n",
-			       (unsigned int) p->port_no, p->dev->name,
-			       vlan->vid, ERR_PTR(err));
-		}
+		__vlan_del(vlan);
 	}
 
 	/* notify about the last/whole vlan range */
@@ -837,8 +832,9 @@ int br_vlan_delete(struct net_bridge *br
 	br_fdb_delete_by_port(br, NULL, vid, 0);
 
 	vlan_tunnel_info_del(vg, v);
+	__vlan_del(v);
 
-	return __vlan_del(v);
+	return 0;
 }
 
 void br_vlan_flush(struct net_bridge *br)
@@ -1368,8 +1364,9 @@ int nbp_vlan_delete(struct net_bridge_po
 		return -ENOENT;
 	br_fdb_find_delete_local(port->br, port, port->dev->dev_addr, vid);
 	br_fdb_delete_by_port(port->br, port, vid, 0);
+	__vlan_del(v);
 
-	return __vlan_del(v);
+	return 0;
 }
 
 void nbp_vlan_flush(struct net_bridge_port *port)


