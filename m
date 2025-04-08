Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4940E26561C;
	Tue,  8 Apr 2025 11:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111440; cv=none; b=DZYcd7YadnYII6vSu1fXe8hsNYJBJy+eXuiG9/IyV80+62A9vo9h+IIhzDNHRvSld5qE0ebjhppTfMl43tC3DopfoZm583yhLy1dlt4Dv5fJ9Ta6BoFBUuhK9tkW3WnsSrFm1TotSoSGEhxZYbu+XEd2GhBERwQvSbho6WSRJDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111440; c=relaxed/simple;
	bh=0OP7daw69+XyryrjvzGsPSnTaQxYhv0hJ0LOwM5GfJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuPTsXfAV17hHmksnrDnHnGsmE4lTyWDRZSHoi7IG7aHrAR5MycDQvrmRorPI0T0oIsJCJ70Kx09LAQeNPsYwCgCvc4Zsb/RpeiqJKslnNzcuq8wxROBwWVn2uX4QLJs3fUV+n0f1WX9yPWQu/9eWDGibcJwiNMeXy/IFCiuvGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHLMlxDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHLMlxDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C956DC4CEE5;
	Tue,  8 Apr 2025 11:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111440;
	bh=0OP7daw69+XyryrjvzGsPSnTaQxYhv0hJ0LOwM5GfJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHLMlxDB63nOqWqx19BzC+PKr3b8RZSyW0NmKQMcx2hFqA+c2sQnBMCShpzzIzGXV
	 xXaihfLNgcEuPgUDi/tv3i8kMblWZcEFKpeDey6cZOEeunqaVYGO6Ft5s4HUmWK4G5
	 qHES1w6H9rABI3uGmNTU3HPZQJ48REscgQ0ov9xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 432/731] libbpf: Fix accessing BTF.ext core_relo header
Date: Tue,  8 Apr 2025 12:45:29 +0200
Message-ID: <20250408104924.321606660@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 48c66f3a92002..560b519f820e2 100644
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



