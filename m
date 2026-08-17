Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CC443B4B5;
	Mon, 17 Aug 2026 14:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977479; cv=none; b=uQgBgRylfgz90xro46kC1oTSJVJc3nspZ/yULvj90mh7oWL5ExM2IAdyGwWujzyVBpzgp32tyr4ZYfcmbfTf6mvMa8mC4zDObeyFLEzIYczigKJXK1fISkQxhd3XULWo/KyQ96ywH96s62WH1XIU7LrNujWcJmui1uP8SWW7AE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977479; c=relaxed/simple;
	bh=tOgY1fTDLbw4abRDYnC7dwc5gmOitynqS0iQkwg5zXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+soHjyBCTxNsKLbmSTEY7Az7//8Q+InvX51H00/DmnjA869/VsOltCUY3KSgKCXVRwA8E05MhFYTYe0v3WvMYyntP9p1mgVWGWBfD3cMojsx27DwLnZyZjKrTIRKpPK3VeS+s+6g7IZp1urFWKgNWK3qX6o9mswEk9FinsJEZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aIfeYuM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aIfeYuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5751F000E9;
	Mon, 17 Aug 2026 14:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977477;
	bh=3wlM/xQUeyLlSAVgjOuj5TtzyDk4fGPDP/XqsYp/AMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2aIfeYuMDvz3/DTtdd6q1pIN8HZv9nV98UoOIb7P/p8IsX07yhOTkwwDRS/ksXDyh
	 idyDnISiPkpPdirnAdn7QrdBnbmAru+uSDm3E1y/yhRUfgKy12sk+Z8M9llDWhUqhF
	 fIpTjzVh4w/aL6FzS4uj896I2uTccZ+gCKm92Bc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Eelco Chaudron <echaudro@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 342/456] net: openvswitch: fix potential UAF on meter attach failure
Date: Mon, 17 Aug 2026 15:32:12 +0200
Message-ID: <20260817132552.963057289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Ilya Maximets <i.maximets@ovn.org>

commit a58a2b0ce354df531ebc71fc870058c2feb59f6b upstream.

While attaching a newly created meter attach_meter() function makes
the new meter visible to other CPUs but can still fail afterwards.
On failure, it detaches the meter back and returns an error.

However, this is an unexpected behavior for the ovs_meter_cmd_set()
that uses a plain kfree(meter) on attach failure without waiting for
RCU readers to stop using it, assuming it was never visible.

This is never a problem for ovs-vswitchd as it always creates meters
before creating any flows that use them.  But the UAF can be triggered
with a custom application using uAPI:

 BUG: KASAN: slab-use-after-free in ovs_meter_execute (net/openvswitch/meter.c:653)
 Read of size 8 at addr ffff88810d152650 by task meter/2508

 Call Trace:
  ovs_meter_execute (net/openvswitch/meter.c:653)
  do_execute_actions (net/openvswitch/actions.c:1407)
  ovs_execute_actions (net/openvswitch/actions.c:1584)
  ovs_packet_cmd_execute (net/openvswitch/datapath.c:703)
  ...
  netlink_sendmsg (af_netlink.c:1900)

 Allocated by task 2519:
  __kasan_kmalloc (mm/kasan/common.c:398 mm/kasan/common.c:415)
  ovs_meter_cmd_set (net/openvswitch/meter.c:422)
  ...
  netlink_sendmsg (af_netlink.c:1900)

 Freed by task 2519:
  kfree (mm/slub.c:2705 mm/slub.c:6405 mm/slub.c:6720)
  ovs_meter_cmd_set (net/openvswitch/meter.c:479)
  ...
  netlink_sendmsg (af_netlink.c:1900)

Fix that by making sure attach_meter() doesn't make the meter visible
until all the checks are done and the function can't fail anymore.

This also makes sure the "hash" value is calculated after the potential
re-sizing of the table.

Reported by Trend Micro's Zero Day Initiative as ZDI-CAN-31642.

Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported number")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://patch.msgid.link/20260727121022.198461-1-i.maximets@ovn.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/meter.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -136,18 +136,10 @@ static void dp_meter_instance_remove(str
 
 static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
 {
-	struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
-	u32 hash = meter_hash(ti, meter->id);
+	struct dp_meter_instance *ti;
+	u32 hash;
 	int err;
 
-	/* In generally, slots selected should be empty, because
-	 * OvS uses id-pool to fetch a available id.
-	 */
-	if (unlikely(rcu_dereference_ovsl(ti->dp_meters[hash])))
-		return -EBUSY;
-
-	dp_meter_instance_insert(ti, meter);
-
 	/* That function is thread-safe. */
 	tbl->count++;
 	if (tbl->count >= tbl->max_meters_allowed) {
@@ -155,16 +147,29 @@ static int attach_meter(struct dp_meter_
 		goto attach_err;
 	}
 
-	if (tbl->count >= ti->n_meters &&
-	    dp_meter_instance_realloc(tbl, ti->n_meters * 2)) {
-		err = -ENOMEM;
+	ti = rcu_dereference_ovsl(tbl->ti);
+	if (tbl->count >= ti->n_meters) {
+		err = dp_meter_instance_realloc(tbl, ti->n_meters * 2);
+		if (err)
+			goto attach_err;
+
+		ti = rcu_dereference_ovsl(tbl->ti);
+	}
+
+	hash = meter_hash(ti, meter->id);
+
+	/* In general, selected slots should be empty, because
+	 * OvS uses id-pool to fetch available ids.
+	 */
+	if (unlikely(rcu_dereference_ovsl(ti->dp_meters[hash]))) {
+		err = -EBUSY;
 		goto attach_err;
 	}
 
+	dp_meter_instance_insert(ti, meter);
 	return 0;
 
 attach_err:
-	dp_meter_instance_remove(ti, meter);
 	tbl->count--;
 	return err;
 }


