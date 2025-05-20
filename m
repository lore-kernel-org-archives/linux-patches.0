Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947B0247289;
	Tue, 20 May 2025 14:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749720; cv=none; b=MyKrF7KScbc4PZp+2UQyq2A5+SKNSBWHP5GAK44eCzHA5GEWP/A5BQThSJgx72UIX66XybGVcZYyM9ldqVjcjZaCL1Bfdmw3BivVKCfIce5hy7tbAii5yR3v0Jie9GnG7D8gN/EK4EsW/cKU+7Y3srWppMTnO2KNcR98uxXV80w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749720; c=relaxed/simple;
	bh=Ed4FtVhTZ1yWuQn1nS37wJWt6NcFbIWF/KSHJGP7srI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jtbudu7nfgCstSOEfVG/blIX90Qz2Ud0ic9i/sp5z5HcKr7mbw8a/H8AQ+Sgyj/3D2qvuSWyx6Yqy1Uk0hO7mqEmBwI95qOHkdEU3sQI+uvuavFSbOtVoC5NEoH7fDznlio8vFiCCJ7zSacVKEQu/D4f4U0IfPhqB+S/tcNTAds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaJLKCD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaJLKCD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA18C4CEEB;
	Tue, 20 May 2025 14:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749720;
	bh=Ed4FtVhTZ1yWuQn1nS37wJWt6NcFbIWF/KSHJGP7srI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xaJLKCD6qSrevjpuCgmE3SE8ntcnLm7271PT7CgsYzECoDlVD0o9gGKa1wfUTywgu
	 XeT3iJaO+LGx2oQoa9g2MCoEmRtoNcH+FiiT0sZsZgWo1ho1In35XZAvFEqwX8YTJb
	 h8l8t/bvRrH25F8D669COKmtSi5qygcbi8ADrM+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/117] tools/net/ynl: ethtool: fix crash when Hardware Clock info is missing
Date: Tue, 20 May 2025 15:50:03 +0200
Message-ID: <20250520125805.502145014@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 45375814eb3f4245956c0c85092a4eee4441d167 ]

Fix a crash in the ethtool YNL implementation when Hardware Clock information
is not present in the response. This ensures graceful handling of devices or
drivers that do not provide this optional field. e.g.

  Traceback (most recent call last):
    File "/net/tools/net/ynl/pyynl/./ethtool.py", line 438, in <module>
      main()
      ~~~~^^
    File "/net/tools/net/ynl/pyynl/./ethtool.py", line 341, in main
      print(f'PTP Hardware Clock: {tsinfo["phc-index"]}')
                                   ~~~~~~^^^^^^^^^^^^^
  KeyError: 'phc-index'

Fixes: f3d07b02b2b8 ("tools: ynl: ethtool testing tool")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250508035414.82974-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/ethtool.py | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/net/ynl/ethtool.py b/tools/net/ynl/ethtool.py
index 47264ae20036b..ffd8eb6d19048 100755
--- a/tools/net/ynl/ethtool.py
+++ b/tools/net/ynl/ethtool.py
@@ -333,16 +333,24 @@ def main():
         print('Capabilities:')
         [print(f'\t{v}') for v in bits_to_dict(tsinfo['timestamping'])]
 
-        print(f'PTP Hardware Clock: {tsinfo["phc-index"]}')
+        print(f'PTP Hardware Clock: {tsinfo.get("phc-index", "none")}')
 
-        print('Hardware Transmit Timestamp Modes:')
-        [print(f'\t{v}') for v in bits_to_dict(tsinfo['tx-types'])]
+        if 'tx-types' in tsinfo:
+            print('Hardware Transmit Timestamp Modes:')
+            [print(f'\t{v}') for v in bits_to_dict(tsinfo['tx-types'])]
+        else:
+            print('Hardware Transmit Timestamp Modes: none')
+
+        if 'rx-filters' in tsinfo:
+            print('Hardware Receive Filter Modes:')
+            [print(f'\t{v}') for v in bits_to_dict(tsinfo['rx-filters'])]
+        else:
+            print('Hardware Receive Filter Modes: none')
 
-        print('Hardware Receive Filter Modes:')
-        [print(f'\t{v}') for v in bits_to_dict(tsinfo['rx-filters'])]
+        if 'stats' in tsinfo and tsinfo['stats']:
+            print('Statistics:')
+            [print(f'\t{k}: {v}') for k, v in tsinfo['stats'].items()]
 
-        print('Statistics:')
-        [print(f'\t{k}: {v}') for k, v in tsinfo['stats'].items()]
         return
 
     print(f'Settings for {args.device}:')
-- 
2.39.5



