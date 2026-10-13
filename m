Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E734F7CB2;
	Tue, 13 Oct 2026 12:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893667; cv=none; b=AN0FZMaFKEFyy7pNZEa5GAY9fadp6SqyaQ/EbMMQVCgs1lTTdef8o31VGm5+K6x7oHdJpltF2cqAk7E1nhCnJN7FQuKbEgRNxaTsuKCCAwAg2NHRXmJXmbp5QUPygHNjrrKZ1i0yo6/v1lrYPWDdghe3qRWvaExSFbyrgLtQxwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893667; c=relaxed/simple;
	bh=mcHiKgSjmP5B2tfeRWVCi640ibxYXYGzp30VANnSADk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ububRvX8WWVpKyZE9tC6T1dEUPapLkNy83Fyuj4hghXoquVorHBkhKsUar6UzSzIosDT2Qr0xfq5WUMWUfmupVoffVV7KYrhv1iFl0cMXcLetjBlffmP+HeuW4UOvEQexRQYuqlZru9rIoJc3aLluTS6XEpeI3HBoayzsikeaQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeqAVCwo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeqAVCwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6931F00898;
	Tue, 13 Oct 2026 12:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893666;
	bh=zuWyHLg/wkLe7xk6e4V8WyKDKTwPOsrnbCuCYzCZZVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VeqAVCwowKbShNqos8drVye3MnqMX7IWr296svvswtYKLqDZgdbQB+t53VdIsNh3D
	 O58X5qS2Qe0IDlFV3W4Vj/D+myMRgtY8ZoHwTL7MTd5ZWAzf18vqnWl2E9TuVKALUI
	 dgN2hqfnn6Y6nhlNSkVMturXrDb76PWQQDRYj0B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 248/621] net: hsr: defer node table free until after RCU readers
Date: Tue, 13 Oct 2026 13:34:03 +0200
Message-ID: <20261013112926.747434075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit aaec7096f9961eb223b5b149abe9495525c205d9 ]

HSR node-list and node-status generic-netlink operations run under
rcu_read_lock(). They walk hsr->node_db through hsr_get_next_node() and
hsr_get_node_data(), but RTM_DELLINK teardown removes the same node table
with plain list_del() and frees each node immediately.

That lets a generic-netlink reader hold a struct hsr_node pointer across
hsr_dellink(). In a KASAN build, widening the reader window after
hsr_get_next_node() obtains the node reproduces a slab-use-after-free
when the reader copies node->macaddress_A; the freeing stack is
hsr_del_nodes() from hsr_dellink().

Use list_del_rcu() and defer the free through the existing
hsr_free_node_rcu() callback. This matches the lifetime rule used by the
HSR prune paths, which already delete nodes with list_del_rcu() and
call_rcu().

Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260513233838.3064715-2-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_framereg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index bd2fbbc4420b2..f366429aff88b 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -129,8 +129,10 @@ void hsr_del_nodes(struct list_head *node_db)
 	struct hsr_node *node;
 	struct hsr_node *tmp;
 
-	list_for_each_entry_safe(node, tmp, node_db, mac_list)
-		kfree(node);
+	list_for_each_entry_safe(node, tmp, node_db, mac_list) {
+		list_del_rcu(&node->mac_list);
+		kfree_rcu(node, rcu_head);
+	}
 }
 
 void prp_handle_san_frame(bool san, enum hsr_port_type port,
-- 
2.53.0



