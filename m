Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85832264DD;
	Tue, 17 Jun 2025 16:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179004; cv=none; b=q9fpk3aG4Fo/zC2uoSFu6LbDa+5KO+e7LLZJ0B6+tyfgI1QqbMeg9ueYs6izZaVZB9aitU8w/mb9Qc31XErrEXH/Rv5zVuVXY6bYxEC6ibg6tRtfA3JbbiqMtbrh3H/DFVAi4FEN8wsswks5C2HlAAe4u/b/uEx5yRb7CZ1lbYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179004; c=relaxed/simple;
	bh=JoQnMg0C0iVEcRVxqqZkwzAxUfvZ9xHuAp0hb+J4S30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuRGCYm6AtjSu8Pc2zk7E7SzXXZZnQjh1xerW+1QovTm1H3FJBBT+9dP40BnCjgspG7TO4NTSu9TYs2+OHSaGDOqCUVilwGwhhXfU2Dv/ojQrjpfDgijdPmUB9yLlqQJz+tPS/9uIsNCch0QEBpD6NAvTHtx4ww2bj2X0TMfoDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iN/5BxOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iN/5BxOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CE6C4CEE3;
	Tue, 17 Jun 2025 16:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179004;
	bh=JoQnMg0C0iVEcRVxqqZkwzAxUfvZ9xHuAp0hb+J4S30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iN/5BxOZsGtGXEwCBX2ozKu18vQbwl3OT8aP9wfUIFxlhlXjQtSvfjevNkgGCsBLf
	 POlAsIVhcKjRvWE0fRWTsUswSOCWP5B41llHI8Z68JJFxlFdiJ+KLAI59Xa7rxZkgL
	 c9eiB1Brm7Y0XqVvY11MukfbDyN1zlEzfk0an720=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 619/780] netlink: specs: rt-link: decode ip6gre
Date: Tue, 17 Jun 2025 17:25:27 +0200
Message-ID: <20250617152516.688031298@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8af7a919c52f02514a145f995cbdf0deadb8075a ]

Driver tests now require GRE tunnels, while we don't configure
them with YNL, YNL will complain when it sees link types it
doesn't recognize. Teach it decoding ip6gre tunnels. The attrs
are largely the same as IPv4 GRE.

Correct the type of encap-limit, but note that this attr is
only used in ip6gre, so the mistake didn't matter until now.

Fixes: 0d0f4174f6c8 ("selftests: drv-net: add a simple TSO test")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://patch.msgid.link/20250603135357.502626-3-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/rt_link.yaml | 53 +++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/rt_link.yaml b/Documentation/netlink/specs/rt_link.yaml
index ba767c42e8792..2ac0e9fda1582 100644
--- a/Documentation/netlink/specs/rt_link.yaml
+++ b/Documentation/netlink/specs/rt_link.yaml
@@ -1810,7 +1810,7 @@ attribute-sets:
         type: u8
       -
         name: encap-limit
-        type: u32
+        type: u8
       -
         name: flowinfo
         type: u32
@@ -1853,6 +1853,54 @@ attribute-sets:
       -
         name: erspan-hwid
         type: u16
+  -
+    name: linkinfo-gre6-attrs
+    subset-of: linkinfo-gre-attrs
+    attributes:
+      -
+        name: link
+      -
+        name: iflags
+      -
+        name: oflags
+      -
+        name: ikey
+      -
+        name: okey
+      -
+        name: local
+        display-hint: ipv6
+      -
+        name: remote
+        display-hint: ipv6
+      -
+        name: ttl
+      -
+        name: encap-limit
+      -
+        name: flowinfo
+      -
+        name: flags
+      -
+        name: encap-type
+      -
+        name: encap-flags
+      -
+        name: encap-sport
+      -
+        name: encap-dport
+      -
+        name: collect-metadata
+      -
+        name: fwmark
+      -
+        name: erspan-index
+      -
+        name: erspan-ver
+      -
+        name: erspan-dir
+      -
+        name: erspan-hwid
   -
     name: linkinfo-vti-attrs
     name-prefix: ifla-vti-
@@ -2314,6 +2362,9 @@ sub-messages:
       -
         value: gretap
         attribute-set: linkinfo-gre-attrs
+      -
+        value: ip6gre
+        attribute-set: linkinfo-gre6-attrs
       -
         value: geneve
         attribute-set: linkinfo-geneve-attrs
-- 
2.39.5



