Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141842571DC;
	Tue, 25 Mar 2025 12:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905725; cv=none; b=TqXux7Q5RASZ47hJleeD1Vmm5glDV7ys9nOYQgViwNAoOjqVVCQwr7gthWv8GHhBO/xMNCIQ8SIfrV34NhVq1T8Tolz7VkEDBmkzHnoxRGP3GsegRzWUiFZ7gr/BR45jTJwhzLMxyNzXQk/DXmQb6s9PvgiGM4otQUZdN1Z7x4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905725; c=relaxed/simple;
	bh=AUcjFZkc+E3vNmDATh+VA9BkGqKqjgUD/ZmjxB2AKP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8jXEwbiRjIN5jiYKi1nT6h1LT73+HsVji6szOXALPqYouVu0tN30SVa/fkh8oUPpEKRWZSeVCzi7R3XuCjwq4yhyoT2+I8IlJmtN4bj/PD7iY3OZorSgsKs3SrpKTFbbJul/oj8MXmEScGsheMOjF+//oC4ahWGPNM87MIvGKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLDMBtdN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLDMBtdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DFCC4CEE4;
	Tue, 25 Mar 2025 12:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905724;
	bh=AUcjFZkc+E3vNmDATh+VA9BkGqKqjgUD/ZmjxB2AKP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLDMBtdNdQcnx9SrDXlfM1CEF2WK8prd8Up3/iqh4SRH8O3FeJWwCz/0BD2ogtCKc
	 1/vPIEqhNg4Qdg41et08Svjt0Tpp2BkoOBkt6I0pk2BsBtket3VKn3wAJTaHx6CNQ1
	 Umrei9vyFvAM+xV8/dbHAi9Mh/gr30BiFpqmtKhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asahi Lina <lina@asahilina.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/198] scripts: generate_rust_analyzer: Handle sub-modules with no Makefile
Date: Tue, 25 Mar 2025 08:21:31 -0400
Message-ID: <20250325122200.036618637@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asahi Lina <lina@asahilina.net>

[ Upstream commit 5c7548d5a25306dcdb97689479be81cacc8ce596 ]

More complex drivers might want to use modules to organize their Rust
code, but those module folders do not need a Makefile.
generate_rust_analyzer.py currently crashes on those. Fix it so that a
missing Makefile is silently ignored.

Link: https://github.com/Rust-for-Linux/linux/pull/883
Signed-off-by: Asahi Lina <lina@asahilina.net>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Stable-dep-of: 2e0f91aba507 ("scripts: generate_rust_analyzer: add missing macros deps")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/generate_rust_analyzer.py | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/generate_rust_analyzer.py b/scripts/generate_rust_analyzer.py
index 75bb611bd7516..ab6af280b9de0 100755
--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -98,7 +98,10 @@ def generate_crates(srctree, objtree, sysroot_src):
             name = path.name.replace(".rs", "")
 
             # Skip those that are not crate roots.
-            if f"{name}.o" not in open(path.parent / "Makefile").read():
+            try:
+                if f"{name}.o" not in open(path.parent / "Makefile").read():
+                    continue
+            except FileNotFoundError:
                 continue
 
             logging.info("Adding %s", name)
-- 
2.39.5



