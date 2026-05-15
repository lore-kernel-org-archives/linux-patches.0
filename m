Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06713B9D84;
	Fri, 15 May 2026 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861275; cv=none; b=Ry2jQJp8LxCAz0eJBFaw/04Sf7V8vjNtu5D0zdbCv4/v1e2Muotxu8/S6EHYdripAikFa5p0mqVqMn52+1joMZo3r3QPS5CyqM43GM0X48NnD20r/o7f8D5tYl+PMTb3JchGxUEwl0QvQE3CRrOvKq58tPVlKsGkqZdg9pbzg+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861275; c=relaxed/simple;
	bh=iAyDTbXNICyVj2NpQ45FzgprqeRGZH2nO9xMXUT1qYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gz5dHRDpZMevhkWVP4DtMUMqwJBJJrBN20dN0/WaWfpSmp/wcuyRnOg7IR/Cs9IkFamxJ4BoK2avdtKiorqTPJjZfK1imhgTUmWTQrmh/u0x54lqYbrPquSTs8DSO4zeVPf4YA5Wac6bRljhOcPgg4vLlKJAuOk5ysmxpo5U40s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hde4RdhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hde4RdhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66089C2BCB0;
	Fri, 15 May 2026 16:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861275;
	bh=iAyDTbXNICyVj2NpQ45FzgprqeRGZH2nO9xMXUT1qYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hde4RdhJnVR5MAR3wuYDqcZVmlunoStUHPVMbha7Ywk8iyJEDJWPQR4pigJYTCjOt
	 oNXNJ6dYMyW3UjyXBa7VXAHTdkoGS9fO8Q0hRPaTf6/MSfctB4ROAV1jrNdrmcxcBH
	 n2hj1qtrCrWCLpie1SfJHrfCmL8rDvZBIlgjAj4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 266/474] openvswitch: vport: fix self-deadlock on release of tunnel ports
Date: Fri, 15 May 2026 17:46:15 +0200
Message-ID: <20260515154720.757314941@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

commit aa69918bd418e700309fdd08509dba324fb24296 upstream.

vports are used concurrently and protected by RCU, so netdev_put()
must happen after the RCU grace period.  So, either in an RCU call or
after the synchronize_net().  The rtnl_delete_link() must happen under
RTNL and so can't be executed in RCU context.  Calling synchronize_net()
while holding RTNL is not a good idea for performance and system
stability under load in general, so calling netdev_put() in RCU call
is the right solution here.

However,
when the device is deleted, rtnl_unlock() will call netdev_run_todo()
and block until all the references are gone.  In the current code this
means that we never reach the call_rcu() and the vport is never freed
and the reference is never released, causing a self-deadlock on device
removal.

Fix that by moving the rcu_call() before the rtnl_unlock(), so the
scheduled RCU callback will be executed when synchronize_net() is
called from the rtnl_unlock()->netdev_run_todo() while the RTNL itself
is already released.

Fixes: 6931d21f87bc ("openvswitch: defer tunnel netdev_put to RCU release")
Cc: stable@vger.kernel.org
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260430233848.440994-2-i.maximets@ovn.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/vport-netdev.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -189,9 +189,13 @@ void ovs_netdev_tunnel_destroy(struct vp
 	 */
 	if (vport->dev->reg_state == NETREG_REGISTERED)
 		rtnl_delete_link(vport->dev, 0, NULL);
-	rtnl_unlock();
 
+	/* We can't put the device reference yet, since it can still be in
+	 * use, but rtnl_unlock()->netdev_run_todo() will block until all
+	 * the references are released, so the RCU call must be before it.
+	 */
 	call_rcu(&vport->rcu, vport_netdev_free);
+	rtnl_unlock();
 }
 EXPORT_SYMBOL_GPL(ovs_netdev_tunnel_destroy);
 


