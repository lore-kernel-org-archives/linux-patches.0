Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA20934AAE2;
	Mon, 18 Aug 2025 14:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525685; cv=none; b=kqcBanby55bT918erP7uW5DPxN+Rr3isxxCdOTaxv2qfxV0WcJAwwWgj2CcbaFybm8Un81Q7Og3IGJNn9d4lppzcSxZqMOXY8LhnFe+u90Y8NFZ0Hf2ajWuBSsrhL9d6yduf0QI0VkqOuT1bY22J+tGC68EyUq9P6FkvDYrYcuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525685; c=relaxed/simple;
	bh=JWZCnHlI4lf/qBc1wi8HwySYRAHmzLMc3KD+21FKja8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4NCug9uhLhis170oOJwz3oPampAGGEbm1uu9IJGvc3w63Kkhmkji8N48XRT9d91ZgmHcWI+5zRzOmkVcRQcnFK+B20dWCQev3uu5/Y7IjMmfvKrAKAb+8giKqRVyUJ3rnLqi9wu/wtH4LiooYq6RafXT2S+zo2iAM2yj/DG9kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYXvJDqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYXvJDqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD46C113D0;
	Mon, 18 Aug 2025 14:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525685;
	bh=JWZCnHlI4lf/qBc1wi8HwySYRAHmzLMc3KD+21FKja8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYXvJDqWEtHMuAPWz859N11ramZqggAhQNKs4hi2XOFW3zFCNvoeH07mvM5FRYioY
	 BxpfSKix3e0oNZpLk6hDKZf8buXpHxrmW5xuMj9kLEoX6ubAE154OnPr6zt9Cr3dcP
	 FIByPwSYwNi+NODc6yrQrkACpQA5gQk6pwaWSPyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <qmo@kernel.org>,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 335/570] bpftool: Fix JSON writer resource leak in version command
Date: Mon, 18 Aug 2025 14:45:22 +0200
Message-ID: <20250818124518.755483505@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 85cd83fed8267cde0dd1cea719808aad95ae4de7 ]

When using `bpftool --version -j/-p`, the JSON writer object
created in do_version() was not properly destroyed after use.
This caused a memory leak each time the version command was
executed with JSON output.

Fix: 004b45c0e51a (tools: bpftool: provide JSON output for all possible commands)

Suggested-by: Quentin Monnet <qmo@kernel.org>
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20250617132442.9998-1-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index cd5963cb6058..2b7f2bd3a7db 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -534,9 +534,9 @@ int main(int argc, char **argv)
 		usage();
 
 	if (version_requested)
-		return do_version(argc, argv);
-
-	ret = cmd_select(commands, argc, argv, do_help);
+		ret = do_version(argc, argv);
+	else
+		ret = cmd_select(commands, argc, argv, do_help);
 
 	if (json_output)
 		jsonw_destroy(&json_wtr);
-- 
2.39.5



