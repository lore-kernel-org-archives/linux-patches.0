Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0431C3AE6E6;
	Wed, 20 May 2026 16:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296386; cv=none; b=I0evH9Dcd3FLXOdmBhGxUMEaqqtAEg8QY3wm7nngKa0lDwmaLJwwbXY3gDvfiCi18GAitOaN1LysF/JIjK20wOk1pOefgSpJZrmvE9oJdCLaZSAw6vOoIil4YWH/zMNGAqb1ccPq3MsHkhlRMdQIPERW0jp4z07WadgN1CO6tAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296386; c=relaxed/simple;
	bh=BnPv+WOlvE53JaCYUo9NkKe9xg/HwOD3B4rjhXF7AAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkuCE/+oqsVWnHHfMtLmO0Td9GsDNBAjIz4GRxLWS0iSbMAYa/b8OpPNiwrLrvICdb+bvrOfz6+krmFJHePfczupsPCj3HIvFMf+uHiHN+zgBp3YQMuJJUjyb5hYoOZ4EPyA25dCt8wH/rfoW2kdJMqxqS/kcckODnEXwk3V48I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chxHeq8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chxHeq8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB311F00893;
	Wed, 20 May 2026 16:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296384;
	bh=udFhIriGAvgOiFC/f3U0NpEeR3rlo9HoXXptHbBbAV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chxHeq8eEAGZqhy2lQLKVYMImyUSugV9q55nvFjurRrR5JAfnwfEqMbQGCcVs7sRt
	 ajsdsZp8/6RaU2ImMVKO64hsdIGu1qfdaQoIW7pZReWC0PRwNL6VJT2ErLMstH6NEV
	 iHQ88y1eiMeSeB4ZVByptOE8p02aHKN5D638+pfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0738/1146] f2fs: allow empty mount string for Opt_usr|grp|projjquota
Date: Wed, 20 May 2026 18:16:28 +0200
Message-ID: <20260520162204.908745330@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 2a3db1e02ce08c14af04da70bb99e8a0a31eb9e8 ]

The fsparam_string_empty() gives an error when mounting without string, since
its type is set to fsparam_flag in VFS. So, let's allow the flag as well.

This addresses xfstests/f2fs/015 and f2fs/021.

Fixes: d18535132523 ("f2fs: separate the options parsing and options checking")
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index f44e962b1ee7d..79cc7b39802f8 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -336,9 +336,12 @@ static const struct fs_parameter_spec f2fs_param_specs[] = {
 	fsparam_flag("usrquota", Opt_usrquota),
 	fsparam_flag("grpquota", Opt_grpquota),
 	fsparam_flag("prjquota", Opt_prjquota),
-	fsparam_string_empty("usrjquota", Opt_usrjquota),
-	fsparam_string_empty("grpjquota", Opt_grpjquota),
-	fsparam_string_empty("prjjquota", Opt_prjjquota),
+	fsparam_string("usrjquota", Opt_usrjquota),
+	fsparam_flag("usrjquota", Opt_usrjquota),
+	fsparam_string("grpjquota", Opt_grpjquota),
+	fsparam_flag("grpjquota", Opt_grpjquota),
+	fsparam_string("prjjquota", Opt_prjjquota),
+	fsparam_flag("prjjquota", Opt_prjjquota),
 	fsparam_flag("nat_bits", Opt_nat_bits),
 	fsparam_enum("jqfmt", Opt_jqfmt, f2fs_param_jqfmt),
 	fsparam_enum("alloc_mode", Opt_alloc, f2fs_param_alloc_mode),
@@ -979,26 +982,26 @@ static int f2fs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		ctx_set_opt(ctx, F2FS_MOUNT_PRJQUOTA);
 		break;
 	case Opt_usrjquota:
-		if (!*param->string)
-			ret = f2fs_unnote_qf_name(fc, USRQUOTA);
-		else
+		if (param->type == fs_value_is_string && *param->string)
 			ret = f2fs_note_qf_name(fc, USRQUOTA, param);
+		else
+			ret = f2fs_unnote_qf_name(fc, USRQUOTA);
 		if (ret)
 			return ret;
 		break;
 	case Opt_grpjquota:
-		if (!*param->string)
-			ret = f2fs_unnote_qf_name(fc, GRPQUOTA);
-		else
+		if (param->type == fs_value_is_string && *param->string)
 			ret = f2fs_note_qf_name(fc, GRPQUOTA, param);
+		else
+			ret = f2fs_unnote_qf_name(fc, GRPQUOTA);
 		if (ret)
 			return ret;
 		break;
 	case Opt_prjjquota:
-		if (!*param->string)
-			ret = f2fs_unnote_qf_name(fc, PRJQUOTA);
-		else
+		if (param->type == fs_value_is_string && *param->string)
 			ret = f2fs_note_qf_name(fc, PRJQUOTA, param);
+		else
+			ret = f2fs_unnote_qf_name(fc, PRJQUOTA);
 		if (ret)
 			return ret;
 		break;
-- 
2.53.0



