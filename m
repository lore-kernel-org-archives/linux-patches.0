Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2845513D607;
	Thu, 13 Jun 2024 12:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281428; cv=none; b=eC+Apahzgsz1GDyvJsD29Vci7p1hh30ThxVzttfZnoTqQ0YWMfjzny2WFB+dU2VrK5JXbE6cPclO4bvS9SfE7bkqbF6o0ZncKMvam+dmkd5iEvQMPJrqYkkNTam83rwLMKQPw01OztR267b+vyM0cCkeZoT3Qi8rg4nvqPqDLxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281428; c=relaxed/simple;
	bh=mdkKJrsZhByPfDmwRickyI6043MT6GA5QWM4kpzzQ30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsliLhDignUzRbmLMUbPbrinYuopWZz7g4ApSV6gA+HuzcJAkc4senkrsmujTau037UwhjTVNN8aYB03Xu/3B1R82q85H7fPQpMX8f3YO2jTRNraOA/kL2fjKnKkJI0RcwaBUPHsQRVs6zRu/MdImtTzF+XmJouB7cKNKrGTGWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tp384Gat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tp384Gat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A8BC2BBFC;
	Thu, 13 Jun 2024 12:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281427;
	bh=mdkKJrsZhByPfDmwRickyI6043MT6GA5QWM4kpzzQ30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tp384GatTjKpqS8FN06rEzc7UCgO272lpD6LFUR9zLo3GTaYJdpwMSTodPpgzhADQ
	 DofmMQ4Vn7sPA0cfKQq22AGf7o7zMv7SjZy+jOT2GDxLkDMOJT0nSCKrlDcrZ3tz6t
	 P6zruSKVpMAoNBHH7WnOp8B+Y/k+0XGd1bkO9Evc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/317] bpf: Fix potential integer overflow in resolve_btfids
Date: Thu, 13 Jun 2024 13:34:29 +0200
Message-ID: <20240613113257.260336917@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f32c059fbfb4f..8b2a2576fed66 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -637,7 +637,7 @@ static int sets_patch(struct object *obj)
 
 static int symbols_patch(struct object *obj)
 {
-	int err;
+	off_t err;
 
 	if (__symbols_patch(obj, &obj->structs)  ||
 	    __symbols_patch(obj, &obj->unions)   ||
-- 
2.43.0



