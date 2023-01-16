Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F6E46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80982C433EF;
	Mon, 16 Jan 2023 16:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885332;
	bh=xy6xPy29pR/HUIfcwqaFCncCoH5kH0/U1YfaNtuhAFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTvMFZtCCm9pbJ69zgwQH5wo+/lPSoRSGbnYwlT627jL+zLSebydGx8EfbMn7OaO0
	 zmoZ4Dj6sQoSmVKn7CEBvfoNI+vQkcOTrTWy1j3FZZLzVJhdQb1EJOe27MGj/nMUU2
	 687vjU2u+aeAXcDVNiAflkprKdJ03QkofVJPTn3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <ptyadav@amazon.de>
Subject: [PATCH 5.4 012/658] xen-netback: move removal of "hotplug-status" to the right place
Date: Mon, 16 Jan 2023 16:41:40 +0100
Message-Id: <20230116154910.207440043@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pratyush Yadav <ptyadav@amazon.de>

The removal of "hotplug-status" has moved around a bit. First it was
moved from netback_remove() to hotplug_status_changed() in upstream
commit 1f2565780e9b ("xen-netback: remove 'hotplug-status' once it has
served its purpose"). Then the change was reverted in upstream commit
0f4558ae9187 ("Revert "xen-netback: remove 'hotplug-status' once it has
served its purpose""), but it moved the removal to backend_disconnect().
Then the upstream commit c55f34b6aec2 ("xen-netback: only remove
'hotplug-status' when the vif is actually destroyed") moved it finally
back to netback_remove(). The thing to note being it is removed
unconditionally this time around.

The story on v5.4.y adds to this confusion. Commit 60e4e3198ce8 ("Revert
"xen-netback: remove 'hotplug-status' once it has served its purpose"")
is backported to v5.4.y but the original commit that it tries to revert
was never present on 5.4. So the backport incorrectly ends up just
adding another xenbus_rm() of "hotplug-status" in backend_disconnect().

Now in v5.4.y it is removed in both backend_disconnect() and
netback_remove(). But it should only be removed in netback_remove(), as
the upstream version does.

Removing "hotplug-status" in backend_disconnect() causes problems when
the frontend unilaterally disconnects, as explained in
c55f34b6aec2 ("xen-netback: only remove 'hotplug-status' when the vif is
actually destroyed").

Remove "hotplug-status" in the same place as it is done on the upstream
version to ensure unilateral re-connection of frontend continues to
work.

Fixes: 60e4e3198ce8 ("Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/xenbus.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -202,10 +202,10 @@ static int netback_remove(struct xenbus_
 	set_backend_state(be, XenbusStateClosed);
 
 	unregister_hotplug_status_watch(be);
+	xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
 	if (be->vif) {
 		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
 		xen_unregister_watchers(be->vif);
-		xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
 		xenvif_free(be->vif);
 		be->vif = NULL;
 	}
@@ -435,7 +435,6 @@ static void backend_disconnect(struct ba
 		unsigned int queue_index;
 
 		xen_unregister_watchers(vif);
-		xenbus_rm(XBT_NIL, be->dev->nodename, "hotplug-status");
 #ifdef CONFIG_DEBUG_FS
 		xenvif_debugfs_delif(vif);
 #endif /* CONFIG_DEBUG_FS */


