Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF4969318;
	Wed, 21 Feb 2024 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523232; cv=none; b=KXB2einCsnnyrCTB6Toff+WErpoyckJzdmNQQ9zYo/iNp994H2J+JSmQz5d6wVgh/TcqQq26MlLJexfc+4jwNNJSsyz2hgCfIqUObO1RsD/T9Phj4wc9wsh10fxbypVEjAD0LAB7xZjWZH6KKfmag10NxlAwDPoj9K8hqQ16hQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523232; c=relaxed/simple;
	bh=Z/94GXyUuZGRXTN3GQG3m/wowfpiK7Bn5S/CWPp91oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csYe8UihHjRQIz9asPUwvv4jKneMr5YiOphJETFydKrF9ebyGft6pFP2p+c4tiq/ktbNIDTpKLvHn/eYSfDder9al5s+Y1kvTt3R5+VtvDlujmh29qBPUvS6SoIGGBPGEx9mGgNchAHBRZGHTvJV0eejb5WiZg6S75hLRnj4hg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnrUPGUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnrUPGUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604C4C433F1;
	Wed, 21 Feb 2024 13:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523231;
	bh=Z/94GXyUuZGRXTN3GQG3m/wowfpiK7Bn5S/CWPp91oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnrUPGUu6O+QNdIh0YGEMYxcx5UzfM3z2F7gwAsVEU9LXQIanklmnqVjEv1+/Htxw
	 87IDzMD8j4loe2G+C2wwgZA6tyW1MCb7XcCmvHztPUGjEABqHisMuSq5+tsl0Ai8Sq
	 ajMLW78269OmIJqUShf+K3XPRU9wz/qRcCd5y7jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Krejci <radek.krejci@oracle.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 374/476] modpost: trim leading spaces when processing source files list
Date: Wed, 21 Feb 2024 14:07:05 +0100
Message-ID: <20240221130021.852856199@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 905c0ec291e1..e6962678032e 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -328,7 +328,12 @@ static int parse_source_files(const char *objfile, struct md4_ctx *md)
 
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



