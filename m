Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A19813D600;
	Tue, 23 Jul 2024 18:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760024; cv=none; b=r6jyhqmjQ8iI8alR1fRBAH+tItgaI8OZtaTPdPZuen01zXF9jHUMr8BTrWdThMr0VC6crJphyAfDq/BVcBddIhDMLvU/VTQ1USyvFneMbDUgwLgVfpAhaXgKNVLghm7aaMqpi1t0FPrZi+VJ2qovpCC+qWkUV3QJZo7lWuHpVNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760024; c=relaxed/simple;
	bh=HJ0bW0c62z25E98dL3h4dkqYVzK/d7niRig6Se70pX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbBM2FRvuTAB7Av3png27vpWxCvtWD4gWJfKHbiZTaNI7y7rd77LCSdLt+D6apLg28uSmCm/3ocdsT+5w27tx4lMdu7NBmed4YRozOME6PRPixKQ8XMmvKCLwQVP08TwtIN8TU0iWWe6YSP5f8VkTP1ivzyTdaRibv47CJuFuk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcaLJYjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcaLJYjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04379C4AF0A;
	Tue, 23 Jul 2024 18:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760024;
	bh=HJ0bW0c62z25E98dL3h4dkqYVzK/d7niRig6Se70pX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcaLJYjHnsSrSN55tp9PzI9Pp1jZ9V8hVgXlVwRd77u0RaAjdhrPviXqQ7NNaHjPB
	 8QpAD/ANCyBA6T3Doq87QtNZgMN0HWdwe/CxI7MgOrmcaqmlMqIUbP1X/E+gkDIDw0
	 WOD+1ae2stDx64wmdyVy+fCzg6UpNHakrYqrZbyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Moreno <amorenoz@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 078/163] selftests: openvswitch: Set value to nla flags.
Date: Tue, 23 Jul 2024 20:23:27 +0200
Message-ID: <20240723180146.482763334@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Moreno <amorenoz@redhat.com>

[ Upstream commit a8763466669d21b570b26160d0a5e0a2ee529d22 ]

Netlink flags, although they don't have payload at the netlink level,
are represented as having "True" as value in pyroute2.

Without it, trying to add a flow with a flag-type action (e.g: pop_vlan)
fails with the following traceback:

Traceback (most recent call last):
  File "[...]/ovs-dpctl.py", line 2498, in <module>
    sys.exit(main(sys.argv))
             ^^^^^^^^^^^^^^
  File "[...]/ovs-dpctl.py", line 2487, in main
    ovsflow.add_flow(rep["dpifindex"], flow)
  File "[...]/ovs-dpctl.py", line 2136, in add_flow
    reply = self.nlm_request(
            ^^^^^^^^^^^^^^^^^
  File "[...]/pyroute2/netlink/nlsocket.py", line 822, in nlm_request
    return tuple(self._genlm_request(*argv, **kwarg))
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "[...]/pyroute2/netlink/generic/__init__.py", line 126, in
nlm_request
    return tuple(super().nlm_request(*argv, **kwarg))
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "[...]/pyroute2/netlink/nlsocket.py", line 1124, in nlm_request
    self.put(msg, msg_type, msg_flags, msg_seq=msg_seq)
  File "[...]/pyroute2/netlink/nlsocket.py", line 389, in put
    self.sendto_gate(msg, addr)
  File "[...]/pyroute2/netlink/nlsocket.py", line 1056, in sendto_gate
    msg.encode()
  File "[...]/pyroute2/netlink/__init__.py", line 1245, in encode
    offset = self.encode_nlas(offset)
             ^^^^^^^^^^^^^^^^^^^^^^^^
  File "[...]/pyroute2/netlink/__init__.py", line 1560, in encode_nlas
    nla_instance.setvalue(cell[1])
  File "[...]/pyroute2/netlink/__init__.py", line 1265, in setvalue
    nlv.setvalue(nla_tuple[1])
                 ~~~~~~~~~^^^
IndexError: list index out of range

Signed-off-by: Adrian Moreno <amorenoz@redhat.com>
Acked-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/openvswitch/ovs-dpctl.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
index 5e0e539a323d5..8b120718768ec 100644
--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -531,7 +531,7 @@ class ovsactions(nla):
             for flat_act in parse_flat_map:
                 if parse_starts_block(actstr, flat_act[0], False):
                     actstr = actstr[len(flat_act[0]):]
-                    self["attrs"].append([flat_act[1]])
+                    self["attrs"].append([flat_act[1], True])
                     actstr = actstr[strspn(actstr, ", ") :]
                     parsed = True
 
-- 
2.43.0



