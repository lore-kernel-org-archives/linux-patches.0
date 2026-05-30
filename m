Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A443438AE;
	Sat, 30 May 2026 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158725; cv=none; b=eVkWvxwK22YCB0QvBv1RrXFsuURptCG18RfP73qohdfm8Qvh8xeFCRMnC4PofIXMLZ9MEan/RSM4WYKilMPXWGXRInapGB4O5g6DigjynfH2GgcAqo82WyHW0ts76NyLhz1Seem7ah6Dtewg0sCkNZ3p/UifJgyANhoIxVVQltE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158725; c=relaxed/simple;
	bh=eKVRggwKGnzFjMUb8w3ptpl7Mwo9dOG56SZOKZH6O2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXsfoiyEayqqk+5iihV+e5G/3Q76aN7R5W8ljGe8hhg5jQCh9YV2lIhg+bZNqJ1pnWjisJFlFVagOpZuCJdKFSdB9fOykDu5F/7UwEuilhwsLrFLsKcLNMWc49RGwlYkjtch+yMz5jvsRA2LL8iCm7ytzXAvIto7Ydp18cBif2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGiETMmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGiETMmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEDE1F00893;
	Sat, 30 May 2026 16:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158723;
	bh=JCNGA0CJquvOjPBTnHHVVuycn9WaTufVcjczqrHOEZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EGiETMmIoaFdXhBxCFQLUNfxJ+7pfWDDKGsRLJS+vxLEBmLTmwz0GlstRO91lVkKJ
	 jYx7afTMlBm4nifwo5aM++K4xaiDyGZScuClNEZvD8ymSTZKOXmRCL02GkCY8bkxTr
	 AVLoSU4KAL6vBbtWGVQO0cZdc3XH/jNn7UXaSkAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Fiona Behrens <me@kloenk.dev>,
	Trevor Gross <tmgross@umich.edu>,
	Tamir Duberstein <tamird@kernel.org>
Subject: [PATCH 6.1 077/969] scripts: generate_rust_analyzer.py: avoid FD leak
Date: Sat, 30 May 2026 17:53:21 +0200
Message-ID: <20260530160302.477993811@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@kernel.org>

commit 9b4744d8eda2824041064a5639ccbb079850914d upstream.

Use `pathlib.Path.read_text()` to avoid leaking file descriptors.

Fixes: 8c4555ccc55c ("scripts: add `generate_rust_analyzer.py`")
Cc: stable@vger.kernel.org
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Fiona Behrens <me@kloenk.dev>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Link: https://patch.msgid.link/20260127-rust-analyzer-fd-leak-v2-1-1bb55b9b6822@kernel.org
Signed-off-by: Tamir Duberstein <tamird@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_analyzer.py |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -115,9 +115,10 @@ def generate_crates(srctree, objtree, sy
 
     def is_root_crate(build_file, target):
         try:
-            return f"{target}.o" in open(build_file).read()
+            contents = build_file.read_text()
         except FileNotFoundError:
             return False
+        return f"{target}.o" in contents
 
     # Then, the rest outside of `rust/`.
     #


