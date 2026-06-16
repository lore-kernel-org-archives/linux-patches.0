Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4805D33688F;
	Tue, 16 Jun 2026 16:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626719; cv=none; b=c4cRgN9YDqkMQeHmeu0DzR2jXaRbC0WEHsbEwpQfeNtWIpQpwO03cyVAX9zCy2qgbZrxfSM/QeFzhLUns79ewvbVtZ1K/DOhXsHKu9WU5ggfP4qjpd89bVshdswcXt28Q6dM7mNx24ZZ3grCzHVWNoayvd550zISZsApeFTkrlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626719; c=relaxed/simple;
	bh=znUaCpMAM7CbNasmp5Mti1DkaLG55FOQqt0Pb4GvM9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESrp7ezz8V4RNDC5vKyQkRuXvS9A8J5G1WkUyyIz9+cSajZMbeDesAnKODstQ7eEavr122QRAKIZRo1WmNnQoLlOMnVI2LH8tQCrbBiXdI59KOkZJiXoaTsFgiWk29GAG78V7stjsB73HK5Tm09sskRkhqZbei3RGP0KPh6wsFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6n8o9KR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6n8o9KR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4661F000E9;
	Tue, 16 Jun 2026 16:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626717;
	bh=B9BqPEx8NH0a/DPf3dhdVah1FeMMg1hcUdBGk63rD4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6n8o9KRZMQtkH0UZAPMjoN2/IzKYV+6seEUCYRJUEcfSNTcj8pRN6zz3GGPuwtzG
	 ArTn2rXAkMyNko7mNJAI1Hq9FNCLl+bJLcuTxntSHUt4qakZRuOuTQyqMz/ce1d8Iz
	 bdD5BBqHL/8tY1lw/cBMtcj2+mRcEgGyHh78O+PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chirag Shah <chirag@nvidia.com>,
	Andy Roulin <aroulin@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/261] vxlan: vnifilter: send notification on VNI add
Date: Tue, 16 Jun 2026 20:28:13 +0530
Message-ID: <20260616145047.693068032@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Andy Roulin <aroulin@nvidia.com>

[ Upstream commit aa6ca1c5c338907817374b59f7551fd855a88754 ]

When a new VNI is added to a vxlan device with vnifilter enabled,
no RTM_NEWTUNNEL notification is sent to userspace. This means
'bridge monitor vni' never shows VNI add events, even though
VNI delete events are reported correctly.

The bug is in vxlan_vni_add(), where the notification is guarded by
'if (changed)'. The 'changed' flag is set by vxlan_vni_update_group()
only when the multicast group or remote IP is modified, but for a
new VNI added without a group (e.g. in L3 VxLAN interface scenarios),
the function returns early without setting changed=true. Since this
is a new VNI, the notification should be sent unconditionally.

The notification is not guarded by the return value of
vxlan_vni_update_group() because, at this point, the VNI has already
been inserted into the hash table and list with no rollback on error.
The VNI will be visible in 'bridge vni show' regardless, so userspace
should be informed. This is consistent with vxlan_vni_del() which also
notifies unconditionally.

The 'if (changed)' guard remains correct in vxlan_vni_update(), which
handles the case where a VNI already exists and is being re-added --
there, we only want to notify if the group/remote actually changed.

Reproducer:

 # ip link add vxlan100 type vxlan dstport 4789 local 10.0.0.1 \
      nolearning external vnifilter
 # ip link set vxlan100 up
 # bridge monitor vni &
 # bridge vni add vni 1000 dev vxlan100    # no notification
 # bridge vni delete vni 1000 dev vxlan100 # notification received

Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
Reported-by: Chirag Shah <chirag@nvidia.com>
Signed-off-by: Andy Roulin <aroulin@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/20260602185138.253265-2-aroulin@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_vnifilter.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
index 06d19e90eadb59..1ab78a8bb9e011 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -769,8 +769,7 @@ static int vxlan_vni_add(struct vxlan_dev *vxlan,
 	err = vxlan_vni_update_group(vxlan, vninode, group, true, &changed,
 				     extack);
 
-	if (changed)
-		vxlan_vnifilter_notify(vxlan, vninode, RTM_NEWTUNNEL);
+	vxlan_vnifilter_notify(vxlan, vninode, RTM_NEWTUNNEL);
 
 	return err;
 }
-- 
2.53.0



