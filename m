Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046794;
	b=EpgUuZPPjCBsYrxXs7deDKCeu2iTthH3c/NFLccGfTW6EqUeNiZHpxJZOFzMZGiNPtz/
	 Zt+bDR6XFfR1MX7lSWlHifk9LJXrCYuQpo1EjUnhIg1M+dyJzYjW6MjDDfZp2VegfVKrQ
	 PGIuIBbVBPmw+wIDJmyLUUMBy7tXVfF+azlo2gwuh/jwjiWKpkNk+u5ZGv6i5+dodwFHu
	 JiReSLvPDPYet0mPr29ZauTTcW4p0DrRPK2CIKR6BRlVDxguw9d/InLjdlVnes1rE3DKU
	 9J8qsW33L654orti4zXRfppMNkkHJBXSwtK5kbwij4DvEv3XQnMZVbEapOsl2QJsF1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dh5G2LERx2MAmivfNyQPlnReLcyLjdALAnUqF+8jM9s=;
	b=ks6xBKT9c5TU8jRvG2OhJZlEZCJ9pnaPftJa2Vxp6CqsgjmRFHn81pj88Qpky0t0Z7Fw
	 GGpNjbeJ7Tt2nwlHTRdt9z3sSGfEPkUGM0xatY6GnLOTRcAET9gBCWUmyuQfrHEE7bBIU
	 HFh2DTAWSNsf5+lMZDtYm2qqGWayYsZUqrQ46Q7/k+NcFAO8KMXKx8AeHltv13zjoADcg
	 UhA8CkH+sqbxZJ3DZHr1OYM9CVme3vVaVYOxlDAYGOBTXqDmXoUuIXxUf9AiqjHbtk/NS
	 NOHZqRVJwMYWLt+whrRmRhiSg52+Ofwz9lfmhzwvhFzBAw1HxD9UnjZ7FRmQBd1KlBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XPUFmmdi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607CF606A325;
	Thu, 19 Nov 2026 00:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XPUFmmdi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52751F000C4;
	Thu, 19 Nov 2026 00:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046794;
	bh=Dh5G2LERx2MAmivfNyQPlnReLcyLjdALAnUqF+8jM9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPUFmmdimWghT6DtxikmLw8bAV973U2GzRcFFX+l0ea4S629JxCGgiE/idzgtzBjS
	 JeQdUw+QceTfTXtu3jrRh1PRoPQ/VaLNNZEDjNzX7Wg6Mqib1godt2U1hCUZgFSwoX
	 ldTWteebuj+2km1M4wamnHznx0rngcZNsdmasvwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1407/2857] splice: avoid stale f_pos writeback on error
Date: Wed, 18 Nov 2026 15:40:41 +0100
Message-ID: <20261118150252.005563034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ea92caf95a385..418c03d9b9f84 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1101,10 +1101,10 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
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
@@ -1121,10 +1121,10 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 
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



