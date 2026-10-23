Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774852;
	b=I5BuoAFWdFir6c/l+P+vRLawUW1Igm5yXWj6JrBz3wgoUoUHHhtt6AdTrNI9PDkEUutD
	 QetE9zgqUsAHGUS3dODR/qbukrCiiRlTmhxfZjoFGfv60bf2x/Hp5mMkKydisYaX0+K4n
	 J4Nzhb4+HgAf6df/+9ejAxDca6lMbK4VW9GvImObZqX0dG51L66DqUh2hHxj5+Yn9ArKv
	 J5k3dHlNOJSJw63p2cOw/XzcbRYMQc2N+gO5Ox7vHSYvsfACmBpHo4QmTXwG/HonCL3jF
	 vqy8cTJg1M7fDUmvVdlObY5nkECg3WF6IX50tRui/NQETcX/FMwQ7/H3rAaheYgsl+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xgui4jjq7vdcym3xtzNr1iRPXmuZrOsIVIg6WSuH5Fs=;
	b=n72u8Amc+delmlV66/S13lB4Yu7h+TIXPHOTfBQ5DhMrY/j6j29cRuYjSECzgMCQJlPS
	 QOlJTHlbW3COnrpQ4xVIhvHg2LfvhXDCV5vnafSWP7iwKiJaMpAECgOxD8G76Pv3oh6Ih
	 vrOz7z6IP88Toeh5Af6CQmAPikxiWYmsstdIieQY0kb4+3s+SGoZblGhjLVw57GEJawoB
	 yb7rHeMaDabw3nJCVO/SqTPbZhvPcY05Tpg6LfNnYOKTMrBPLnY/rFkO7TX8EAVJVZfsA
	 hpGvd7gt+lCSn9qhld8uTgTObXmaTwvVHV46iZhSvwuqu+NoLX+Qp0X51BkMgFUJhxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GrOgP6fa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D27F606A31A;
	Fri, 23 Oct 2026 17:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GrOgP6fa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4401F01825;
	Fri, 23 Oct 2026 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774852;
	bh=Xgui4jjq7vdcym3xtzNr1iRPXmuZrOsIVIg6WSuH5Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GrOgP6fabrd1fTC22uGY88NeSHAvpU6CeJYnBWgThC9PntZsRENCK/j+k+cim/SQg
	 gf9nfb2i2/5j43cEfAn2hW9Q+GXIMu5NJiEy1zTNpTb3Q1XDkk6dfMA+VxMOghk206
	 OPM+z0WDs8kE/E0Ld1ChmFO0XyQl/Mx9PDM8X7pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 181/242] cifs: dont update i_size in cifs_do_truncate without a cached handle
Date: Fri, 23 Oct 2026 18:40:23 +0200
Message-ID: <20261023163718.068792992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit fe39cd9d48f2346605f3746e0cc19e89d5f373eb upstream.

If find_writable_file() returns null, cifs_file_flush will return
0 without issuing set_file_size, and the outer 'if (!rc)' block
will set i_size to 0 before telling the server to truncate.  If
the cifs_open() then fails, the inode will have size 0, while
the server file is unchanged.

Move the netfs_resize_file() and cifs_setsize() into the 'if
(cfile)', so they only run after a successful set_file_size.

In the no-handle else branch, evict stale pages with
truncate_inode_pages before the O_TRUNC open to dispose of old
cache pages, and let the open response set the i_size.

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1012,10 +1012,26 @@ static int cifs_do_truncate(const unsign
 			server = tcon->ses->server;
 			rc = server->ops->set_file_size(xid, tcon,
 							cfile, 0, false);
-		}
-		if (!rc) {
-			netfs_resize_file(&cinode->netfs, 0, true);
-			cifs_setsize(inode, 0);
+			if (!rc) {
+				inode_lock(inode);
+				filemap_invalidate_lock(inode->i_mapping);
+				netfs_resize_file(&cinode->netfs, 0, true);
+				cifs_setsize(inode, 0);
+				filemap_invalidate_unlock(inode->i_mapping);
+				inode_unlock(inode);
+				cifs_invalidate_cache(inode, 0);
+			}
+		} else {
+			/*
+			 * No cached handle; evict stale pages so they can't
+			 * be served after the file is later extended; let
+			 * the server's O_TRUNC open response set the i_size
+			 */
+			inode_lock(inode);
+			filemap_invalidate_lock(inode->i_mapping);
+			truncate_inode_pages(inode->i_mapping, 0);
+			filemap_invalidate_unlock(inode->i_mapping);
+			inode_unlock(inode);
 			cifs_invalidate_cache(inode, 0);
 		}
 	}


