Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B7533EAF9;
	Mon, 20 Apr 2026 16:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701021; cv=none; b=gAmaJpPCM2KJO53DS6CZWY+uc+A3c3sVFjDfpGUCi14bef/Rmyk4ZZZPUBTXnQ+9A+fC4D5jbJYj35LR3NMB4TjLcKptcW2R+wWkuYK+GNQ+MFHRX5LQBQdeyKAcXAlAjapz+kvM6KEDrbUDAioQvb/hPbIWG8MmGceD68lb5wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701021; c=relaxed/simple;
	bh=74ky5X6xQL4pQV4Y1fN4C7ITBle5ET0j4jUD0JRZ7dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUejQ2Rmg1UjbYexmnL1M/2obrFyT87jG+bl1IPwQPJWnMKzof4HIDFdWzjFOJ8BDgs/yBBSkXAgOHaXzi8MS4DieNfnhNEHW98PrRJkTCeSL8i2MxluWEePWmkkWlg+OGl53D4J2ahkm/qCfLLnM7AvfA6JTZD3H4WGHelKi2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOABzS9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOABzS9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7039C19425;
	Mon, 20 Apr 2026 16:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701021;
	bh=74ky5X6xQL4pQV4Y1fN4C7ITBle5ET0j4jUD0JRZ7dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOABzS9FqKDJp2ieDm/8BI4Oxg4g5H8ajoIm/2m+cEHv9LafoxrsUvZhzCu2oTOD4
	 0Vp0htNpLZX4aIbgfSadXW6wRds+N2ovaXfpj3msIJYZi3K8lx54vW9H3TmIOPHMUz
	 jyMyLoG1YKl/qvBIAInbB/WEWzb3JsgPi5CQmmF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Fiona Behrens <me@kloenk.dev>,
	Trevor Gross <tmgross@umich.edu>,
	Tamir Duberstein <tamird@kernel.org>
Subject: [PATCH 6.18 151/198] scripts: generate_rust_analyzer.py: avoid FD leak
Date: Mon, 20 Apr 2026 17:42:10 +0200
Message-ID: <20260420153941.044039182@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -168,9 +168,10 @@ def generate_crates(srctree, objtree, sy
 
     def is_root_crate(build_file, target):
         try:
-            return f"{target}.o" in open(build_file).read()
+            contents = build_file.read_text()
         except FileNotFoundError:
             return False
+        return f"{target}.o" in contents
 
     # Then, the rest outside of `rust/`.
     #


