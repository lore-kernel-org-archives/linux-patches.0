Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D7D265CCD;
	Tue, 30 Sep 2025 14:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243833; cv=none; b=nOpT5ULkcdTRAAlq6dmkodTX3q1UaH9B2zMAwhMD2EBUMjfAsmnPGnbvY6VTDDHS3gl+ZamBgprsq2RFk8RXcKab8ENWL5JYTRYHouxAwItSTjoMdQvB5Fn7A7yueCPg5x6hzX4ibl8oFb/hL5insEYgFGVY+1Q3CyHMyZivYNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243833; c=relaxed/simple;
	bh=cJdh8dsYsyQGFcjuaoHbVK5IxRS6xobDGw0QditBokk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBhyKraOedH7Gw2ITT+QnNXcfYRlbIUhu47ojH8PkTndPFqEQ/zeeTdTAXhkkXBkw6U1SB68GCZC3bSu2FQ1OlPQgAwP6jI8oxnJXDc12BLsK0kPZ3K3GNINoOrVXAXwkjyFV4v9/7DDZvlwtmFwroDIz5QvlCxqhDupDjDQs6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0dEuD7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0dEuD7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B803C4CEF0;
	Tue, 30 Sep 2025 14:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243833;
	bh=cJdh8dsYsyQGFcjuaoHbVK5IxRS6xobDGw0QditBokk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0dEuD7wFqYek67SLqzREMQ74L9iEcVz/zF4m4IS9rU/7SAvZJV9MvWyKc3jRmkpg
	 vx5e/EUIA3zSpovlVR9XQnxmMEGNe04YGma6t2jmE29L37bbRehN47/YrQ4vudX4DZ
	 L8g1moMxW9lB8QqwZuPb8+Yk6t/OfZUT3GOdcVyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunsheng Luo <luochunsheng@ustc.edu>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 08/81] fuse: check if copy_file_range() returns larger than requested size
Date: Tue, 30 Sep 2025 16:46:10 +0200
Message-ID: <20250930143820.011098196@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3365,6 +3365,9 @@ static ssize_t __fuse_copy_file_range(st
 		fc->no_copy_file_range = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err && outarg.size > len)
+		err = -EIO;
+
 	if (err)
 		goto out;
 


