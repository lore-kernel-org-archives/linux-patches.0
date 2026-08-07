Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77BC474275;
	Fri,  7 Aug 2026 15:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117553; cv=none; b=GQ4k2OcHG7zIhgBPJ81Vi7nwjovcrbfv676hnjbCUd1LxDt9GRwKEXy8aixX61Cp+zY93y1cZRQr8npGICRyGay5FkCePak1Oqj7Iyrsc4uwg0pAemDUNs4fUAdmBidIEV7wTEHVOqWQ/luXYX3KS9xB7RRp8m1Ln1ue9AOurDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117553; c=relaxed/simple;
	bh=KuzDANlwG2UbUD5RZkagsz8uuC8ZNTuxlZcCPrO2kWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOp9vZeVE/knpRJEkVk0GO0appqLEBcwerD6wGpcnHuUew79gLwZHWoI0msNnZxssmQx69f52GET/cvPMgtOga1oFlkE9qf7oHcLfchNOHJnhvArYYdCQQ2j3tsyRrMr6+zya7HO5NJT3UCZa/phUHM/aM5Td8TvcPpaUtccMxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sb6AffQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sb6AffQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04791F000E9;
	Fri,  7 Aug 2026 15:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117552;
	bh=qprHiaJCcy65Jsya8FuInexu05rmf85ho7CreKnIsKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sb6AffQavJUvLv2aNTf0G/tJsUtBNX+EaBb9JdOM0mTeTYuJPmbZEOlwux3oYi4Rs
	 Bjrk4lNCc1sw4c9obkEQRx1wVCw0/qB811CeEoK+ao1yAXyZoT8Ok7sQNE1N7FAfzP
	 svgS/vnAlSOY4OMKHomyul8uUnIveRhyuDhIY1eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 352/438] net: openvswitch: fix skb leak on flow key update failure during ct
Date: Fri,  7 Aug 2026 16:39:08 +0200
Message-ID: <20260807143435.475388555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

commit bc62e843bc48f933da765ce47079fd992e535794 upstream.

ovs_ct_execute() always steals or frees the skb on failure while
ovs_flow_key_update() does not.  So, if it fails and we return right
away, the skb ends up leaked.

Fix that by breaking instead and letting the common error handling
code at the bottom of the loop to free the skb properly.

This is a very unlikely scenario as it requires the packet to become
unparseable by applying a set of actions on a previously parseable skb,
but should be fixed nevertheless.

Reported by Sashiko.

Fixes: ec0d043d05e6 ("openvswitch: Ensure flow is valid before executing ct")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260727181851.306076-3-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/actions.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1380,7 +1380,7 @@ static int do_execute_actions(struct dat
 			if (!is_flow_key_valid(key)) {
 				err = ovs_flow_key_update(skb, key);
 				if (err)
-					return err;
+					break;
 			}
 
 			err = ovs_ct_execute(ovs_dp_get_net(dp), skb, key,


