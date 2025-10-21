Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A274273D66;
	Tue, 21 Oct 2025 19:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076704; cv=none; b=h2hwrDGwrG5dCrtYJqP1MmM2fH25nMp4RcdXocqF/bC04fGy1Rrs8SphiGU4mmFgMJgkNfPldO3pylD9PHW4iunc9Epewc95SDHV3EcDQBk8XKaMgEY8c9oorvP5bPUPxIHk2hpxMC++CUIeloFyNQiEfQqQCwRsistE5XeTYWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076704; c=relaxed/simple;
	bh=bFi8m2gV6HvATaJVTf8/ZY3iNSCRBcYuWFU1POsTW0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eESXOOrIES2bEAyBbjYXscVv0oOZriFY4gaSctfcwj0sngf3zWpgs3DsxyeHJSJ1Gx/AEhhKF82KUwCpYNFb9X9Ov7a+EhK856KRoFVUzNAfbrq4yhbOCAjEOyHnBEZLh6gqkfwRJKARAu4xH+z2KCZzMMFJCZpjmTe8/0RcvpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyrs9lj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyrs9lj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37638C4CEF1;
	Tue, 21 Oct 2025 19:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076702;
	bh=bFi8m2gV6HvATaJVTf8/ZY3iNSCRBcYuWFU1POsTW0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyrs9lj/LmE3N9M3b+xrfSpA1a3f3X1gDyimDagiXntYfDC74GBDjtD/+weetLd0E
	 /ErawMq9I6+cnrLBXx/sV6C2/i0s8lVd3P0I0O8+nejG56VzJsHRMkGoQUnkE/VPEW
	 IAWANM+LfQqyFnH+KhjP9tyE90dX3A4TQG9bCXbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 012/136] btrfs: fix memory leak on duplicated memory in the qgroup assign ioctl
Date: Tue, 21 Oct 2025 21:50:00 +0200
Message-ID: <20251021195036.260420967@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Sabaté Solà <mssola@mssola.com>

commit 53a4acbfc1de85fa637521ffab4f4e2ee03cbeeb upstream.

On 'btrfs_ioctl_qgroup_assign' we first duplicate the argument as
provided by the user, which is kfree'd in the end. But this was not the
case when allocating memory for 'prealloc'. In this case, if it somehow
failed, then the previous code would go directly into calling
'mnt_drop_write_file', without freeing the string duplicated from the
user space.

Fixes: 4addc1ffd67a ("btrfs: qgroup: preallocate memory before adding a relation")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3852,7 +3852,7 @@ static long btrfs_ioctl_qgroup_assign(st
 		prealloc = kzalloc(sizeof(*prealloc), GFP_KERNEL);
 		if (!prealloc) {
 			ret = -ENOMEM;
-			goto drop_write;
+			goto out;
 		}
 	}
 


