Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40AA1E51E1;
	Tue, 26 Aug 2025 12:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213046; cv=none; b=o7fE3kXDB9gpFsvqmjpF/3mzwTOlBd0iZaFcp/WvGg14enywHWclUYw/SLA7nVQZ8fu6HbZPazHvdm2Jcxd+G7lCn5QPsZD4LYadxpNf9qgThGIU/OKdagicobX8X2ceqsnh5K+RG6w8dAD+BwjejWcfK2k73bx8cYnpy/+6n+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213046; c=relaxed/simple;
	bh=K54trnWXGHfjojaFppYY3lMIrKMccwxDkRMf5Y4ty+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYAbSgoSad9lRuPC+/81lfqEPX5GibWFV8o8QoJB5SF6KTLMoqjdxHHRPZ5houtGbBvSQDYEBvv5rcVR/KrYrz7OmVUWZVDyaeqUNxPhP5DXLMFf0RT3QU4xYVvHRYwRvXHbYxWJhkGdPySw5P3FXl5EQevG9b4Pxazs8EWUnUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnuOzQJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnuOzQJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E77C4CEF1;
	Tue, 26 Aug 2025 12:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213045;
	bh=K54trnWXGHfjojaFppYY3lMIrKMccwxDkRMf5Y4ty+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnuOzQJ8+WxG5fEoH6J8uTgC3Or2QABPBr5h4ZFIa7q36VNcMuXTrNz9oGX/abzfB
	 ZvWyGqnMbF5eHKDSrJBhGCjBEo2uHPt44uTg11VnMYGZvVjQqkMKsZh7g5/iFD1nGO
	 raXvZ8h70icRgZb/JKPXG8wfb0VxYj7Gnw8weGh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <qmo@kernel.org>,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/587] bpftool: Fix JSON writer resource leak in version command
Date: Tue, 26 Aug 2025 13:05:50 +0200
Message-ID: <20250826110958.052999051@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 08d0ac543c67..a0536528dfde 100644
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



