Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34AA3E5A15;
	Tue, 12 May 2026 17:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608039; cv=none; b=Bq5ZrGLcEqvKkQUA6BPEtTEbqzTfnq8mfzmAY+SekJ7rOARRr5RWuEKEOLRcRbJJ6emLsPL1hvZlAQCYXQTDEbi/RjPB7DP0F8HjNSFTDey6uTqnBQcJghFXpMT64N6zKm1efMcawNjJZATxkNcWIBwgDatgklaz9Nj8wYJMn5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608039; c=relaxed/simple;
	bh=bTeIaNs9NJ+3hAT8JkX7b/UvMPLDZI5jEBnZgLfdEaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ef7lL9uZFlR3W4R3Wriivo5lq+MHu2xaA1H9xjIH6RXc8TUQCRchZ5C1O7ZpNOuIyiD9NlNQeRPzD8hjUSn+21CfSNAYXhs0Zq+LXZvYJ1yLhduYYnUyuPIgm16KiI0wdC2GVr4mSlSfpfmzsiyAY1nEU1UUrE9ZKBwqVfe+zMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AvkkWvI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AvkkWvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B8FC2BCB0;
	Tue, 12 May 2026 17:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608039;
	bh=bTeIaNs9NJ+3hAT8JkX7b/UvMPLDZI5jEBnZgLfdEaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0AvkkWvIPWqwmy6dJLFKbFvBj51+EOytyL2veEwHqawv4hKTNtofAP1GurrApAPUf
	 xezH9//49esva9Em+w+o19uZzYYD+7oxifrq4lZAetYdSB0XDLkiC7ScOyshHXbuR5
	 EoVXZyLbGMtH2UjxEBRQh69wWvS9mIBlCyJSNdmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 132/206] openvswitch: vport: fix self-deadlock on release of tunnel ports
Date: Tue, 12 May 2026 19:39:44 +0200
Message-ID: <20260512173935.653004520@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -196,9 +196,13 @@ void ovs_netdev_tunnel_destroy(struct vp
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
 


