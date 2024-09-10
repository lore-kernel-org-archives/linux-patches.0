Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803A7172BA8;
	Tue, 10 Sep 2024 10:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964070; cv=none; b=lNX1b1xcOQxLZCpCtZLnIfNQzfDRWKatcl/6WMEWzW+tsBs+eZW8gWdiNPoo8RqzkSpvSHybfa644y2Qltf84F+0rYCj6HAjkZiwEBDhqX+/6VzVwof84hjeXdUKRYVA4kf5CsFvoAgb3Stdj6OpnEegnWm7WR/1M4+Y6PEc/p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964070; c=relaxed/simple;
	bh=vTYU3+Qk9DEX3W/iR7NNgcGgWAgsCwpSj1CPHPVCn7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7BnuN7N72tdyj+mGO16TVs4rGnlmpVJaXIA3ev12XoaXVvpmKXFO7SVnCfHminYN5OEP71uLGI5JCDI08M6bZbufhrLd9glgGoHe30hcz7rXuz1oVmwh4sqLbrtfY+TI9t23t+6RnXsk1ouW1JyDqpfyF3L+U8V4j9h8ERz2ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vK0slgqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vK0slgqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06153C4CEC3;
	Tue, 10 Sep 2024 10:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964070;
	bh=vTYU3+Qk9DEX3W/iR7NNgcGgWAgsCwpSj1CPHPVCn7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vK0slgqyR2INw+OBWVUfUkQbuZfelAmz05gfSw9tpIOyxT4HsnEZ/drSLINs5Hpaa
	 DNUyz6xXvJlD2qsjvxC3NhqLKfrjlAxyTtyKIDRiY1pbfuo9FbYn5soKyvgZChhr/0
	 Pc3vjUCpyiDwH4awLMngxY76x331cxwa5x1A9TVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangyun <yangyun50@huawei.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.6 031/269] fuse: fix memory leak in fuse_create_open
Date: Tue, 10 Sep 2024 11:30:18 +0200
Message-ID: <20240910092609.351687706@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -668,7 +668,7 @@ static int fuse_create_open(struct inode
 
 	err = get_create_ext(&args, dir, entry, mode);
 	if (err)
-		goto out_put_forget_req;
+		goto out_free_ff;
 
 	err = fuse_simple_request(fm, &args);
 	free_ext_value(&args);


