Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2295343B490;
	Tue, 21 Jul 2026 22:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671900; cv=none; b=em+J/vfTA4a+KYhOGGVWTmmFcHBRtVE0XY/RuSRSab9IM9Z8PTscY0nFD6WVyLa3H8NF0OjMPT1aUS+S+bEkKpFVarYWgf6zXDsEdGLbUgk5GO/pn2e/3/TmoEEz2iVmlxZcGqeKFwUFuP2fb+Vs7vwdFG3LaT8eOgkuGJv/df4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671900; c=relaxed/simple;
	bh=LABx0rhLFXvmxqsRYgockTfkfHU1w035yFl13BQn+4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlpiaypHWB7iG7jTYy6zXv0UCzVVc8Q3QZJy2vwSdRqRvks5/JgG2akzpnkiE9paLS0G3wF8lYC4DkqfOeHPTrjZ6BJpCedjR/a6KeTHQkIRN/ULTjXdbheNcDdID+Ph5pWpsib3QiUeEI372MJlox/AEquWxtPusX6veM/Dt3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blbEC9C7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blbEC9C7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855821F00A3A;
	Tue, 21 Jul 2026 22:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671899;
	bh=oQVmmFvAa4KRdO72+PoZnE9TgkhViNxdZ24T1HDdzvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=blbEC9C7l/1i8YunpTkLD0y0BNEoPr7zH8kD5tXFsXP4Vlxx/PD/DxI5I9CjhvjS6
	 xRVI/MjPwjfA3AafZ8/LkDpMgJyy/CV7DKU5p/7OA4I4ACQgSKrxOZxf1YI9G/8Pzr
	 +48erq/0g4lrU8stIX9rrUSvm+jDxWwEQ7D8E73Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 421/843] tools lib api: Fix mount_overload() snprintf truncation and toupper range
Date: Tue, 21 Jul 2026 17:20:56 +0200
Message-ID: <20260721152415.506931993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit fd1f70776add263f8ef38a87ae593c75303f1dcd ]

mount_overload() builds an environment variable name like
"PERF_SYSFS_ENVIRONMENT" from fs->name.  Two bugs:

1) snprintf() uses name_len as the buffer size instead of sizeof(upper_name).
   For fs->name = "sysfs" (len=5), the output is truncated to "PERF" (4
   chars + null), so getenv() never finds the intended variable.

2) mem_toupper() only uppercases name_len bytes, converting just the "PERF"
   prefix rather than the full string including the filesystem name portion.

Fix by using sizeof(upper_name) for snprintf and strlen(upper_name) for
mem_toupper, so the full "PERF_SYSFS_ENVIRONMENT" string is correctly
formatted and uppercased.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 73ca85ad364769ff ("tools lib api fs: Add FSTYPE__mount() method")
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fs/fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index e13034cb0b6315..d8a55846883059 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -272,8 +272,8 @@ static const char *mount_overload(struct fs *fs)
 	/* "PERF_" + name + "_ENVIRONMENT" + '\0' */
 	char upper_name[5 + name_len + 12 + 1];
 
-	snprintf(upper_name, name_len, "PERF_%s_ENVIRONMENT", fs->name);
-	mem_toupper(upper_name, name_len);
+	snprintf(upper_name, sizeof(upper_name), "PERF_%s_ENVIRONMENT", fs->name);
+	mem_toupper(upper_name, strlen(upper_name));
 
 	return getenv(upper_name) ?: *fs->mounts;
 }
-- 
2.53.0



