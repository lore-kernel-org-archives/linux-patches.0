Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A398837;
	Mon, 28 Oct 2024 06:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098383; cv=none; b=LBUw6LeUXqvHbPvF5c1e4UoxNVrI0jrtdWiOUWlKLNJx96bATdRAa7ROtARoJ62Ct8/YMs6jVv926LEq77OSuBqxu7OBxc94pZQ6a5vXOe3E7vqp/VdHbpNKcZfKplYBJLpv4PJ5aLAe1EaLhjoJmo426xapjjvLHswgeURGxI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098383; c=relaxed/simple;
	bh=LwvZ+n65uKRjcaxDjt/JHN+RVeD9OtITbEj0nrRQQ74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ty2N0IvpbP46poxXMjAgEyigfTdxBRY4lDbPgt9mzphMNjDA8mVE/usdi2BmE3UXLemdpJASH9ck5FsGF14EUmeVYYJ/yP0BF+CHZKW6oEEGsUchjEULlp66y83gDeXVXL1EFjLF5wnlMMsMpVV4FtndrJ0CMSgayzLInrfRRDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yum2DKGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yum2DKGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22883C4CEC7;
	Mon, 28 Oct 2024 06:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098383;
	bh=LwvZ+n65uKRjcaxDjt/JHN+RVeD9OtITbEj0nrRQQ74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yum2DKGDDecIWKvOxVsMNDYNskjkfI4LhX+5Ya/V7KdjJXweUGfOwtgm7rsR82at1
	 InItXdJD5LlBp+gco63H/ThdftxAQxv4sUz5Yi/GHDtK7loWQscPgDKajaR0tBkm3S
	 6//t6mEtrXYnIDSEO/umaCg4dgbeZktyytv8sM04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Mamedov <rm@romanrm.net>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 202/261] btrfs: clear force-compress on remount when compress mount option is given
Date: Mon, 28 Oct 2024 07:25:44 +0100
Message-ID: <20241028062317.120060647@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 3510e684b8f6a569c2f8b86870da116e2ffeec2d upstream.

After the migration to use fs context for processing mount options we had
a slight change in the semantics for remounting a filesystem that was
mounted with compress-force. Before we could clear compress-force by
passing only "-o compress[=algo]" during a remount, but after that change
that does not work anymore, force-compress is still present and one needs
to pass "-o compress-force=no,compress[=algo]" to the mount command.

Example, when running on a kernel 6.8+:

  $ mount -o compress-force=zlib:9 /dev/sdi /mnt/sdi
  $ mount | grep sdi
  /dev/sdi on /mnt/sdi type btrfs (rw,relatime,compress-force=zlib:9,discard=async,space_cache=v2,subvolid=5,subvol=/)

  $ mount -o remount,compress=zlib:5 /mnt/sdi
  $ mount | grep sdi
  /dev/sdi on /mnt/sdi type btrfs (rw,relatime,compress-force=zlib:5,discard=async,space_cache=v2,subvolid=5,subvol=/)

On a 6.7 kernel (or older):

  $ mount -o compress-force=zlib:9 /dev/sdi /mnt/sdi
  $ mount | grep sdi
  /dev/sdi on /mnt/sdi type btrfs (rw,relatime,compress-force=zlib:9,discard=async,space_cache=v2,subvolid=5,subvol=/)

  $ mount -o remount,compress=zlib:5 /mnt/sdi
  $ mount | grep sdi
  /dev/sdi on /mnt/sdi type btrfs (rw,relatime,compress=zlib:5,discard=async,space_cache=v2,subvolid=5,subvol=/)

So update btrfs_parse_param() to clear "compress-force" when "compress" is
given, providing the same semantics as kernel 6.7 and older.

Reported-by: Roman Mamedov <rm@romanrm.net>
Link: https://lore.kernel.org/linux-btrfs/20241014182416.13d0f8b0@nvm/
CC: stable@vger.kernel.org # 6.8+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 98fa0f382480..3f8673f97432 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -340,6 +340,15 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		fallthrough;
 	case Opt_compress:
 	case Opt_compress_type:
+		/*
+		 * Provide the same semantics as older kernels that don't use fs
+		 * context, specifying the "compress" option clears
+		 * "force-compress" without the need to pass
+		 * "compress-force=[no|none]" before specifying "compress".
+		 */
+		if (opt != Opt_compress_force && opt != Opt_compress_force_type)
+			btrfs_clear_opt(ctx->mount_opt, FORCE_COMPRESS);
+
 		if (opt == Opt_compress || opt == Opt_compress_force) {
 			ctx->compress_type = BTRFS_COMPRESS_ZLIB;
 			ctx->compress_level = BTRFS_ZLIB_DEFAULT_LEVEL;
-- 
2.47.0



