Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CFA223C53;
	Thu, 12 Dec 2024 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022641; cv=none; b=kFLguAphg44lLFBNqeLMl36Osr03dv0kZFpZdwi2U3N8y5YhuOdcU1IysnYhNjfmNtvxj5EPJN7KxEyZHZSVckAx+yihvqFdfrBuqiemKGeYkvuRVbfV2F6P9H4k2Yvn2cF0HPspTaFy+GJ+aTIFcgBJ5NB6fooRw0Q8TKRRPTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022641; c=relaxed/simple;
	bh=TBLwGTKlpUXHOSXnJkaARyJn4vONUCbKsYtUEUwlXB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxZ3gbLAaVd0SLIzVmtyfwkixF1tvLAsnCsKYrYrSip6D0EA9liXGdffHvJvqJhZ/Fyd9w9q00lkUtuu37pN/0ODQrxq9fjb60yacvsPWzL8+8zW4p7imCXgXO0kwYMwe4QW1Y+IoZuhz0bwfinovS3UEmcN7YFI6VpKZcC3LYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Id19j8Vo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Id19j8Vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0613DC4CED0;
	Thu, 12 Dec 2024 16:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022641;
	bh=TBLwGTKlpUXHOSXnJkaARyJn4vONUCbKsYtUEUwlXB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Id19j8Vov7tsdkdSJCf+Cimyei4Em5S2NlIIicr+9eO07x5bnZz/nsF3B+QJ4stA/
	 zrFEaRgLKXC80gJj63rAYwXqmYQhFBt8bvBrM6MemGaBS17Eiw0fZ0ecU5qKLdB01P
	 AkdWjn+LK2iVmC7kx5faCtLE8xqU08J9dLGPtHxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Mingli Yu <mingli.yu@windriver.com>
Subject: [PATCH 5.15 296/565] ksmbd: fix slab-use-after-free in smb3_preauth_hash_rsp
Date: Thu, 12 Dec 2024 15:58:11 +0100
Message-ID: <20241212144323.167442927@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Mingli Yu <mingli.yu@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/server.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
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


