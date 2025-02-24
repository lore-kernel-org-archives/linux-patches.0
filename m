Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8051B7F4;
	Mon, 24 Feb 2025 14:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409185; cv=none; b=NvOPi5CMx+Dmw5icbNGlIlVZL7KfktB5hPf8GiAzV2b4NBCNjtQxn7TRU69gjTfv4DIm1fG2jU62ylPpU1dmzZ1ozVKCpKy1GTn73LSZdDigtzzzUehOHUYPYMgQ7Iu+WWdpu/FzdTMsqB0tkv0dGRddFuJ5pyEWSs+oTzoMUjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409185; c=relaxed/simple;
	bh=wDbZo1pTFT7Kjgj//gdc+4twUbF8zOkIw1gj2RnRoNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFFlaWpz+hSOc4QVuQNHz8ub4F8Iwh0A+5DEf2ICnYBRRApat11lGMjOWcoA4k5hlCoU3BcKKQrkcu1WpO/coRz8FG2QaRigy0btpv4URUdjveghfqQXWECuJ5zeyiDQHyk+TGmy26Xqz75MkYY4f0Xf31oE0U/pjHWUsYyg7lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8kH19hf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8kH19hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDC9C4CED6;
	Mon, 24 Feb 2025 14:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409184;
	bh=wDbZo1pTFT7Kjgj//gdc+4twUbF8zOkIw1gj2RnRoNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8kH19hftt8jONV9XdAiFpO1OG7wsMqt4H9+LMoUHOWHFm4w50rCrChX7QyJknJou
	 XTj5+olN5nig+pOfCfjVgsCjmPh9ILzE4RPHi2oZgKVJghhivnISPqUL/uuU/2wvoq
	 edDeoViQEtJYARaS+jJLWLc0yC2q4hwM3vdcmfVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.13 121/138] acct: block access to kernel internal filesystems
Date: Mon, 24 Feb 2025 15:35:51 +0100
Message-ID: <20250224142609.227852387@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 890ed45bde808c422c3c27d3285fc45affa0f930 upstream.

There's no point in allowing anything kernel internal nor procfs or
sysfs.

Link: https://lore.kernel.org/r/20250127091811.3183623-1-quzicheng@huawei.com
Link: https://lore.kernel.org/r/20250211-work-acct-v1-2-1c16aecab8b3@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reported-by: Zicheng Qu <quzicheng@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/acct.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -243,6 +243,20 @@ static int acct_on(struct filename *path
 		return -EACCES;
 	}
 
+	/* Exclude kernel kernel internal filesystems. */
+	if (file_inode(file)->i_sb->s_flags & (SB_NOUSER | SB_KERNMOUNT)) {
+		kfree(acct);
+		filp_close(file, NULL);
+		return -EINVAL;
+	}
+
+	/* Exclude procfs and sysfs. */
+	if (file_inode(file)->i_sb->s_iflags & SB_I_USERNS_VISIBLE) {
+		kfree(acct);
+		filp_close(file, NULL);
+		return -EINVAL;
+	}
+
 	if (!(file->f_mode & FMODE_CAN_WRITE)) {
 		kfree(acct);
 		filp_close(file, NULL);


