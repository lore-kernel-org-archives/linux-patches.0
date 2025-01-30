Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAEA13FEE;
	Thu, 30 Jan 2025 14:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246885; cv=none; b=FII6GZrsqWdddx0JNjFB9jeHgu2xElS/RG38C74uHxmXm4nhf82ZE1LBbM5l0SFq+FHvdIoioG6+P9V4X+N3btrJREx5rEgMm3byi5XKpjGTHFt5l13V4m5iruJJ3NsjbhuiBTiQNL39ffbuRDMAzE1Vp1qrqgbxR2xyHiDZGEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246885; c=relaxed/simple;
	bh=5X/0vMENPAGJa/TNCGPqo+cvco4KsBHgMj7h71jyx/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uGGTXpq9bgEj8unIQ11NJMcWhlnEO0/x5upstevstfABKdEn7cX1eRQm8txPLj9b9UvDCE/VeEyZjEDbSFFGgkORGbq2IChtNb3icCdPUvv/kQ5NxvsYbbZ4InkS7nLQ5lmh1E5McKZ2cjw48mO7Y11DutmqkLJEGpC+uNew1Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6cqX2lu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6cqX2lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78354C4CEE0;
	Thu, 30 Jan 2025 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246884;
	bh=5X/0vMENPAGJa/TNCGPqo+cvco4KsBHgMj7h71jyx/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6cqX2luua6KgOGzWjX2S1NboHFHy3wkf1bSHqnk0CrwfALvU66dqqxtXFCmAuRhE
	 6FPUJuipUDFPdIgicxPZxdigmOx4mSXyzcDNoJdIcnPG0V3QufkUAQkqkjVc2RfMdw
	 iLFQjeIIo95Xd9v7HFYBDiBvxz0CDakxaqj2Amrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dario=20Wei=C3=9Fer?= <dario@cure53.de>,
	Max Kellermann <max.kellermann@ionos.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 001/133] ceph: give up on paths longer than PATH_MAX
Date: Thu, 30 Jan 2025 14:59:50 +0100
Message-ID: <20250130140142.554181278@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit 550f7ca98ee028a606aa75705a7e77b1bd11720f upstream.

If the full path to be built by ceph_mdsc_build_path() happens to be
longer than PATH_MAX, then this function will enter an endless (retry)
loop, effectively blocking the whole task.  Most of the machine
becomes unusable, making this a very simple and effective DoS
vulnerability.

I cannot imagine why this retry was ever implemented, but it seems
rather useless and harmful to me.  Let's remove it and fail with
ENAMETOOLONG instead.

Cc: stable@vger.kernel.org
Reported-by: Dario Weißer <dario@cure53.de>
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[idryomov@gmail.com: backport to 6.1: pr_warn() is still in use]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2451,12 +2451,11 @@ retry:
 
 	if (pos < 0) {
 		/*
-		 * A rename didn't occur, but somehow we didn't end up where
-		 * we thought we would. Throw a warning and try again.
+		 * The path is longer than PATH_MAX and this function
+		 * cannot ever succeed.  Creating paths that long is
+		 * possible with Ceph, but Linux cannot use them.
 		 */
-		pr_warn("build_path did not end path lookup where "
-			"expected, pos is %d\n", pos);
-		goto retry;
+		return ERR_PTR(-ENAMETOOLONG);
 	}
 
 	*pbase = base;


