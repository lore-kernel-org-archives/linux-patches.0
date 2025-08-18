Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A9E31B11A;
	Mon, 18 Aug 2025 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525787; cv=none; b=KH+Ue+9CN03pl3ljDWuUrdUdWgk0eN8xvh+mpnIvZkaBSoxpAEx9FMQy9vpoA4f8DmXojviocpSfzYGPbbaVor1iuzYKB45wFJrCB8vGc1dJCegQ1qTGuQkCcfBES98zOMR4DJY6TLquFgldTQ3rgMz/P0lNG/rnfI8gjDfyt0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525787; c=relaxed/simple;
	bh=XUJnb3FDMe7bLh9ictAtreLNox21ZQB1xXMyCoqfYEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZg0cVWgNlGaJjluChZYY7AfWVR1XhLpBK+KSFECV48PLOuw70ZKksDB/0W02Gn7tu8/OpfEGCCYT9lzxiwmQBXWP7dX3VxouTRO+rutujf0OXX1QmIQYPfgDV0F8x6jUPHcDfTU7YMTP10+w5Yvmpp2tXOh8AYd4jY+Qm8soBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eiivx/f6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eiivx/f6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DAAC4CEEB;
	Mon, 18 Aug 2025 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525787;
	bh=XUJnb3FDMe7bLh9ictAtreLNox21ZQB1xXMyCoqfYEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eiivx/f6esROpfiZhRpv05nTpPwa3ASEnRcTyswcKEM9ZFcFdRUXx34bx7hq6OdiX
	 7o8w47/8a0TpC4HWzOSRa+kbGTP2deXEegVrnivgiav0nGs/HqUDbZv5lvuY2cjRdd
	 jPbXIdnJOShuAkm1ifBTaRqXBDSlWHR0z2n3EK7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 366/570] sphinx: kernel_abi: fix performance regression with O=<dir>
Date: Mon, 18 Aug 2025 14:45:53 +0200
Message-ID: <20250818124519.960459256@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



