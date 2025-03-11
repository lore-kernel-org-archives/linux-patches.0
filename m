Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0662405F9;
	Tue, 11 Mar 2025 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706079; cv=none; b=OKp5gc7OwT+RtvD7ArPQzvSE5osboQumU02xB5+4IqsnEsG6tu1tPWtPm44hVsSpQrsFbEKhY+rfcNqP9zGQhdUGOhecgAvXSHIEEaA9YguIQSJSZs+1qrQnZcRogBasZqqk2LwxPff5Pa2RlnQNUsXqVVhxrq9UkCmX5N7CXWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706079; c=relaxed/simple;
	bh=csWSJo0/bwr+9SGed7myAdPc2+2iciwa5ELr9ImyQmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEzNkIukW+ljkPK5o8Ib6UuAJRvcU+IVfS2+XgKkgZdX8Qs2LQiWoSyGx3ePeVYjH56uieTWlkruFeaNgitDP/82S/uK4LLLlwdM0qS9oBQ8q/7d4fbL0Ec9iMenYsmpJsuE2IWd5xoclxtYuehI4EZY9POVMfGh29brDJPkcug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhcnuvPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhcnuvPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1907C4CEE9;
	Tue, 11 Mar 2025 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706079;
	bh=csWSJo0/bwr+9SGed7myAdPc2+2iciwa5ELr9ImyQmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhcnuvPKDfV9LeOHiRITocxbIUizyiHMp+IGPhxmjO/3QmiLq94iks5y5FVgw5XXS
	 JidDtJrNRIGKm8KEk2qPvSrPIuDNTiNllCvO14KZiT9tFEAId7p/XQ/LJ0dLdVb6o5
	 2bljDHuoZpqYChvvRhU84eD72PLAJ/YpH74cEJBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.4 255/328] acct: block access to kernel internal filesystems
Date: Tue, 11 Mar 2025 16:00:25 +0100
Message-ID: <20250311145725.044618636@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -216,6 +216,20 @@ static int acct_on(struct filename *path
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


