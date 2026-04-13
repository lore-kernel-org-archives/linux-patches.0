Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97011307AC7;
	Mon, 13 Apr 2026 16:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098548; cv=none; b=P2hvyd3yzzP8FcPT8FtU41dUBIF+syU0tB1A1YHwTV6iM04DuwuzbOd9txJ50bsjERVJ05DG5Q+AEOfpbSgpQZjme9jL39ZhrtmC6OYu5z8/vJYk/1xeAoUc1Lk+uqTYo37xG9BnJy2znKVZ8qQI1xkX8SQ+Vxp2ZCVYCwhqzFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098548; c=relaxed/simple;
	bh=AuMCt+o6XEs00X4cEpLP4BFaVLz31qHAxTvyeSf/Qhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XILtnSb+JDsrosAD8IcTrHqawRE7UvRE6THs1sAnk1JE1aWJu/ZBReFRMlf7zQN9PREyL/sG3GF9IoaPt6gCxYsENYzL8rz7dzoWbuZnJjY15ASP0FrjLuscT49wCuMi3E7MVG1yxtI9eWEVm5wrAOUrfwQ+qWcxD7nHaN2MY60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQTTDHcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQTTDHcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED89C2BCAF;
	Mon, 13 Apr 2026 16:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098548;
	bh=AuMCt+o6XEs00X4cEpLP4BFaVLz31qHAxTvyeSf/Qhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQTTDHcYZFaeircOVtwJ1+Q4QmusxnPp8yFFtXqJEug0yXcntkbUlCg06Qca6Ik2P
	 E7JRPA3F3zuqgzA19OBITU65csSkRs8/HU6EziIZe+uZh6jFUEW4zvs3HQW+WNWdSG
	 EM3jt019htRyulIPuWcu2xUMRtM2kkC4VGQlp0AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre <roger.andersen@protonmail.com>,
	Stanislas Polu <spolu@dust.tt>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 5.15 567/570] ksmbd: Fix refcount leak when invalid session is found on session lookup
Date: Mon, 13 Apr 2026 18:01:38 +0200
Message-ID: <20260413155851.717772634@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
 


