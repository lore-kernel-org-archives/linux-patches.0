Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDB92918C1;
	Wed, 23 Apr 2025 15:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422086; cv=none; b=UG4od+3n3TPbyx+AFaCcy5rO+Dw+t8Sureyg3dHN27M0v4wo+9SxgrRFRwce6ZLfi2Wmn6EvS83DhId/7C/4AqgAee1VIpobqu48yfpUAgdvERWUHoq41CeRfjLWR322wtTBs1CIIfoyVhnhw3D6BcwVkFyyo31+uXEl3QyeqLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422086; c=relaxed/simple;
	bh=lUnDBRzghIJw4k6GhhGz9OXagKj8hjkTv+2oPxCSjuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8qUYK3BHLA6EXwLCStyde08uwg3bexp9RhrvrJ+AKJPUyMBFor0wUh7ivbVBBKcnlofdh+GWUvE6zrt2YJ5SFlwqYSNPs0sL15e+fI1OfO+BdR/FGGXD0/n9UDwcE6MaewiemaG7A/B0LSJrFEjfoSpodcCKJOZDDV+DVfcjoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsUM0a58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsUM0a58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC9EC4CEE2;
	Wed, 23 Apr 2025 15:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422086;
	bh=lUnDBRzghIJw4k6GhhGz9OXagKj8hjkTv+2oPxCSjuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsUM0a58HFy8dqSNJlpDoUsmz4FZ0JH8i/jqztKNjUVUeufkdlZhFzr+2OySum3Di
	 41RxsMwoc5D/Jn5Pcb09m6cqbOrxGgGXvN2D4Z1GBKYKNhOnAF/x7kxJ/LbWS/Spo2
	 uErQSe6rtTY0SEBSlXOac72F0t5qgU2bs3+N40Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 275/393] tools: ynl-gen: track attribute use
Date: Wed, 23 Apr 2025 16:42:51 +0200
Message-ID: <20250423142654.712103300@linuxfoundation.org>
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

[ Upstream commit ee0a4cfcbdcc6a7b2b35dba475e68187ebdafbf1 ]

For range validation we'll need to know if any individual
attribute is used on input (i.e. whether we will generate
a policy for it). Track this information.

Link: https://lore.kernel.org/r/20231018163917.2514503-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ce6cb8113c84 ("tools: ynl-gen: individually free previous values on double set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 575b7e248e521..4c86fe0cd1179 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -42,6 +42,9 @@ class Type(SpecAttr):
         self.type = attr['type']
         self.checks = attr.get('checks', {})
 
+        self.request = False
+        self.reply = False
+
         if 'len' in attr:
             self.len = attr['len']
         if 'nested-attributes' in attr:
@@ -845,6 +848,7 @@ class Family(SpecFamily):
 
         self._load_root_sets()
         self._load_nested_sets()
+        self._load_attr_use()
         self._load_hooks()
 
         self.kernel_policy = self.yaml.get('kernel-policy', 'split')
@@ -965,6 +969,22 @@ class Family(SpecFamily):
                         child.request |= struct.request
                         child.reply |= struct.reply
 
+    def _load_attr_use(self):
+        for _, struct in self.pure_nested_structs.items():
+            if struct.request:
+                for _, arg in struct.member_list():
+                    arg.request = True
+            if struct.reply:
+                for _, arg in struct.member_list():
+                    arg.reply = True
+
+        for root_set, rs_members in self.root_sets.items():
+            for attr, spec in self.attr_sets[root_set].items():
+                if attr in rs_members['request']:
+                    spec.request = True
+                if attr in rs_members['reply']:
+                    spec.reply = True
+
     def _load_global_policy(self):
         global_set = set()
         attr_set_name = None
-- 
2.39.5



