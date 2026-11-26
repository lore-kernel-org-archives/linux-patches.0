Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704399;
	b=xceyvGQnKSDIW7ryLeQSVfa7TgxJrMHFP+dBEVN8oFqlfDlsUGYtZb9OTJBOd4qacuNR
	 UbyYBtFDsYkJZp/nMQZvQPPz62ph+H9ysHJ9JtXFpSxvl4skjScSuAsJxZbMGTh+etEJG
	 cfEcI/i2n9gQJxrkEBbxAynAunWltW42qPO/jMu4C0EEn3SKRV4nzXBFRdQbZIpdROIVu
	 MFoWFr2yPUP9779BHOQ0hlnM81vv2WfBQ6iM5Y0AxHb3bRz2p3RlMSH24EXqNKG/J+F0K
	 Pxwg4wXUz2nYe6fJP2hc46hlYi8yVBnqO6osHsdu03KmEpbU8p1b3xn1EdhmzJ/QhXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2lM/7Qq+uFHZnnixYJfmcYA8lqdoLLVCHp/ijiW45gU=;
	b=dnktpF6xXoYFeaK3ql/WLC8pFt0YSGLRgX6xlZdLOKatkr0eJZMDGbzTSDvgeQSvTA6Y
	 ou17a9MfomY2BcrAzQIWVnBTOaZZ+MevYXBABjC9UHm0LGTHnWUcLD1dpvB5K1ZE+MNeW
	 a+s2jwGjkGjn7ZDWpTE+xNnwE95hJIqTVtva+vlSP4UuBh8i9esLirW6/tPQhmGqR5jYG
	 oiLfLeLJWySiJb1qz8M2zhQHtYTRnFjDBdOgeZK6fNhxFocp6QmT+IfRhOa1U2iJHxAqd
	 kBKGvt+U0eMuPI4bXMKKv4/viezrcRYheN+ApQWLumvPtcwcYxnGytO4ETTW2vO+Y+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n93/8oyb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6970B606A321;
	Thu, 26 Nov 2026 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n93/8oyb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71131F000E1;
	Thu, 26 Nov 2026 14:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704399;
	bh=2lM/7Qq+uFHZnnixYJfmcYA8lqdoLLVCHp/ijiW45gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n93/8oyb4Qbih+FyYYak7WPZb1qAnB5mNoEYIse4ivk74yfLve/djNI+42D8nMwmY
	 Ocy1tjg2pgYjjJtOAnaHaSmgFxJ/ekeuwoYpVVFHL+KPe7BbwXyiZfw4u+sCbb//oR
	 1wcj5ilEq5ONfDP+rjt4XLl0Ae5q0naU75jQZN3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/265] vfs: preserve subsecond timestamps at filesystem time limits
Date: Thu, 26 Nov 2026 15:37:04 +0100
Message-ID: <20261126143611.563278978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 55a0c91000646b008261e3b1e15d1e774f3026e4 ]

timestamp_truncate() clears tv_nsec whenever the clamped seconds equal
either filesystem time limit. This also drops the fractional part of
timestamps whose seconds were already within the supported range.

For example, setting a JFS mtime to 0.123456789 produces 0.000000000,
although the filesystem can store the requested value. Utilities such
as touch and cp -p consequently lose valid subsecond timestamps when
preserving these endpoint values. Timestamps strictly between the
filesystem limits are unaffected.

Only clear tv_nsec when clamping actually changes tv_sec. Continue to
truncate in-range nanoseconds to the filesystem's timestamp granularity,
including when the seconds equal either endpoint.

Ben Hutchings suggested comparing clamped and original seconds in the
2019 utimes review. That caller was switched to timestamp_truncate(),
but the helper retained its endpoint equality check.

Link: https://lore.kernel.org/lkml/12c095e595836a7ff7f2c7b2a32cb5544dd29b55.camel@codethink.co.uk/
Fixes: 50e17c000c46 ("vfs: Add timestamp_truncate() api")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261101113815.52911-1-dennylin0707@gmail.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 59ad098db6c9c..ac1c681669e38 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2318,9 +2318,10 @@ struct timespec64 timestamp_truncate(struct timespec64 t, struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	unsigned int gran = sb->s_time_gran;
+	time64_t seconds = t.tv_sec;
 
 	t.tv_sec = clamp(t.tv_sec, sb->s_time_min, sb->s_time_max);
-	if (unlikely(t.tv_sec == sb->s_time_max || t.tv_sec == sb->s_time_min))
+	if (unlikely(t.tv_sec != seconds))
 		t.tv_nsec = 0;
 
 	/* Avoid division in the common cases 1 ns and 1 s. */
-- 
2.53.0



