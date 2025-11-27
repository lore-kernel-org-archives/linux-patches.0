Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2C6273816;
	Thu, 27 Nov 2025 14:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254897; cv=none; b=QY9XDn66y25w2ZTFNqxXCRvv5DTsnYa48+Z2LCPGOBnpSopMYP1eGBxXHn+BYwtwgea8HDTeaaXbF/9t544xfbaxvOeMcWLKDbQCtBTMwM+VNnqmZEE4adpkEu5DVWhTKxuq3O2sjh5AAxRrJVPs/j5DDWd4B59wGAMhjs8Ct8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254897; c=relaxed/simple;
	bh=HwjMhvTvi3Pia68tpB2Lm3mTfXzThD/5BLiYXq2szg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOcv5aaz2oThorhqJ2WhVovJwzEHqQS98LA0emrQ+8BXBQsnArT2evUK+1xyJCQ3y44Yyrx2CKB2L3i2xpa9FXdYSfIurK90mdelvMmDkd8CdeDB8ww5m5Nu37mgnXvnkaU4y3nXeJygTNi9Z7PdwvnjpxQy8/ESJSEAXaIJgfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmWPIMpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmWPIMpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A93C4CEF8;
	Thu, 27 Nov 2025 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254896;
	bh=HwjMhvTvi3Pia68tpB2Lm3mTfXzThD/5BLiYXq2szg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmWPIMpk2FeEX5V1xrW2llJZ/BQqqWuXymieA6gW+qqFuLYCxXmFpcdlA3mXsiwV+
	 aCYt6jU5W3RqVgpJAH8QT9n0Z07g8Dlz8ApVZR1u8FMUiY7B1iflySYJBh+0lcXB8A
	 NPFbwtqDJCxx0vhGUZX+81jmNMWdN9wUMr8nAUps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Yuan <me@yhndnzj.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Hugh Dickins <hughd@google.com>
Subject: [PATCH 6.6 05/86] shmem: fix tmpfs reconfiguration (remount) when noswap is set
Date: Thu, 27 Nov 2025 15:45:21 +0100
Message-ID: <20251127144028.004026969@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Yuan <me@yhndnzj.com>

commit 3cd1548a278c7d6a9bdef1f1866e7cf66bfd3518 upstream.

In systemd we're trying to switch the internal credentials setup logic
to new mount API [1], and I noticed fsconfig(FSCONFIG_CMD_RECONFIGURE)
consistently fails on tmpfs with noswap option. This can be trivially
reproduced with the following:

```
int fs_fd = fsopen("tmpfs", 0);
fsconfig(fs_fd, FSCONFIG_SET_FLAG, "noswap", NULL, 0);
fsconfig(fs_fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
fsmount(fs_fd, 0, 0);
fsconfig(fs_fd, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0);  <------ EINVAL
```

After some digging the culprit is shmem_reconfigure() rejecting
!(ctx->seen & SHMEM_SEEN_NOSWAP) && sbinfo->noswap, which is bogus
as ctx->seen serves as a mask for whether certain options are touched
at all. On top of that, noswap option doesn't use fsparam_flag_no,
hence it's not really possible to "reenable" swap to begin with.
Drop the check and redundant SHMEM_SEEN_NOSWAP flag.

[1] https://github.com/systemd/systemd/pull/39637

Fixes: 2c6efe9cf2d7 ("shmem: add support to ignore swap")
Signed-off-by: Mike Yuan <me@yhndnzj.com>
Link: https://patch.msgid.link/20251108190930.440685-1-me@yhndnzj.com
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -126,8 +126,7 @@ struct shmem_options {
 #define SHMEM_SEEN_INODES 2
 #define SHMEM_SEEN_HUGE 4
 #define SHMEM_SEEN_INUMS 8
-#define SHMEM_SEEN_NOSWAP 16
-#define SHMEM_SEEN_QUOTA 32
+#define SHMEM_SEEN_QUOTA 16
 };
 
 #ifdef CONFIG_TMPFS
@@ -4004,7 +4003,6 @@ static int shmem_parse_one(struct fs_con
 				       "Turning off swap in unprivileged tmpfs mounts unsupported");
 		}
 		ctx->noswap = true;
-		ctx->seen |= SHMEM_SEEN_NOSWAP;
 		break;
 	case Opt_quota:
 		if (fc->user_ns != &init_user_ns)
@@ -4154,14 +4152,15 @@ static int shmem_reconfigure(struct fs_c
 		err = "Current inum too high to switch to 32-bit inums";
 		goto out;
 	}
-	if ((ctx->seen & SHMEM_SEEN_NOSWAP) && ctx->noswap && !sbinfo->noswap) {
+
+	/*
+	 * "noswap" doesn't use fsparam_flag_no, i.e. there's no "swap"
+	 * counterpart for (re-)enabling swap.
+	 */
+	if (ctx->noswap && !sbinfo->noswap) {
 		err = "Cannot disable swap on remount";
 		goto out;
 	}
-	if (!(ctx->seen & SHMEM_SEEN_NOSWAP) && !ctx->noswap && sbinfo->noswap) {
-		err = "Cannot enable swap on remount if it was disabled on first mount";
-		goto out;
-	}
 
 	if (ctx->seen & SHMEM_SEEN_QUOTA &&
 	    !sb_any_quota_loaded(fc->root->d_sb)) {


