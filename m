Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830961D0799;
	Wed,  2 Oct 2024 13:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876898; cv=none; b=DTIsrXUlokkAJ5Vae4YuyKB0A+mDsD0/shBtWfBuzvvS1KhC48CuajtcabOgW1i8as6mWRkLo1xeCakCoodaD3tSnMB47xfopPqhyyPWOoVEr0r63n4CHJ34AS9UzofskHPb3DVe3+fqgZnjOqFSJHCxHhU7OEbyn2X4R4CJkPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876898; c=relaxed/simple;
	bh=MHn7C3JdTRz6RNXi/BRd34SeS5Dl2Ph5cVPjuFB7U50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJGzIwvSU8IetdjtBvn0Qx0/k0OzAfOM9rO64VcDkRh7lfkkGehCsu/3VRjsaOG1mIHOCi9g6Qf7ZzybF6Jm8bxHg5yvo0XcOJYum6h7tHHgyvBOfqubkyGBDKrU8ljUjyG0HXlb9LLZTKDvSKN1tyjYy2Tlm15Rb280Kt6GdFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NW50Ahfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NW50Ahfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E913C4CEC2;
	Wed,  2 Oct 2024 13:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876898;
	bh=MHn7C3JdTRz6RNXi/BRd34SeS5Dl2Ph5cVPjuFB7U50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NW50AhflhO1k9iYbKPTfN/xLRqVHDSYHnoIoKVSj2f2WPsJsNF1xBdhM4Js7Y54+2
	 Yjrh0AXO6kDyh+S50vGPVqldT3Fm/UlToISVB3AM9f9oPNNJFoO7eYBD0nJD43HJ8B
	 uqjWiGaM5iVym7S9tgLMN2yuj0m4u2sgayXWUTJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hobin Woo <hobin.woo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.11 566/695] ksmbd: make __dir_empty() compatible with POSIX
Date: Wed,  2 Oct 2024 14:59:24 +0200
Message-ID: <20241002125845.098833952@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hobin Woo <hobin.woo@samsung.com>

commit ca4974ca954561e79f8871d220bb08f14f64f57c upstream.

Some file systems may not provide dot (.) and dot-dot (..) as they are
optional in POSIX. ksmbd can misjudge emptiness of a directory in those
file systems, since it assumes there are always at least two entries:
dot and dot-dot.
Just don't count dot and dot-dot.

Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1115,9 +1115,10 @@ static bool __dir_empty(struct dir_conte
 	struct ksmbd_readdir_data *buf;
 
 	buf = container_of(ctx, struct ksmbd_readdir_data, ctx);
-	buf->dirent_count++;
+	if (!is_dot_dotdot(name, namlen))
+		buf->dirent_count++;
 
-	return buf->dirent_count <= 2;
+	return !buf->dirent_count;
 }
 
 /**
@@ -1137,7 +1138,7 @@ int ksmbd_vfs_empty_dir(struct ksmbd_fil
 	readdir_data.dirent_count = 0;
 
 	err = iterate_dir(fp->filp, &readdir_data.ctx);
-	if (readdir_data.dirent_count > 2)
+	if (readdir_data.dirent_count)
 		err = -ENOTEMPTY;
 	else
 		err = 0;


