Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62753335BA1;
	Mon, 18 Aug 2025 13:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523999; cv=none; b=sPv5kHDV/QcbTElqDsmUiHyhznnnjt7Ro6R5cY94j23OOe77blnKnxhqKhy+67zCyZ/zRkXrpu83NsN0Pb1Fg3ABQW3whZ8ETWIUCiE1QpBetvYok4xbNYGTnQtxdhUnGn1Rm0bN2+ogXfcexcDM84BhfV5ZO9WR+8a+nqBAKoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523999; c=relaxed/simple;
	bh=FYzhuSMRN/2BWNUXYMRYJK0a0BIyR6AajjCK3E6Kq9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxQeYZJkWoGzuxkXtq8OYQufiyqidIPwszRgCxu25vNC4+BlBa6rmiWFhJvnH1rV6OHcM/fIZw0eiYOdfOdN8KegyLK0CMis6+UY4u9EizMrfXMZ88o3fjAJH4Ls2PDURZKpsqYEYEgAIBsG/5V5erc8l8nyGSSt0kyYuZGnPeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFGR8U3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFGR8U3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9395C4CEEB;
	Mon, 18 Aug 2025 13:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523999;
	bh=FYzhuSMRN/2BWNUXYMRYJK0a0BIyR6AajjCK3E6Kq9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFGR8U3XcWsWPASg+INlrl0qhmSapJZHh77I8rSvBDHbJzV7+BljHD3W1wlUdJvZ0
	 E0bQyBRk634HsCUoCAb3oN1N7hSR68cjT+h7T5IXQcm2GLCoFjqxs/VvJSDpJQl4rx
	 6MTGjJC8XKmnVc9veTvKF4GBvzC95jZg9Y5mc1HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 338/515] sphinx: kernel_abi: fix performance regression with O=<dir>
Date: Mon, 18 Aug 2025 14:45:24 +0200
Message-ID: <20250818124511.443498477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 2b16b71a05a7f056221751b906c13f8809656b1f ]

The logic there which adds a dependency note to Sphinx cache
is not taking into account that the build dir may not be
the source dir. This causes a performance regression:

$ time make O=/tmp/foo SPHINXDIRS=admin-guide htmldocs

	[OUTDATED]
	Added: set()
	Changed: {'abi-obsolete', 'abi-removed', 'abi-stable-files', 'abi-obsolete-files', 'abi-stable', 'abi', 'abi-removed-files', 'abi-testing-files', 'abi-testing', 'gpio/index', 'gpio/obsolete'}
	Removed: set()
	All docs count: 385
	Found docs count: 385

	real    0m11,324s
	user    0m15,783s
	sys     0m1,164s

To get the root cause of the problem (ABI files reported as changed),
I used this changeset:

#	diff --git a/Documentation/conf.py b/Documentation/conf.py
#	index e8766e689c1b..ab486623bd8b 100644
#	--- a/Documentation/conf.py
#	+++ b/Documentation/conf.py
#	@@ -571,3 +571,16 @@ def setup(app):
#	     """Patterns need to be updated at init time on older Sphinx versions"""
#
#	     app.connect('config-inited', update_patterns)
#	+    app.connect('env-get-outdated', on_outdated)
#	+
#	+def on_outdated(app, env, added, changed, removed):
#	+    """Track cache outdated due to added/changed/removed files"""
#	+    print("\n[OUTDATED]")
#	+    print(f"Added: {added}")
#	+    print(f"Changed: {changed}")
#	+    print(f"Removed: {removed}")
#	+    print(f"All docs count: {len(env.all_docs)}")
#	+    print(f"Found docs count: {len(env.found_docs)}")
#	+
#	+    # Just return what we have
#	+    return added | changed | removed

Reported-by: Akira Yokosawa <akiyks@gmail.com>
Closes: https://lore.kernel.org/linux-doc/c174f7c5-ec21-4eae-b1c3-f643cca90d9d@gmail.com/
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Tested-by: Akira Yokosawa <akiyks@gmail.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/e25673d87357457bc54ee863e97ff8f75956580d.1752752211.git.mchehab+huawei@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/sphinx/kernel_abi.py | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/sphinx/kernel_abi.py b/Documentation/sphinx/kernel_abi.py
index db6f0380de94..4c4375201b9e 100644
--- a/Documentation/sphinx/kernel_abi.py
+++ b/Documentation/sphinx/kernel_abi.py
@@ -146,8 +146,10 @@ class KernelCmd(Directive):
                 n += 1
 
             if f != old_f:
-                # Add the file to Sphinx build dependencies
-                env.note_dependency(os.path.abspath(f))
+                # Add the file to Sphinx build dependencies if the file exists
+                fname = os.path.join(srctree, f)
+                if os.path.isfile(fname):
+                    env.note_dependency(fname)
 
                 old_f = f
 
-- 
2.39.5



