Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404EE3DE420;
	Mon,  4 May 2026 14:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903714; cv=none; b=JSO20wiaALN1BVDjGc3FBrd381sPTIeoVom+vP0/s3ZSqi3uhCFkQC+VhFks3ixlTDpffChdbjQUzjftJ6OaKsoZ1awb7ZHohegiuHbOAa+oMHMe19wAI2fvt0tytz5QZyglcFf4olsX5WGBW+lT5/HOCZ+kD4X/Z0cBCvn0PQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903714; c=relaxed/simple;
	bh=6SfB0NjAW4yaTncacdw04ApRWWvwVXoCkW5ov51ypwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJiDkpOIhtTQvTgUneeBbqYGvUpmevcbJDHaIpFk6hEpAWwHE0fBNXqfBrO1BLyCIIubWueJsiO4BY29qpfwNaaFStf//rQdjh3lJk8u70ZVDWPCyVBHknFslzASv3TP+sZBH3O0YQLr81qbFMh4P0qqMXW7PIi0TCIaOWvy/E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAs/e/2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAs/e/2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA779C2BCB8;
	Mon,  4 May 2026 14:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903714;
	bh=6SfB0NjAW4yaTncacdw04ApRWWvwVXoCkW5ov51ypwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAs/e/2I4k3lDif3bCG6FdtWN/5XIuKA7G9vuwExrKiyV5pgzi2wRIZKyith/4haI
	 3n642WeDzT8xG2LaT6h0qyIh8KjgwClDovWCqYy3UY4bde7H5aQ/sJ+n1O9LHMV0Ao
	 Snr4N4FAN3GMxwi7YYinNhFecsRid0OUU4zTHoLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 034/275] um: drivers: call kernel_strrchr() explicitly in cow_user.c
Date: Mon,  4 May 2026 15:49:34 +0200
Message-ID: <20260504135144.205891234@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


