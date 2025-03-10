Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB8822AE7C;
	Mon, 10 Mar 2025 17:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629127; cv=none; b=u8tBYUygIc81Emtr0qAx7pk37sNdFSSXkaAeyzoq3K+nHLEiWe1TwG3sGLxXXr691fZKqozrDnXUwzzt9xW0U7zTuStySLt18lcreWi+BOxw/zR+dg4p5B76lVsisXZvqPIcEtFB1iUML9OGqP4ZBWuZDM6u1+WECtmc8iW1SUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629127; c=relaxed/simple;
	bh=RjwPNjzL8ekAadipPT3FO8Apk/oSH1XErcziTpzntUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLwC9g7zQGJ2ETrPTRCZU9YlO/diQr+Jc8rp7h4uHZobxKOFAhnXJLW86ec5GWjLscePGXrQPR8W1BNYiCrHQK/p7C663WRRdp+Mp8T13NcYZxZjqGZ/gT/tCZyTCzDG55frw6WiTTqvR8L5Sna4wl9cUb8WM2isO6uDTuCaDHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYPcmNQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYPcmNQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFB3C4CEE5;
	Mon, 10 Mar 2025 17:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629126;
	bh=RjwPNjzL8ekAadipPT3FO8Apk/oSH1XErcziTpzntUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYPcmNQcubh0bU0u34aUrfrV3ibEYOtSKW4YjJ2PrThnvDxv3ekgspGUhmJ31rgj/
	 HpJhMvnxQyjk4ZbZM3SnIaEr9DC8lRLOy87o7tUAQf4Uo4GHM/lXcaU0VKCoCAoXV6
	 67L7VOwfv/Fg96fFbvsYOvQcQT9d+PXeB5HZEosM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/620] kconfig: require a space after # for valid input
Date: Mon, 10 Mar 2025 18:00:25 +0100
Message-ID: <20250310170552.688689370@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 4d137ab0107ead0f2590fc0314e627431e3b9e3f ]

Currently, when an input line starts with '#', (line + 2) is passed to
memcmp() without checking line[1].

It means that line[1] can be any arbitrary character. For example,
"#KCONFIG_FOO is not set" is accepted as valid input, functioning the
same as "# CONFIG_FOO is not set".

More importantly, this can potentially lead to a buffer overrun if
line[1] == '\0'. It occurs if the input only contains '#', as
(line + 2) points to an uninitialized buffer.

Check line[1], and skip the line if it is not a space.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: a409fc1463d6 ("kconfig: fix memory leak in sym_warn_unmet_dep()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/confdata.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 033f2882436d3..80160aee01ff6 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -434,6 +434,8 @@ int conf_read_simple(const char *name, int def)
 		conf_lineno++;
 		sym = NULL;
 		if (line[0] == '#') {
+			if (line[1] != ' ')
+				continue;
 			if (memcmp(line + 2, CONFIG_, strlen(CONFIG_)))
 				continue;
 			p = strchr(line + 2 + strlen(CONFIG_), ' ');
-- 
2.39.5



