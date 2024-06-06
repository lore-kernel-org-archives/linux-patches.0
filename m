Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47AF19EEC0;
	Thu,  6 Jun 2024 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683552; cv=none; b=ZVU7TqlcBDmF9+eyaTdk5ycMgBneBMsyUG88UPIg2NieoKvxkq3aIXGXsyMO2lDadNDTvP4Q5vF5wjVn3Oe7+0ttkIfA4wZnuG/vit5kwUKhYAOsJeMHGI/wp85+S0gQ9CQR9afLivjVSCOEebWgPzWMdYvQhfBqCWta8g9J99Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683552; c=relaxed/simple;
	bh=wZQfoSTo92hZNzfnhaQqZ5PvZUV33KFSVdToclpM9gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHV38a3ImvTTShG4FM7/SRmuVE7saCCiGPQFVIazy0k3ukbcxHUJGt5Or8caAsLVLBjMCr6ApJLTsU2jD/2sZ6RIEv5ImH1uGjrG720hcK0Z25xMeJbe04OC0UDE4TddeLJncpmr3YDNTAsw+uPJnUOCncsOE+M3xMetKfs6bPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcsAn6FX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcsAn6FX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFF9C2BD10;
	Thu,  6 Jun 2024 14:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683552;
	bh=wZQfoSTo92hZNzfnhaQqZ5PvZUV33KFSVdToclpM9gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcsAn6FXyJusStU7vJ2WD3GXFMoq2oOXRGb2wT3kfRx9LqNwdp5C9sYuWD6bamBfj
	 2tJMjohhYY1KAHH8AAM3OAvYHYcWmCJAHGY4Zg0k2DPVO/XM4pXcNt2fDqrLROo9Ho
	 oBc+qdQWXQK09xdHLgkaK+5IPXZ2Ke1ARUB+4OIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 443/473] bpf: Fix potential integer overflow in resolve_btfids
Date: Thu,  6 Jun 2024 16:06:12 +0200
Message-ID: <20240606131714.367514251@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ef0764d6891e4..82bffa7cf8659 100644
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



