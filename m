Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3711509BC;
	Tue, 20 Feb 2024 21:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463631; cv=none; b=P9JYrL9ADWv2ZG7ik761ZS7npjdCmJppNSYfYVbPeb6/FP6//DEs4NfgjuY+KNfFPZvHwmlejBIsmNc1g/tIZFfKJQ4gMfJiJWHtO1rsvT8VnBhcINlxjc6qCUutyZTXmdtSUjto1OvqNXC1X3J0RIKxaVcQ2c5EXqH5+OSyr38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463631; c=relaxed/simple;
	bh=SjnmeDitgHieh70h2t0LtYL36s6U/JwiUZKCA2W3UF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vmvp1m1lwsH5/P6sPQ1fPX64g4C3o/jsJBGXraR21B/Qr/Zp0eW76diDbk5rEP2QaAkID40SFXaTz6aNLvtN/TyfpRYxYXMXnnPPhF4ibUo4FwgJfbjSSEGRUZmZejLYBAyQaoZSBdbmd1JB6pLurPZrK/4CMlWahnm69oG1czs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxByPILj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxByPILj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ED3C433C7;
	Tue, 20 Feb 2024 21:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463630;
	bh=SjnmeDitgHieh70h2t0LtYL36s6U/JwiUZKCA2W3UF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxByPILjE3WQXzAng2+aUsQMi3y15ymk7Uv44V2UVR85mJmAclFR3moqvVSKNlNCa
	 tvY6v0DOhypnfgZOkSH1T8ISsTFKwvFe3P+c4pP2lTgVVJyXoHCEqrEUFQOVuYafiD
	 JJsg0pKMoX9THBIk3hAhNdz39cYtoGPTnlYRASVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Krejci <radek.krejci@oracle.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/331] modpost: trim leading spaces when processing source files list
Date: Tue, 20 Feb 2024 21:53:39 +0100
Message-ID: <20240220205640.830423521@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Radek Krejci <radek.krejci@oracle.com>

[ Upstream commit 5d9a16b2a4d9e8fa028892ded43f6501bc2969e5 ]

get_line() does not trim the leading spaces, but the
parse_source_files() expects to get lines with source files paths where
the first space occurs after the file path.

Fixes: 70f30cfe5b89 ("modpost: use read_text_file() and get_line() for reading text files")
Signed-off-by: Radek Krejci <radek.krejci@oracle.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/sumversion.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index 31066bfdba04..dc4878502276 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -326,7 +326,12 @@ static int parse_source_files(const char *objfile, struct md4_ctx *md)
 
 	/* Sum all files in the same dir or subdirs. */
 	while ((line = get_line(&pos))) {
-		char* p = line;
+		char* p;
+
+		/* trim the leading spaces away */
+		while (isspace(*line))
+			line++;
+		p = line;
 
 		if (strncmp(line, "source_", sizeof("source_")-1) == 0) {
 			p = strrchr(line, ' ');
-- 
2.43.0



