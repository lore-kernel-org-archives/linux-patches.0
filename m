Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447781EE02F;
	Tue, 30 Sep 2025 15:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245068; cv=none; b=Yo9bB6RIE8Jpz2JWOaeuKR60MJUG0BRJbO26Xx4XlXPpbPUUQKPtPX7dwW25Fi6eOWa2wRS0/hn1T1hgeqaUOPbqoaXbJdRJeZ78o3lrUDM0PrmwgZSLgwpkOMs6roq9Oy4C2m9oycjaQRstfUAXNqPj0rsEfeZSOUxQhgJxvUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245068; c=relaxed/simple;
	bh=IQghZj3xs/7dv+Vh2PfTV3CTSiOjT+xa4epiJ5DZamA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIMOhDnqsfa2gXyjXHpF0ZC0RG0xCQTI9CskxgVzqwLpLK2K/DQbwDzFkPPE2lOiUown3Uyulj5Jf1OpcOoY2dBK7gpxnORuhgzZW3vAS/FZylfq20NveLRmbqYZNfGB1RyEe8miXkEk5ZzCkzpK60CQwPuNVerDVQgfdgRJenk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCplIsrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCplIsrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF90C113D0;
	Tue, 30 Sep 2025 15:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245068;
	bh=IQghZj3xs/7dv+Vh2PfTV3CTSiOjT+xa4epiJ5DZamA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCplIsrModbLHJr7bFsG3HDj7rmIigMdAwSTV9JIKniprehpZT2v872Y+hvWTtSJp
	 BTHWF/+5Hyn9z9jzpO9l1o65xj1uV6AYikURY0Fx8xYK2qFQpMYusDm+3lUKlhetIW
	 E478+UFPRi8/zieNwu9YpmF2BfvZMt3SGvqJi7ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunsheng Luo <luochunsheng@ustc.edu>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 025/151] fuse: check if copy_file_range() returns larger than requested size
Date: Tue, 30 Sep 2025 16:45:55 +0200
Message-ID: <20250930143828.615316167@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit e5203209b3935041dac541bc5b37efb44220cc0b upstream.

Just like write(), copy_file_range() should check if the return value is
less or equal to the requested number of bytes.

Reported-by: Chunsheng Luo <luochunsheng@ustc.edu>
Closes: https://lore.kernel.org/all/20250807062425.694-1-luochunsheng@ustc.edu/
Fixes: 88bc7d5097a1 ("fuse: add support for copy_file_range()")
Cc: <stable@vger.kernel.org> # v4.20
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3113,6 +3113,9 @@ static ssize_t __fuse_copy_file_range(st
 		fc->no_copy_file_range = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err && outarg.size > len)
+		err = -EIO;
+
 	if (err)
 		goto out;
 


