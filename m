Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4C51849;
	Thu, 13 Jun 2024 12:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282669; cv=none; b=oeMgUTe2vFtNnuGQEFYiZQAxYWI1xDeAB9RycMkl38tXz7e9IlKQxrVuGSdsk7D+n36msIC+uEtKSijKYxgUiYG8oAuzEql3RbZHc4JIiP8CjkCJiOt/qzQ3UglPqdbXk73g7bWoOa5D1qaSCPyywt9nVqnqx176VGzjoGVO2oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282669; c=relaxed/simple;
	bh=0YYXtbeAH9DvfZ1lmqac57okO1i0u1L/J1X69gDChuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlmYlnypFhhzBCmBAyYqkXKCQOOfEQKCJJlwl0l41EoN5pnIPKxzbyc5ClQlLRQdrmb+ArQy2NT+FYTNRNQ9Ce37HV3o4b+pvjrqWfHYxZltpq+iopq2EkMZ3PjO+mPR8Bpx1MxgorpR/RCeYUa+J1aMY0v7XImHPT3TBbv9yoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ndlo806e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ndlo806e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD43C2BBFC;
	Thu, 13 Jun 2024 12:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282669;
	bh=0YYXtbeAH9DvfZ1lmqac57okO1i0u1L/J1X69gDChuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ndlo806eHiKZpxC/a9cdeUQFrHCX/7VRL6SAup6Y0XJjeTq1gWTXRgjgwwWpkJ7Qo
	 QELHQ5SIMMg4F7aCcMCPYU/5WFRuGiZZe+8ySzcRrAkrkb8ERPv1Teu9Be38UPdn9X
	 +feF7EOv6NPj7o6QGzSZ9raE6Ck5SGnlsofuFANk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roded Zats <rzats@paloaltonetworks.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 315/402] enic: Validate length of nl attributes in enic_set_vf_port
Date: Thu, 13 Jun 2024 13:34:32 +0200
Message-ID: <20240613113314.427543568@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Roded Zats <rzats@paloaltonetworks.com>

[ Upstream commit e8021b94b0412c37bcc79027c2e382086b6ce449 ]

enic_set_vf_port assumes that the nl attribute IFLA_PORT_PROFILE
is of length PORT_PROFILE_MAX and that the nl attributes
IFLA_PORT_INSTANCE_UUID, IFLA_PORT_HOST_UUID are of length PORT_UUID_MAX.
These attributes are validated (in the function do_setlink in rtnetlink.c)
using the nla_policy ifla_port_policy. The policy defines IFLA_PORT_PROFILE
as NLA_STRING, IFLA_PORT_INSTANCE_UUID as NLA_BINARY and
IFLA_PORT_HOST_UUID as NLA_STRING. That means that the length validation
using the policy is for the max size of the attributes and not on exact
size so the length of these attributes might be less than the sizes that
enic_set_vf_port expects. This might cause an out of bands
read access in the memcpys of the data of these
attributes in enic_set_vf_port.

Fixes: f8bd909183ac ("net: Add ndo_{set|get}_vf_port support for enic dynamic vnics")
Signed-off-by: Roded Zats <rzats@paloaltonetworks.com>
Link: https://lore.kernel.org/r/20240522073044.33519-1-rzats@paloaltonetworks.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index d0a8f7106958b..52bc164a1cfbc 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -1117,18 +1117,30 @@ static int enic_set_vf_port(struct net_device *netdev, int vf,
 	pp->request = nla_get_u8(port[IFLA_PORT_REQUEST]);
 
 	if (port[IFLA_PORT_PROFILE]) {
+		if (nla_len(port[IFLA_PORT_PROFILE]) != PORT_PROFILE_MAX) {
+			memcpy(pp, &prev_pp, sizeof(*pp));
+			return -EINVAL;
+		}
 		pp->set |= ENIC_SET_NAME;
 		memcpy(pp->name, nla_data(port[IFLA_PORT_PROFILE]),
 			PORT_PROFILE_MAX);
 	}
 
 	if (port[IFLA_PORT_INSTANCE_UUID]) {
+		if (nla_len(port[IFLA_PORT_INSTANCE_UUID]) != PORT_UUID_MAX) {
+			memcpy(pp, &prev_pp, sizeof(*pp));
+			return -EINVAL;
+		}
 		pp->set |= ENIC_SET_INSTANCE;
 		memcpy(pp->instance_uuid,
 			nla_data(port[IFLA_PORT_INSTANCE_UUID]), PORT_UUID_MAX);
 	}
 
 	if (port[IFLA_PORT_HOST_UUID]) {
+		if (nla_len(port[IFLA_PORT_HOST_UUID]) != PORT_UUID_MAX) {
+			memcpy(pp, &prev_pp, sizeof(*pp));
+			return -EINVAL;
+		}
 		pp->set |= ENIC_SET_HOST;
 		memcpy(pp->host_uuid,
 			nla_data(port[IFLA_PORT_HOST_UUID]), PORT_UUID_MAX);
-- 
2.43.0



