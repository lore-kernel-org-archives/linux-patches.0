Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621707;
	b=d2Y2vpDy3MNfXVxgW78YdI69GM6m8hAnSzg13lIKUnhxFaloWPMD2/6rIoHkesyNJfHr
	 O2zZhEUsFNyfYU1uSBXoTCUYrjDtaoaz2FbcGleTUEiGmIDJOJebuRq1pdvM/qYgGxaVq
	 boIDta2iiKJhWI3OxuSryP5kDvQrOlgjW6aP5LgKN0GMcMXDSMRVwnVVuzlRegbUoHBPX
	 vXUN/odXIcASXaNIWdmo3xeQ9y7g8GXNqDuSBecRhER1aH2K3dVLBdJYZbKRqBhNiRhu6
	 x/fpEw5RZHG2TfymCpxFlgTjqnPDovJuSY/U5+3HDY4HLGmFyM+dIAt5iTrlGhVc5XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g/td2BlaeAXgOXrj7cAyg5fcFKv0W8g1UzX7lk7093w=;
	b=ASQTvWYXiktQ3LQ8F/Z86xgjv4uy12qdL1eu7bWJ5M68KSk8Anw2vUjicr7LnO8Ac1G3
	 BJQUAtcHRbOrbzsMPt+iQ7dqP5PN6Wx21vGLpkdJMtZgpOYf6IzF/nnMQsL0gfAi71nmg
	 UD6x/SNvOZbV65mp2ytFsmLQ6yawubXzO+z1Ut28yA1kaz1eFokdwi42kO2yW3kk1aeUC
	 jELLwIc1Y2bnjd4XvwcD0Kx+65wjHz0o6eb4J35T1WAXvD7aRd3Sv5VseOIdX44tVGdw6
	 XDx2rNBKovB/bYI5xL98ebsW5hQoqWsPt4GZxHioXXaCcTY+aaOV3o04SUGsK2UV9+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PV9hXd70;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB7C606A327;
	Wed, 25 Nov 2026 15:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PV9hXd70
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15B31F000CA;
	Wed, 25 Nov 2026 15:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621707;
	bh=g/td2BlaeAXgOXrj7cAyg5fcFKv0W8g1UzX7lk7093w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PV9hXd70Z9W7yCJ5mb3Gy1pagg6vdnwWcPnsbabmMwxmNcF4u1H8EiFlgVlpDO9mK
	 pU5VWkm/eDryArNgIwCy5gEtNvS53bPAXukNrnvZ6jALH2BgsFGuq0OfxBP2njARpW
	 GAB18GfKRTzfLk4eh/7+zpI62FM6IMstxiRI80k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 304/990] vfs: preserve subsecond timestamps at filesystem time limits
Date: Wed, 25 Nov 2026 15:27:51 +0100
Message-ID: <20261125143829.213827688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index b60111fad771a..a5333c9ff761d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2741,9 +2741,10 @@ struct timespec64 timestamp_truncate(struct timespec64 t, struct inode *inode)
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



