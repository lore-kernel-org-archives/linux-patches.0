Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97931F7580;
	Mon, 23 Jun 2025 22:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716776; cv=none; b=gVKB1SdM8nHVYnlAn9ne3I5lReGBP1ruuIYSpbAkGOolnzwtzkwGLIJkDhJ4n5VDeuigjYnBf3Ns5YoYYl492BFH4F9qcPjGIb9cmDNndUhWTa6iuq+MvgCjSRMTxt7M0kSEXAbANp4mlZY8ZdWw9nHvQGLv1FQgzXnBR/46IH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716776; c=relaxed/simple;
	bh=jMlw41lLDcswCLEqK3SebUSfoDc0GU5F5pT7MamoEzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGK+OOf5Q9kKhaf7j4B0gvRUCoQyKaM0H2pcEI1sY2dm/AHoAs6aM1Fno3MBs/xXMPns5AipqiXjpq/IaWXT1j2tNAepn+ejeTAcQDbbK7l+IshpPkW73YgspPHkZaqUwClwC6YWkpV7R0bgINQS11PTSr27OFhJvZ1w8flviGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMawNYyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMawNYyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51839C4CEEA;
	Mon, 23 Jun 2025 22:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716776;
	bh=jMlw41lLDcswCLEqK3SebUSfoDc0GU5F5pT7MamoEzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMawNYyUiF4xVUiP4oPjpUDE07Bd1U1xJYvof/9VDA0kjXMjUHlznL1LCR1yqBgj+
	 trNk9TzCn6tMA/r11+WqbQIGLGecBbd9cPGTzs2QI66AWYlHQ8w0Udl2eXhUk7cP6K
	 wlHZ7It3JV8/TnwK573yRVLvB3uqGMA4YjairAO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 554/592] tools: ynl: parse extack for sub-messages
Date: Mon, 23 Jun 2025 15:08:32 +0200
Message-ID: <20250623130713.622772590@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Donald Hunter <donald.hunter@gmail.com>

[ Upstream commit 09d7ff0694ea133c50ad905fd6e548c13f8af458 ]

Extend the Python YNL extack decoding to handle sub-messages in the same
way that YNL C does. This involves retaining the input values so that
they are available during extack decoding.

./tools/net/ynl/pyynl/cli.py --family rt-link --do newlink --create \
    --json '{
        "linkinfo": {"kind": "netkit", "data": {"policy": 10} }
    }'
Netlink error: Invalid argument
nl_len = 92 (76) nl_flags = 0x300 nl_type = 2
	error: -22
	extack: {'msg': 'Provided default xmit policy not supported', 'bad-attr': '.linkinfo.data(netkit).policy'}

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://patch.msgid.link/20250523103031.80236-1-donald.hunter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9738280aae59 ("tools: ynl: fix mixing ops and notifications on one socket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/pyynl/lib/ynl.py | 39 ++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/tools/net/ynl/pyynl/lib/ynl.py b/tools/net/ynl/pyynl/lib/ynl.py
index dcc2c6b298d60..55b59f6c79b89 100644
--- a/tools/net/ynl/pyynl/lib/ynl.py
+++ b/tools/net/ynl/pyynl/lib/ynl.py
@@ -594,7 +594,7 @@ class YnlFamily(SpecFamily):
             scalar_selector = self._get_scalar(attr, value["selector"])
             attr_payload = struct.pack("II", scalar_value, scalar_selector)
         elif attr['type'] == 'sub-message':
-            msg_format = self._resolve_selector(attr, search_attrs)
+            msg_format, _ = self._resolve_selector(attr, search_attrs)
             attr_payload = b''
             if msg_format.fixed_header:
                 attr_payload += self._encode_struct(msg_format.fixed_header, value)
@@ -712,10 +712,10 @@ class YnlFamily(SpecFamily):
             raise Exception(f"No message format for '{value}' in sub-message spec '{sub_msg}'")
 
         spec = sub_msg_spec.formats[value]
