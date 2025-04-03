Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9913D2512FF;
	Thu,  3 Apr 2025 15:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693909; cv=none; b=N0SpLAo8Q+wi9tVxQ6HS67S3/DZ7hHCOMGBHN9A3gBfT8IvjfzoBXrzgORaEydMw0qpCQ9cOFIpm5F4aoNP9ey7ULfU+Y0u7wj9hetAVkxLbOQQ/08HbnXVmRAtdcZtFZDiSdzaEuxobfme220BCTmSbQeMsWqp2+pSrbzMNnMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693909; c=relaxed/simple;
	bh=ZDzV9+cg5mVAHSwXwS9h/wI+/M+7i9sOblt2VtoytEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6nSAr6K5TWog/k7uo8BvA+C+PHAOEXodAFllpBDPFIf1fu8T9+2cl/92rfgDDXSoM4fZYAYj47dhS8pjXUHnuPxhrBbKAc6PFmUHUZWQoT/IMOpLNN8AeoYY3xoQsGE23g0JQ34H8NHUm9Au/CKvMCtNQ6nkTTkWQTQaFQx0Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlLUjQ2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlLUjQ2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3314FC4CEE3;
	Thu,  3 Apr 2025 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693909;
	bh=ZDzV9+cg5mVAHSwXwS9h/wI+/M+7i9sOblt2VtoytEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlLUjQ2YEwRdBg2SACdBrNoEXHBDgRmptkLR0B5vWEsgG5XmVERHheHGdEp7vyd1r
	 xjGV206jSYH9Xoyr7+KdHJoZztkxkr8U344zhH4TmHO1nJ+a/sDaoYtcwNa6zP8OQ6
	 SSxjK+zqWIiLIiKp7j4zT4XfolSm84oX2aiffWjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.12 22/22] bcachefs: bch2_ioctl_subvolume_destroy() fixes
Date: Thu,  3 Apr 2025 16:20:32 +0100
Message-ID: <20250403151622.681251535@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
References: <20250403151622.055059925@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit 707549600c4a012ed71c0204a7992a679880bf33 ]

bch2_evict_subvolume_inodes() was getting stuck - due to incorrectly
pruning the dcache.

Also, fix missing permissions checks.

Reported-by: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/fs-ioctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -520,10 +520,12 @@ static long bch2_ioctl_subvolume_destroy
 		ret = -ENOENT;
 		goto err;
 	}
-	ret = __bch2_unlink(dir, victim, true);
+
+	ret =   inode_permission(file_mnt_idmap(filp), d_inode(victim), MAY_WRITE) ?:
+		__bch2_unlink(dir, victim, true);
 	if (!ret) {
 		fsnotify_rmdir(dir, victim);
-		d_delete(victim);
+		d_invalidate(victim);
 	}
 err:
 	inode_unlock(dir);


