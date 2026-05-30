Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813821A680F;
	Sat, 30 May 2026 17:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163512; cv=none; b=ALPFxFbzYeC9HeRuQO6Fc3lzrChRtDvO96/uOtpto713529LxLxu4SRS+njII1H6bb5goTjgzqb3glMHeiUzoe0XH9ozpnsygsUhubUSTk49NRESldeueJ9lPOZwCqIVyy4bcX9iyREkXTbMZVicSsFB3hM5rxAa59o0q22mjJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163512; c=relaxed/simple;
	bh=f7eSejIyPXbcWL6rEIcYuQx3v2c/36dKCcQT4k0GQPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3To+7kJ4AThCghjvzcwUk52JJI3f1Zpul0PhS9tY+qXCee4NLZ8ZBXyfyq6ArkfaxYT8CevLIpKVW5Ihw47myep4RvSUZ49UPGK3G34sq/6GHLHHleyF1vp/ioutB59E6cgakxXf4oA2uy9aKMzr0IJQ/IFsGO+aPnnwCtrKqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpuzPBrQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpuzPBrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43951F00893;
	Sat, 30 May 2026 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163511;
	bh=FbRetxYA6Nf1/Iwp8Hb72SQ6aAT1TFA1Ez5eKhJR1RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jpuzPBrQ6EU/E/Pr+21dAf3DJpFdhV+oV8jP5heCiLZpn51yBzrb/oJmWO8gB032K
	 dsujiheXoV6NLgTbNVDObDFVcGRymOatQUoFJoTbPI3exdubNLDiUdjmfMGL7Lk27t
	 ellmALufOOj8x4zXrEjHIyGMfW0t99gMJ7rL14o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Li hongliang <1468888505@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 280/776] ksmbd: do not expire session on binding failure
Date: Sat, 30 May 2026 17:59:54 +0200
Message-ID: <20260530160247.794102213@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 9bbb19d21ded7d78645506f20d8c44895e3d0fb9 ]

When a multichannel session binding request fails (e.g. wrong password),
the error path unconditionally sets sess->state = SMB2_SESSION_EXPIRED.
However, during binding, sess points to the target session looked up via
ksmbd_session_lookup_slowpath() -- which belongs to another connection's
user. This allows a remote attacker to invalidate any active session by
simply sending a binding request with a wrong password (DoS).

Fix this by skipping session expiration when the failed request was
a binding attempt, since the session does not belong to the current
connection. The reference taken by ksmbd_session_lookup_slowpath() is
still correctly released via ksmbd_user_session_put().

Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 700c8070f57a7..9fef4d88ee8ba 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1938,8 +1938,14 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			if (sess->user && sess->user->flags & KSMBD_USER_FLAG_DELAY_SESSION)
 				try_delay = true;
 
-			sess->last_active = jiffies;
-			sess->state = SMB2_SESSION_EXPIRED;
+			/*
+			 * For binding requests, session belongs to another
+			 * connection. Do not expire it.
+			 */
+			if (!(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
+				sess->last_active = jiffies;
+				sess->state = SMB2_SESSION_EXPIRED;
+			}
 			ksmbd_user_session_put(sess);
 			work->sess = NULL;
 			if (try_delay) {
-- 
2.53.0



