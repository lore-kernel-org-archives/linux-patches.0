Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81571C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D95C433D2;
	Wed, 28 Dec 2022 16:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246098;
	bh=T2xzC8VcMURXvVDF6sbFKUXF9JoG/z82gplZpt5oZRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ec6hB7VsVfYbDTgFc6K6xoFYpZfMcEADpy6NSZ62HxLX1B3IAG8QvkrNVWvkY+OrY
	 a9CkmW+QGNEnuTBA9VQvEcUPllAF1r0Z5iZP08qWym5oeBUdTF2xedPRPtfKJrplP4
	 PHgNk8UrN1t+LxcjBb0qXb73PtfFK7GzckQ3wvp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-security-module@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1012/1073] LoadPin: Ignore the "contents" argument of the LSM hooks
Date: Wed, 28 Dec 2022 15:43:20 +0100
Message-Id: <20221228144355.655176782@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 1a17e5b513ceebf21100027745b8731b4728edf7 ]

LoadPin only enforces the read-only origin of kernel file reads. Whether
or not it was a partial read isn't important. Remove the overly
conservative checks so that things like partial firmware reads will
succeed (i.e. reading a firmware header).

Fixes: 2039bda1fa8d ("LSM: Add "contents" flag to kernel_read_file hook")
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Serge Hallyn <serge@hallyn.com>
Tested-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://lore.kernel.org/r/20221209195453.never.494-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/loadpin/loadpin.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
index 44521582dcba..d6767fddbd5a 100644
--- a/security/loadpin/loadpin.c
+++ b/security/loadpin/loadpin.c
@@ -120,21 +120,11 @@ static void loadpin_sb_free_security(struct super_block *mnt_sb)
 	}
 }
 
-static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
-			     bool contents)
+static int loadpin_check(struct file *file, enum kernel_read_file_id id)
 {
 	struct super_block *load_root;
 	const char *origin = kernel_read_file_id_str(id);
 
-	/*
-	 * If we will not know that we'll be seeing the full contents
-	 * then we cannot trust a load will be complete and unchanged
-	 * off disk. Treat all contents=false hooks as if there were
-	 * no associated file struct.
-	 */
-	if (!contents)
-		file = NULL;
-
 	/* If the file id is excluded, ignore the pinning. */
 	if ((unsigned int)id < ARRAY_SIZE(ignore_read_file_id) &&
 	    ignore_read_file_id[id]) {
@@ -190,9 +180,25 @@ static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
 	return 0;
 }
 
+static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
+			     bool contents)
+{
+	/*
+	 * LoadPin only cares about the _origin_ of a file, not its
+	 * contents, so we can ignore the "are full contents available"
+	 * argument here.
+	 */
+	return loadpin_check(file, id);
+}
+
 static int loadpin_load_data(enum kernel_load_data_id id, bool contents)
 {
-	return loadpin_read_file(NULL, (enum kernel_read_file_id) id, contents);
+	/*
+	 * LoadPin only cares about the _origin_ of a file, not its
+	 * contents, so a NULL file is passed, and we can ignore the
+	 * state of "contents".
+	 */
+	return loadpin_check(NULL, (enum kernel_read_file_id) id);
 }
 
 static struct security_hook_list loadpin_hooks[] __lsm_ro_after_init = {
-- 
2.35.1



