Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB44713D607;
	Thu, 13 Jun 2024 12:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281431; cv=none; b=aKWiXrb95L7WagRHgOinm/U2vXd6/7I5frKdJBlv5Z2aT4UQpVXM87/p+rMWY/LlCwUzs85dXINovI6KX0tUXvN2t4i4jDq8zYheXKnLzu2MMiYgDYn/Fcqt1my1JOLx4X2yrcpbYPaOoK0ToMtjCn8xJlTSh2zH7Oyk9pJaUR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281431; c=relaxed/simple;
	bh=YWrxBMrUmjS54niEPzawAXDVsYz7YUbZhkwcoexfnGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7RuRJX5y0GbBbRcgd5g9X5M4UeLp74nvtlQuWgLlIxo4sOxNQV3iw7RbwV/DhRKvS7uyZKPEOoKIXfyWpXT7z8nm+d2aBNCSQsmNXLHdba3mCxUPjdhIDYLKOJCdP1zq/tMTrXtaoQDsi4M+eIaZcAL+m49c9OL1VVh3P3aQlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c18Vyrxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c18Vyrxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFDAC32786;
	Thu, 13 Jun 2024 12:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281430;
	bh=YWrxBMrUmjS54niEPzawAXDVsYz7YUbZhkwcoexfnGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c18VyrxaM5XoybqwMJPW6LQazQ1lM0or1pA7f0/YFhVYoF8LgOlbF8Y+cnQWXff0V
	 3kGV9R25wJRDlGb1Q8iJxcoslVCHVWxl1aVHoMxAfP/QPAQrajf/cE1CLqcfVPefE2
	 d9Q7kxH2zU6KeafjM/27D7ni7Ir4c0Hsm7W9DmqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roded Zats <rzats@paloaltonetworks.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/317] enic: Validate length of nl attributes in enic_set_vf_port
Date: Thu, 13 Jun 2024 13:34:30 +0200
Message-ID: <20240613113257.298252841@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 548d8095c0a79..b695f3f233286 100644
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



