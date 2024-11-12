Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB74170A3A;
	Tue, 12 Nov 2024 10:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407363; cv=none; b=fnEUNuov4fNi6MaBHukgiGUiWGeXBXLQrxcg+0EpbmzCnDfi1BP8Gti7JcMZW+0LHi21u2QjpIOwC6AS4iMSmsTeqYdDpMru/U9Nh5NPAo0P/CGtZ9zydkCjFVHIplE6o7qxGpN55wKjYDTWpMAsTpNIrEsEbzLsYrQG+zwaAUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407363; c=relaxed/simple;
	bh=v42vZgvRONYsAWWRzuL6rWLcaUHXfde/4O9U3NYQvQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIZ8wQHx7fDmMh0mMW3OXR9l5nkQca9qS4OlyKYLmSXRhmY/ZN7/g6Z3YiSvRphPy9m63qW5tYm++QVLLMcW8gDbYc8Ff8rL9+WabvDGmsFdZGDv8h4H3iDyEd2t+g8q7nMzZGEddDAVOg9QkStflivgcTDY/2YGNfsGjLf8wCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiDDHyKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiDDHyKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295C4C4CECD;
	Tue, 12 Nov 2024 10:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407363;
	bh=v42vZgvRONYsAWWRzuL6rWLcaUHXfde/4O9U3NYQvQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiDDHyKYw01WB/U2/eJxb84JWz1papLgADVAdrzyutDxo7qwgcuqFLznK+DO3R6uY
	 UhzZC3MP/J4kLHz3wIg4RL6M5WepQ7Ii5Rd6hHt+4PVTH8Rmr5OHXX/KCsdVY+YJrR
	 i9+sOZgGlHWYjkZ7Z9wCFxafc48hzdpAnwXc97LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 54/98] ksmbd: fix slab-use-after-free in smb3_preauth_hash_rsp
Date: Tue, 12 Nov 2024 11:21:09 +0100
Message-ID: <20241112101846.325797643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit b8fc56fbca7482c1e5c0e3351c6ae78982e25ada upstream.

ksmbd_user_session_put should be called under smb3_preauth_hash_rsp().
It will avoid freeing session before calling smb3_preauth_hash_rsp().

Cc: stable@vger.kernel.org # v5.15+
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/server.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -238,11 +238,11 @@ static void __handle_ksmbd_work(struct k
 	} while (is_chained == true);
 
 send:
-	if (work->sess)
-		ksmbd_user_session_put(work->sess);
 	if (work->tcon)
 		ksmbd_tree_connect_put(work->tcon);
 	smb3_preauth_hash_rsp(work);
+	if (work->sess)
+		ksmbd_user_session_put(work->sess);
 	if (work->sess && work->sess->enc && work->encrypted &&
 	    conn->ops->encrypt_resp) {
 		rc = conn->ops->encrypt_resp(work);


