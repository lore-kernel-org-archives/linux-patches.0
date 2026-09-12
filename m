Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9BE30BF70;
	Sat, 12 Sep 2026 08:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201325; cv=none; b=GFw0aQs8vk+pzIr82XONLVV6noL5pqt1VHsW5dbaRFe6ihs4hSaFoe2kGOSodgmO92eYgTMoloAsMkenL16hedK0f2JAKZly3QPwIvFxQMcXT6fX+9z/RPJ/axX27T2SdIOdI5tuSNmlc8WRiTRlzQMdpZXA8oxtDt0ypxg0UnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201325; c=relaxed/simple;
	bh=6lecuOle7Ixj6SHv7EC1GJI2hq1bWCtIp14b6x8pP1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VekqK8QaHSvmWiDlhiKwVILK8Nh/Gpd1k2yVTG76z1rgfNGpCiDJQw9+vrQz2eRhxrkzmPDLf4a/MuTuDG6h32r6g9whMapSmClsZOdBW5qJNb3uqKlFIa+jcyyPM7Ld+PlfUS1AgC8KqyHg2cL/xR8yDVkfizbiIHqHPNheGfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnnYbq5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnnYbq5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C481F000FF;
	Sat, 12 Sep 2026 08:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201324;
	bh=hRsur+re+sL9KsTfj0dmg614O5ALZSRF3aOeaM7jvZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RnnYbq5LfwfV3Mx5db3/dYOqJqyfowR+HM/MMRtZhz4+nwI+QRaZMuMV6NxGrdPIA
	 Q1hsS1EIGAMSxNB23z0EbYE0RZyO7JKKH1A/FvD9R+ulzHwJ2Ie8jGJeMsnVmTDXRm
	 zLCvENMh0mIo6KVt0F1mDlNh6YKyCL6r4iMgo5yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	live-patching@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0974/1815] objtool/klp: Fix module name normalization for paths with dots
Date: Sat, 12 Sep 2026 08:45:24 +0200
Message-ID: <20260912065711.841062563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 165affd6f095323d953b0ed5823ec4d0db3b7d0d ]

When .modinfo has no "name=" tag, __find_modname() falls back to
converting the object's build-tree path to a runtime module name by
stripping directory components, converting '-' to '_' and truncating the
file extension.

It does all that in a single pass over the entire path, so the first dot
anywhere in the path ends the name.  For an object built in a directory
whose name contains a dot, e.g. "drivers/foo-1.0/bar.o", the result is a
bogus module name.

Strip the directory components up front so only the basename is scanned
for the extension separator.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: live-patching@vger.kernel.org
Link: https://patch.msgid.link/9017b4609553bed16674e8f924d34691cbc2b2c1.1785727106.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index f8787d7d14547..aeb99d572300c 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1140,7 +1140,7 @@ static struct export *find_export(struct symbol *sym)
 static const char *__find_modname(struct elfs *e)
 {
 	struct section *sec;
-	char *name;
+	char *name, *slash;
 
 	sec = find_section_by_name(e->orig, ".modinfo");
 	if (!sec) {
@@ -1158,10 +1158,12 @@ static const char *__find_modname(struct elfs *e)
 		return NULL;
 	}
 
+	slash = strrchr(name, '/');
+	if (slash)
+		name = slash + 1;
+
 	for (char *c = name; *c; c++) {
-		if (*c == '/')
-			name = c + 1;
-		else if (*c == '-')
+		if (*c == '-')
 			*c = '_';
 		else if (*c == '.') {
 			*c = '\0';
-- 
2.53.0



