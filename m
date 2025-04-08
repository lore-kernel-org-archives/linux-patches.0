Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A16526B094;
	Tue,  8 Apr 2025 12:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114687; cv=none; b=AE1LnatcE40XNrQnju67+vi6v7I5qqzyYmPOXAHwDA7FKy0IajiGJTUKHf80LTd74xcx9YMfFo9D49ZS7PEuqeoDlEgg7ET/6/ObSRt9JIGkkSC+64FczQF8usFiIdwdpcZ/CSGCpMQZejZXRu9aMwvZjO8wRo9d4AD24iYa8bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114687; c=relaxed/simple;
	bh=baI8JvYB9abS4qVUis6dInKlstty8htMyf/uvFIDZzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyQYGl7P586fX8krhjW0SJQys+S3DjKAEU2FRGA2nmRz1IjUpaFOaHUjeGDdw0z6X1yNkipj8/0DCQXpKCh7cP5CzyqFSkXiEWlKu7lUduHa2CTMgULGsIbZUj4+A4Jr10Q2sBBHf3bCVgIa3asHvtxCfJ10iIOuKD6vcUoMSkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIXuqrVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIXuqrVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC195C4CEE5;
	Tue,  8 Apr 2025 12:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114687;
	bh=baI8JvYB9abS4qVUis6dInKlstty8htMyf/uvFIDZzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIXuqrVdyUGVNmBSrx9Ah96cjSrv7EkhhmucupSpCayXLoBIihHxjE4oKtH18xPg9
	 YE7j3B+BKy5oKXAX9uSG8MvoB6ooEPi6ToaCRrtsD+2h+glEpxpsF33I/KnpQCpXKz
	 MyT34+ELWdqNEc2L9B598uR7GeTR8oaQ1yeT/T0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 197/499] libbpf: Fix accessing BTF.ext core_relo header
Date: Tue,  8 Apr 2025 12:46:49 +0200
Message-ID: <20250408104856.102794204@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 0a7c2a84359612e54328aa52030eb202093da6e2 ]

Update btf_ext_parse_info() to ensure the core_relo header is present
before reading its fields. This avoids a potential buffer read overflow
reported by the OSS Fuzz project.

Fixes: cf579164e9ea ("libbpf: Support BTF.ext loading and output in either endianness")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://issues.oss-fuzz.com/issues/388905046
Link: https://lore.kernel.org/bpf/20250125065236.2603346-1-itugrok@yahoo.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 7e810fa468eaa..5a2f1792c60d5 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -3015,8 +3015,6 @@ static int btf_ext_parse_info(struct btf_ext *btf_ext, bool is_native)
 		.desc = "line_info",
 	};
 	struct btf_ext_sec_info_param core_relo = {
-		.off = btf_ext->hdr->core_relo_off,
-		.len = btf_ext->hdr->core_relo_len,
 		.min_rec_size = sizeof(struct bpf_core_relo),
 		.ext_info = &btf_ext->core_relo_info,
 		.desc = "core_relo",
@@ -3034,6 +3032,8 @@ static int btf_ext_parse_info(struct btf_ext *btf_ext, bool is_native)
 	if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_relo_len))
 		return 0; /* skip core relos parsing */
 
+	core_relo.off = btf_ext->hdr->core_relo_off;
+	core_relo.len = btf_ext->hdr->core_relo_len;
 	err = btf_ext_parse_sec_info(btf_ext, &core_relo, is_native);
 	if (err)
 		return err;
-- 
2.39.5



