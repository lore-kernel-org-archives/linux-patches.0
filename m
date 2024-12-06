Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A1720125C;
	Fri,  6 Dec 2024 15:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498049; cv=none; b=gFwuN5dbSJ2E3xMk5pL7zghX4JNByv9ZXndQtvSAnZoW2xtDwRnqT7LmV+47UVZZVfiKHQTGsf1Y4FX5wvkHxRvW5L0xgOKCJlqz4tIl+y/HTkP9A5+uIas8V+xygmOf83Bfs4oWeswufUVRr0ngNgFsZVXTU1fUfFGoV8Jl0v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498049; c=relaxed/simple;
	bh=Yky2xUZkiiuCD2CXZDyFVN1X7r2bNfaLM/x9C48j7VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hl6P5aK9wqqcPG3o4ItuvUzfwfAdVnJCaOSGZ96WMePVBNi3OIFwNivql97h+s8LnhpGVGxuOv94LZUWVDRTBl7K6V1n+1oDzp4k8iHXoHe98tzA7oAcC7+GLEjRDGEWjtpwBQjT6fLRIIXgcyYTvnxTw+h/2nFtYK03EcaQL9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lI+2E7VD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lI+2E7VD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F2FC4CED1;
	Fri,  6 Dec 2024 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498049;
	bh=Yky2xUZkiiuCD2CXZDyFVN1X7r2bNfaLM/x9C48j7VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lI+2E7VDK0vyT2vRDVwQAdOv8EyapWiF6uiKb+uRGVGLqqBikdFxviYZIgZDJ4/+W
	 rnCJ4tYoRHI3Whf0GteGvHseWzohQU1NORbk3Hwmjv5IM4Ufk8AsX9uiXfqRSXgEIA
	 395Yhc/zmDVoYpp0FzY9poC1vamkt2T3BgmSud/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Sadovnikov <ancowi69@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 6.6 471/676] jfs: xattr: check invalid xattr size more strictly
Date: Fri,  6 Dec 2024 15:34:50 +0100
Message-ID: <20241206143711.765553152@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Artem Sadovnikov <ancowi69@gmail.com>

commit d9f9d96136cba8fedd647d2c024342ce090133c2 upstream.

Commit 7c55b78818cf ("jfs: xattr: fix buffer overflow for invalid xattr")
also addresses this issue but it only fixes it for positive values, while
ea_size is an integer type and can take negative values, e.g. in case of
a corrupted filesystem. This still breaks validation and would overflow
because of implicit conversion from int to size_t in print_hex_dump().

Fix this issue by clamping the ea_size value instead.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Cc: stable@vger.kernel.org
Signed-off-by: Artem Sadovnikov <ancowi69@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -559,7 +559,7 @@ static int ea_get(struct inode *inode, s
 
       size_check:
 	if (EALIST_SIZE(ea_buf->xattr) != ea_size) {
-		int size = min_t(int, EALIST_SIZE(ea_buf->xattr), ea_size);
+		int size = clamp_t(int, ea_size, 0, EALIST_SIZE(ea_buf->xattr));
 
 		printk(KERN_ERR "ea_get: invalid extended attribute\n");
 		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1,


