Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A489825A334;
	Tue, 11 Nov 2025 01:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824071; cv=none; b=MZYGQjDJ8I8BvUSIpszih3a+7HkLdz6eS0b1Hv0nli41XiGckIXgUk3JFsrqhW8K6yjoyBxtvsha15w+4/305bdm/f3+yjN3gb0Al73TZflVy/6FFP2uK04E6SnVMUg4jpiT01ggAP0qoSDX9V6+JT1NmmzlbKZtarSyPFYKSXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824071; c=relaxed/simple;
	bh=ehYKDwXcD3dH5bsLqSF/T1s6XJPNUEy/+Yw9zS42aBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d+EmCYuvCWowYuEKuXhkRVrN8iKFc2nx6sURFmp0/8eHmkuIMgNkBCj1Bw8z6qkP0QULErrpS3RV/taXBKisIHz5AJxIgQN3Ym6VaJyWbWoUjZY2yqkRr/PkhqekUguuCtOvvMq1hwXE6TICItXvdcFPriZESOY3dNen9QOTTN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVyvuN4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVyvuN4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A80C116B1;
	Tue, 11 Nov 2025 01:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824071;
	bh=ehYKDwXcD3dH5bsLqSF/T1s6XJPNUEy/+Yw9zS42aBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVyvuN4fWXugRtl4krWNm2ypcmPhSmn3tK4dEWh1IiIYTjJdunQ3o8GY/+1oiUPfe
	 xzhmxv+0xVSGDp91V5MIQ1RbNDC1oV/MeF0T1KR5IX9ZuEcr6pIHEAFUM29EaNHdXT
	 +30TfHKpO1yRWxtObRYyta6fyKT2ie+dfhxCwuZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 431/849] netlink: specs: fou: change local-v6/peer-v6 check
Date: Tue, 11 Nov 2025 09:40:01 +0900
Message-ID: <20251111004546.853601036@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit 9f9581ba74a931843c6d807ecfeaff9fb8c1b731 ]

While updating the binary min-len implementation, I noticed that
the only user, should AFAICT be using exact-len instead.

In net/ipv4/fou_core.c FOU_ATTR_LOCAL_V6 and FOU_ATTR_PEER_V6
are only used for singular IPv6 addresses, and there are AFAICT
no known implementations trying to send more, it therefore
appears safe to change it to an exact-len policy.

This patch therefore changes the local-v6/peer-v6 attributes to
use an exact-len check, instead of a min-len check.

Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://patch.msgid.link/20250902154640.759815-2-ast@fiberby.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/fou.yaml | 4 ++--
 net/ipv4/fou_nl.c                    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/netlink/specs/fou.yaml b/Documentation/netlink/specs/fou.yaml
index 57735726262ec..8e7974ec453fc 100644
--- a/Documentation/netlink/specs/fou.yaml
+++ b/Documentation/netlink/specs/fou.yaml
@@ -52,7 +52,7 @@ attribute-sets:
         name: local-v6
         type: binary
         checks:
-          min-len: 16
+          exact-len: 16
       -
         name: peer-v4
         type: u32
@@ -60,7 +60,7 @@ attribute-sets:
         name: peer-v6
         type: binary
         checks:
-          min-len: 16
+          exact-len: 16
       -
         name: peer-port
         type: u16
diff --git a/net/ipv4/fou_nl.c b/net/ipv4/fou_nl.c
index 3d9614609b2d3..506260b4a4dc2 100644
--- a/net/ipv4/fou_nl.c
+++ b/net/ipv4/fou_nl.c
@@ -18,9 +18,9 @@ const struct nla_policy fou_nl_policy[FOU_ATTR_IFINDEX + 1] = {
 	[FOU_ATTR_TYPE] = { .type = NLA_U8, },
 	[FOU_ATTR_REMCSUM_NOPARTIAL] = { .type = NLA_FLAG, },
 	[FOU_ATTR_LOCAL_V4] = { .type = NLA_U32, },
-	[FOU_ATTR_LOCAL_V6] = { .len = 16, },
+	[FOU_ATTR_LOCAL_V6] = NLA_POLICY_EXACT_LEN(16),
 	[FOU_ATTR_PEER_V4] = { .type = NLA_U32, },
-	[FOU_ATTR_PEER_V6] = { .len = 16, },
+	[FOU_ATTR_PEER_V6] = NLA_POLICY_EXACT_LEN(16),
 	[FOU_ATTR_PEER_PORT] = { .type = NLA_BE16, },
 	[FOU_ATTR_IFINDEX] = { .type = NLA_S32, },
 };
-- 
2.51.0



