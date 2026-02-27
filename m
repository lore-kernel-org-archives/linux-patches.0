Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7920B665
	for <patches@lists.linux.dev>; Fri, 27 Feb 2026 03:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772162175; cv=none; b=P4Mr1NWnK0fJSEeElmnHoHjIymLUJv6OFo6M7uV+glj1va91C9tdOSQ0T2AqhScReleo1ZgMfgK9r5K836kgdHp1KA2QFoL/6EDZz0pDBoi3ck1PFg7IIXAZgv1H8C4/LqFGS7hKLqNTpc3Jml5w/bsi9p/m5A8yh6Q/v9FjHXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772162175; c=relaxed/simple;
	bh=PSRmzzLqVPUD9zU1BFy85CDWL9+pYdv0nott+E8XKbA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=psirnCPipSsK9q8cmO/ZFZMiwAFlzDMYILY4svxmSoIsoSjb7qsaRWuJLCcOIEw4MNH+v09MbTFJ3gLcasc6zBbhE38Rk7l3AZ7KHVDCY7e9w8UWChCssA/c1ATkAa5Llf7VPxCGHIuGdDMAjsc60A89VoCnWeq1TmMChwhSABI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=mW4LBVCV; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="mW4LBVCV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=mW4LBVCVHaZsREkJFQ//iAwcYRCE57kC6LPSVXdb3XVZFOPgJH15Li/5Hcgvft7bYfw5A2QGfLp4a
	 lwkgv33DrayM/y2dkYMbGzJQA/5mAvmYkkg5BlurLrwWd+fpjFRIFUIu8mu4n4VmrBUEeqYCeSm2Nx
	 I2nqe/bNKQf+RQBU=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-03-12081 (RichMail) with SMTP id 2f3169a10c708e7-008f3;
	Fri, 27 Feb 2026 11:16:02 +0800 (CST)
X-RM-TRANSID:2f3169a10c708e7-008f3
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	linkinjeon@kernel.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	roger.andersen@protonmail.com,
	spolu@dust.tt,
	stfrench@microsoft.com,
	senozhatsky@chromium.org,
	sfrench@samba.org,
	hyc.lee@gmail.com,
	sashal@kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 5.15.y] ksmbd: Fix refcount leak when invalid session is found on session lookup
Date: Fri, 27 Feb 2026 11:16:01 +0800
Message-Id: <20260227031601.1548925-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit cafb57f7bdd57abba87725eb4e82bbdca4959644 ]

When a session is found but its state is not SMB2_SESSION_VALID, It
indicates that no valid session was found, but it is missing to decrement
the reference count acquired by the session lookup, which results in
a reference count leak. This patch fixes the issue by explicitly calling
ksmbd_user_session_put to release the reference to the session.

Cc: stable@vger.kernel.org
Reported-by: Alexandre <roger.andersen@protonmail.com>
Reported-by: Stanislas Polu <spolu@dust.tt>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 fs/ksmbd/mgmt/user_session.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
index f59714bfc819..8bd18610547d 100644
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -302,8 +302,10 @@ struct ksmbd_session *ksmbd_session_lookup_all(struct ksmbd_conn *conn,
 	sess = ksmbd_session_lookup(conn, id);
 	if (!sess && conn->binding)
 		sess = ksmbd_session_lookup_slowpath(id);
-	if (sess && sess->state != SMB2_SESSION_VALID)
+	if (sess && sess->state != SMB2_SESSION_VALID) {
+		ksmbd_user_session_put(sess);
 		sess = NULL;
+	}
 	return sess;
 }
 
-- 
2.34.1


