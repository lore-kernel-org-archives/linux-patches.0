Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F0A27BF8D;
	Tue, 27 May 2025 17:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368259; cv=none; b=btZ0kFnW/3k7XZvWzG+BX7Pi0uKJBWF26jIbpQzmZBa+oa7U868BogIqrl+lLm6ON+18mYd9fjTSqFdxptryBzBoDbaZ00Rx/2dSfvYPPNRpmeiXTGLbF53S4twzhO96g/NnKHweB2/ItQ/uvEy8HiohKHGZX5Fdg4oakYM4dHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368259; c=relaxed/simple;
	bh=UArihea9v5KG60RIUW8wBvSXpu+ZcL9Ssh/2S544fMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjuTUOXWlIOzqUqX6qzhGG4PL3HXP1ZRmggVoDVFa9Min3y6wPfBoOLuFubF2zto0/Gh5l8t6Uz4Xmqm/KkX1FlGqDwTOQxZzmvoOkYIuQoHRDfVhDx+7S6H1rnIdzLm853Yhq/t+oKDEa8OOPUN9v43qQIdQBqF3+9b52A0C9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWbQHLry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWbQHLry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7575AC4CEE9;
	Tue, 27 May 2025 17:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368258;
	bh=UArihea9v5KG60RIUW8wBvSXpu+ZcL9Ssh/2S544fMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWbQHLrywEK8YsZnQQ2iIav/RCjMASW9CW2nMJ+pIOoC/xxnUm2YDwEQ8oVDeJSW2
	 qTVaBtpHeeDV7lbgRCDMe/2EpVBUr9I5oZ7eNgT2B72WBVheA6+B1Y9EXbIaHlzXd+
	 OwHWer16VA+arR4kxa31Uby9rDg+t37Zcrsa1Upc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 650/783] smb: server: smb2pdu: check return value of xa_store()
Date: Tue, 27 May 2025 18:27:27 +0200
Message-ID: <20250527162539.602224481@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index c2603c398a467..f2a2be8467c66 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1450,7 +1450,7 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
-	struct channel *chann = NULL;
+	struct channel *chann = NULL, *old;
 	struct ksmbd_user *user;
 	u64 prev_id;
 	int sz, rc;
@@ -1562,7 +1562,12 @@ static int ntlm_authenticate(struct ksmbd_work *work,
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



