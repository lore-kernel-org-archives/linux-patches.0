Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B2F22FF40;
	Mon, 10 Mar 2025 18:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630632; cv=none; b=k9ifTJHG+diZl+Ze7ykABiGQExjZgvxv8FB5o5rG/x67xuulq/Op2vOztqZB9zu086ljhvem0VCkPtjI1G1JW+Z18yQx+T9x+h7mvxWNRIVQGjR5yMpc3fKyaex3DL9rBQWkFCMinaf8uNXTKJ6R9oE1fWBGvyRzIhMiK0EAbVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630632; c=relaxed/simple;
	bh=zYnDHOFnp5mqZzvAxCypTdclzwTwhkfXx/l6+C4eFD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOfg6vBt8DfD+9mn8pScDbSNZAj58MXElGXUceSrCn8mMdg4r60TkncZL3xO1XmDJN+1MQZOIxcgH7JIQLNXGKVMiCDWBj/tmqI9XlZMXPGYnDG44gCbRllquHDU/o96cp0XJwzeqwoiVPCA10EPR6E0F8+BuaTZ+Z0tKO9sMIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkHreA86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkHreA86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047D6C4CEE5;
	Mon, 10 Mar 2025 18:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630632;
	bh=zYnDHOFnp5mqZzvAxCypTdclzwTwhkfXx/l6+C4eFD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkHreA86T9R1HHoO0m1JuuxPYK1qASn5nJH1zhN/VpSCVphqzLAGqNvpin74Tj53n
	 m3jPueaDJJHxdGTW0emgBLRb8MiIbaMrGY0h6QpJen6bV68xkFnKfO9X5LtEdWzQWt
	 90+WhYH3o/8EWMp5pevw1s36PBTuGgwMIx9ubNow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 481/620] acct: block access to kernel internal filesystems
Date: Mon, 10 Mar 2025 18:05:27 +0100
Message-ID: <20250310170604.559320445@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -225,6 +225,20 @@ static int acct_on(struct filename *path
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


