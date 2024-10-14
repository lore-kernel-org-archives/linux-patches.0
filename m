Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFA745C1C;
	Mon, 14 Oct 2024 15:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918458; cv=none; b=M1NS0lvpAceT4U1//QY1B52+gEK1N/4RM2k9SrH7BP+Mpf1ygRAlcXHe1E9q/ME7AusX6zoPKM+UtrMUORmNZoW+Gdm2Fhzqbgr8aCwZoqFvMOTnuFWfv/hp5MXMS2QlhwXU7EmPEs9Gl64P8qlAmoztGT4uv2pY8Ag4S+05LnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918458; c=relaxed/simple;
	bh=i1HhEoTNDjHc8r08Fo/rsJIPsXpzKaXBS7ADaro7u+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIloScl+9MT7Vd1oDwrF+jViY6BrX5pXRS5wthkj0glCqJL7hILw9aO/7z433386ilEoJtgXlnKC+8H7UxQdXW/jPoTlAZo4Xe/nHyrR+qRkA8SbbWUfCPfRLcbyQNyso/gOPakYFrOAXj9pSapZV09SdhgkjterY4jL7mWirAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0C77quD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0C77quD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C68C4CEC3;
	Mon, 14 Oct 2024 15:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918458;
	bh=i1HhEoTNDjHc8r08Fo/rsJIPsXpzKaXBS7ADaro7u+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0C77quD/WLBbCTpF1pucmk5XzdtRNJK7Bob/goy+sYbj1dZuQTEIOhaVg7bsD0Ux
	 e7vNJuWopVRKACN3w31K2+ARuSdAMglM0gmT5EGbYm+o7ZK9E4STDc+v26INi/ZW6K
	 B8cnJjrcrDE4bXmgemDOWRR7i77fDkuEj4HbFLs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hobin Woo <hobin.woo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 298/798] ksmbd: make __dir_empty() compatible with POSIX
Date: Mon, 14 Oct 2024 16:14:12 +0200
Message-ID: <20241014141229.649987795@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1102,9 +1102,10 @@ static bool __dir_empty(struct dir_conte
 	struct ksmbd_readdir_data *buf;
 
 	buf = container_of(ctx, struct ksmbd_readdir_data, ctx);
-	buf->dirent_count++;
+	if (!is_dot_dotdot(name, namlen))
+		buf->dirent_count++;
 
-	return buf->dirent_count <= 2;
+	return !buf->dirent_count;
 }
 
 /**
@@ -1124,7 +1125,7 @@ int ksmbd_vfs_empty_dir(struct ksmbd_fil
 	readdir_data.dirent_count = 0;
 
 	err = iterate_dir(fp->filp, &readdir_data.ctx);
-	if (readdir_data.dirent_count > 2)
+	if (readdir_data.dirent_count)
 		err = -ENOTEMPTY;
 	else
 		err = 0;


