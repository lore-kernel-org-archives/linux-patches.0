Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937BE3AEF58;
	Tue, 21 Jul 2026 22:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673965; cv=none; b=MBxDfPhYbhOUDZk1PZicK7cX5wE/QEM+ZJcgOWlOl9XrgrNm7ij0b5K6kGkzI2pcmyevuxe2QkIEWdjmMQrc13//PreRKpCkspoZDsrdq2AZDDSdAhSW0Fb350xJzeWQlvgZKQy3IGIy4l5cxDCoFnd+wB8mBMs+JSzWdrSFPgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673965; c=relaxed/simple;
	bh=Z0MKwaSDf4xA7bZarEYFmTe9IaUL4TQ01eV+UJq9ZHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPk3BZC972z0jT32+ESSKxrTF4D+s5oB5M5YcLmcXmEH672Y6J5S0t9NQ67An4RcQQLJjrvBTgBrhje0SKr1o8in/z9XUVC5khzv8fCDJ7dFD+T4yBxCXrF056FTBZyWhl7MlxgJcDvOol7F7TCzQD6Ks0lkrNgXyXWATJGtKNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p44kgjXR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p44kgjXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0547C1F000E9;
	Tue, 21 Jul 2026 22:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673964;
	bh=oJiCrhfyjJPuKYBwrYjVTS8iftBuqtVcVtO8r7KJyMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p44kgjXR9PG9lH3RzVKuO3lOh1mtRGuyKFUk/eFzymb2HQ//RMjMRAZX6AURtvgh9
	 0RWvkm7SK/MdzeFhtxUd8d1G7FynXy29emRZvAN4Zd1wU5t0paIz2CurbfNZ5lz6L+
	 OQQ6uz4/yEKgvsqKAc897Y6ceigZyq0qf6nZMQIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/699] tools lib api: Fix mount_overload() snprintf truncation and toupper range
Date: Tue, 21 Jul 2026 17:21:18 +0200
Message-ID: <20260721152402.888773758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



