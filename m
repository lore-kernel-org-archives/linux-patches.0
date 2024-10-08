Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4539F1DFD86;
	Tue,  8 Oct 2024 13:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393832; cv=none; b=hphr8CRD59sqY+HUMKQdgfcq82tWkN7KDDGt6sNbD+XZj4Bp8baqy/nI600PxE9Bw+M4vavJI5WA+UeHTn0dP8yNluBBwtQhtW7p1FrP5vtjxByDf8me4hqtPsiobYcSKMkUH/kwp6dSGiDtyZZkFDn48KCxEAa80wWxembygHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393832; c=relaxed/simple;
	bh=KeCaeRgEBnwISd12HJOIG9gd73/QWj9+vfu95mlVp2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/7Rgricw529j82TtEFxpViYh+wJmVnUGyPQEYxq3J3rwR3m6r5fx25aaGeV+eejg3chpqBDIfpsbIMwAyhtr7GX9I0hXgabnKumwR5BWvFmE4Kj6IyWDfeQl6rQDA61P8jDQUnHOFZhAn8Q9yPiJ8PQubtbGuTryREwUdu/40s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=desFHOIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="desFHOIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D47C4CECD;
	Tue,  8 Oct 2024 13:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393832;
	bh=KeCaeRgEBnwISd12HJOIG9gd73/QWj9+vfu95mlVp2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=desFHOIuwEi2zrB99N3c/qyj3WT+Ov4PHrnH9j4/rjPlywy6OIX0s4kdff9olcsiT
	 TjHBwJlWSSUOeu+6SonWNW+NK1S4QCL51/WnMcXA04G4+nQdRLZZZbtlYmih/reNQH
	 l+xUYnCAeZbMLW3deB2KREQv9YVqS0V51gLpNAdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 269/386] exfat: fix memory leak in exfat_load_bitmap()
Date: Tue,  8 Oct 2024 14:08:34 +0200
Message-ID: <20241008115639.976798645@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit d2b537b3e533f28e0d97293fe9293161fe8cd137 upstream.

If the first directory entry in the root directory is not a bitmap
directory entry, 'bh' will not be released and reassigned, which
will cause a memory leak.

Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
Cc: stable@vger.kernel.org
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/balloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -110,11 +110,8 @@ int exfat_load_bitmap(struct super_block
 				return -EIO;
 
 			type = exfat_get_entry_type(ep);
-			if (type == TYPE_UNUSED)
-				break;
-			if (type != TYPE_BITMAP)
-				continue;
-			if (ep->dentry.bitmap.flags == 0x0) {
+			if (type == TYPE_BITMAP &&
+			    ep->dentry.bitmap.flags == 0x0) {
 				int err;
 
 				err = exfat_allocate_bitmap(sb, ep);
@@ -122,6 +119,9 @@ int exfat_load_bitmap(struct super_block
 				return err;
 			}
 			brelse(bh);
+
+			if (type == TYPE_UNUSED)
+				return -EINVAL;
 		}
 
 		if (exfat_get_next_cluster(sb, &clu.dir))


