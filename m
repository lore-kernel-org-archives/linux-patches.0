Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA9C28136E;
	Wed, 23 Apr 2025 14:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419769; cv=none; b=bXSFYqfD6zpuz04CNV8S7cAIjJ7Y9C2ndBjPZYIbbr2/SuoDdbmGVkyPZPRqEsfU4RlVCE0h5XWsFEenk5c6DaaG+SvAlQlkmnHAtx8/gAcLTgtxAfgmIHb0xuZJWiArpHOwzheFAJdLcSSXrHLekngMFxzvQm2HM5LFH4aRjVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419769; c=relaxed/simple;
	bh=4KwlD3bRbAZs7/TM+BkvB3yKCzfnQAxebl2yGvssH84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpcYOiMlWsMoFPsTDsV7JxdHrBsf/VuzlrwlsGNt2ueB20OIX4j8AeKIxI7Vgesb5pRG4Smy+OIShxV611C+kmXssClPIgckacOsPqozDXUzDM/Kbyi5ZlfBbS0GwA+MJCxobts+RIjr9LCdq7JOGlg8fHVLHlFbbSGXS1n+Z6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OMwUI1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OMwUI1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C48AC4CEE2;
	Wed, 23 Apr 2025 14:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419768;
	bh=4KwlD3bRbAZs7/TM+BkvB3yKCzfnQAxebl2yGvssH84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OMwUI1nrt33enBNpngqeNSJl7aqu6RZXBeZxy/SYCB+jzKP3grsd8IWHYENMLVX6
	 2dEviKXbCiYHIh1BjUk3v7kxpH7nDs16VAKOSA5gLltkIu/mPbZsTH3fG15LmKzn8s
	 cnlclJQBNSuMd1LD/xRxe7d4QJajKUOnsWlM7iWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/223] netlink: specs: rt-link: add an attr layer around alt-ifname
Date: Wed, 23 Apr 2025 16:42:10 +0200
Message-ID: <20250423142619.491288442@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0c4d5d40cae90..11d9abec99bc0 100644
--- a/Documentation/netlink/specs/rt_link.yaml
+++ b/Documentation/netlink/specs/rt_link.yaml
@@ -1094,11 +1094,10 @@ attribute-sets:
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
@@ -1137,6 +1136,13 @@ attribute-sets:
         name: dpll-pin
         type: nest
         nested-attributes: link-dpll-pin-attrs
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
@@ -2319,7 +2325,6 @@ operations:
             - min-mtu
             - max-mtu
             - prop-list
-            - alt-ifname
             - perm-address
             - proto-down-reason
             - parent-dev-name
-- 
2.39.5



