Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6671CCEDA;
	Wed,  2 Oct 2024 14:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879107; cv=none; b=k+n7V7TAhlJsaLIoYrK+AI4Overq9WStd8dCkJrIuF6RfZhg/+qjRABiZO7CE5Cm2PfI0uSuzWbn6vIoY/KhhsjNEY0IQmP9dnTzu+qPF10tNfbc5NUws/0DGngioanUEVKRUS7juVIcQQkJGc1lU1vrecsXbA7alvtFTyWxh7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879107; c=relaxed/simple;
	bh=kWZTC/jpFguTX2ROMmvaoVTzBueqB8LMnmlpoKLDeBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EJ7nXAEPr3N5sCmcIOsXnFLUet7tvl/V8aBoa8xIOkLNUKhDg0Lc6qQiR465TL5KmdbH5lPUFw1t8b2isEYPEOLk+gYLVSzZc2/kUjdfTvfYpq4nW4iLZcsSLcTTpxick5AUm1tUUEbLf8pxac/unwrLK99UH2v1I185g79vKt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u82lhMZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u82lhMZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86D3C4CECE;
	Wed,  2 Oct 2024 14:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879107;
	bh=kWZTC/jpFguTX2ROMmvaoVTzBueqB8LMnmlpoKLDeBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u82lhMZl6tcVUErbibAYIFGXCLN/TpL8M8yXzxW/EXCc4hyzqDnyItFCXmLmnB3HY
	 Wr5FAZ0u0evg9KbCZqsIAwK/1VABuOerlJaI+W8JBH6twujTDy03cSNGPSoqyJ1IyC
	 WEoNXrz110eqRFgMcGbyWpR2N5+VyMHGFzMZ4PEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marc=20Aur=C3=A8le=20La=20France?= <tsi@tuyoix.net>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 613/634] debugfs show actual source in /proc/mounts
Date: Wed,  2 Oct 2024 15:01:53 +0200
Message-ID: <20241002125835.313345406@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Aurèle La France <tsi@tuyoix.net>

[ Upstream commit 3a987b88a42593875f6345188ca33731c7df728c ]

After its conversion to the new mount API, debugfs displays "none" in
/proc/mounts instead of the actual source.  Fix this by recognising its
"source" mount option.

Signed-off-by: Marc Aurèle La France <tsi@tuyoix.net>
Link: https://lore.kernel.org/r/e439fae2-01da-234b-75b9-2a7951671e27@tuyoix.net
Fixes: a20971c18752 ("vfs: Convert debugfs to use the new mount API")
Cc: stable@vger.kernel.org # 6.10.x: 49abee5991e1: debugfs: Convert to new uid/gid option parsing helpers
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 91521576f5003..66d9b3b4c5881 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -89,12 +89,14 @@ enum {
 	Opt_uid,
 	Opt_gid,
 	Opt_mode,
+	Opt_source,
 };
 
 static const struct fs_parameter_spec debugfs_param_specs[] = {
 	fsparam_gid	("gid",		Opt_gid),
 	fsparam_u32oct	("mode",	Opt_mode),
 	fsparam_uid	("uid",		Opt_uid),
+	fsparam_string	("source",	Opt_source),
 	{}
 };
 
@@ -126,6 +128,12 @@ static int debugfs_parse_param(struct fs_context *fc, struct fs_parameter *param
 	case Opt_mode:
 		opts->mode = result.uint_32 & S_IALLUGO;
 		break;
+	case Opt_source:
+		if (fc->source)
+			return invalfc(fc, "Multiple sources specified");
+		fc->source = param->string;
+		param->string = NULL;
+		break;
 	/*
 	 * We might like to report bad mount options here;
 	 * but traditionally debugfs has ignored all mount options
-- 
2.43.0



