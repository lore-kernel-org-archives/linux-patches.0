Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54B04FD27C;
	Wed, 30 Sep 2026 18:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793820; cv=none; b=UYUL8BxYsV9si2h/WVLPe7oLGGD8o7fxc1Qr8a5uaDWm7Kj7IKL/Z7JHG3xD/fDFyA8dlOE9yUdfHD1HCBH9gFCQ9Yv3Ku2Uuf+CS34gkQhPm07IMlPbWNIV2c/2n4Keo/dpdb1uBNlqphZ+jzPg18/M573KtS/jjXP0PZp/kVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793820; c=relaxed/simple;
	bh=5JScWejfdwUweCxQ6NeJcO66M0V5hD13PNpefLBly+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATJhaWdOHNqvmRm5akslfNce4pCM0ipmq000hl1522Ungwdk7bj+mZ54i7P4rpPNhIqGtS0Xb3yKyo0QbKLxyTq13XjcXdXouLrBVgbJLFf/pYI6HbnUz25nvfZCgvN91cW4mwjKcUnvao2A7NXl4JQLHGJWcMQH/FfS9xbjibI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mV0Kcs1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mV0Kcs1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CA11F000FF;
	Wed, 30 Sep 2026 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793818;
	bh=XWub4BQj6xEd2P0rxNYK52PZ9BgS7BnVPeCjyA4FC30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mV0Kcs1mKz4PUNdQEkwWmimf/9Eo8LP9pdoyos4FbMFiDgWa1gvJxwPiqxtQdwoRe
	 jsvWek8eGI5sj9TL7P8xLnrjaC6ZuNUu7mOPGUd0f6Grjk0Hu7yN2OXqQMx5k+6vJr
	 jRDP3K6OSfx3Rierklr9cej8hx3nngMujtUwo6/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Artem Martynenko <amartynenko140@gmail.com>
Subject: [PATCH 6.18 389/395] hfsplus: avoid double unload_nls() on mount failure
Date: Wed, 30 Sep 2026 17:30:51 +0200
Message-ID: <20260930152349.144017941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Shardul Bankar <shardulsb08@gmail.com>

commit ebebb04baefdace1e0dc17f7779e5549063ca592 upstream.

The recent commit "hfsplus: ensure sb->s_fs_info is always cleaned up"
[1] introduced a custom ->kill_sb() handler (hfsplus_kill_super) that
cleans up the s_fs_info structure (including the NLS table) on
superblock destruction.

However, the error handling path in hfsplus_fill_super() still calls
unload_nls() before returning an error. Since the VFS layer calls
->kill_sb() when fill_super fails, this results in unload_nls() being
called twice for the same sbi->nls pointer: once in hfsplus_fill_super()
and again in hfsplus_kill_super() (via delayed_free).

Remove the explicit unload_nls() call from the error path in
hfsplus_fill_super() to rely solely on the cleanup in ->kill_sb().

[1] https://lore.kernel.org/r/20251201222843.82310-3-mehdi.benhadjkhelifa@gmail.com/

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/r/20260203043806.GF3183987@ZenIV/
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Link: https://lore.kernel.org/r/20260204170440.1337261-1-shardul.b@mpiricsoftware.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Signed-off-by: Artem Martynenko <amartynenko140@gmail.com>
---
 fs/hfsplus/super.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -652,7 +652,6 @@ out_free_vhdr:
 	kfree(sbi->s_vhdr_buf);
 	kfree(sbi->s_backup_vhdr_buf);
 out_unload_nls:
-	unload_nls(sbi->nls);
 	unload_nls(nls);
 	return err;
 }


