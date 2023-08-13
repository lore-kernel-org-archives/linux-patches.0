Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1ED9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6672C433C8;
	Sun, 13 Aug 2023 21:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962719;
	bh=ZDLjwiJlEnLYq1lcOf4AVnwMrnT0jR3Hno1KI8zbff8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtSk4iv34pbuBdqgFoxKFP8TzbXZYeru+ItdUxFDmRotRf56mEaQOV5Qz2RGbsN3Y
	 iXL3LTTFRLyFvcFJUHZzVP+MTTe3JdG5GwoiNOkJsj6GZQe80JOG2K6WWyAobDRSHJ
	 2LOyOm1nFFM4TbdGz2GhfUL4tFxlNN732xZ1oKjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@idosch.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 097/149] drivers: vxlan: vnifilter: free percpu vni stats on error path
Date: Sun, 13 Aug 2023 23:19:02 +0200
Message-ID: <20230813211721.689944942@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit b1c936e9af5dd08636d568736fc6075ed9d1d529 upstream.

In case rhashtable_lookup_insert_fast() fails inside vxlan_vni_add(), the
allocated percpu vni stats are not freed on the error path.

Introduce vxlan_vni_free() which would work as a nice wrapper to free
vxlan_vni_node resources properly.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 4095e0e1328a ("drivers: vxlan: vnifilter: per vni stats")
Suggested-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_vnifilter.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -713,6 +713,12 @@ static struct vxlan_vni_node *vxlan_vni_
 	return vninode;
 }
 
+static void vxlan_vni_free(struct vxlan_vni_node *vninode)
+{
+	free_percpu(vninode->stats);
+	kfree(vninode);
+}
+
 static int vxlan_vni_add(struct vxlan_dev *vxlan,
 			 struct vxlan_vni_group *vg,
 			 u32 vni, union vxlan_addr *group,
@@ -740,7 +746,7 @@ static int vxlan_vni_add(struct vxlan_de
 					    &vninode->vnode,
 					    vxlan_vni_rht_params);
 	if (err) {
-		kfree(vninode);
+		vxlan_vni_free(vninode);
 		return err;
 	}
 
@@ -763,8 +769,7 @@ static void vxlan_vni_node_rcu_free(stru
 	struct vxlan_vni_node *v;
 
 	v = container_of(rcu, struct vxlan_vni_node, rcu);
-	free_percpu(v->stats);
-	kfree(v);
+	vxlan_vni_free(v);
 }
 
 static int vxlan_vni_del(struct vxlan_dev *vxlan,


