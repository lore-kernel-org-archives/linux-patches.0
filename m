Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEE63A5436;
	Fri,  7 Aug 2026 15:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116352; cv=none; b=vF2W2emPLPQZTQYIN+L1LgakgISOjac8sX3ET5VbDDbiQE3MPV4puOqrGFSMYPFxIUf7K4fVpU5mKiLftoJzN9od+i2fQbCdiekHb4ebu9cl5KgxMkbJBzGWBd+c6c0Cs31HZ9V44PeEZ6CEOGXgeWmgqf/y3HkbnC5dIVeMst4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116352; c=relaxed/simple;
	bh=N3oQ+/dUVzY7WuQkrVqt5egqTikOCc5onmaIbapA8l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4MKSDb8BjbYAHCmWRvubD2hYZEu0KyaxLEw04n+dr6NeC+r6WO3qmONBKvpbrf0oK7MEe91vU1tfW46egC4vKy7xYD1jNVk5bJYE/hKhI7vs3jfe1BMiSGqb8/2IVjQ7zeEUvXdOzOCGUNkZZ9EIK2gg2sLiBfXb3rzIM79v8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFQbKpjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFQbKpjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FF81F00A3A;
	Fri,  7 Aug 2026 15:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116350;
	bh=3tMBjL/CV4FQ0hV5WNMit91/oRXOeLNL63sWTxGY/tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFQbKpjWx1wbef7Xt+7nwHxO2o0Dk/HXhFTZOSFoZWb4kdqb0fDQ0X7AzXWIUcIh4
	 PPfyp36EP7gkZMZ121JyBuqqErxtBqAu+LocMRCMkvo7TedA9wgBug6k6oKpQUdtNZ
	 QsRu0zf1xMJSGlq1y91epgl5DrJXVlH60O95wJjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 164/261] net: openvswitch: fix skb leak on flow key update failure during ct
Date: Fri,  7 Aug 2026 16:38:41 +0200
Message-ID: <20260807143418.902006745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
@@ -1354,7 +1354,7 @@ static int do_execute_actions(struct dat
 			if (!is_flow_key_valid(key)) {
 				err = ovs_flow_key_update(skb, key);
 				if (err)
-					return err;
+					break;
 			}
 
 			err = ovs_ct_execute(ovs_dp_get_net(dp), skb, key,