-        return spec
+        return spec, value
 
     def _decode_sub_msg(self, attr, attr_spec, search_attrs):
-        msg_format = self._resolve_selector(attr_spec, search_attrs)
+        msg_format, _ = self._resolve_selector(attr_spec, search_attrs)
         decoded = {}
         offset = 0
         if msg_format.fixed_header:
@@ -787,7 +787,7 @@ class YnlFamily(SpecFamily):
 
         return rsp
 
-    def _decode_extack_path(self, attrs, attr_set, offset, target):
+    def _decode_extack_path(self, attrs, attr_set, offset, target, search_attrs):
         for attr in attrs:
             try:
                 attr_spec = attr_set.attrs_by_val[attr.type]
@@ -801,26 +801,37 @@ class YnlFamily(SpecFamily):
             if offset + attr.full_len <= target:
                 offset += attr.full_len
                 continue
-            if attr_spec['type'] != 'nest':
+
+            pathname = attr_spec.name
+            if attr_spec['type'] == 'nest':
+                sub_attrs = self.attr_sets[attr_spec['nested-attributes']]
+                search_attrs = SpaceAttrs(sub_attrs, search_attrs.lookup(attr_spec['name']))
+            elif attr_spec['type'] == 'sub-message':
+                msg_format, value = self._resolve_selector(attr_spec, search_attrs)
+                if msg_format is None:
+                    raise Exception(f"Can't resolve sub-message of {attr_spec['name']} for extack")
+                sub_attrs = self.attr_sets[msg_format.attr_set]
+                pathname += f"({value})"
+            else:
                 raise Exception(f"Can't dive into {attr.type} ({attr_spec['name']}) for extack")
             offset += 4
-            subpath = self._decode_extack_path(NlAttrs(attr.raw),
-                                               self.attr_sets[attr_spec['nested-attributes']],
-                                               offset, target)
+            subpath = self._decode_extack_path(NlAttrs(attr.raw), sub_attrs,
+                                               offset, target, search_attrs)
             if subpath is None:
                 return None
-            return '.' + attr_spec.name + subpath
+            return '.' + pathname + subpath
 
         return None
 
-    def _decode_extack(self, request, op, extack):
+    def _decode_extack(self, request, op, extack, vals):
         if 'bad-attr-offs' not in extack:
             return
 
         msg = self.nlproto.decode(self, NlMsg(request, 0, op.attr_set), op)
         offset = self.nlproto.msghdr_size() + self._struct_size(op.fixed_header)
+        search_attrs = SpaceAttrs(op.attr_set, vals)
         path = self._decode_extack_path(msg.raw_attrs, op.attr_set, offset,
-                                        extack['bad-attr-offs'])
+                                        extack['bad-attr-offs'], search_attrs)
         if path:
             del extack['bad-attr-offs']
             extack['bad-attr'] = path
@@ -1012,7 +1023,7 @@ class YnlFamily(SpecFamily):
         for (method, vals, flags) in ops:
             op = self.ops[method]
             msg = self._encode_message(op, vals, flags, req_seq)
-            reqs_by_seq[req_seq] = (op, msg, flags)
+            reqs_by_seq[req_seq] = (op, vals, msg, flags)
             payload += msg
             req_seq += 1
 
@@ -1027,9 +1038,9 @@ class YnlFamily(SpecFamily):
             self._recv_dbg_print(reply, nms)
             for nl_msg in nms:
                 if nl_msg.nl_seq in reqs_by_seq:
-                    (op, req_msg, req_flags) = reqs_by_seq[nl_msg.nl_seq]
+                    (op, vals, req_msg, req_flags) = reqs_by_seq[nl_msg.nl_seq]
                     if nl_msg.extack:
-                        self._decode_extack(req_msg, op, nl_msg.extack)
+                        self._decode_extack(req_msg, op, nl_msg.extack, vals)
                 else:
                     op = None
                     req_flags = []
-- 
2.39.5



