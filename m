Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85883EA7B
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyX8e3Ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66300C433C7;
	Wed, 15 Nov 2023 19:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076796;
	bh=8JxoHUs2puu2QzUJNOS7zBcHFnLXtI9jPdD/V3Jgvc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iyX8e3Ao7weKOOGdUcemN2ALXthyqSZOP+iGggR9sV8Ahc5IhtsL3uSY8ZShXhwXs
	 lBF5rCrMp8lEqsWQRVqdyV6ngn2SMhhTTN+RIJT4Cxg+LcF4ndlkq43b5UawMJEYpw
	 U1FEe8ezWqY/OqAKPzENNThfS+AqSFRbsg5J7csE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/603] pstore/platform: Add check for kstrdup
Date: Wed, 15 Nov 2023 14:09:34 -0500
Message-ID: <20231115191615.191850186@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit a19d48f7c5d57c0f0405a7d4334d1d38fe9d3c1c ]

Add check for the return value of kstrdup() and return the error
if it fails in order to avoid NULL pointer dereference.

Fixes: 563ca40ddf40 ("pstore/platform: Switch pstore_info::name to const")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20230623022706.32125-1-jiasheng@iscas.ac.cn
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/platform.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index e5bca9a004ccc..03425928d2fb3 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -464,6 +464,8 @@ static int pstore_write_user_compat(struct pstore_record *record,
  */
 int pstore_register(struct pstore_info *psi)
 {
+	char *new_backend;
+
 	if (backend && strcmp(backend, psi->name)) {
 		pr_warn("backend '%s' already in use: ignoring '%s'\n",
 			backend, psi->name);
@@ -484,11 +486,16 @@ int pstore_register(struct pstore_info *psi)
 		return -EINVAL;
 	}
 
+	new_backend = kstrdup(psi->name, GFP_KERNEL);
+	if (!new_backend)
+		return -ENOMEM;
+
 	mutex_lock(&psinfo_lock);
 	if (psinfo) {
 		pr_warn("backend '%s' already loaded: ignoring '%s'\n",
 			psinfo->name, psi->name);
 		mutex_unlock(&psinfo_lock);
+		kfree(new_backend);
 		return -EBUSY;
 	}
 
@@ -521,7 +528,7 @@ int pstore_register(struct pstore_info *psi)
 	 * Update the module parameter backend, so it is visible
 	 * through /sys/module/pstore/parameters/backend
 	 */
-	backend = kstrdup(psi->name, GFP_KERNEL);
+	backend = new_backend;
 
 	pr_info("Registered %s as persistent store backend\n", psi->name);
 
-- 
2.42.0



