Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E324519922B;
	Thu,  6 Jun 2024 14:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683737; cv=none; b=nPKTrMe+68fryfHZ68GiD32FC4V6/BQeatnHYx0+5nQqb2OqPhY4xyJpsivKiCR5hvYO1KrpPQWpDCajp/SCridHGIAunXFjfUZmAAXLEMUkOXfFEcGsYnZj3OGLjmXO5yjauDS4StrRwRZCYR1Btz8F0W+HkSO74w+yL9p1h2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683737; c=relaxed/simple;
	bh=oU+BOc/uAzDxrZ2PqbCXoZUSOKRja5nwqQUSSz6WykI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYsnOtv5eWNC1wC1hG5+9gfCNdJK51kRN8ByveoeaS68vVSmM7tl4s7rrL3gp/yfwfAn8T2kXI0dz+wEBljbNamphZ/qHFesscCwPgmcy3s4r9a5vBvvAeEi+B7zEI23AO3XHfpNS8D6stOWaK75PwjbQyVlcHUI6tFXwH4hDxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtSWL1n0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtSWL1n0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FCFC2BD10;
	Thu,  6 Jun 2024 14:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683736;
	bh=oU+BOc/uAzDxrZ2PqbCXoZUSOKRja5nwqQUSSz6WykI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtSWL1n0H4L/HwQQiB/LMlEvpoOWIs2CwrOTNNHVxhVymFJj5siPL8QSHLKe7I7MR
	 UNshsxUftHs009IhpcTeZ3oRlk0vi/RHyiwPJUk0D7DlG4ghfWXXav3b/NQ5YfYWMx
	 e4cgtLddDpUl7jBYzvEAiOKyqN3us/fNDYvB9u9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 692/744] bpf: Fix potential integer overflow in resolve_btfids
Date: Thu,  6 Jun 2024 16:06:04 +0200
Message-ID: <20240606131754.678432785@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Friedrich Vock <friedrich.vock@gmx.de>

[ Upstream commit 44382b3ed6b2787710c8ade06c0e97f5970a47c8 ]

err is a 32-bit integer, but elf_update returns an off_t, which is 64-bit
at least on 64-bit platforms. If symbols_patch is called on a binary between
2-4GB in size, the result will be negative when cast to a 32-bit integer,
which the code assumes means an error occurred. This can wrongly trigger
build failures when building very large kernel images.

Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
Signed-off-by: Friedrich Vock <friedrich.vock@gmx.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240514070931.199694-1-friedrich.vock@gmx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/resolve_btfids/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index d9520cb826b31..af393c7dee1f1 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -728,7 +728,7 @@ static int sets_patch(struct object *obj)
 
 static int symbols_patch(struct object *obj)
 {
-	int err;
+	off_t err;
 
 	if (__symbols_patch(obj, &obj->structs)  ||
 	    __symbols_patch(obj, &obj->unions)   ||
-- 
2.43.0



