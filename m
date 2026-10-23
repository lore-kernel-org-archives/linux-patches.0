Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774098;
	b=2nS2KdboMuTTukks0ZRmmpNNxVTAmYWvRLyVXz8Cx7IXh3VY6ieXJcipA6cWAgD/y4p+
	 UlwizSxnOvs9HGAXZHnT9zNIYJ61n5MUuCujnIMhd6NE7SaizYEoww8xlayWdcR6lUxSk
	 RDpLMnxQly90NY/Ry7LjxXLI0HeenZ9B/IXqI1RWdguvA2TABq+4bHv1o5ktBeDUjKLi0
	 nOlnLJipZPeUv1rFwBqLOa4dTEtU9fsom1asmCcJOSvsDW2OZQum6oLrJ+iq4MeJg/NIH
	 oz5jGdO4Pqh3EOH5gyI2nnu99G0w9SXn3kyT2PwtMghI7TwUllFvhyaMMOU29S6CXbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=63QywmBiKWiyHF/osbFL/EqbqR1GjWYg7bH/8bmr2oQ=;
	b=kJUB4hPtJdwY26F1G+tIqmDpxKvn1/+lpjvjkprWN0L22IZF9Z8wwZyHE/UOUvYG4TIw
	 dal7V4epYdk4V+BHpFm8Gp/KuuuUP+q1Y0qmi4uOiY7VDmcoNQmJzwSHF9/z0dcYNiu2v
	 yqLydYqNvOUQzhPQHARGEsWlY91KpwX+NvTejcuMLBhBlVqdtgrYvY4whx60vvhuakiaW
	 eCOue30eH9d5FA5igVu3VPkRgWgy9nrj/2mD3y5dNUzC1muCQ1vGLJkE6ykeQY/87TE8v
	 YhIq9p/4zuWyJJMxZObwNO52gw0MmcChRFk6RzkFxpxHhWDFHj+6OLqVBgKIC8PyIyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dddBlXi3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5AA606A31B;
	Fri, 23 Oct 2026 16:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dddBlXi3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5852C1F01825;
	Fri, 23 Oct 2026 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774097;
	bh=63QywmBiKWiyHF/osbFL/EqbqR1GjWYg7bH/8bmr2oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dddBlXi3GS8WoxYNiOlULsnHLl9vX5Sn5iyups9swxZhRLOh1yutR7u8RZOJy/RcD
	 nO0jXqOJVeEriTD9BaOc689+aznfPjuFW0Fqy5d3CPZN+PHdhNtRAvTQwiIrfA4hq1
	 w5tGnn2h2BOanmbk9w9C4ewQ1NjiA93zjihw7JKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 120/193] cifs: dont update i_size in cifs_do_truncate without a cached handle
Date: Fri, 23 Oct 2026 18:36:37 +0200
Message-ID: <20261023163717.040806106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1003,10 +1003,26 @@ static int cifs_do_truncate(const unsign
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


