Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3907C26461D;
	Tue,  8 Apr 2025 11:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112937; cv=none; b=Ji0WYAlZpg6Rcaesrm6b8rJG01jh9KxupdOoiEGSoe/aNmnjTGbH8CXY/OYwwiBVjc0J7vzYOIkULOyVnoxseJiDvIdsa0zuX97l8cZOvbo3VaXj9sYnB2W+iGER33aRxJH2F8VsByD8wO45rB1gy6asO15W3HthxIVBlWBenu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112937; c=relaxed/simple;
	bh=KyPFHBOrZau6qMhoQ5CvglrY3e8udmZPd4kT5p1FgJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKdiBgA26E+yhwiCGlKe/Ke93JrYz2Y5p8kle8kKz4DV0rTLowYF9hz3eZZEweYiRZuoJsGbPvYjZRqqwV927yeHU8B3fsRxa5ipagojQR5jH7Bx01mFq52FyXnQj4QuBx2APw+VaxIjXiGtKNUYbFGWLNl/gv0KrZ/+R+NYJ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f291vyEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f291vyEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC78FC4CEEB;
	Tue,  8 Apr 2025 11:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112937;
	bh=KyPFHBOrZau6qMhoQ5CvglrY3e8udmZPd4kT5p1FgJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f291vyEc5tIlnXFPjyel6WRac2ZgAs6Y26gqXX659DH5ZcGZ88TdA/aDQk1VgyXR7
	 FbarLFUAGoh/2BHxl1OGWAN8KiYsl5ZefF40uf552GDRf7EvtFNH0xZQULlxnklung
	 A9jmQGSpfwV4Hkl8d8xE1N713DT7BU1Lgujha9HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/279] ksmbd: use aead_request_free to match aead_request_alloc
Date: Tue,  8 Apr 2025 12:49:57 +0200
Message-ID: <20250408104832.127476630@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 6171063e9d046ffa46f51579b2ca4a43caef581a ]

Use aead_request_free() instead of kfree() to properly free memory
allocated by aead_request_alloc(). This ensures sensitive crypto data
is zeroed before being freed.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 3b776b5de7db6..647692ca78a28 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -1211,7 +1211,7 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 free_sg:
 	kfree(sg);
 free_req:
-	kfree(req);
+	aead_request_free(req);
 free_ctx:
 	ksmbd_release_crypto_ctx(ctx);
 	return rc;
-- 
2.39.5



