Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7044418D7;
	Tue, 16 Jun 2026 15:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623302; cv=none; b=gbw7wD3VXVqMQublUkhHUHw0csDZLPii02lVjS0GVGeK9KzQLCcDBPeHSEKrTwaX0oUhE5LlYMuZYfo+PdPtAb+2Z7tJI5+Q76u0ehOJYHIkrmPkXrdsjI/vHwkV3ONJfNoBWviVqxx0hdSxKr2hBPkUNsZYHikgX9RShF83CXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623302; c=relaxed/simple;
	bh=hf/MacHu356K8TPA8DtgpxIjxbvZhddtMykq8WizSTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6oB0rsbZJ/ITW4eBpuYAxEx7reK4UI+uiWcAsdwO2bOqWZjz31ZmKwjlWg89VdREh7nD2ikwsRK8/VUdw7IJvntsYEfE57SyeRtI5eZdLjfgVstOpVfdtp8rx+1/8Gg3Dw56VCZsa1Cn25xK0UbzBZh6gJD83TX43eaQpGN3TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaxtXC09; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaxtXC09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D79E1F00A3A;
	Tue, 16 Jun 2026 15:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623301;
	bh=2Pe7o7w69c9rgl5uWxD6HzpTgvnSCxkR8F+YHxKpA0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eaxtXC09r60BcxxxExM/UPxPVNbTl+FS22NoKPFB0Diz/2yfwCq9s1+z6gTUdS/DH
	 5OtBJUfhxqIyoogYuRakXpLf5csn/wk/Rm1L5f+J28Oh/jjhURTazGY6/n5uJNQ/35
	 cQulbDFL+Ve8gpWYvbpRJXwIi2rtZfIqOVPhBifo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Moreno <amorenoz@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 123/378] net: openvswitch: fix possible kfree_skb of ERR_PTR
Date: Tue, 16 Jun 2026 20:25:54 +0530
Message-ID: <20260616145116.820999093@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Moreno <amorenoz@redhat.com>

[ Upstream commit ee30dd2909d8b98619f4341c70ec8dc8e155ab02 ]

After the patch in the "Fixes" tag, the allocation of the "reply" skb
can happen either before or after locking the ovs_mutex.

However, error cleanups still follow the classical reversed order,
assuming "reply" is allocated before locking: it is freed after unlocking.

If "reply" allocation happens after locking the mutex and it fails,
"reply" is left with an ERR_PTR, and execution jumps to the correspondent
cleanup stage which will try to free an invalid pointer.

Fix this by setting the pointer to NULL after having saved its error
value.

Fixes: 893f139b9a6c ("openvswitch: Minimize ovs_flow_cmd_new|set critical sections.")
Signed-off-by: Adrian Moreno <amorenoz@redhat.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://patch.msgid.link/20260604121946.942164-1-amorenoz@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index bbbde50fc6498f..f0164817d9b723 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1316,6 +1316,7 @@ static int ovs_flow_cmd_set(struct sk_buff *skb, struct genl_info *info)
 
 		if (IS_ERR(reply)) {
 			error = PTR_ERR(reply);
+			reply = NULL;
 			goto err_unlock_ovs;
 		}
 	}
-- 
2.53.0



