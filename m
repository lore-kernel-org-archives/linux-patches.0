Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037168;
	b=WcsAaPh4C7vsYFKQ1s6YU3eTigoNyUEWdGGAY9Hoy1ORHnQXs7sj2r8VXyOt7ovRyU+i
	 2Cyama4wsZGK1zSXTgOYSdLvk2QVdYmy72Dv4/hINnA8MDpCmNK6fZOiauxin1toqVCnV
	 FvJy6zZnAvkXvqi6UdG1YbGGPC5LktPSeBh91jd3jJteEkUWtK1OMaEawnSVvjhiQ8DS8
	 YW+DpO6mLCPn231YcCD8SY0vA0eHay5MzWPO9OjUzn9KLi0d+x9ujKS0HOZCZkTg37Mg7
	 o0DQ9na8RQHASLiwGomwz9SjYrleQEb+i2nqY0TSPBfVWiu55Ep/jQ8MIIe0WfOD6Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lLLJIQzCb5dY4vvwUxO7XnoqV1AW/T8D+1W3xjKMZIs=;
	b=U8AOESUBdv7s9T/RRvyLf5nke+B+lGX9pqY9iK+iGW1u5fRo4TVUf9FjgBuRol0trC9q
	 KanHB0FVoXzMzkER5qaxqoh4627IZYyF009uZ6MO9CMpmjlNyWZS1+p67gkypsqSN24pt
	 yawvcMrM07SEz/o+TDbieibAcHikAiUubaNSdKb4G5tKlqLp562x78rbtZ4M585kbdebt
	 ta29BOz8Nqq/UQWZRj9wh7O5ZakwG3PeWl04Vy5ihjPUSunUUFNe8h/7VEqzDauyGVqce
	 jQjlToJiy0IGrM0UJQlHRO37X7VD2UIrgzPVa4qcTmA+7ViTq/BZn0DMnGM6NF0uG1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ijFF/4XF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A429D606A331;
	Wed, 18 Nov 2026 21:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ijFF/4XF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA231F000C4;
	Wed, 18 Nov 2026 21:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037168;
	bh=lLLJIQzCb5dY4vvwUxO7XnoqV1AW/T8D+1W3xjKMZIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijFF/4XFwFljPHV/Ct8q8JRja48/95/4IOjboosKgdiyBpE1Oaido7K/Cj0mQdFVl
	 xKtOA9zTGnryFITX6mpjh/nLxDeL07B6MoTrRkAqWm6b9VZePcD+jfaaFsQhXrJTtb
	 707peLJN6O0l2/9Fj+Jg7Fv1P3yvjdZ4E4qIRr44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1291/3318] splice: avoid stale f_pos writeback on error
Date: Wed, 18 Nov 2026 15:31:53 +0100
Message-ID: <20261118150358.997285428@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 79b496ebe382866e3a05090b7dc9ae95e85e65b2 ]

do_splice() snapshots an implicit file position before calling the splice
helper. Since splice does not take f_pos_lock, another operation on the
same open file description can update f_pos while the helper is blocked.
If the helper then fails, the unconditional writeback restores the stale
snapshot.

For a directory without ->splice_read, a file-to-pipe splice fails with
-EINVAL. A concurrent directory mutation and getdents() call can advance
f_pos and refresh the filesystem's revalidation cookie before that failure
restores only the old position. The next ext2 readdir can then trust an
offset inside a directory entry and copy data from the adjacent page to
userspace.

Only update an implicit file position when splice returns a non-negative
result, matching read and write. Keep explicit offset updates unchanged.

Fixes: 7995bd287134 ("splice: don't pass the address of ->f_pos to methods")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20261018051708.2422394-1-4ncienth@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 6f9b06bbb860a..53c5a44b08bb1 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1292,10 +1292,10 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 		ret = do_splice_from(ipipe, out, &offset, len, flags);
 		file_end_write(out);
 
-		if (!off_out)
-			out->f_pos = offset;
-		else
+		if (off_out)
 			*off_out = offset;
+		else if (ret >= 0)
+			out->f_pos = offset;
 	} else if (opipe) {
 		if (off_out)
 			return -ESPIPE;
@@ -1312,10 +1312,10 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 
 		ret = splice_file_to_pipe(in, opipe, &offset, len, flags);
 
-		if (!off_in)
-			in->f_pos = offset;
-		else
+		if (off_in)
 			*off_in = offset;
+		else if (ret >= 0)
+			in->f_pos = offset;
 	} else {
 		ret = -EINVAL;
 	}
-- 
2.53.0



