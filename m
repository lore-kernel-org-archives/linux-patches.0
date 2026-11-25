Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624602;
	b=PKo26Tme3oz72baL0oxK+M8zeFN/pvUtFlG3gCj5xPevexkdo2Vf4CTdfnptfICzIrc8
	 KU/Qy3WpRuK3ZOiKDen76ytoIVSkoum+6X9d2meBVKE+eHm/pD2t/hKXEzQGCQywOdHEJ
	 IDlW/dq1Ef9lbfemrwoXPq36xzRoog1xgRK1UZZtpr+VsH1+Ul5yHUgM3N8EM/sfrsV3N
	 pPLX51gd2tKi2wI/w/v5zgiCQBv3AX1ndcR7uJT3h61noPm1cSujSWF9JhArx4ii9Gef7
	 maDJzXfc8pYDKQC66Myv+T5U36K0ct7pCqVUlBYz2jLtVoy0YnFMjv9OzWjyA3+H//Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ms+1HT9EgrrkmQR6Mc0B2LpXrXdDk9aHZFhmgYIDy8=;
	b=OBv6fKtpHaNzhZv6E5m4ozAlQfxnNMtb0T+3qUqCLlPJZ69DF4PNfhy7wMBUWnfYd9ec
	 CWH+qByyFNBiVYMq/Uxc3I4nidPQlZkxtvl7bszg1+6rbdiyqO9Ftpia3IAcs7Q7XwfIx
	 VS790OMoE/RiR1dCoJBfhuY662DsLf9BFSsc+At5VaStX1MRhBCNR9DYQJxIauxI2SDYk
	 XScQZA2/BkfHZUIJT8G8uwk9axmJflEkFezMKS7nOhc0A6ddtYpGtXTcUdprb2MUmBYFa
	 ebHzAE0NRLwnLjemMBrYv2/9gPnRfQJDFbI2rhgi3GSRsTj5IyUaPCRmtt5S1mWQnQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjAnt2eB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FA9606A33F;
	Wed, 25 Nov 2026 16:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjAnt2eB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F16E1F000C4;
	Wed, 25 Nov 2026 16:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624601;
	bh=5ms+1HT9EgrrkmQR6Mc0B2LpXrXdDk9aHZFhmgYIDy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjAnt2eBCjvI5iZ5yXYIR0BK+dLJ5yYgyLE8ROnA9HX9IRyHKM9Lj+M+59iHKgHD0
	 RRxWAziVVbIbWuTVFZjLyEo/CVxD8SdaXOgidqv/HQiSpuI2p7H10nlPev2mteTm+P
	 F/DB67LZNF6M78D+h2BjJMGvyfE1eBlGK7wsAm5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/816] vfs: preserve subsecond timestamps at filesystem time limits
Date: Wed, 25 Nov 2026 15:29:54 +0100
Message-ID: <20261125143854.904085349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 87396234d1e25..a9a038c863d3a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2621,9 +2621,10 @@ struct timespec64 timestamp_truncate(struct timespec64 t, struct inode *inode)
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



