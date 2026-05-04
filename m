Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5131A6827;
	Mon,  4 May 2026 14:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904507; cv=none; b=NKlnk8/fJ9Q7Tm6/vKKhIpy7OGW6xkrkg+68BdNf9YyzKVQZajNw4iiHNc9u/zV7jOeM5yJXKVHKXTEy+jGEmV94YR1OxY54SP4oNY0WX5+U60Empv9q7CXwSI+0xYw/JxEPl3+nc4703vG5cbCLy8N6tBAI5rpfcmCdhwv4MWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904507; c=relaxed/simple;
	bh=6abax6E2vDbHtbdYTo7OhpJ0fZ1ilEde8A9afziTe58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgyY0+wdgY7EmK2+Z35UJAKe4joRnVbQ1kbeRULulhTe/9Skrwc/ivx3OUoA4Yf4FWgVPYCKQbyhA4CaPfKq8G9PZVynQ/Gy0A0ZQ13fGHOdVXEiPe2vow8bQRVG/Q5Y9IqZ/sTdlWJDFmQv687y711aherjlmsBHLsL3pIg9+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkCiLxLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkCiLxLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BAFC2BCB8;
	Mon,  4 May 2026 14:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904506;
	bh=6abax6E2vDbHtbdYTo7OhpJ0fZ1ilEde8A9afziTe58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkCiLxLXAoOzFB7sgeHi130CsLz+f4lpz3T8J/v8VqaTxEUe80wkhVh8Gvcl5KnJo
	 Wsy9Oh9R7bmPMnUwcOv6GYiAPLWyiyATZu6GmlEl7HZUcQ1NdtTjb2PGqIIWLukWz1
	 8mqbJ8MZq1Qbo5ZOu1OhSJMVcgaVjJQ/TQlb8ypk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 032/215] um: drivers: call kernel_strrchr() explicitly in cow_user.c
Date: Mon,  4 May 2026 15:50:51 +0200
Message-ID: <20260504135131.348480612@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 91e901c65b4da02a6fd543e3f0049829ae9645b7 upstream.

Building ARCH=um on glibc >= 2.43 fails:

  arch/um/drivers/cow_user.c: error: implicit declaration of
  function 'strrchr' [-Wimplicit-function-declaration]

glibc 2.43's C23 const-preserving strrchr() macro does not survive
UML's global -Dstrrchr=kernel_strrchr remap from arch/um/Makefile.
Call kernel_strrchr() directly in cow_user.c so the source no longer
depends on the -D rewrite.

Fixes: 2c51a4bc0233 ("um: fix strrchr() problems")
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260408070102.2325572-1-michael.bommarito@gmail.com
[remove unnecessary 'extern']
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/cow_user.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/um/drivers/cow_user.c
+++ b/arch/um/drivers/cow_user.c
@@ -15,6 +15,12 @@
 #include "cow.h"
 #include "cow_sys.h"
 
+/*
+ * arch/um/Makefile remaps strrchr to kernel_strrchr; call the kernel
+ * name directly to avoid glibc >= 2.43's C23 strrchr macro.
+ */
+char *kernel_strrchr(const char *, int);
+
 #define PATH_LEN_V1 256
 
 /* unsigned time_t works until year 2106 */
@@ -153,7 +159,7 @@ static int absolutize(char *to, int size
 			   errno);
 		return -1;
 	}
-	slash = strrchr(from, '/');
+	slash = kernel_strrchr(from, '/');
 	if (slash != NULL) {
 		*slash = '\0';
 		if (chdir(from)) {


