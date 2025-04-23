Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A3C27FD75;
	Wed, 23 Apr 2025 15:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422233; cv=none; b=F8tCLes4Gy6E4x3TGNQDO9OU69u3PXM/n10daBJb7jjcmm2109bZd7hFfBtKJC5AzjhgCTjzcYbxsfTyJG18+11sAp0Ypsbxck4ZKJ7fL3mawy7dLW+z31ASS6Bfth78vBn3nyDDP3TFaDlmtWeSe6vd8HRCiaAIYUCZJlfNxTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422233; c=relaxed/simple;
	bh=8bi19nHHi7RMaXH95huB6OuC0pCvrGJBjb05pJVGC44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7szCo6qMzWH2TOnEoN37waUklrGKL/SxkwREGSBh1AJaydIYyv/jFDwEo6GszJOWhkLcLhiqG6od5J7hAKt3SHy6jNM+zjNvrY8D9vo5s0bRIMM4VuXqrw1NwDkvkRveVsyNuJLucRRzuI3Yt1H1XGAEkH86YhhyeCV2QZ5IIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ix6/bei2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ix6/bei2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA32C4CEE2;
	Wed, 23 Apr 2025 15:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422233;
	bh=8bi19nHHi7RMaXH95huB6OuC0pCvrGJBjb05pJVGC44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ix6/bei2zUZKw8vtv2IK5aqfyfUHspVikelI80H0h8vTSTMprGbIqVpsX6/YevAsx
	 TNfSB46Cs2bGOP+Qm5hToRcXb1MVc4Te8Nnts0EtEMtA2TLiqbgozVi2P3wVF9/Lz8
	 XO/c7+fKenHB2ErSSNdK4gwD76WvjYz0Kn/N2an4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/393] netlink: specs: rt-link: add an attr layer around alt-ifname
Date: Wed, 23 Apr 2025 16:42:56 +0200
Message-ID: <20250423142654.912950959@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit acf4da17deada7f8b120e051aa6c9cac40dbd83b ]

alt-ifname attr is directly placed in requests (as an alternative
to ifname) but in responses its wrapped up in IFLA_PROP_LIST
and only there is may be multi-attr. See rtnl_fill_prop_list().

Fixes: b2f63d904e72 ("doc/netlink: Add spec for rt link messages")
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250414211851.602096-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/rt_link.yaml | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/netlink/specs/rt_link.yaml b/Documentation/netlink/specs/rt_link.yaml
index d86a68f8475ca..34f74c451dcdb 100644
--- a/Documentation/netlink/specs/rt_link.yaml
+++ b/Documentation/netlink/specs/rt_link.yaml
@@ -892,11 +892,10 @@ attribute-sets:
       -
         name: prop-list
         type: nest
-        nested-attributes: link-attrs
+        nested-attributes: prop-list-link-attrs
       -
         name: alt-ifname
         type: string
-        multi-attr: true
       -
         name: perm-address
         type: binary
@@ -931,6 +930,13 @@ attribute-sets:
       -
         name: gro-ipv4-max-size
         type: u32
+  -
+    name: prop-list-link-attrs
+    subset-of: link-attrs
+    attributes:
+      -
+        name: alt-ifname
+        multi-attr: true
   -
     name: af-spec-attrs
     attributes:
@@ -1362,7 +1368,6 @@ operations:
             - min-mtu
             - max-mtu
             - prop-list
-            - alt-ifname
             - perm-address
             - proto-down-reason
             - parent-dev-name
-- 
2.39.5



