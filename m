Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624592;
	b=0Scj/ptJlUnN9hZoW7uaFfJvtrFoNYpS4UAQQ8q20UK62+X0twEORIwkV9cH6vYZAYWa
	 p+LCifyH/uzNmRbEsYTEqX9SQMTSR9WcRfiadoPZ6fz31crMacehojWdg7YCQp09ObDIB
	 qaiXMK+/6PIVbZy5vjD2aPpw9W9U16NzZtXxwjvDZJGuKaT5iSFRx8tT/Ypd6ZR/RR3Qb
	 lqt838rHmHhaRUeuXYGRbRG2DXJGweXqkLmBW4PYxh0KztIuH4rxAzhTZtG2bHaOl37wi
	 4kV44B6JjTSgAuv0UIOVfVyfNtsX0A4b+otAxatDk/+HPBHyc0CX+TlZirDHV4dLkVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sq24X+yA9baleicXNGzLu60PLi0n1aIq8r1omJE+L0g=;
	b=Ndj9x8gX6hH2zcPU7fp6RO0W4lr7Zx3GJiSgHS3upgZRBB10YWChRTH/PDeD5hiN608/
	 QhOZv7ooZc6Fz+B48HjJIiF6r+Oc+aWMfdymJuHIB3+eqnsa0Fw8fctvJxgqvv/rX8zka
	 e9DpWmCIY9rPJ6Zide57OW9sZGBjx+gY8lvbVw0+0TFqTX82o9h/qhxle85/yQWZWxj+J
	 5dwetfwNMQLrpLVU3Injk/b+H5neaI0fatWoQzhSUvGzPaJGpICNISJHnFZkBEzVEAdor
	 v7W49hbql4kSlhfMHsqV9Q5VJzF/puewZ83Rw1LaKjoaYGLqAiawEdnZrwkyFGzkAKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NZgJpvsy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73190606A687;
	Wed, 25 Nov 2026 16:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NZgJpvsy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE7E1F000D2;
	Wed, 25 Nov 2026 16:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624592;
	bh=sq24X+yA9baleicXNGzLu60PLi0n1aIq8r1omJE+L0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZgJpvsykJ1HH6j5oxOnnVywiQRBjSIyjtf2jF0mdNCVwKGhDBGj0mDurXob3f7pJ
	 tUTj91e3/2VOrr5/2vwvIxp2fG+7K8fSaKnMilVbo/xYFdpcZLzZrZUw/N/HwhvHsi
	 TAnwVs3fUaqtxpump1XuN/rpJHLVDZ168bdK8Q04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 243/816] libfs: end offset readdir at positions past DIR_OFFSET_EOD
Date: Wed, 25 Nov 2026 15:29:51 +0100
Message-ID: <20261125143854.835345901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 45eb9737058fa78a73f17a5da55c8cb482c6d5bb ]

offset_dir_llseek() takes any position up to LONG_MAX but
offset_readdir() only skips the walk for DIR_OFFSET_EOD itself. For a
position past it mas_find_rev() starts the walk at the highest offset
in the directory. So an lseek() past the end makes the next
getdents64() return the whole directory again.

Before commit b9b588f22a0c ("libfs: Use d_children list to iterate
simple_offset directories") the walk went up from the position and
found nothing past the end, and dcache_readdir() returns nothing there
either. So only walk for positions below DIR_OFFSET_EOD.

Fixes: b9b588f22a0c ("libfs: Use d_children list to iterate simple_offset directories")
Link: https://patch.msgid.link/20261101-work-libfs-offset_readdir-v2-3-c621125b56d1@kernel.org
Reviewed-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 028f2cf729d5d..b4664a864689d 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -559,7 +559,7 @@ static int offset_readdir(struct file *file, struct dir_context *ctx)
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
-	if (ctx->pos != DIR_OFFSET_EOD)
+	if (ctx->pos < DIR_OFFSET_EOD)
 		offset_iterate_dir(file, ctx);
 	return 0;
 }
-- 
2.53.0



