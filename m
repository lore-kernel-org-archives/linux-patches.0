Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F75F1D078B;
	Wed,  2 Oct 2024 14:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880328; cv=none; b=DwlPZ7vrTyJ4+xBQ+Jb+VeJysCSkHPNPXRBCVvASYIwlyXLvXvBjCGFn9Rhij0OZX4Dt1KNwFR213kZ7j7UqwLW4ZLvD9NjEHZG86q9yGk8sF32qbhI3risg+SCGR7dX3b2+QvifVDX8oFeA1S1DtQNssofFWIP/p5E4txqM4d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880328; c=relaxed/simple;
	bh=57tgiWm7xkDuVzreGimbJINN2vlh7498vR54Nkk3V9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Buenvg+e4bHv7frUfHFKe7KGFD3u/8uScVHi9QXkwfY4+OGkdV1rXjacZJQJAcT7fBxWAGeRa2vZQVPDVw+TDkQxiMgoMaWWkAawe3mRNUTrZMfu6uM1tY0gmzCXxGFLbR88RxxdvwNJ6tQtyJWHtSWS3tARXhd0xaq6948JzuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmDl0TFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmDl0TFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C21C4CEC2;
	Wed,  2 Oct 2024 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880328;
	bh=57tgiWm7xkDuVzreGimbJINN2vlh7498vR54Nkk3V9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmDl0TFvRZ/mtpEa12Cy9z1/aFTi4UG8mecu+bo3LhlN22/4VDcxwKtmEmfdflXn7
	 e14cNzF8GCR6/gwQCr1w5sN0jkSB7uLj2H2UWkbM4OQDVQZAcvgArfAKNDomkhkTnV
	 1KBfl+ZWi6IMDK+1T3dnQpEn9XlB9pJ2j8/Ne/Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hobin Woo <hobin.woo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 421/538] ksmbd: make __dir_empty() compatible with POSIX
Date: Wed,  2 Oct 2024 15:01:00 +0200
Message-ID: <20241002125809.051918534@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
@@ -1110,9 +1110,10 @@ static bool __dir_empty(struct dir_conte
 	struct ksmbd_readdir_data *buf;
 
 	buf = container_of(ctx, struct ksmbd_readdir_data, ctx);
-	buf->dirent_count++;
+	if (!is_dot_dotdot(name, namlen))
+		buf->dirent_count++;
 
-	return buf->dirent_count <= 2;
+	return !buf->dirent_count;
 }
 
 /**
@@ -1132,7 +1133,7 @@ int ksmbd_vfs_empty_dir(struct ksmbd_fil
 	readdir_data.dirent_count = 0;
 
 	err = iterate_dir(fp->filp, &readdir_data.ctx);
-	if (readdir_data.dirent_count > 2)
+	if (readdir_data.dirent_count)
 		err = -ENOTEMPTY;
 	else
 		err = 0;


