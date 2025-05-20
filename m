Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7ED242907;
	Tue, 20 May 2025 14:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750083; cv=none; b=J1tcfYEsxtRkFcYXWD4tslvTueYVdjhSbpjRO3yRkjIx3G3ptNGA/VBNLouD5UGSMXFyr39kMYVlC4P8YhPObuRjqS/c6MM55A8iFU/hc407BtiIRR7460nBqDWSC2J/JjU0uxvgtXoGk/3MRHutJ58kfvglL0iDSz2tjalAYi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750083; c=relaxed/simple;
	bh=UaVMNLLrlXf9VYGH2XJVV+uk8mOVLVnD8kzKwoSgNfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRaVJWBdHHWfMev3r8OCLU9kdt4tzQ1L+XS4eFrQCgqoQ+2HmqnXyeDNRQXasfoDPpevKha456CYMbzLLbZA6QjmMobgxN+vltG71DcgmOnB+PwHJ8VV4mC7Y811IHEJzAosrU5y8Pe/v7qvEuF08x6E8vSnlbGCxQmrJOtivgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=er/P8X9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="er/P8X9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26887C4CEE9;
	Tue, 20 May 2025 14:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750082;
	bh=UaVMNLLrlXf9VYGH2XJVV+uk8mOVLVnD8kzKwoSgNfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=er/P8X9Lw71vMigo9i8G15MJwOmeEJSn+02wOhVOatbJxRt/6ePo2CuM7WxpUsqbJ
	 eqBNrtMBxJxAZc24JtfiD+0rMvvgDEvTXoU+mzTqj8BzVvpZBg1En51kLy3YafiMA7
	 4z2a6cZE5oZ5Mrb4k0ikUqpM8acHIJmwGqWRUyt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/143] tools/net/ynl: ethtool: fix crash when Hardware Clock info is missing
Date: Tue, 20 May 2025 15:49:50 +0200
Message-ID: <20250520125811.439362270@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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
index 63c471f075abf..7e8342f914816 100755
--- a/tools/net/ynl/ethtool.py
+++ b/tools/net/ynl/ethtool.py
@@ -337,16 +337,24 @@ def main():
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



