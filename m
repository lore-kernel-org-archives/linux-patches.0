Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A783519A288;
	Fri, 24 Apr 2026 13:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037924; cv=none; b=D/dvQ3BwkqOSz4BOYuARoB3PdspItmO9KdxppdGW44rs6FXpDEeQWQsN4pTWs8WlzFsFKOtuJkDF6QFE2LnE5s5G/lrulamQ6UuQkCSNlw+AWxwahK4z/HUEZzj7rdxs5igD+JEiAmmVC68QthU1Q8CMmeqd8T6mh/WRBLRwwTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037924; c=relaxed/simple;
	bh=QF+379hpvxX6v7OPKhkdGb2zs04PuPYQWHk6v+v/O8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0eGTOo4npWU2PTjUYlQleh8NVS1IOsO+plMSb0MJmE1VjS1qx3iu71y9FHRwq5PtQdTYhbSz4aOeMuMBHurbddP6E+c7/VKJT6XtyqslrzjpzHAGsRttpS5FqBxsjtUB2UZhHjvsyRSzul7dHwJ7D0fbUDcs2r27jWz6NDolF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REylkVVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REylkVVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0073CC19425;
	Fri, 24 Apr 2026 13:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037924;
	bh=QF+379hpvxX6v7OPKhkdGb2zs04PuPYQWHk6v+v/O8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REylkVVUj7FEokSNrGNqj3JsQjbX0JnQpv53rOjXeE+Ey39cipJe+aqyQ1dlSGCKK
	 I9ww0Ecqil5rV9PZjaTXGhg/Gki18LxP1v+/WWAdAQmpsEb4tTXmfcoqAqybqf7RJY
	 lJO4ORm0ingtAN6ALWMnN8gLoG3EQy+mFjfldd9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Fiona Behrens <me@kloenk.dev>,
	Trevor Gross <tmgross@umich.edu>,
	Tamir Duberstein <tamird@kernel.org>
Subject: [PATCH 6.6 090/166] scripts: generate_rust_analyzer.py: avoid FD leak
Date: Fri, 24 Apr 2026 15:30:04 +0200
Message-ID: <20260424132551.586892837@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -121,9 +121,10 @@ def generate_crates(srctree, objtree, sy
 
     def is_root_crate(build_file, target):
         try:
-            return f"{target}.o" in open(build_file).read()
+            contents = build_file.read_text()
         except FileNotFoundError:
             return False
+        return f"{target}.o" in contents
 
     # Then, the rest outside of `rust/`.
     #


