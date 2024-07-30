Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A1018455E;
	Tue, 30 Jul 2024 16:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358217; cv=none; b=Ns8eVwEh4bPk2hnno08+sEYJhWWvsl+UsoJGPsZPq7tnFZh0eOCw016TaKy8FeDQKA/nNYZAznoU18leyioyGCbjSxywluj5dZpmX/OwvsymwdV3X4lBHdAyK17Iw4k3E2zr2Mk5lgrjM2DEq7buUDPshAMP3xEU/qGW0iFNEU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358217; c=relaxed/simple;
	bh=IcIu1KZGWa9DAOND940gRmFCHLm/+TU1QNCTBofMGik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Am6EWMI44x18d0m9+gXjlK0kN2sHpfrsMohcuMYC4NlJYS4OKjxELnwl9+S7xo4e9muGqaLSVD79Djvs/Lg7pEWQe6Y0PF8YRWZPEYySEo8dit87ohCgZVZMZzK+8BahNow8FXFxncCjnxE2x6Yd8Gi18Y8+bvM5xyZMRTrUQUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIluZ3zM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIluZ3zM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC487C32782;
	Tue, 30 Jul 2024 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358217;
	bh=IcIu1KZGWa9DAOND940gRmFCHLm/+TU1QNCTBofMGik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIluZ3zMaBjM3sHLRDXzfvXX2KWJkENbIAYJzZ/wgLXlqGyau69a7xM8ojktH4k32
	 xIqI5Ro127rBXw7QMus/BgQ6vB5PzJLqjaCxNHktuwGjAsxHYo6F0U5qS5ThMT6dF1
	 PoPnYdbrcjxKRseBvpkRXj4MRPeb2ZU9TSiuEdlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	Kees Cook <keescook@chromium.org>,
	Eric Biggers <ebiggers@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 367/440] dm-verity: fix dm_is_verity_target() when dm-verity is builtin
Date: Tue, 30 Jul 2024 17:50:00 +0200
Message-ID: <20240730151630.152620159@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 3708c7269593b836b1d684214cd9f5d83e4ed3fd upstream.

When CONFIG_DM_VERITY=y, dm_is_verity_target() returned true for any
builtin dm target, not just dm-verity.  Fix this by checking for
verity_target instead of THIS_MODULE (which is NULL for builtin code).

Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Cc: stable@vger.kernel.org
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1497,14 +1497,6 @@ bad:
 }
 
 /*
- * Check whether a DM target is a verity target.
- */
-bool dm_is_verity_target(struct dm_target *ti)
-{
-	return ti->type->module == THIS_MODULE;
-}
-
-/*
  * Get the verity mode (error behavior) of a verity target.
  *
  * Returns the verity mode of the target, or -EINVAL if 'ti' is not a verity
@@ -1575,6 +1567,14 @@ static void __exit dm_verity_exit(void)
 module_init(dm_verity_init);
 module_exit(dm_verity_exit);
 
+/*
+ * Check whether a DM target is a verity target.
+ */
+bool dm_is_verity_target(struct dm_target *ti)
+{
+	return ti->type == &verity_target;
+}
+
 MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
 MODULE_AUTHOR("Mandeep Baines <msb@chromium.org>");
 MODULE_AUTHOR("Will Drewry <wad@chromium.org>");


