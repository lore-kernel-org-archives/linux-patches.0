Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AFE1DF265;
	Wed, 19 Feb 2025 09:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956229; cv=none; b=C0ZgVwj7yO8MaYm7kruTdlP3hUMNFbpSLcQfBYieRB9sNEzJwlmVNWRynDp+jaXnUY7qX7YmsO5td0fUqBecCUU5mDC1jdo1HfI4gD1j7pMTm1LQAJU8nJiVupdC2mfZ/CSFd/Ds32j1DnpjqeDyCUlF78I2pVWDnIV5IVJw8nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956229; c=relaxed/simple;
	bh=uKRfEsiv1bRaFc+ZxLdZFuNQdGMrmVthX7rAbewuOYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MwBg97eyyLq+2zJ+IHpVubRL7gvD9500vwiA3chS5wIzoN4WzAqFKzeh1bhRNQiuuMTk9mKiRUxk7lRZ81d3HDMe2mRtAx2YEyztBPzdyhudkTxGBgyXL0DpTj8ezShDkvVqIzrY5EdpI9wHvnW6Hr4K2YMAQvisvnJJhB6PQA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=of7CuJny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="of7CuJny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5297C4CEE6;
	Wed, 19 Feb 2025 09:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956229;
	bh=uKRfEsiv1bRaFc+ZxLdZFuNQdGMrmVthX7rAbewuOYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=of7CuJnyg0hMdZ/pM0pBvNTdPLAJFM8N2cJdnZC70SbE51rImkEAIwm6fpH0NArUH
	 807P7lg2o+G/7P8ZoT2lb4R0UbABeSZMomup+gZfWm9TyDhISyZSnBsj6f+h2pTcn7
	 aT11W9a4avphzjj/IET5141VwWrb+N5mnfVvo5ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/578] samples/landlock: Fix possible NULL dereference in parse_path()
Date: Wed, 19 Feb 2025 09:21:21 +0100
Message-ID: <20250219082655.917659052@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f29bb3c722307..ce9b77bc167b1 100644
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



