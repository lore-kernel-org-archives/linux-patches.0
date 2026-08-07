Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D158E306744;
	Fri,  7 Aug 2026 15:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115475; cv=none; b=R7r8Hr/UlJnifDi7Iu1fUJXLMO7Gp7OT1WSyU930v7zgrUdUWjRiIWD/1AB7kiHQsOyLl5k0sOSna2Gjm0xVUKDdmN/E5AS4/ACzMNBvjKwDqU0JV+WmvdlIazCowABxqGoOK1tplnHnwjJQe3Gf0CwSWwNRw7JsTeOHAWyyx74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115475; c=relaxed/simple;
	bh=GaIxLoX+NVV4pWg4UhZr3UlLNFdD7u1aQTmIG/caoLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrEsbb8VBvMaEp+NV9QGEPUIoZ6LSNOgkUKjckOm9mtV0ipVLjVr5KNRwDP6WuTDdBG8HWHFh4xR00OwjY8hkS+SKq/ZMraJb62OrChBlQDxroSujOwAh0HxKSspphvCANs2CmvC0ipcjEb0eSFMtmp8fWmsuZLAC6nnQlTfIZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y692x4Wk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y692x4Wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339F21F00A3A;
	Fri,  7 Aug 2026 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115473;
	bh=4pzFzsOyRXapHs1kIEmWTcJP3SmO6+P40P5Z/HML72E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y692x4Wkn7Szex/wxayp51jvS+4lkJ0Mf0v0xdcKj71ctpS4GUxcg59fUS3QoPTob
	 CoKlOMpaEx0IRV+Woq7nY/AQvu0CAMu7QtHhSsWoXxLr9Su6GqAp/SvWASnt88abk1
	 kAGvY0a5gol9/Sk5ZXI3u0I2+2Vm20CenbhWBocA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Eelco Chaudron <echaudro@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 282/396] net: openvswitch: fix potential UAF on meter attach failure
Date: Fri,  7 Aug 2026 16:37:22 +0200
Message-ID: <20260807143430.348629457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -133,18 +133,10 @@ static void dp_meter_instance_remove(str
 
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
@@ -152,16 +144,29 @@ static int attach_meter(struct dp_meter_
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


