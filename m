Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AFE3382DE;
	Mon, 20 Apr 2026 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700438; cv=none; b=m/jxniS6FWm4yJCPHXTcz5Bm+UCetK0S/gU+0uRU6GRCI7lObP2+blQ3TmyhgdWM3gm5rH0kcmj6jwHI4CtZmLNDCRLVWlXV4TkvcaA6BtiA5T6R3E4ZrE1WDeJR1pVLbWJhig2IeX/t3/kblm/D5F+J6AbyBv/3QsuUYkAsbJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700438; c=relaxed/simple;
	bh=b2zRrafx/CkRmYV95ZstBDnmjm4RETp5kPlNheqodQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFtx+5e5/cDNl5HXmCbNxDHr2PKKvpEizk2Mlbn+2c8/Kn31x+S8wYBtXbfSvZUsej71Q56rEt6a1o0qkogXeJb9ot4xq9b6U0bShM7mh39GJ/XGBCEIMsVrUEQMOT6KHwzLbuIP+PjKVJOqSoP7PBLEvbEtMzEachG8oGT1w48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogtYHi79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogtYHi79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE903C2BCB4;
	Mon, 20 Apr 2026 15:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700438;
	bh=b2zRrafx/CkRmYV95ZstBDnmjm4RETp5kPlNheqodQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogtYHi79vfLrOCTK8KbXa1Lp2qVNUD9LcwN5uO+EJE4ormUaLrXv6Ez7Z7DmqkSj9
	 2trD01cmeiTLJLgaQ9tItux0HUZBea+8ILr1mUDPo4BudPZ9gI0IHTejmeN8+gn/3F
	 3mEwlqOz9DcQTHlBc1DspMV2O3E+tn7pgffid10A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Fiona Behrens <me@kloenk.dev>,
	Trevor Gross <tmgross@umich.edu>,
	Tamir Duberstein <tamird@kernel.org>
Subject: [PATCH 6.19 171/220] scripts: generate_rust_analyzer.py: avoid FD leak
Date: Mon, 20 Apr 2026 17:41:52 +0200
Message-ID: <20260420153940.183276434@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -190,9 +190,10 @@ def generate_crates(srctree, objtree, sy
 
     def is_root_crate(build_file, target):
         try:
-            return f"{target}.o" in open(build_file).read()
+            contents = build_file.read_text()
         except FileNotFoundError:
             return False
+        return f"{target}.o" in contents
 
     # Then, the rest outside of `rust/`.
     #


