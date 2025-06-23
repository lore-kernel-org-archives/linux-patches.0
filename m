Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403193597E;
	Mon, 23 Jun 2025 22:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716488; cv=none; b=eFLi4ZuRWZJUQ91w7O1TkWehkTo6/yQ9n+KieztVdgjdhGQspZpJJzISrdHE/daYftkk9qornnWwA7YDeFx6zhCMnKMiftr5tOGEQwDgtAsJfBrBamoaleCw0BKx9MzLy4p27wYvdD1RqiKM7QUV3DfTxOauH3gKiXiPhfaD/wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716488; c=relaxed/simple;
	bh=3dUh7VGUbVpoUh1+058CUtxrV5Vp4aGAz3TYkHhaQLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5ercFgnKawW4CehuEF2DkxI/z/Y+STXe14NoqzEMd8wWvN77345qWFLt3wFUynwiTSpAownUwr8SLLXxSKy90Y8KZmWM+S9NrDh61Qzl0RXENLuQj/qLR4dOSUdSS6zeQkQUeGplw7PU/xO/QR0lz4CYDtEPbgF5XCmDxO/kfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYgAKIn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYgAKIn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFB0C4CEEA;
	Mon, 23 Jun 2025 22:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716488;
	bh=3dUh7VGUbVpoUh1+058CUtxrV5Vp4aGAz3TYkHhaQLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYgAKIn9lY5V79O/1Ej1NMbBOBEVUlw/5GSYgKBpHlBfyvwSSe0wxYkDfGiYE3TNo
	 9TCeeLhZKo6KMu9Asjwe+fua43Gpkr5FArJUh2mcXM/moqbf1V29FgA4qDcRCg0wi9
	 wEAwNb/C62ZCsVfi7WaJ46TAJ6BtlmPvi9PWEp5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 555/592] tools: ynl: fix mixing ops and notifications on one socket
Date: Mon, 23 Jun 2025 15:08:33 +0200
Message-ID: <20250623130713.646326850@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 9738280aae592b579a25b5b1b6584c894827d3c7 ]

The multi message support loosened the connection between the request
and response handling, as we can now submit multiple requests before
we start processing responses. Passing the attr set to NlMsgs decoding
no longer makes sense (if it ever did), attr set may differ message
by messsage. Isolate the part of decoding responsible for attr-set
specific interpretation and call it once we identified the correct op.

Without this fix performing SET operation on an ethtool socket, while
being subscribed to notifications causes:

 # File "tools/net/ynl/pyynl/lib/ynl.py", line 1096, in _op
 # Exception|     return self._ops(ops)[0]
 # Exception|            ~~~~~~~~~^^^^^
 # File "tools/net/ynl/pyynl/lib/ynl.py", line 1040, in _ops
 # Exception|     nms = NlMsgs(reply, attr_space=op.attr_set)
 # Exception|                                    ^^^^^^^^^^^

The value of op we use on line 1040 is stale, it comes form the previous
loop. If a notification comes before a response we will update op to None
and the next iteration thru the loop will break with the trace above.

Fixes: 6fda63c45fe8 ("tools/net/ynl: fix cli.py --subscribe feature")
Fixes: ba8be00f68f5 ("tools/net/ynl: Add multi message support to ynl")
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://patch.msgid.link/20250618171746.1201403-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/pyynl/lib/ynl.py | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/tools/net/ynl/pyynl/lib/ynl.py b/tools/net/ynl/pyynl/lib/ynl.py
index 55b59f6c79b89..61deb59230671 100644
--- a/tools/net/ynl/pyynl/lib/ynl.py
+++ b/tools/net/ynl/pyynl/lib/ynl.py
@@ -231,14 +231,7 @@ class NlMsg:
                     self.extack['unknown'].append(extack)
 
             if attr_space:
-                # We don't have the ability to parse nests yet, so only do global
-                if 'miss-type' in self.extack and 'miss-nest' not in self.extack:
-                    miss_type = self.extack['miss-type']
-                    if miss_type in attr_space.attrs_by_val:
-                        spec = attr_space.attrs_by_val[miss_type]
-                        self.extack['miss-type'] = spec['name']
-                        if 'doc' in spec:
-                            self.extack['miss-type-doc'] = spec['doc']
+                self.annotate_extack(attr_space)
 
     def _decode_policy(self, raw):
         policy = {}
@@ -264,6 +257,18 @@ class NlMsg:
                 policy['mask'] = attr.as_scalar('u64')
         return policy
 
+    def annotate_extack(self, attr_space):
+        """ Make extack more human friendly with attribute information """
+
+        # We don't have the ability to parse nests yet, so only do global
+        if 'miss-type' in self.extack and 'miss-nest' not in self.extack:
+            miss_type = self.extack['miss-type']
+            if miss_type in attr_space.attrs_by_val:
+                spec = attr_space.attrs_by_val[miss_type]
+                self.extack['miss-type'] = spec['name']
+                if 'doc' in spec:
+                    self.extack['miss-type-doc'] = spec['doc']
+
     def cmd(self):
         return self.nl_type
 
@@ -277,12 +282,12 @@ class NlMsg:
 
 
 class NlMsgs:
-    def __init__(self, data, attr_space=None):
+    def __init__(self, data):
         self.msgs = []
 
         offset = 0
         while offset < len(data):
-            msg = NlMsg(data, offset, attr_space=attr_space)
+            msg = NlMsg(data, offset)
             offset += msg.nl_len
             self.msgs.append(msg)
 
@@ -1034,12 +1039,13 @@ class YnlFamily(SpecFamily):
         op_rsp = []
         while not done:
             reply = self.sock.recv(self._recv_size)
-            nms = NlMsgs(reply, attr_space=op.attr_set)
+            nms = NlMsgs(reply)
             self._recv_dbg_print(reply, nms)
             for nl_msg in nms:
                 if nl_msg.nl_seq in reqs_by_seq:
                     (op, vals, req_msg, req_flags) = reqs_by_seq[nl_msg.nl_seq]
                     if nl_msg.extack:
+                        nl_msg.annotate_extack(op.attr_set)
                         self._decode_extack(req_msg, op, nl_msg.extack, vals)
                 else:
                     op = None
-- 
2.39.5



