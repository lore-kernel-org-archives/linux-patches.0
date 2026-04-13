Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72083DEAF5;
	Mon, 13 Apr 2026 14:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776090686; cv=none; b=u8Ez4ISveF/sxgCZJ1cuBeTyrxN/HIITtw/xVU72PLk3QgeYDN5pu2vDwUiQzvEqONQh5QL5E99wSrbP3kI2HWmvOiUttHlsuUKdQww1QFMG+NhbOJMmeflEFCdPNFESzRVI1p3g/CzcR1pk0jhN/K7RI7t4/wnGxQqd9svOAI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776090686; c=relaxed/simple;
	bh=jX4JsnYURKTydMGJbpJlNGZ20mw333IsO8fNn0HYEaY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=jCZMwA3FEDIZ1kqeNoeemFTrAMO0Q1sFjxQg6Y61HH++2kMpQ3r0TCZ8IdDc5S4wLX1DqCrvZh7NyT53rPohUBEq8f6snUXlvLF3vRvxOD47nZkOAnhHS5D/Ui9PQPrbIJvOZ8MbMp//jHm1cZqN5i4uT/YVAbSqOdOegn70QY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtH4SOZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtH4SOZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EEFC2BCAF;
	Mon, 13 Apr 2026 14:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776090686;
	bh=jX4JsnYURKTydMGJbpJlNGZ20mw333IsO8fNn0HYEaY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=GtH4SOZBAM/zZNDgev1eWjvBEL1bkOcwpshEhiU1UGV0zJ2bQaO7XsFsrMNSA5H7C
	 8BeMGhRE9A8aB0MGGxFYTT9n6AFjVAWbspbq4Dsx3zuGifq9gfo/PrZhBAi4jBmnIR
	 bEKtxudm2O/4jpSVh3HnX/gjaHz3XGY/7m3SdKnY=
Subject: Patch "ksmbd: Fix refcount leak when invalid session is found on session lookup" has been added to the 5.15-stable tree
To: 1468888505@139.com,gregkh@linuxfoundation.org,hyc.lee@gmail.com,linkinjeon@kernel.org,patches@lists.linux.dev,roger.andersen@protonmail.com,sashal@kernel.org,senozhatsky@chromium.org,sfrench@samba.org,spolu@dust.tt,stfrench@microsoft.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 13 Apr 2026 16:30:58 +0200
In-Reply-To: <20260227031601.1548925-1-1468888505@139.com>
Message-ID: <2026041358-litter-distill-6101@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    ksmbd: Fix refcount leak when invalid session is found on session lookup

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ksmbd-fix-refcount-leak-when-invalid-session-is-found-on-session-lookup.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-219895-greg=kroah.com@vger.kernel.org Fri Feb 27 04:16:14 2026
From: Li hongliang <1468888505@139.com>
Date: Fri, 27 Feb 2026 11:16:01 +0800
Subject: ksmbd: Fix refcount leak when invalid session is found on session lookup
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, linkinjeon@kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, roger.andersen@protonmail.com, spolu@dust.tt, stfrench@microsoft.com, senozhatsky@chromium.org, sfrench@samba.org, hyc.lee@gmail.com, sashal@kernel.org, linux-cifs@vger.kernel.org
Message-ID: <20260227031601.1548925-1-1468888505@139.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/mgmt/user_session.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -302,8 +302,10 @@ struct ksmbd_session *ksmbd_session_look
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
 


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-5.15/ksmbd-fix-refcount-leak-when-invalid-session-is-found-on-session-lookup.patch
