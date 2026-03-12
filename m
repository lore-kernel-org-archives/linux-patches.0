Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2850E342CB4;
	Thu, 12 Mar 2026 20:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346763; cv=none; b=Dtkq7fNtRc8sISRBiww1CvxBhwA97judJJjDMHtlzLfoHzvAhz3qLA4FTiH8vsIIsXnHFoVN/B6OHq0ia1zClmZwz/HA9tdkqPAj4dwtlve3aFTWfS/nehHtuuKM80o06ZmUR1+R+pSB1w2T6mEU18KqUHqnxWOw4n5xBJjs2wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346763; c=relaxed/simple;
	bh=ajDwrKttVcyx88Bnsehu+3ucqwhrG5UdM/8NzGbiGZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+wwR/6HtbfXR1Bsz2vchO0LJZIw0fK15gzl6lko8bc+qVNgBiTt+zniSd8+iGhTkLPKA8LnaPQTpShXqzNHry7M2esmLakVIrZKQSpHrPO0e5teyasNnghuzAzs/3ZADdOt+vEZm7HmYDdpYUgpppl6pWytqPfwrwQI6lS/tkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFuAnxnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFuAnxnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8DDC19425;
	Thu, 12 Mar 2026 20:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346763;
	bh=ajDwrKttVcyx88Bnsehu+3ucqwhrG5UdM/8NzGbiGZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFuAnxnFHvdGeI8Oan1x9yf3BjOgfjKxjuyaKYfJ7Zt8/hyNBnlmD0nZajOxJqGWx
	 ocd1+pEmQQPIc1s1S+hQIkG99b3obU7xAfnost+f1AitianqaawtIvTXqbrJ257fGj
	 pZ7hhEjfHxqrI3l9KpubCz6HvYP4kpaq8TYEuDwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/265] ksmbd: check return value of xa_store() in krb5_authenticate
Date: Thu, 12 Mar 2026 21:08:23 +0100
Message-ID: <20260312201022.430432128@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit ecd9d6bf88ddd64e3dc7beb9a065fd5fa4714f72 ]

xa_store() may fail so check its return value and return error code if
error occurred.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 4f3a06cc5797 ("ksmbd: add chann_lock to protect ksmbd_chann_list xarray")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ac8248479cba2..8fa6ab9dfd077 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1592,7 +1592,7 @@ static int krb5_authenticate(struct ksmbd_work *work,
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	char *in_blob, *out_blob;
-	struct channel *chann = NULL;
+	struct channel *chann = NULL, *old;
 	u64 prev_sess_id;
 	int in_len, out_len;
 	int retval;
@@ -1658,7 +1658,12 @@ static int krb5_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;
 
 			chann->conn = conn;
-			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, KSMBD_DEFAULT_GFP);
+			old = xa_store(&sess->ksmbd_chann_list, (long)conn,
+					chann, KSMBD_DEFAULT_GFP);
+			if (xa_is_err(old)) {
+				kfree(chann);
+				return xa_err(old);
+			}
 		}
 	}
 
-- 
2.51.0



