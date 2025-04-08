Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFB926B2C5;
	Tue,  8 Apr 2025 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117147; cv=none; b=u2rK9xF+uCU1HkxBPTVP7FLsWbB+PmCaLmJ8OMqsdeUW5F+Ta1OwoJMV+lyHT0oEwqw+8J7ucaqCtme83ehjxWosOHYqadOx5c3CGqjvJghJx+7ajzhwoRkaCK+VBULzM3iy5APp6j8tuP+9hj04WdZSaeAzU61QJPRgYRDE194=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117147; c=relaxed/simple;
	bh=phSXsIYv+IZUmlPccEOOkatu37U44NBLdHKHGYBObHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYnTnrrBSenZU8LYb8HVUevgLFX6qm1fDfeSGGVTIgcW8/tnP1Q5GsAVkrF7Z9Y4WTp/cU1wNY7ZCdRfPLO1KKiJMfQK19MQ+W8Uo32PPFw1rsc2eqLq+OI5jBQ9k9632xnBKhJEgvuffqO3ZfBMPVAbLryQBGELWHuehaDZ85E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/e1SxbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/e1SxbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78506C4CEE5;
	Tue,  8 Apr 2025 12:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117146;
	bh=phSXsIYv+IZUmlPccEOOkatu37U44NBLdHKHGYBObHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/e1SxbNVaXOeO7KzrUfknlDBgW88nqs/GeoJ3w/LZ3fabjdQgoEQ7XOtoFin9G+b
	 P2uXGg6abZSWmZV3QdblH1h0CP9acPLBWwrA1ngiYPy6QLEJNq1lM0ZTwa+yt67g0w
	 Y+yTDLH72OX7D4U1/vvk8XCQqXB7tkiUC/svFhf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 402/423] exfat: fix potential wrong error return from get_block
Date: Tue,  8 Apr 2025 12:52:08 +0200
Message-ID: <20250408104855.270130099@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Sungjong Seo <sj1557.seo@samsung.com>

commit 59c30e31425833385e6644ad33151420e37eabe1 upstream.

If there is no error, get_block() should return 0. However, when bh_read()
returns 1, get_block() also returns 1 in the same manner.

Let's set err to 0, if there is no error from bh_read()

Fixes: 11a347fb6cef ("exfat: change to get file size from DataLength")
Cc: stable@vger.kernel.org
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -391,6 +391,8 @@ static int exfat_get_block(struct inode
 			/* Zero unwritten part of a block */
 			memset(bh_result->b_data + size, 0,
 			       bh_result->b_size - size);
+
+			err = 0;
 		} else {
 			/*
 			 * The range has not been written, clear the mapped flag


