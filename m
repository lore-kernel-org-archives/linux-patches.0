Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A706F35E541;
	Tue,  6 Jan 2026 17:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721665; cv=none; b=kxMah93Mj+dDdfx7WfbJTITzFw4aAIbTo6tHHHSi/hwNdusU+x+LLpL1lG6XUYifyByMBUKzaDnTClx1UoA21kBCYojogcfePL50Wygs0H0uyXe+ayXDYG34Dfea0pjnAAlgSKGYIk/DpKDLy7C7rUXTy9+y1nTym85r4SlfyIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721665; c=relaxed/simple;
	bh=rO3PN0kV1absZP67zedRory/d7Taq4mhHcjt8/rTlV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3UJevmQBdXarbC5meO7UW50azq5LMUTbTI1L1IJVeD9We6xBiP+Ct0YPTGNxq7lUVmM+gsdCS+jgUycCllqDkQAh3fmrLwpDmKlJLtmZFq1ksMy3lUGVVbNxXleN3/byGaQ1m5N3/LiJonWNm4PEgIECFDaRbfGAdMK0tnGSjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzdccbH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzdccbH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C337EC116C6;
	Tue,  6 Jan 2026 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721665;
	bh=rO3PN0kV1absZP67zedRory/d7Taq4mhHcjt8/rTlV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzdccbH0kvAmewd3PD9KZSnGCZgMY1pGgjmOSCNUKYTGLlmesXABwV6NgIrEakpSQ
	 0ZOrSGCH2t/V0eq+GOFoL+vVh1TkrfIQy6OzIP9Ez3yNwr8QJb5d+QzD22iUVZWm1J
	 e6bjb3wOfEm/Tu5nLWbmJ2RLcxsFU6cU0epZ1nhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/312] net: dsa: fix missing put_device() in dsa_tree_find_first_conduit()
Date: Tue,  6 Jan 2026 18:01:50 +0100
Message-ID: <20260106170549.162411124@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit a9f96dc59b4a50ffbf86158f315e115969172d48 ]

of_find_net_device_by_node() searches net devices by their /sys/class/net/,
entry. It is documented in its kernel-doc that:

 * If successful, returns a pointer to the net_device with the embedded
 * struct device refcount incremented by one, or NULL on failure. The
 * refcount must be dropped when done with the net_device.

We are missing a put_device(&conduit->dev) which we could place at the
end of dsa_tree_find_first_conduit(). But to explain why calling
put_device() right away is safe is the same as to explain why the chosen
solution is different.

The code is very poorly split: dsa_tree_find_first_conduit() was first
introduced in commit 95f510d0b792 ("net: dsa: allow the DSA master to be
seen and changed through rtnetlink") but was first used several commits
later, in commit acc43b7bf52a ("net: dsa: allow masters to join a LAG").

Assume there is a switch with 2 CPU ports and 2 conduits, eno2 and eno3.
When we create a LAG (bonding or team device) and place eno2 and eno3
beneath it, we create a 3rd conduit (the LAG device itself), but this is
slightly different than the first two.

Namely, the cpu_dp->conduit pointer of the CPU ports does not change,
and remains pointing towards the physical Ethernet controllers which are
now LAG ports. Only 2 things change:
- the LAG device has a dev->dsa_ptr which marks it as a DSA conduit
- dsa_port_to_conduit(user port) finds the LAG and not the physical
  conduit, because of the dp->cpu_port_in_lag bit being set.

When the LAG device is destroyed, dsa_tree_migrate_ports_from_lag_conduit()
is called and this is where dsa_tree_find_first_conduit() kicks in.

This is the logical mistake and the reason why introducing code in one
patch and using it from another is bad practice. I didn't realize that I
don't have to call of_find_net_device_by_node() again; the cpu_dp->conduit
association was never undone, and is still available for direct (re)use.
There's only one concern - maybe the conduit disappeared in the
meantime, but the netdev_hold() call we made during dsa_port_parse_cpu()
(see previous change) ensures that this was not the case.

Therefore, fixing the code means reimplementing it in the simplest way.

I am blaming the time of use, since this is what "git blame" would show
if we were to monitor for the conduit's kobject's refcount remaining
elevated instead of being freed.

Tested on the NXP LS1028A, using the steps from
Documentation/networking/dsa/configuration.rst section "Affinity of user
ports to CPU ports", followed by (extra prints added by me):

$ ip link del bond0
mscc_felix 0000:00:00.5 swp3: Link is Down
bond0 (unregistering): (slave eno2): Releasing backup interface
fsl_enetc 0000:00:00.2 eno2: Link is Down
mscc_felix 0000:00:00.5 swp0: bond0 disappeared, migrating to eno2
mscc_felix 0000:00:00.5 swp1: bond0 disappeared, migrating to eno2
mscc_felix 0000:00:00.5 swp2: bond0 disappeared, migrating to eno2
mscc_felix 0000:00:00.5 swp3: bond0 disappeared, migrating to eno2

Fixes: acc43b7bf52a ("net: dsa: allow masters to join a LAG")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20251215150236.3931670-2-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index d466d0234087..ded9a291e620 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -366,16 +366,10 @@ static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 
 struct net_device *dsa_tree_find_first_conduit(struct dsa_switch_tree *dst)
 {
-	struct device_node *ethernet;
-	struct net_device *conduit;
 	struct dsa_port *cpu_dp;
 
 	cpu_dp = dsa_tree_find_first_cpu(dst);
-	ethernet = of_parse_phandle(cpu_dp->dn, "ethernet", 0);
-	conduit = of_find_net_device_by_node(ethernet);
-	of_node_put(ethernet);
-
-	return conduit;
+	return cpu_dp->conduit;
 }
 
 /* Assign the default CPU port (the first one in the tree) to all ports of the
-- 
2.51.0



