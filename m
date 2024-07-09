Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77563157A72;
	Tue,  9 Jul 2024 11:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524017; cv=none; b=k5jQugYeVMpCe+eu88bqo7cylpl/krNQv9IdP0Fh95AL80PwGhuuZvwLqznVkJ7eQnSbVpcoePkdx4J7CSJptCr8oqeGeV+y5puGtwlMq71vaONC/hGMOPrigBAEHEf0tPHkfP1Sl0dFRuzyl21CbnCqdjXJYHUR4co+9hX/bcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524017; c=relaxed/simple;
	bh=/kUmoFMUd83K/qUIfdgJD2gV8lBYF4eeTc19MVxZVHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grUUxBBACxQoL2QmWQEI9MuGIorHn35rksIYFIy4fSYq2OrSYim/XJjF8B9eU9IohRKBTgmGR8LX8FXZT2555ZaHxZ0TCuRCsGcLIdphd+cMvpckQ/HGDoad/SrNVpg66Udgnq7a+IoWA2EhgRmw5SdGEz4OhMPlK59uokdZeYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOLtRwvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOLtRwvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3947C3277B;
	Tue,  9 Jul 2024 11:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524017;
	bh=/kUmoFMUd83K/qUIfdgJD2gV8lBYF4eeTc19MVxZVHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOLtRwvyQ0jAA+306twNdpixy3+E25KgesdiUs4U6WcPGYnYQfZbmKEJJstP2l5aY
	 yXJkVwPRZ6H0fPZCR930MinXIZFMBEI52ySuknL1VtgJOjwUCdy3BlpJ8yrchPW69d
	 cw0ZJTNQHJerKxnfG1W//ez+4s8Y9VBLDq8YB6OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 044/197] kunit/fortify: Do not spam logs with fortify WARNs
Date: Tue,  9 Jul 2024 13:08:18 +0200
Message-ID: <20240709110710.669964559@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 091f79e8de44736a1e677701d67334bba5b749e3 ]

When running KUnit fortify tests, we're already doing precise tracking
of which warnings are getting hit. Don't fill the logs with WARNs unless
we've been explicitly built with DEBUG enabled.

Link: https://lore.kernel.org/r/20240429194342.2421639-2-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/fortify_kunit.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/fortify_kunit.c b/lib/fortify_kunit.c
index fdba0eaf19a59..ad29721b956bc 100644
--- a/lib/fortify_kunit.c
+++ b/lib/fortify_kunit.c
@@ -15,10 +15,17 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+/* We don't need to fill dmesg with the fortify WARNs during testing. */
+#ifdef DEBUG
+# define FORTIFY_REPORT_KUNIT(x...) __fortify_report(x)
+#else
+# define FORTIFY_REPORT_KUNIT(x...) do { } while (0)
+#endif
+
 /* Redefine fortify_panic() to track failures. */
 void fortify_add_kunit_error(int write);
 #define fortify_panic(func, write, avail, size, retfail) do {		\
-	__fortify_report(FORTIFY_REASON(func, write), avail, size);	\
+	FORTIFY_REPORT_KUNIT(FORTIFY_REASON(func, write), avail, size);	\
 	fortify_add_kunit_error(write);					\
 	return (retfail);						\
 } while (0)
-- 
2.43.0



