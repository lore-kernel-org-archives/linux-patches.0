Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9968F175BF;
	Mon, 12 May 2025 18:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073033; cv=none; b=VxqizxxAOTB5CRTK6trz+J4s+parPrUwcFvjAPZ4upCZIQ4dRJJf6Z5O7I0pORN6bf6N3ebt9WWdnHPj8Q6Dnke9vlcGmmgtFSkPsiJYvNMqcboBnboocJHCz4QTctII/386gUdayFpSP1iuzW9BC8CVsEBzWpG8cNNBq4HFcNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073033; c=relaxed/simple;
	bh=t2hKnZMc3lngHVhd7ASjFtocl5hgwH4s+/szG4V+ETs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFS9FWXTSnYmj2/dCQ3ilWQvJVrlhqHfMnajI3Q65R8vhDltvZ3teDFZjQ6BmJYyMMVbhaUleTqED8gQBbAkJHaq6pMf5vy+IDqELlWB+TJFbfYFl7MwfBHUWrW4uhFF/mu9haq631nJ6XsJkJ7Hpf2XQb1YCCgILrglDuqdetk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbY8zL69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbY8zL69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16227C4CEE7;
	Mon, 12 May 2025 18:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073033;
	bh=t2hKnZMc3lngHVhd7ASjFtocl5hgwH4s+/szG4V+ETs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbY8zL69Gw9/Yu88I1rgWH5PcIakkdla9pZhbP765693yMSQEDzBJT22WbVfR2UPg
	 Xizk13g/ZQ+t3Dqa2LeBfuaQibr2BZLZw7T3DJPYOjaLEKQwvx31tvNP0HbGjbqUrv
	 RnuzHKrgxh9RYut28qx/gybExNUGHzRBm5/99fX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.12 126/184] USB: usbtmc: use interruptible sleep in usbtmc_read
Date: Mon, 12 May 2025 19:45:27 +0200
Message-ID: <20250512172046.949883867@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit 054c5145540e5ad5b80adf23a5e3e2fc281fb8aa upstream.

usbtmc_read() calls usbtmc_generic_read()
which uses interruptible sleep, but usbtmc_read()
itself uses uninterruptble sleep for mutual exclusion
between threads. That makes no sense.
Both should use interruptible sleep.

Fixes: 5b775f672cc99 ("USB: add USB test and measurement class driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250430134810.226015-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1380,7 +1380,10 @@ static ssize_t usbtmc_read(struct file *
 	if (!buffer)
 		return -ENOMEM;
 
-	mutex_lock(&data->io_mutex);
+	retval = mutex_lock_interruptible(&data->io_mutex);
+	if (retval < 0)
+		goto exit_nolock;
+
 	if (data->zombie) {
 		retval = -ENODEV;
 		goto exit;
@@ -1503,6 +1506,7 @@ static ssize_t usbtmc_read(struct file *
 
 exit:
 	mutex_unlock(&data->io_mutex);
+exit_nolock:
 	kfree(buffer);
 	return retval;
 }


