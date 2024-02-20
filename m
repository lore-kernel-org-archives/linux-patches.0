Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6461509AE;
	Tue, 20 Feb 2024 21:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462878; cv=none; b=q1OmwrXm1Q5g8QiBo1d3WMUhgxDmPSfqJDhAnIXglsPs66BzFYzLnbXyOEGYF4kNnk/56dgyCfbQOezCyywblo3n4Z/9MM+FFisv3edud0SDxlK3cG4/hKl/Yc9xm1F2sftW99lfZo8u+P/yBWjD4tJtoFYEZT4j9fpYs9eSlGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462878; c=relaxed/simple;
	bh=ha0eNfsdrXKlvRfb8sGcQsWpYzMoafcbPL5YtM1i/EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6Hnjqf6DBrw3OMQHMN5CIbpLLWaxrqdNl3ePWIDn5prwyq40JccB5lOUDc9I+wqugeJkoTq0sub1OAwrGveI7SNX9VoiIDqNXFsX/KZpXCYnklwuei1ZEkZA5XqJydGJCEU7eBEbeOgxXOHbNc/9hv7H0mOIBiTaXjEu16/gQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1GuzD2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1GuzD2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FC0C43390;
	Tue, 20 Feb 2024 21:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462878;
	bh=ha0eNfsdrXKlvRfb8sGcQsWpYzMoafcbPL5YtM1i/EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1GuzD2Vq4gJ2kctN7gFHwha5RDLvzUfmTfYuCCrAkZ4i7dZdjsJ77MQA1GeP2eoN
	 OxNV075hflmd+8GXCrvtY1Wiy0tuC4tI0HW35WWwxHVL+96ffpMPMjdbp/cn+O6htd
	 Lu33sblnzdhIDv8r9hFt2Sjn9zEB+tvaLuO4TUDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Krejci <radek.krejci@oracle.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/197] modpost: trim leading spaces when processing source files list
Date: Tue, 20 Feb 2024 21:50:24 +0100
Message-ID: <20240220204843.026831872@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6bf9caca0968..a72e6cf61a1f 100644
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



