Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E0F18CBE1;
	Tue, 30 Sep 2025 14:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244176; cv=none; b=CFjAtWAyzXe4dlCyqe9P6TbH5MMGDH6vPSxNr/yHAiCTVA78A/MIWbZ4zJCgknZP4xbdBRrmYN6KM1hIfZjVbz5PE2Qu9F63+HdEfw+ieI7E6zN0tw98i4bcPbcO5zH6tlJC1aTTpku8Ms1AOMcWlpASKUY7f9ENpXqmjDe1H8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244176; c=relaxed/simple;
	bh=dhJ1teCd0FdKin1LyzkUERjsh1Ji38NLWcsWID4QQbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzAADcoMloWS0Y/1LNhMN+jW5UxrjLnxE9IzSE3izdi3z/pANO5Qw0lHEq0YmmXcoMj8sepY/aQNyJiBL3StKzgZ29GgG3/vH5Wjc0AO+nVCKVapY4Tn4haVNeiHpGNxWrgCG/QqpGOJrVegU36YFpiE7lcusThJQZ0sbbJIiHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Dz9/nFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Dz9/nFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1543EC116B1;
	Tue, 30 Sep 2025 14:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244176;
	bh=dhJ1teCd0FdKin1LyzkUERjsh1Ji38NLWcsWID4QQbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Dz9/nFlXGdYk4CU0U0n2jXwt6qexvD/338YYMQbYtfZuHlsJ1TQTGQHu5AttXgqF
	 CJbDZYQyxYJQXNsYvBo2RQQDFGN8nKkirBwgkdRb0mcNuNdJbm04+D7+9+tLzqljXB
	 rgpo4hqYuRpz28RFHOu1N31hUWlGf8qNY7qhs2dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunsheng Luo <luochunsheng@ustc.edu>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 019/122] fuse: check if copy_file_range() returns larger than requested size
Date: Tue, 30 Sep 2025 16:45:50 +0200
Message-ID: <20250930143823.777150521@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3450,6 +3450,9 @@ static ssize_t __fuse_copy_file_range(st
 		fc->no_copy_file_range = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err && outarg.size > len)
+		err = -EIO;
+
 	if (err)
 		goto out;
 


