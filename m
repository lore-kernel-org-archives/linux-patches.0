Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0E43B4B5;
	Mon, 17 Aug 2026 14:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977481; cv=none; b=rQcBNIkbgBGGmuK3+6dNdaYIKQARBARJNFyhTDbadpY34VmW+YKszlR4BCDhUFuSvyoG3F/KPIkKLXITnaZ0rk2vEy4PmWjKaVzDTsw/GMC6qKc862Bnew60mCCwkd+qQuH1uDYsiZz1+MW+XG2AhvnSaTUbFA9g3G9CmFL2NZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977481; c=relaxed/simple;
	bh=jopfARZD342U90fvyD3a4x5qjrHn3+IzGma0unDHCVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilV/vJQUJVZPLw3Gg75d6R1AhKCGNn4d5hOoX9sgj9oNPA56a55o4+ebwqSIXTu7E7El/OZjT2MkxIjKg4LFqRbozwW2BdpbDm7PPmrEqOxK2+mS61FJoizLva+8fOrPs8u4GV2Vwe25iKyMvoVSPktL4D2e8yKuKEKXpk45POk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X75LR2RL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X75LR2RL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4A41F000E9;
	Mon, 17 Aug 2026 14:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977480;
	bh=L7T4ZYLTB6AbMWD+LEUFc5xhIIUtpHF7xrkAGiF1OHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X75LR2RL7dqAGQwixBUj5xycoFe8aLkoBJnNliHRE01Roekrj7Z6p5zUD9j2psBFm
	 TeYsXdbxZcVZHnKF2qR+R35qcQBghwYbrhpqY4rJbErMCCOxFPPGRFaDx4aFx+ADnn
	 GSrYQFwodA51axiyQrDdiJ8vnQDFm0Ql2pQySqNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 343/456] net: openvswitch: fix skb leak on flow key update failure during ct
Date: Mon, 17 Aug 2026 15:32:13 +0200
Message-ID: <20260817132552.995145250@linuxfoundation.org>
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
@@ -1326,7 +1326,7 @@ static int do_execute_actions(struct dat
 			if (!is_flow_key_valid(key)) {
 				err = ovs_flow_key_update(skb, key);
 				if (err)
-					return err;
+					break;
 			}
 
 			err = ovs_ct_execute(ovs_dp_get_net(dp), skb, key,


