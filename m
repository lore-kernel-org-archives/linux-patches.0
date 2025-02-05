Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7060157465;
	Wed,  5 Feb 2025 14:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765356; cv=none; b=uerbiWURFnB2B2eLNvoVU+r6d4qMh59bAhljX7ve7vBrdxrns3w06KdX+m8HwbZr7t18wxXdgktCnJcPmaioAZTlqvnHUYnkg9kVuC5GjPW7eSO3OquLvnjpETHr9aSBnu5qxe0Oh4Goakt87+xC1CFxbLQStuoQenX83hQ6zr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765356; c=relaxed/simple;
	bh=fhQnllwvGD+3KjHCRxSUnGLRz33KSkIjxEYWB0NqZSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PyECKuoE4pD2HfCUrO3dMDuMvqqgx0q9/bN3xaRaNrcQxy0NuzEqBZZYbnN3tkqFeAQZFRadvBxUGCx8GEbqjYi+zTyHf4AteMSQ3H+nFqjo4Dl5U+FE74dZvDBVIgYPho8X4gpgYXzDXUBs9qf75wfKIz2WNMncNzjqlwCW2PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMSodMWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMSodMWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EF6C4CEDD;
	Wed,  5 Feb 2025 14:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765356;
	bh=fhQnllwvGD+3KjHCRxSUnGLRz33KSkIjxEYWB0NqZSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMSodMWJqxOfgZcHzEPFH8u3ne0jKCHGs7z5OVUOCNOoablTIDCm37PKOeg5kCvv5
	 Ly8a0nDsUKZXUsem0M4McJL/Be6QsQ6lVHlmKQChaS6IhdMDcrKrfbHOy047tpK0oV
	 gw7x1nf3Xa7vns6d+mSYleIC4GDVwOqy3YdntCE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 150/623] samples/landlock: Fix possible NULL dereference in parse_path()
Date: Wed,  5 Feb 2025 14:38:12 +0100
Message-ID: <20250205134501.974151690@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 57565dfd74a26..07fab2ef534e8 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -91,6 +91,9 @@ static int parse_path(char *env_path, const char ***const path_list)
 		}
 	}
 	*path_list = malloc(num_paths * sizeof(**path_list));
+	if (!*path_list)
+		return -1;
+
 	for (i = 0; i < num_paths; i++)
 		(*path_list)[i] = strsep(&env_path, ENV_DELIMITER);
 
@@ -127,6 +130,10 @@ static int populate_ruleset_fs(const char *const env_var, const int ruleset_fd,
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



