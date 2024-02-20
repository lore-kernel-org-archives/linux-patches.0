Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C181509BC;
	Tue, 20 Feb 2024 21:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464718; cv=none; b=MisbJBxX4+aX+HZ6pKbsGUCwMPoP9uiXkODNRDeQVlKZLp3AbFO8O+kwJbAvBvldBtQ/0tMRZWAprfym2R+TqRFqj7hVXm2SmhpRXSLs7UtpjixO2z4LIdE6qmpTym2h60oWGGjlL8pNiVcIGxdcBePN6X3AOiZZcrQAd+6Pkek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464718; c=relaxed/simple;
	bh=JKHjpVyseXilvTWZc4/l21PI4+ikVmQQhOAygQTlrPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuKDujp+v7de+hFG0nXXGj1l4jk+n1wdSzI6+EuGp5uOBaUAS6JtM8BKmujfT0VIima5hkDM5+vNsQeUvCIybd0/M4NqURJ92HYvW4a1d0Z3pgHAmPvz3hzku0ZVLQthf0Io2+fQ2zOupDH6tBL8SZTj6XhE95V9z1yiqBuCI3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGpTa598; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGpTa598"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97506C433C7;
	Tue, 20 Feb 2024 21:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464718;
	bh=JKHjpVyseXilvTWZc4/l21PI4+ikVmQQhOAygQTlrPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGpTa598QaiKTYw5/gBBGHJ1oxW+envtisb86TyHAWwXeUuIa0L9WTVABsylX83Z2
	 GybHRdKCTG9lXkYH2B17yp0D5age/S0z2azj1nCticWY3le4k1x94xYrf1bEXVv4k1
	 s0+81jJZ/ZNCVzoI4MZ/ucgy+bCpksAL1wMynraE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Krejci <radek.krejci@oracle.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 114/309] modpost: trim leading spaces when processing source files list
Date: Tue, 20 Feb 2024 21:54:33 +0100
Message-ID: <20240220205636.755072152@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



