Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15EF213143;
	Tue, 12 Nov 2024 10:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408210; cv=none; b=K4HMNVbyvGCKxOCh+DOfjUGFwFBSg2kVyNVQpFP9zrZZ9f8+mwoL0P/WHLnGn60fAWs4Cm+hxzE6LSlmzpalsRskMMI0rLmZHw5zjjBmzj2MoSgXhZuTWN9ZHL2yxXCfoxaXS1dNGt70wNA5d7RJ9Z1OXEMyfOc6W17uqYJnyCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408210; c=relaxed/simple;
	bh=+85+hUcnq46ZJUmt3Dahtb/LA6n669HZ4G+zy3hzeNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFY/dEPZAi8XjyKy63QN7tWzGj2+PlIwYfh2bcEu0i3gDbCBnKUtRKRy3p78rZJc3mAKlc5ovg/31a1EFF8lihJquO4A87BB7vZ/e1PWa6ymKR4UvPYeUx2p8fVe1xpfYLga1QCuLe+Khd2TzGmAlXJRDgytregoEKUnXdpDhsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwLR2eP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwLR2eP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E19C4CECD;
	Tue, 12 Nov 2024 10:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408209;
	bh=+85+hUcnq46ZJUmt3Dahtb/LA6n669HZ4G+zy3hzeNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwLR2eP7bDH6jkVZD46WK4x3s/cacTHeZ/eI7/G8FyIspRJWr0zgC8aXnwA3jm3gP
	 27CGMu3H3EMlH7vifU5RvDwQu5JA6ag08ehfeWNGwEKj1clEYWEl1Vq4d0YIUOFc8T
	 vqKjTB6eqFry4V7+nOADm1MqRGVHCTtwprscnZ/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.11 092/184] ksmbd: fix slab-use-after-free in smb3_preauth_hash_rsp
Date: Tue, 12 Nov 2024 11:20:50 +0100
Message-ID: <20241112101904.390472084@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


