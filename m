Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A712584
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F567C433EF;
	Thu, 23 Feb 2023 13:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157802;
	bh=z730S/5vXkO8OQA9zIOEJ1EJTdJgIRPQix+LqlfHysE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WH+CnaSUeVR+e59uLfzR+I9+m+brleOSxsxHHHQGS2GWymvSgxq0CeCQjBygiw8iD
	 OZ4IWrUsT3JbYfml0dncrPLKeKLjRUM2ezuUvLZiI5Qg03cqjpP/Aznen1uzZ7v/Na
	 nrKfreIcUjcPlzCQe2E90j2puzkVmVybTBxsDpy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Eric Biggers <ebiggers@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 6.1 45/46] ext4: Fix function prototype mismatch for ext4_feat_ktype
Date: Thu, 23 Feb 2023 14:06:52 +0100
Message-Id: <20230223130433.686304168@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
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

commit 118901ad1f25d2334255b3d50512fa20591531cd upstream.

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed.

ext4_feat_ktype was setting the "release" handler to "kfree", which
doesn't have a matching function prototype. Add a simple wrapper
with the correct prototype.

This was found as a result of Clang's new -Wcast-function-type-strict
flag, which is more sensitive than the simpler -Wcast-function-type,
which only checks for type width mismatches.

Note that this code is only reached when ext4 is a loadable module and
it is being unloaded:

 CFI failure at kobject_put+0xbb/0x1b0 (target: kfree+0x0/0x180; expected type: 0x7c4aa698)
 ...
 RIP: 0010:kobject_put+0xbb/0x1b0
 ...
 Call Trace:
  <TASK>
  ext4_exit_sysfs+0x14/0x60 [ext4]
  cleanup_module+0x67/0xedb [ext4]

Fixes: b99fee58a20a ("ext4: create ext4_feat kobject dynamically")
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org
Build-tested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20230103234616.never.915-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20230104210908.gonna.388-kees@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/sysfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -491,6 +491,11 @@ static void ext4_sb_release(struct kobje
 	complete(&sbi->s_kobj_unregister);
 }
 
+static void ext4_feat_release(struct kobject *kobj)
+{
+	kfree(kobj);
+}
+
 static const struct sysfs_ops ext4_attr_ops = {
 	.show	= ext4_attr_show,
 	.store	= ext4_attr_store,
@@ -505,7 +510,7 @@ static struct kobj_type ext4_sb_ktype =
 static struct kobj_type ext4_feat_ktype = {
 	.default_groups = ext4_feat_groups,
 	.sysfs_ops	= &ext4_attr_ops,
-	.release	= (void (*)(struct kobject *))kfree,
+	.release	= ext4_feat_release,
 };
 
 void ext4_notify_error_sysfs(struct ext4_sb_info *sbi)


