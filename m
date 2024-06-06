Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1EA1993BF;
	Thu,  6 Jun 2024 14:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683239; cv=none; b=m7ESoNEzHetk38hJbopGq2zIZHBTSho4lq3Z3E3hoDpn+ndbDo6oJcbDNoM62dBLu+uWORo7tsIx8A766qjZO0R0gx85qp7pOw02KziMT+xALaPWmW7EaKMLfdREA9h1Bn+Dkvb8Nex/HUELqnIw0ft4EQiqoKBhK5V9GK2lZ/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683239; c=relaxed/simple;
	bh=8aEueV8MFeCv3ELdSEIynKnZG8FHhVUmBAPx7EPGXy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZGB0PaqoT/B2p/FHm0qhWQdoxpDc5uS90YDmB3XlETdhYBHzC+EijhtvzlSgVRAtUQWh8eOa8lzWmfSl1PmzB0kuNzD+M9L4zfF+EeWsjwNXkGaOESKOavT92qb26RfAa0Fm1lymIq3HHJTt9yfT7lzij2MYWq6UUwaNlHmqWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJ0ldA8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJ0ldA8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2331C2BD10;
	Thu,  6 Jun 2024 14:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683239;
	bh=8aEueV8MFeCv3ELdSEIynKnZG8FHhVUmBAPx7EPGXy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJ0ldA8D7wRWtu06KeEbZoku/a8rOEtJbSvq8FeZoUgBsLUagtvubqDdORRRIC3Pq
	 RVEKQ5CngrtbJG4P0ct/Da8SfjTLtDRCEM9sA0fBK+OIFjmoXN/oHS723J4X0hWAcd
	 BEdBdxqBDg8ASDkjnj5gFgHnpngf4nsU13jZ8f+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/473] gfs2: Dont forget to complete delayed withdraw
Date: Thu,  6 Jun 2024 16:00:45 +0200
Message-ID: <20240606131703.781704370@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit b01189333ee91c1ae6cd96dfd1e3a3c2e69202f0 ]

Commit fffe9bee14b0 ("gfs2: Delay withdraw from atomic context")
switched from gfs2_withdraw() to gfs2_withdraw_delayed() in
gfs2_ail_error(), but failed to then check if a delayed withdraw had
occurred.  Fix that by adding the missing check in __gfs2_ail_flush(),
where the spin locks are already dropped and a withdraw is possible.

Fixes: fffe9bee14b0 ("gfs2: Delay withdraw from atomic context")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 7762483f5f20f..91a542b9d81e8 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -82,6 +82,9 @@ static void __gfs2_ail_flush(struct gfs2_glock *gl, bool fsync,
 	GLOCK_BUG_ON(gl, !fsync && atomic_read(&gl->gl_ail_count));
 	spin_unlock(&sdp->sd_ail_lock);
 	gfs2_log_unlock(sdp);
+
+	if (gfs2_withdrawing(sdp))
+		gfs2_withdraw(sdp);
 }
 
 
-- 
2.43.0



