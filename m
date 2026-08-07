Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2203AEF21;
	Fri,  7 Aug 2026 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115544; cv=none; b=goNoiEzKcNssAWfTQd2B5NY6Sw3KKNOFUeVqN8jOjHDpwbhQmwCFVT+6i0diDV8gfcO3y/JvmwruF9utB3PxqAKR1qoW+9kSCBttRiM5ZqgSTUmbnAyRRebIfgsNVZ9pH0qtsvDlhqOVNxTqa1VDJ/rODs2AUQRNn5gA9cLSVEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115544; c=relaxed/simple;
	bh=sVQZ855hPSdZgUStEDU6pSUqoDKcxnEtmvq0EgG75Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a14uA6kDcYyitiJCDTBdf1D0JVT+HxdzDLJMMc4DIifaB41IWap1RDdlMTUO6/NywAHqgJ9dMzCMeGfQMnFircbfl+chro5hTKlvMXWZmcWGb6TsYaE13OBaYwO2FxyrY7f+4E5XIsVaFvSUFQfv6Yzr5QQZd8kkqxX83S3rZwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDjg7ZU0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDjg7ZU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DECF1F000E9;
	Fri,  7 Aug 2026 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115537;
	bh=uukuSoyCcZ39M16B+bLcd0CrrXdubp22lx5Biv400YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PDjg7ZU0G8PmpsuN5EWfKQlrqHSPUQTqK1cLX2Vsg+0qJHN/tG8Bpr3g5rl2luWo6
	 QzF9O5uqLJnikCL8TEZ83mX7o2y62dUiwsXr7V1Mk3a3SAb4i7wzwSYRRmo1Mg7Uny
	 J7ToP9Ug1ejUNvvtVAAPZozKH35/AFRQOy7ricB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 284/396] net: openvswitch: fix skb leak on flow key update failure during ct
Date: Fri,  7 Aug 2026 16:37:24 +0200
Message-ID: <20260807143430.393590417@linuxfoundation.org>
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
@@ -1379,7 +1379,7 @@ static int do_execute_actions(struct dat
 			if (!is_flow_key_valid(key)) {
 				err = ovs_flow_key_update(skb, key);
 				if (err)
-					return err;
+					break;
 			}
 
 			err = ovs_ct_execute(ovs_dp_get_net(dp), skb, key,


