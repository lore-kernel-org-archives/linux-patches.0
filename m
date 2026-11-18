Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035005;
	b=GAB6OpSxW97m9gSVxBJz4/x4/PuZDkwbAby9stlF8pigxiHYZHTFaX7k3SDY1ZMaeD1t
	 N0mH2xd2jDjIVEQ12uZUYLJvpg1V6uP4F0kwk+caKA1XexOFTIzkQVtaOlyMI1gB4fkZx
	 KffDLsVCTzgj/iszAgQc49xWkL/HwOVf2hS0QqPBTVRvsCDieEVI0LxuFLb/a9KxdvCKM
	 6gaB9Tb7mPlwM3OF+EPCN7BUMVMaQ0ioRgu6WvVopUBCXz1h+LqDjb3i8pGR/8RkMRnVN
	 Hxy6pT9Oa9yCz0JKm3O9AX/upWvxpG+v7ENALfDVlThf7CdbCDOe2lQfrVWfx8IJbXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dMP9VgMbhEqX6n+RmRuYlDVsF7YQSMLkS+ClbIwA9CQ=;
	b=ubhh2Lp+XAFlY/3DosZ8/9BawNRvDJsmddrDGXQTPFGHqDsHCcPYIEvUZwv4w1tv3zoN
	 SLYqUo/TUtkoqNW/CrLUHtT1MmJiSxN5NQ0SIwT0Qzqlw+R1FlPMgBylb1zM9vuFSqXee
	 TQKoAeUossxwB6y1u1WwCQZe1eiJrw/rhSfYMOJUVEjSadNM566mkBXcNRMzI3p1IFBEQ
	 l9cXkZnQetScdsEAv+dqhy71MrRrYczGouQwxQuZ3bjW8gvy3FdOPVSjZz540YmhyVk+r
	 PUOhcsrqHYxk7kqBzhaY8sPZ6xweYtYxGj5+PwZ8m/OcSnUvDIEOkfzVH1TtJGpXdtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ksg355F1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAFD606A325;
	Wed, 18 Nov 2026 20:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ksg355F1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3087C1F000C4;
	Wed, 18 Nov 2026 20:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035004;
	bh=dMP9VgMbhEqX6n+RmRuYlDVsF7YQSMLkS+ClbIwA9CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ksg355F1CV895AJJ9/olQ0FGhgDJ2dqNXEndezoF6n1XOmTbMtsqUYb6tErgskowd
	 ISRsn6geR1SrQ1ttUawqfhN3tZJs7N9l3v+GkQIpL0Sq8GORjNPXhgxrazHZxZfcrD
	 Q9voCYSqWZXXgVjfN9Nw5S0d4t1K51k7t52zAzhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dairui Zhang <zhangdairui@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 0570/3318] ksmbd: fix OOB read and cross-share confusion in ksmbd_validate_name_reconnect()
Date: Wed, 18 Nov 2026 15:19:52 +0100
Message-ID: <20261118150334.531997744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dairui Zhang <zhangdairui@gmail.com>

commit 783a7fc454991544bf92268d8f2413af1a7c7eb8 upstream.

ksmbd_validate_name_reconnect() indexes
ab_pathname[share->path_sz + 1] without checking that the path is
longer than share->path_sz + 1 (d_path() fills the buffer from the
end). A durable fp is not bound to its original share, so a client
can preserve a file from a short-path share and reconnect it on a
long-path share, making strcmp() read past the PATH_MAX buffer -
with a long enough share path this oopses the kernel, and on a
mapped page it also gives a byte-equality oracle on adjacent heap
(the reconnect succeeds exactly when the out-of-bounds string
equals the requested name). A same-share variant with the durable
fp at the share root reads 1 byte past the buffer
(strlen(ab_pathname) == share->path_sz).

Check before comparing: the path must be longer than share->path_sz,
it must start with share->path, and the next character must be '/'.
The share root itself is accepted only for an empty name.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs_cache.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1339,9 +1339,21 @@ int ksmbd_validate_name_reconnect(struct
 		return -EACCES;
 	}
 
-	if (name && strcmp(&ab_pathname[share->path_sz + 1], name)) {
-		ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
-		ret = -EINVAL;
+	if (name) {
+		size_t len = strlen(ab_pathname);
+
+		if (len == share->path_sz && !strncmp(ab_pathname, share->path, len)) {
+			/* the durable fp is the share root itself */
+			if (name[0])
+				ret = -EINVAL;
+		} else if (len <= share->path_sz ||
+			   strncmp(ab_pathname, share->path, share->path_sz) ||
+			   ab_pathname[share->path_sz] != '/' ||
+			   strcmp(&ab_pathname[share->path_sz + 1], name)) {
+			ret = -EINVAL;
+		}
+		if (ret)
+			ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
 	}
 
 	kfree(pathname);


