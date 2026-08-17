Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378142E738B;
	Mon, 17 Aug 2026 14:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977533; cv=none; b=BTcKPXeC6xpBe6UstwPHGBzENo+d0iiqSrzWi70wodRBPFDCgi63s9yircO8pkYSqmQ92OQXShnnDmSfcDHtu37z4VuIgCnokKB3uz8pQ28TvsXzYWM7zm8iIRaR8oNFgSAE9Gqyi+MhGylEtPqRNoe3Zj7MUzWjVXa8AcRevwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977533; c=relaxed/simple;
	bh=8Bl/hqbeSk0yrcB8DUC+KZd2MWxRN/txtSDWDwFBlRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYqsmbGRxFATi9p4XILMyj2LCTo56xZyTsPbEwHh6++o0JRaFx8ub915Tj3a1fk7z1aaieZ+rRR9vZpKe5FlnQZ30gv1j0Rz30zs1lnL8Um0UYn4yBxg5RF7dSGMB3DwyBWcwTW+oxtmywKzGo6i4psMtOAoped32fk2sphFRJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVwopCsf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVwopCsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7E31F000E9;
	Mon, 17 Aug 2026 14:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977532;
	bh=NKZz9oZBkTP4e2vKPkamqPoimtI7A5SBdL/+s7l7DJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVwopCsfbNV0oxCe3GL/cCQCbGBvtOoChAmbxaN76ObuH3yYg77ikiN7c4O77YzG/
	 8TaEkIWP1JHrEY8Q4YTi3PIxaRJfdhJazyHPJ3n1DauYVMeIMgAoA83AcIsZpjz2z/
	 JLoPdi4A+rcqpOPY9FvN4EZGd953DLo6/R5C7T4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 363/456] net: openvswitch: fix skb leak on flow key update failure during recirculation
Date: Mon, 17 Aug 2026 15:32:33 +0200
Message-ID: <20260817132553.704514698@linuxfoundation.org>
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

[ Upstream commit e1cf066244dad576221b7123a0e5005967f25a20 ]

do_execute_actions() returns right away when execute_recirc() fails on
the last action as it assumes this function always takes ownership of
the skb when 'last' is true.  But when the flow key update fails, the
function doesn't free the skb and it ends up leaked.

This is a very unlikely scenario as it requires the packet to become
unparseable by applying a set of actions on a previously parseable skb,
but should be fixed nevertheless.

Reported by Sashiko.

Fixes: 971427f353f3 ("openvswitch: Add recirc and hash action.")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260727181851.306076-2-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[OVS drop reasons are not available in 5.15, hence plain kfree_skb()]
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 3a69ed9d21926..6fd22d3632ba3 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1107,6 +1107,10 @@ static int execute_masked_set_action(struct sk_buff *skb,
 	return err;
 }
 
+/* When 'last' is true, recirc() should always consume the 'skb'.
+ * Otherwise, recirc() should keep 'skb' intact regardless what
+ * actions are executed on recirculation.
+ */
 static int execute_recirc(struct datapath *dp, struct sk_buff *skb,
 			  struct sw_flow_key *key,
 			  const struct nlattr *a, bool last)
@@ -1117,8 +1121,11 @@ static int execute_recirc(struct datapath *dp, struct sk_buff *skb,
 		int err;
 
 		err = ovs_flow_key_update(skb, key);
-		if (err)
+		if (err) {
+			if (last)
+				kfree_skb(skb);
 			return err;
+		}
 	}
 	BUG_ON(!is_flow_key_valid(key));
 
-- 
2.53.0



