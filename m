Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCF718C005;
	Tue, 10 Sep 2024 09:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961353; cv=none; b=Q9uxnNyJ4ymILLMVR9b2GkuzppYXHSf7v/9dIKOC2SrQS2gL6eE32sv2H0iGdup3BR/k3C8I4jYuXFXZnsanLo2TA8Ub+MRA4n8kB44ApxBOe1ViYiK6xJVnLiWV2H33YEd/FM2dZmO0vqdDx0HVVAtbdvzAXYBkBkt7Hr+s7YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961353; c=relaxed/simple;
	bh=btXLsy69zPGclKHtmx1Z0UgcALBpGRADs5odnJexWPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oeki9AbmCEzvCeM8UOPCUHlRi2kO6RRD2Pttpbwu15f0mWBBwx6uVGunGe7fDTUoFXmNMvZA4L82QtzXvMHu8rcQ5WDmXN3x5fBspHmh/imAjsDUYAKFS9yTanZhqmHoo1XN1tkxbA/TZsQenya1N6Et/vWuUNcRozoITcYI7s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwNxtY7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwNxtY7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27D2C4CEC3;
	Tue, 10 Sep 2024 09:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961353;
	bh=btXLsy69zPGclKHtmx1Z0UgcALBpGRADs5odnJexWPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwNxtY7E4QVrAoqfVReaabV1kk5Us1GjhjjtaX8jXOIjsAH9yZeEYUEsFm2w4kRjk
	 FmpL9IoXx4MNwhpl+xT0dPEavSgnu7qc2yCH02fDUJTzxD7UK9rp72DV99YLkYqDjf
	 O3YP4/Of/b//trtJ7qh/1JlsdRlK7jEHWmH2BllI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangyun <yangyun50@huawei.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.10 041/375] fuse: fix memory leak in fuse_create_open
Date: Tue, 10 Sep 2024 11:27:18 +0200
Message-ID: <20240910092623.618188016@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yangyun <yangyun50@huawei.com>

commit 3002240d16494d798add0575e8ba1f284258ab34 upstream.

The memory of struct fuse_file is allocated but not freed
when get_create_ext return error.

Fixes: 3e2b6fdbdc9a ("fuse: send security context of inode on file")
Cc: stable@vger.kernel.org # v5.17
Signed-off-by: yangyun <yangyun50@huawei.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -670,7 +670,7 @@ static int fuse_create_open(struct inode
 
 	err = get_create_ext(&args, dir, entry, mode);
 	if (err)
-		goto out_put_forget_req;
+		goto out_free_ff;
 
 	err = fuse_simple_request(fm, &args);
 	free_ext_value(&args);


