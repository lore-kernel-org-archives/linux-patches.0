Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09DC80622;
	Wed, 21 Feb 2024 14:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524681; cv=none; b=d8HkmABI2OKeEKY/iFaF6L/BigEG9YWjE9JxbjsixNEICzdqg2WQEM0FOcWgGmxN8yxBYOUNAnLOqADapeiOOpsLo7xkvxCL+FN4ox2X2hRtSuwHaBgdSNfPMx5+ArRCDk4FiXuMzAnm6XPGnyqZXoR8MhPsCfrAeQ4U17gxzNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524681; c=relaxed/simple;
	bh=iSc2w5fCR6QNEf1TRVLdks9Z5qBBVmD8nEhCPjxZyTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obXRBrETS/NTOCwqZNoErKz49UjHLUT2TXXLI2BvjTrY7NifE96IIrzLFkwSdjIe5PVX3wOaqXkzDlykti8tir3Gz6Ds6+XhabGkVU9SNFU6oAOXVEyIpAQaOXjw5vcvV7T9U/+nF5LICAGDyTfe9nxwPLJeDZEviBu/MSPZ5Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knkjWeSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knkjWeSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ECAC433F1;
	Wed, 21 Feb 2024 14:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524681;
	bh=iSc2w5fCR6QNEf1TRVLdks9Z5qBBVmD8nEhCPjxZyTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knkjWeSGscJtLzmLpv451aFPM6LWHksJSxKxTxXVW4h8UXLEwld4qE2ewC4NuUosb
	 Qv6CR29elFRC2KHu4jz/5nTW75cFwHJciDdoBG7T+voO6IJufyOw+HOEqiodxZXEP0
	 6R95661tQEffKZ/3kV2w8XNgjpLWQ6t93SUgFwkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Krejci <radek.krejci@oracle.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 310/379] modpost: trim leading spaces when processing source files list
Date: Wed, 21 Feb 2024 14:08:09 +0100
Message-ID: <20240221130004.097036053@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d587f40f1117..b6eda411be15 100644
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



