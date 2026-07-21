Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB4B30EF9A;
	Tue, 21 Jul 2026 19:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662661; cv=none; b=otPUuV+8WYJv/dmfv9kufjL0kMtaiiS450CAuMxcvBbXes5QrS86cQAVa81ny1a2pLA4Gu7uZHy0ZQzymmLAjPNVnzUOtbw+tiSIgSy6QuP2TB7WemGIJrmaHfTFUZjDoWyE3LBKUM+jCfhHZpquYtCY133kAYEa/BbybUJWwso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662661; c=relaxed/simple;
	bh=yFd42cFCc2qylC/xcW0MDOvyRlXWcaQN3JfEzArEAH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l94OeOlrXeBUciFA0vaBt1r0mU+KS65iHsmibo429rpfxM2aiO206rgJwmGvU/uJAleX4ePAgUAslaIVjsnIXjJ636LO05QeOF6JbrbfYgpr395SLRzAhjOH7dvtKoHalHZx4u6bu8VrpqXwzFlJRjAuHbZxaYUDQA2oX+wkYb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEqiWXJq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEqiWXJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206261F000E9;
	Tue, 21 Jul 2026 19:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662660;
	bh=6R+HPPqbb14XRJljpTrSFwcrsiVEHH9Ct69WAV9b+ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEqiWXJqmmW7iJR0Me+HBofrb62JhDQbVn/558/tX4JUBvj8xcA2i8s8wS38UMN+F
	 8sN/fw/c1UgdCL7bY+WrK0JXsKHAJUi+Vv/lpcBd/YZs5jU2/scJH2UcCisFt3uj+Q
	 +vejbg0y5pAqkWhRJfFC/PP2loH32gPXpf6hFtaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0529/1276] tools lib api: Fix mount_overload() snprintf truncation and toupper range
Date: Tue, 21 Jul 2026 17:16:12 +0200
Message-ID: <20260721152457.958641193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9cc161630c2919..a3f81fda3e8489 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -261,8 +261,8 @@ static const char *mount_overload(struct fs *fs)
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



