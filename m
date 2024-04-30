Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B091292C8;
	Tue, 30 Apr 2024 10:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474131; cv=none; b=BkZrTHmWV6ATckxno2HE4XLTpaTAHIirzeTWXaBSPMeWhaxC0GXyyIjEKSo/tFB8x31VL55CnCV1uU1gL6+cXxRrqlYleHbalUlmLW2eckZ6SzFIHunnOZij5koRE05X+9Ux0GlQCvadc++hB0ijx0uDtghPWWvqyCSbrZTB+2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474131; c=relaxed/simple;
	bh=wtW+8VE/MoDCLZLVGPXbA78dhDkRDMBtC6pG7Gq/u8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4I9ZE47c60xENdorwbFvE6aVP9Sz0JDdL48HViJ8VUnSODs82AFRH5aE4NWVU20BDTmIHbTOZtdaKtt3XXMDdxelG6tJHkrQB3TZoPKBv+Q7jVyYeai4Fiae+d/xvt0ESF2YA1UsupDcaB7uvNHFThxWV1W4cTUDTE09f0dmgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDEKLanK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDEKLanK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70418C2BBFC;
	Tue, 30 Apr 2024 10:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474130;
	bh=wtW+8VE/MoDCLZLVGPXbA78dhDkRDMBtC6pG7Gq/u8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDEKLanKWB1S8ofTzXsiHGs46wR44Su7CoxnFoVMJDzhH2oEmNHh6eLCfa/wgGHGG
	 yiC21ukVIRm1BiA+l+7QwU8h5/K+A/whEcaqv9ZuanV0MF3rilSflPfquvOPA7nXy1
	 ZGdPGRNgR7He4uVry0axoxJ5G+WhR1ECjm4pxQn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 066/228] tools: ynl: dont ignore errors in NLMSG_DONE messages
Date: Tue, 30 Apr 2024 12:37:24 +0200
Message-ID: <20240430103105.712310930@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a44f2eb106a46f2275a79de54ce0ea63e4f3d8c8 ]

NLMSG_DONE contains an error code, it has to be extracted.
Prior to this change all dumps will end in success,
and in case of failure the result is silently truncated.

Fixes: e4b48ed460d3 ("tools: ynl: add a completely generic client")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://lore.kernel.org/r/20240420020827.3288615-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 1e10512b2117c..571c2e218993f 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -208,6 +208,7 @@ class NlMsg:
             self.done = 1
             extack_off = 20
         elif self.nl_type == Netlink.NLMSG_DONE:
+            self.error = struct.unpack("i", self.raw[0:4])[0]
             self.done = 1
             extack_off = 4
 
-- 
2.43.0



