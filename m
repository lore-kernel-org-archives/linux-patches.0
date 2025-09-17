Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE94D1F151C;
	Wed, 17 Sep 2025 12:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112776; cv=none; b=RwWXm7grZoAwc3X2YQ1MCFOeNe5yTfLTHyBZksDDxrnlz2jrrw0M4fkMuk9W+mRxx0+Liv2niGCr2XljfjQrbzP/xJyNn7M5WIU3AW8XySK5mUdZHibK+bWmxvZN9YCjDy1PrHJxXyWHxdX6xcwYAogjnpS2SGsGTDIlpoR8pR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112776; c=relaxed/simple;
	bh=xBT/BUrrnuKvM46dgi3rzhaBJ6+NrgsPN4Rrms7RijU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFQ2sx3qvxGzrWS8YrovkiO7UqwC5qg6KvTIoSwlQ6hJuRsUetU+Ekw6A5cfwHcw2T8E3bdu8AtyzUk2xq5l8uGc9DzEtG4was75kGycJo2Xm68Y5P+1cIlKsN/S5eR+9N7kI+qFJ8owYEbgNwIVQehPw3JV0/VQgb17jB7dgXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJox/9En; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJox/9En"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F33C4CEF0;
	Wed, 17 Sep 2025 12:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112775;
	bh=xBT/BUrrnuKvM46dgi3rzhaBJ6+NrgsPN4Rrms7RijU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJox/9EnA58htaZTvXBPScj1kcnnVz2hFZu0L+q86LsKX4dgdneNzX45N1uUajzms
	 X62cElA1MKRemJmbc7KvVVhfhsE1Sot2aNyUAyrDLbL1kOWzqLQR3f/FKw4CBls/Zn
	 RaXkgz5admrQkqdTzjalXSikyOfhZVFpVXuD0nwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunsheng Luo <luochunsheng@ustc.edu>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.16 074/189] fuse: check if copy_file_range() returns larger than requested size
Date: Wed, 17 Sep 2025 14:33:04 +0200
Message-ID: <20250917123353.674875063@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3079,6 +3079,9 @@ static ssize_t __fuse_copy_file_range(st
 		fc->no_copy_file_range = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err && outarg.size > len)
+		err = -EIO;
+
 	if (err)
 		goto out;
 


