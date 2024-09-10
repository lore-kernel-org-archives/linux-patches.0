Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8C7224F6;
	Tue, 10 Sep 2024 09:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961896; cv=none; b=uyYr1lvMKuoLbutr+jebG/SXmc8ghGEAFA7diuikySIbvfWMkZ0QvcJovK+KNBu48vE2BraZfuDJB8d0oIbuGPs87atIoC//aBN/jdqO6Sawq0vshb8Mj6hm0BVFeEkK9QQPAUe/JxwrVPeF6gxbKwXMG09LVj4Mf/qTzw2ysi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961896; c=relaxed/simple;
	bh=J9ZbMTiSZRJNL+YwicjO08pzYKWk6d6qYM8lWDpEoWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FChn1zD9CtHyKJH3kPeUuSvJ7RBs4VCYzEUUFGodGpNLurlVysOx7U57VMj0qg1+PYrtFNWgjub6nxzK8SSW808k4hnKBtrLpWIeVLMH3Cmt7/+obf4YJlOoFkAu+rqU3zA+EZLpDzpU30y1vlvGqGt7vrZTfsLbwmkwO+2dJZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeGe2vPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeGe2vPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C837C4CEC3;
	Tue, 10 Sep 2024 09:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961896;
	bh=J9ZbMTiSZRJNL+YwicjO08pzYKWk6d6qYM8lWDpEoWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeGe2vPsxhMeqiUlVGvSFb8MY1fUPEh1V/TtDeexpWmmf7oL+W3pqieB0lgqsZqoF
	 hLOya39ZhI4to6Tl7tefxatw+36zMtrfmJuqfhumvO8u3SJGiuCNUgbebx7ckjE+78
	 fPPipnWt92a/wCNBMm80+YOUvRnYvOVhnbBFRf2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 198/375] tools/net/ynl: fix cli.py --subscribe feature
Date: Tue, 10 Sep 2024 11:29:55 +0200
Message-ID: <20240910092629.149925081@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit 6fda63c45fe8a0870226c13dcce1cc21b7c4d508 ]

Execution of command:
./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml /
	--subscribe "monitor" --sleep 10
fails with:
  File "/repo/./tools/net/ynl/cli.py", line 109, in main
    ynl.check_ntf()
  File "/repo/tools/net/ynl/lib/ynl.py", line 924, in check_ntf
    op = self.rsp_by_value[nl_msg.cmd()]
KeyError: 19

Parsing Generic Netlink notification messages performs lookup for op in
the message. The message was not yet decoded, and is not yet considered
GenlMsg, thus msg.cmd() returns Generic Netlink family id (19) instead of
proper notification command id (i.e.: DPLL_CMD_PIN_CHANGE_NTF=13).

Allow the op to be obtained within NetlinkProtocol.decode(..) itself if the
op was not passed to the decode function, thus allow parsing of Generic
Netlink notifications without causing the failure.

Suggested-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://lore.kernel.org/netdev/m2le0n5xpn.fsf@gmail.com/
Fixes: 0a966d606c68 ("tools/net/ynl: Fix extack decoding for directional ops")
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://patch.msgid.link/20240904135034.316033-1-arkadiusz.kubalewski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.py | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 35e666928119..ed7b6fff6999 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -388,6 +388,8 @@ class NetlinkProtocol:
 
     def decode(self, ynl, nl_msg, op):
         msg = self._decode(nl_msg)
+        if op is None:
+            op = ynl.rsp_by_value[msg.cmd()]
         fixed_header_size = ynl._struct_size(op.fixed_header)
         msg.raw_attrs = NlAttrs(msg.raw, fixed_header_size)
         return msg
@@ -919,8 +921,7 @@ class YnlFamily(SpecFamily):
                     print("Netlink done while checking for ntf!?")
                     continue
 
-                op = self.rsp_by_value[nl_msg.cmd()]
-                decoded = self.nlproto.decode(self, nl_msg, op)
+                decoded = self.nlproto.decode(self, nl_msg, None)
                 if decoded.cmd() not in self.async_msg_ids:
                     print("Unexpected msg id done while checking for ntf", decoded)
                     continue
@@ -978,7 +979,7 @@ class YnlFamily(SpecFamily):
                     if nl_msg.extack:
                         self._decode_extack(req_msg, op, nl_msg.extack)
                 else:
-                    op = self.rsp_by_value[nl_msg.cmd()]
+                    op = None
                     req_flags = []
 
                 if nl_msg.error:
-- 
2.43.0



