Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B350742067;
	Tue, 23 Jul 2024 18:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759605; cv=none; b=DRSCMluKKq52BCglL6ybwPpYLzhYVEtz5XTMdRoFQVgKs1ZOaazdRc68iXjo5hQMG1U5GTXGt4MEd2mFx+Hwa/QkvFi7E8O6FQt7htXIwOgMxDanfiVp17sOLC0z1oL2W9eL3badQltvzmF29txOIDkVrVJxnhwP9lafv/TFMH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759605; c=relaxed/simple;
	bh=5b564QTNxdzAkhhCubPTK8Z94PyWQe0mlYRwMgeh3oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1ZvjfWJBb4lpdF6/nuX1evBZPhsPvJDjqcNlJhIhtLaIU/aNxhjf0+9yYJlnfVGQnvDtbz0ZmbhBWN/73PaLd7yGCBpGmGa/QRtEtMg5OlJI+u9l6p/7SIxyhmvRqusA7QSYapR8HmWiOjsXuYEtsLnQKCyRBCIlPNIa7dnhGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShvTf2nX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShvTf2nX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B198C4AF09;
	Tue, 23 Jul 2024 18:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759605;
	bh=5b564QTNxdzAkhhCubPTK8Z94PyWQe0mlYRwMgeh3oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShvTf2nXiicEn8U7XgeayyQ7aGxP9e8p44eYZqLYFQVtEUiEpUUbEjGeRKDpPPoO8
	 A+0bvt/2qsGQOBz0pmnanV3rZVYUi4tJELgUdROLnTHIPk4iWLV2tQ+72sPS/2pxWV
	 6mX2DxVLE2UWSTNe5B1NyqCUAsATC+Jw7Dy0tehg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Moreno <amorenoz@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/129] selftests: openvswitch: Set value to nla flags.
Date: Tue, 23 Jul 2024 20:23:27 +0200
Message-ID: <20240723180407.067208493@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



