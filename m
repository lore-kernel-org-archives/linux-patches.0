Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C8A333445;
	Mon, 20 Apr 2026 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701555; cv=none; b=XdsZd1UQ5U13IEKR8U91jCIm13tdOH+CKNC2XurX7rrKgFVED0I/wiwpCPy1E8EizxKFOwvXEI253+5gjfPvN4g4CJMDG3lh9Q+TwxMPpXa1xgfYPwzjtd3LNv0B4ASBgD1XC5w+/r9z08sgKoVvtc5faFo9l94pffi7+Xg0Xdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701555; c=relaxed/simple;
	bh=Ja92mSMTBxpy6V8E6IVy0OVL8TfBsRg7QIforuh423k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASAkmMFNsQAIeiRlUoPc7zGFPgEp3hOWTroWjx2hT8QPmiWMv48jlQhLbh+mNIpY7H+0lZsPr3D8vpFF4zRV+lS3ZB12I9tJZEFe/cNFEoivgcIDaqWMyVLg/MN6uBuBo4RmQGFA+RD3+yUfWDhsu3/N0t9p8l6Pn5hVhoK+QkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prAcIplW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prAcIplW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0BFC19425;
	Mon, 20 Apr 2026 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701554;
	bh=Ja92mSMTBxpy6V8E6IVy0OVL8TfBsRg7QIforuh423k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prAcIplWz3qdxGXquO8MZEcCAjAvdKOcT3GpagX/n3JxXHaCtTrjnIkb4/LHpA8Z0
	 SOgFDQxIgyhQjLDqramkNTJGr/KZACO8kVT0y28NROYzgGnb4JR/c+hXVQ/gcQlGWK
	 ZEsKmrPDMvQIWRReLdYAE0Yc1uQMcbyDBeTO8gB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Fiona Behrens <me@kloenk.dev>,
	Trevor Gross <tmgross@umich.edu>,
	Tamir Duberstein <tamird@kernel.org>
Subject: [PATCH 6.12 117/162] scripts: generate_rust_analyzer.py: avoid FD leak
Date: Mon, 20 Apr 2026 17:42:29 +0200
Message-ID: <20260420153931.280074704@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -146,9 +146,10 @@ def generate_crates(srctree, objtree, sy
 
     def is_root_crate(build_file, target):
         try:
-            return f"{target}.o" in open(build_file).read()
+            contents = build_file.read_text()
         except FileNotFoundError:
             return False
+        return f"{target}.o" in contents
 
     # Then, the rest outside of `rust/`.
     #


