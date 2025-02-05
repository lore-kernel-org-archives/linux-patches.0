Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5621B14D28C;
	Wed,  5 Feb 2025 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763792; cv=none; b=OlCkYNUfmvZ9PIqC5OKIF250A59uWmf0uooBCK9ylnFKxNyRHQtNbwq1l2RLYT9SbQ3ivwJEMCFhJfz2v3YlJNwDsG0hyVf5/YUfICnx2RjvvBs64ZCrsGnF+Xe/1oszGNK+pSguCoOCUmgGSAQWBdEWGBpmSXcoliUC9xHwrag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763792; c=relaxed/simple;
	bh=XpNo7ZKDXk9bAgEW52BvE8quhoVMcOYWAWAV5Hd0FwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mVSw4G6/s1KW/oVz6jwzMh66tK2+W4gyT4EG64Zpa0VMxcxnDQH2V4RXjRja2bAOE2OE8CyxWYMEI4oFfVVIJREN6jeXmAJFznEl6zJrjyYu/rX1cKvmECLy6luAaLkrOJDTzxdUm5UePq4IYAwhVXvKvyF9XEvkUiweFT0aa9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbcEArwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbcEArwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E60FC4CED1;
	Wed,  5 Feb 2025 13:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763791;
	bh=XpNo7ZKDXk9bAgEW52BvE8quhoVMcOYWAWAV5Hd0FwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbcEArwDGe/ijMoSHM/NVjIxd7RA8ac3pIM5llW57ftPQtFLedGfKRvZw0yTRNIDy
	 QtDDeQ1CGUXgpcF/i5UZxGbXdjBERBH3W3rMkLTJ8q17xIG6RtKD/GWRpdafPYkBbQ
	 MUl0/zYE46VTOHd7NykBSjygdnzkSiaQgCkZLqzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/393] samples/landlock: Fix possible NULL dereference in parse_path()
Date: Wed,  5 Feb 2025 14:40:25 +0100
Message-ID: <20250205134424.347729737@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zichen Xie <zichenxie0106@gmail.com>

[ Upstream commit 078bf9438a31567e2c0587159ccefde835fb1ced ]

malloc() may return NULL, leading to NULL dereference.  Add a NULL
check.

Fixes: ba84b0bf5a16 ("samples/landlock: Add a sandbox manager example")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Link: https://lore.kernel.org/r/20241128032955.11711-1-zichenxie0106@gmail.com
[mic: Simplify fix]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/landlock/sandboxer.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
index e2056c8b902c5..be4fec95c4601 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -65,6 +65,9 @@ static int parse_path(char *env_path, const char ***const path_list)
 		}
 	}
 	*path_list = malloc(num_paths * sizeof(**path_list));
+	if (!*path_list)
+		return -1;
+
 	for (i = 0; i < num_paths; i++)
 		(*path_list)[i] = strsep(&env_path, ENV_PATH_TOKEN);
 
@@ -100,6 +103,10 @@ static int populate_ruleset(const char *const env_var, const int ruleset_fd,
 	env_path_name = strdup(env_path_name);
 	unsetenv(env_var);
 	num_paths = parse_path(env_path_name, &path_list);
+	if (num_paths < 0) {
+		fprintf(stderr, "Failed to allocate memory\n");
+		goto out_free_name;
+	}
 	if (num_paths == 1 && path_list[0][0] == '\0') {
 		/*
 		 * Allows to not use all possible restrictions (e.g. use
-- 
2.39.5



