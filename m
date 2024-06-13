Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505D21411CD;
	Thu, 13 Jun 2024 12:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281751; cv=none; b=rJg2/FIN9rjnfoSqxeSLuevJXQ4WaoyNc/QemPoqb48CjInJhbZzGViu+BsbtOyjoXPExZXKwx5yWGZ+pZaSE0LtkrQwat6Tq0FQyV8s3AP1w4xriGcrWF8C73mEh+JDrOFxpV8gHlqlfyXSs+mMNj6hIdycDa+nmDwEAjcCKD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281751; c=relaxed/simple;
	bh=XfHjqJoKtaekeFoF8HQnwo+dqXFJnc1qS8FYW6rOUw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+Cb3cRIy8QBIKLIC04v0o4DDAwUlqYPpmoFmlx62glzgQQPco2cZGkruDnc1I34BnYV09GmtG6M7rk4yWbh6cpumFFbRntoQETWetvgrpfooz5wLBcYEmFEbi2qiCy0b4L02onm+HyhX8KfxachDDgUzNBVl1GsSp/xXqvB/aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lj0vHGRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lj0vHGRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA71C2BBFC;
	Thu, 13 Jun 2024 12:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281751;
	bh=XfHjqJoKtaekeFoF8HQnwo+dqXFJnc1qS8FYW6rOUw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lj0vHGRnunZzUdzeTRHdujBKVTjKR9kLTkOwJFkMMQSb4sTKPDi9clHdhYRDYnj7G
	 J10t7nd5VUWxRWpEJa1kI5EJVzU8YDlmkP8pnUhBqvnyG8q+pNGLGcBC5Ng8gLn3Fy
	 UBOdg/7iG+oKVeNVDxCuzl4MwykjDSxtCU5VZT30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 016/402] fs/ntfs3: Break dir enumeration if directory contents error
Date: Thu, 13 Jun 2024 13:29:33 +0200
Message-ID: <20240613113302.770475810@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 302e9dca8428979c9c99f2dbb44dc1783f5011c3 upstream.

If we somehow attempt to read beyond the directory size, an error
is supposed to be returned.

However, in some cases, read requests do not stop and instead enter
into a loop.

To avoid this, we set the position in the directory to the end.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/dir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -475,6 +475,7 @@ static int ntfs_readdir(struct file *fil
 		vbo = (u64)bit << index_bits;
 		if (vbo >= i_size) {
 			ntfs_inode_err(dir, "Looks like your dir is corrupt");
+			ctx->pos = eod;
 			err = -EINVAL;
 			goto out;
 		}


