Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCBA35A930;
	Fri,  9 Jan 2026 12:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960677; cv=none; b=JNCndvCJFrgLM9w1WLMHKT4IIgEOEHuEQOpDKsVyYZn60ljSYSfehCfncWKOcI3HKrhH1AA8/+4Ze6k3SjsvGkJ3BBdAx5adnWnRQxRTF0un3jgRjwrdCCbPdyiIdXYfbqacER2WhZ97NKKt9/wwXi33PuxemVthpYGOu+/Oz98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960677; c=relaxed/simple;
	bh=JO0QKjxvHnQnF+7EgAJsbSGjkUdSAGFhBPhAPxnqrCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8pNPI+hof0xLIaAGWihodB5gdCZjMwuIWl/gG9Cdc2VcNYckHfquf1oWY9ndi/twvdIEpYF9C7YkMGWGxLxHilffyimI7kYhBpkx8TpjRGKsmebOfKkpL53RDaojphArQvR0uWIOaMxQIyG2a5iqDJgy/xoHmHATsC8L1gYwzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uP2Yr1GC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uP2Yr1GC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A560C16AAE;
	Fri,  9 Jan 2026 12:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960677;
	bh=JO0QKjxvHnQnF+7EgAJsbSGjkUdSAGFhBPhAPxnqrCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uP2Yr1GCOIdpPchUPxYbRvVkcJGpXGWXs5H8JNTL0p1eWc2/3mgbAC2F3Xtryeiw/
	 ypPOJQlbx/KGLNif6crkFTXz0UzRHJMx+yvzs+7DUk9IjxNps2xuu1W6CYmgk4JNio
	 z+6hJ29KhHT7In4UrHgeJuyEM1EsN/Lmdn3Ri7q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Moreno <amorenoz@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Adrian Yip <adrian.ytw@gmail.com>
Subject: [PATCH 6.6 486/737] selftests: openvswitch: Fix escape chars in regexp.
Date: Fri,  9 Jan 2026 12:40:25 +0100
Message-ID: <20260109112152.268215539@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Moreno <amorenoz@redhat.com>

commit 3fde60afe1f84746c1177861bd27b3ebb00cb8f5 upstream.

Character sequences starting with `\` are interpreted by python as
escaped Unicode characters. However, they have other meaning in
regular expressions (e.g: "\d").

It seems Python >= 3.12 starts emitting a SyntaxWarning when these
escaped sequences are not recognized as valid Unicode characters.

An example of these warnings:

tools/testing/selftests/net/openvswitch/ovs-dpctl.py:505:
SyntaxWarning: invalid escape sequence '\d'

Fix all the warnings by flagging literals as raw strings.

Signed-off-by: Adrian Moreno <amorenoz@redhat.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://lore.kernel.org/r/20240416090913.2028475-1-amorenoz@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Adrian Yip <adrian.ytw@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/openvswitch/ovs-dpctl.py |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -489,7 +489,7 @@ class ovsactions(nla):
                     actstr, reason = parse_extract_field(
                         actstr,
                         "drop(",
-                        "([0-9]+)",
+                        r"([0-9]+)",
                         lambda x: int(x, 0),
                         False,
                         None,
@@ -502,9 +502,9 @@ class ovsactions(nla):
                     actstr = actstr[len("drop"): ]
                     return (totallen - len(actstr))
 
-            elif parse_starts_block(actstr, "^(\d+)", False, True):
+            elif parse_starts_block(actstr, r"^(\d+)", False, True):
                 actstr, output = parse_extract_field(
-                    actstr, None, "(\d+)", lambda x: int(x), False, "0"
+                    actstr, None, r"(\d+)", lambda x: int(x), False, "0"
                 )
                 self["attrs"].append(["OVS_ACTION_ATTR_OUTPUT", output])
                 parsed = True
@@ -512,7 +512,7 @@ class ovsactions(nla):
                 actstr, recircid = parse_extract_field(
                     actstr,
                     "recirc(",
-                    "([0-9a-fA-Fx]+)",
+                    r"([0-9a-fA-Fx]+)",
                     lambda x: int(x, 0),
                     False,
                     0,
@@ -588,17 +588,17 @@ class ovsactions(nla):
                                 actstr = actstr[3:]
 
                             actstr, ip_block_min = parse_extract_field(
-                                actstr, "=", "([0-9a-fA-F\.]+)", str, False
+                                actstr, "=", r"([0-9a-fA-F\.]+)", str, False
                             )
                             actstr, ip_block_max = parse_extract_field(
-                                actstr, "-", "([0-9a-fA-F\.]+)", str, False
+                                actstr, "-", r"([0-9a-fA-F\.]+)", str, False
                             )
 
                             actstr, proto_min = parse_extract_field(
-                                actstr, ":", "(\d+)", int, False
+                                actstr, ":", r"(\d+)", int, False
                             )
                             actstr, proto_max = parse_extract_field(
-                                actstr, "-", "(\d+)", int, False
+                                actstr, "-", r"(\d+)", int, False
                             )
 
                             if t is not None:


