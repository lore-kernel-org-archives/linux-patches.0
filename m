Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E241C9B6C;
	Mon, 10 Mar 2025 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628752; cv=none; b=ALIdT6bzN+wqJ7J6E2g9MBHsY9FlB2e+T2HZ70CFbke7BJqjSz9rb2DJCOqOnj+kUhwqornvzE8/1TY/GrKWtY56CsZvomCrFVtjxVoa9LUtJrt12jtrsrTfzgDyWZbbpf7biaK1d4fKD/50yipgUWvIQNYsBRqIZ4kyZfoTJUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628752; c=relaxed/simple;
	bh=eDW88f3AXR114LYZjJZ5LMdhIl0Jr3du+5BSqtlEtUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fLQZ3X2K18hgUQPOXHr4P1Tf2HTnSQHlAEEmA8/h+JKEYGIB4PplyEnK+8c/XDyQWp5mJwKudGRiG2NZZrEyceCoEMk/82gE5veQbiOFKjGJJGbDYugjMRr6XockiHD/idYEO7uosZcMMg8W7RmQly27MG3AzmjZB7q5IF/OCrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFffxO8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFffxO8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80847C4CEE5;
	Mon, 10 Mar 2025 17:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628751;
	bh=eDW88f3AXR114LYZjJZ5LMdhIl0Jr3du+5BSqtlEtUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFffxO8Ncq04H43csW1k/sKtZHvx78YIreA7CB7a5MQFPWAP8dqbMVt42uj9iukaO
	 xgFYXnuRQtfUA8YfA6lQtK3FMbAheAlwB9pusBI9jcET9tLY75u423T83LkLJJvyRP
	 9KnsomtzEL5+H4v1sVaqZTXhXBpe0fRckzTqmYJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/620] samples/landlock: Fix possible NULL dereference in parse_path()
Date: Mon, 10 Mar 2025 17:58:23 +0100
Message-ID: <20250310170547.832770342@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c089e9cdaf328..1825a2935bd82 100644
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
 
@@ -99,6 +102,10 @@ static int populate_ruleset(const char *const env_var, const int ruleset_fd,
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



