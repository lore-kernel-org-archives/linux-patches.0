Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9369A2EAE6;
	Mon, 23 Dec 2024 16:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969737; cv=none; b=Uowh+dA+JSIR9lg2i5x0dI6NgSKK9RQCYFUEgxtEM+M1fXld01e2tkV2fwINAAnS02QsDJAbdeKl/F9bZD6vmkcB5JhU1CWhDgXHtk84R/gH42NP8CNd3sTL1dawa9+Q0LRFdrajgYXRRvp3hCtHKMr8h1Q0IxAbauhC/GEbvyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969737; c=relaxed/simple;
	bh=NVM+uMwBNXpCzKE8KGPpBMf0LVcQfgj2gi/X5Cpn1pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6cB4WAZydaK+8VzRJ6d0QrE+1EH8kpTKJTMEHaZiTARcG/fUrezxCRtwjteyZO2LfSFRMzDGteduISkOE7pNX03TkUj2WATbAta/60IqpX+3Ff4GaaqfVXQmmftbamm2didOgyLL+49QyMh5/2dvEFmdqwAQRLqUYKdpac/aWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSK/VgV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSK/VgV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3EDC4CED3;
	Mon, 23 Dec 2024 16:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969737;
	bh=NVM+uMwBNXpCzKE8KGPpBMf0LVcQfgj2gi/X5Cpn1pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSK/VgV3iE+ZAI3xOUzkjBMbPouzAF6rA4RLNbM31EVTqOcSmWy9WfXTH2OSMYt00
	 fJb5HzP0w4gfTapHRC2YLZIDAT4WXHEfK2FaF0al+paAGLv5nvJhEc78Ld0rMm7OfC
	 abBsBy/Gq3YulvoUfFTZCHJafyvw3c1TWayHACnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/160] tools/net/ynl: fix sub-message key lookup for nested attributes
Date: Mon, 23 Dec 2024 16:57:30 +0100
Message-ID: <20241223155410.185352898@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donald Hunter <donald.hunter@gmail.com>

[ Upstream commit 663ad7481f068057f6f692c5368c47150e855370 ]

Use the correct attribute space for sub-message key lookup in nested
attributes when adding attributes. This fixes rt_link where the "kind"
key and "data" sub-message are nested attributes in "linkinfo".

For example:

./tools/net/ynl/cli.py \
    --create \
    --spec Documentation/netlink/specs/rt_link.yaml \
    --do newlink \
    --json '{"link": 99,
             "linkinfo": { "kind": "vlan", "data": {"id": 4 } }
             }'

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Fixes: ab463c4342d1 ("tools/net/ynl: Add support for encoding sub-messages")
Link: https://patch.msgid.link/20241213130711.40267-1-donald.hunter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.py | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index c22c22bf2cb7..a3f741fed0a3 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -553,10 +553,10 @@ class YnlFamily(SpecFamily):
         if attr["type"] == 'nest':
             nl_type |= Netlink.NLA_F_NESTED
             attr_payload = b''
-            sub_attrs = SpaceAttrs(self.attr_sets[space], value, search_attrs)
+            sub_space = attr['nested-attributes']
+            sub_attrs = SpaceAttrs(self.attr_sets[sub_space], value, search_attrs)
             for subname, subvalue in value.items():
-                attr_payload += self._add_attr(attr['nested-attributes'],
-                                               subname, subvalue, sub_attrs)
+                attr_payload += self._add_attr(sub_space, subname, subvalue, sub_attrs)
         elif attr["type"] == 'flag':
             if not value:
                 # If value is absent or false then skip attribute creation.
-- 
2.39.5



