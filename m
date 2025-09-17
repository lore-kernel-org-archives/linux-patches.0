Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AF717BB21;
	Wed, 17 Sep 2025 13:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114199; cv=none; b=T8XTP7ygktY0EGYkU4S9cBXvmuTASxpouAqJNI6DrUDPLZ/FgEHKO92gKXUiv+qxHwNgwbJf5UoYzGFW9x99+ElUZcL+CR/AXIvI/FTEitH5yuKZPFlCWYvOdGX53mixVpB0NVcUR/VCyJ6kSqFccaZTcl89beHKeMzLehuWFOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114199; c=relaxed/simple;
	bh=mhDb/LgS86DA42tiT9Z9vNVaZ1gTfy5qBbhgPa6083g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHN/XYkt1ZamFCLR5mI5u0SFTuI60cGB2/PejpHEr2D0ijua8n7l/bDZq+hm2VLp6jq9gr5CyhzXCP7EbXjkMZ21vJnXyv0B4IhMXwfl/ADDn081q3jRPCDFQJOi9BrIlfzG1XUedmZ7GhJq6whTyZIfgk+X1o9HnO3IPdX4JMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPLyMgE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPLyMgE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA57C4CEF0;
	Wed, 17 Sep 2025 13:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114199;
	bh=mhDb/LgS86DA42tiT9Z9vNVaZ1gTfy5qBbhgPa6083g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPLyMgE8Ao1dlgbtu6f6/FLQMSslNvPNObdQOkVNZn4p2oL1VCskXizfyICzXZu9z
	 eneG/HFuaQvWIwIJOxPuG/jfts/uVAks+if+x5dJnFatsAArVyBSBwS9v7RV6gIHoi
	 5ApCjnmWI4TjgThAGFm6yVa7Wy+mbjZYwv6xOB2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunsheng Luo <luochunsheng@ustc.edu>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 31/78] fuse: check if copy_file_range() returns larger than requested size
Date: Wed, 17 Sep 2025 14:34:52 +0200
Message-ID: <20250917123330.323435071@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3169,6 +3169,9 @@ static ssize_t __fuse_copy_file_range(st
 		fc->no_copy_file_range = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err && outarg.size > len)
+		err = -EIO;
+
 	if (err)
 		goto out;
 


