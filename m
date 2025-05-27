Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206E0139579;
	Tue, 27 May 2025 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365852; cv=none; b=CKwCtKf3IDdDuZqrDCw/53TQwJvDsFEEzqZ1BM73UEAScgHF4/E8dYbBXFko9kgaozQda3ywEodYSWeQzxfh9tr6pIkB/Y2ylochgyCw1C184ybSWYfaJJpji01rsyaxhzlBEiieG3BMSHDw/CYINzZ80HsgvAMLmfHXjTVQXkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365852; c=relaxed/simple;
	bh=Ev49vztQgMB25fA9TziNCVF88IW9BPpRgvpfhIOHYms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cU5ifVcg+I4gjk8CDMhQzS5iVsL4vCXWFU6uXYNpdCG/WkVKLOy3t+dB/8H/wpcd1WvDx6ZOZgUcTRfn+an2R9mOOFkj9gp3ypEfemKSyONfR6RC6RwoImmbkHKqOIZZz0XC5ZY6mIa/g3tMgT3K3FXhfh8eVJIjZ/T+ypARJsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYrw6ngJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYrw6ngJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FCFC4CEE9;
	Tue, 27 May 2025 17:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365852;
	bh=Ev49vztQgMB25fA9TziNCVF88IW9BPpRgvpfhIOHYms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYrw6ngJ0tocRqxH2DKOM/yHMQhCgRP3WSHonlOLDZYpgHhkGk6J898F0oIT4d3xM
	 61r9/aDBxa/m3G3m2uQ7RJEMi2Iabub9nEkrJYL0rmjNrbUUvEkDjMuyg7sryNkm/g
	 bdo4/hQgv7JuaH8zdoL9851RgpzudH+oqHqGUYEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 508/626] smb: server: smb2pdu: check return value of xa_store()
Date: Tue, 27 May 2025 18:26:41 +0200
Message-ID: <20250527162505.603803370@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit af5226abb40cae959f424f7ca614787a1c87ce48 ]

xa_store() may fail so check its return value and return error code if
error occurred.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f0760d786502f..08d9a7cfba8cd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1448,7 +1448,7 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
-	struct channel *chann = NULL;
+	struct channel *chann = NULL, *old;
 	struct ksmbd_user *user;
 	u64 prev_id;
 	int sz, rc;
@@ -1560,7 +1560,12 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;
 
 			chann->conn = conn;
-			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, KSMBD_DEFAULT_GFP);
+			old = xa_store(&sess->ksmbd_chann_list, (long)conn, chann,
+					KSMBD_DEFAULT_GFP);
+			if (xa_is_err(old)) {
+				kfree(chann);
+				return xa_err(old);
+			}
 		}
 	}
 
-- 
2.39.5



