Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0B6221F20;
	Mon, 24 Feb 2025 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408699; cv=none; b=SHxyfUg51IsEuh8T7BulYhit99AyyXYMkjg0QUoRVXonmsiNrT+KuukhM406NH+GdGjcf3OWGo9EEaooYhfOTjLAHgfLe2S637wRzzHHKlcb0uWVEPK/UYcGvSJUGHsGkHElQ6ALBohbVPaZaahiobFxWPWKOxqMQeg/EUMHm5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408699; c=relaxed/simple;
	bh=6iAX0kCy/kx9Lzos78LmeZJvhdRfK70VLS6pFyHo36U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ7luITtLj52qSkJAtdHRtrqmKRWA8wbSqgL5IfrvQpdTTFK4/HHa2cee3AxJIZlEvP73wr6eAd12h2BFoRsod0mZFDyjSJ9lMgSJ1wlBNifwoi5xJSVK/HSfKig2qXzvpxr9CdVnTWLcSJKUvncvd1RC90T9c3DytiSch6BM1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tme/YPTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tme/YPTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEAAC4CED6;
	Mon, 24 Feb 2025 14:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408699;
	bh=6iAX0kCy/kx9Lzos78LmeZJvhdRfK70VLS6pFyHo36U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tme/YPTkIqZAuFvFylBmwqY9/LNtANQd2rpvTIeGiAN1y/dKVG/flnKNxXclix4E+
	 YL5nWhXp3iA+3Xmm83MvKOkpP4RzML3k+qxHEhZentVlmZyDDKd1AvvJtA0wmd0t7u
	 gGVeUYUwxWV6oS79wVk4fb89QnVIGpavIei9pejY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 135/154] acct: block access to kernel internal filesystems
Date: Mon, 24 Feb 2025 15:35:34 +0100
Message-ID: <20250224142612.337459523@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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


