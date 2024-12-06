Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD44E14D2BD;
	Fri,  6 Dec 2024 14:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496077; cv=none; b=NMuHFROEiKIPK8uy9WiG8+zut7K6tce93jNP3ObYVLPakmW+/ODUJDUmuvHndyOm6iMnsYKsaO5AgO2F6R0q2TsWRNzzKPdUYWTOKG/PY2bwqMoSfylqJ0I0DGkjVdkQo3/VvUl42/eDXvaNJNScyPRxg0wZp7+oiLwWcnWBBkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496077; c=relaxed/simple;
	bh=T6oK81MhJaAyMvLcFhEz0JvTCLf2VvJQMUvQCf4sGhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNItSR6fhIPgfp16LxpXL6Kqj3goyJGbwNDpfr1OEtY1A7m3S65vNTJRCfmFH1q3KZ6u9Ik6FQkeP9+ct8XhFrzR7VjQeNsV8C6J0v020PeRVGJzooi+zpkiWnNWUUTRw1kZu4n92QKt7WVTQhd4ba7zJjqfgOr2m35HFDGfFTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/DYrySy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/DYrySy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B8CC4CED1;
	Fri,  6 Dec 2024 14:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496077;
	bh=T6oK81MhJaAyMvLcFhEz0JvTCLf2VvJQMUvQCf4sGhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/DYrySymnT5OZPl5TvhEx+ar8Zm3LOnbHdh882Zaemca3ggAINc2hxhCCTbzSsrB
	 Xh5d5vLyztWaT76i4KSGK/8S8JKYohZm0jTiOvt4DbRZwvN2MgK+6kvpB+EyaoGzku
	 BXGrqXXWH9I9NqcWX3zfIFSNTgJRvCy7OR4ScPWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 043/146] ovl: Filter invalid inodes with missing lookup function
Date: Fri,  6 Dec 2024 15:36:14 +0100
Message-ID: <20241206143529.323083752@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit c8b359dddb418c60df1a69beea01d1b3322bfe83 upstream.

Add a check to the ovl_dentry_weird() function to prevent the
processing of directory inodes that lack the lookup function.
This is important because such inodes can cause errors in overlayfs
when passed to the lowerstack.

Reported-by: syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=a8c9d476508bd14a90e5
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Link: https://lore.kernel.org/linux-unionfs/CAJfpegvx-oS9XGuwpJx=Xe28_jzWx5eRo1y900_ZzWY+=gGzUg@mail.gmail.com/
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/util.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -197,6 +197,9 @@ void ovl_dentry_init_flags(struct dentry
 
 bool ovl_dentry_weird(struct dentry *dentry)
 {
+	if (!d_can_lookup(dentry) && !d_is_file(dentry) && !d_is_symlink(dentry))
+		return true;
+
 	return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |
 				  DCACHE_MANAGE_TRANSIT |
 				  DCACHE_OP_HASH |


