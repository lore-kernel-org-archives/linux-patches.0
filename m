Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056171D515B;
	Wed, 19 Feb 2025 09:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956606; cv=none; b=aT8JBfVEXc9vv7401ttCw+m1iCPgLexslzCxva7QwBubSUF3GeD5Ifq4+yGEouOnhQpb90l29zJTW4UTW7sFStNlpgmPZy7dVwt3/NL8WweILS0wshevauc0GtRovKNP4LoZEEhxZdhY0hmfAkcWfslws2HfMhkLNaGE/2qE0FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956606; c=relaxed/simple;
	bh=yxLyPYCCwxygzr/1hqU4SMa1I8A8YqkFt/hS88tpeGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cosf5HbBSjMwKEOXbScGXcn93cZMbMNlleyoPqhRCWVCCbm1/2K2oB7G1wFpWUiIM7U/p1wIgx8XxTymQBtzhxZZLb8en98595mpvN3E3n8M9jNST+vYR7JwteQGMvyDBVr/UUR3la3OW5ichHVsuheVqHQbRq/n9UdiIm346m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOHA/1b/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOHA/1b/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845BDC4CED1;
	Wed, 19 Feb 2025 09:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956605;
	bh=yxLyPYCCwxygzr/1hqU4SMa1I8A8YqkFt/hS88tpeGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOHA/1b/sUukjAWOWY0WQg8b5peWg/ojbFsivrUQ0DlbWmCvBFCfgL6o/WPjB2yrs
	 6KVRFQsEI3lktDalM+rmhABeqk6jbwWolxzNr1g7+vXsim8n0bfEcS0UICVSLsCQKG
	 BL20JjrBGB0eMTZVkZuitMVbSgieRK9FYHrSPmq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 236/578] kconfig: require a space after # for valid input
Date: Wed, 19 Feb 2025 09:24:00 +0100
Message-ID: <20250219082702.325718421@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 02ac250b8fe9e..8694ab1e04067 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -432,6 +432,8 @@ int conf_read_simple(const char *name, int def)
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



