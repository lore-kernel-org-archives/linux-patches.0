Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C8C28725B;
	Mon,  9 Feb 2026 14:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648669; cv=none; b=tn4GhRVwXfqAy48E8nuJ4E5hzAFrEzJXZTc21iGWGz5aXyJ+u1n/hg/z6/QcYF/PX7ggluczrlJLlDqrU7r6OlJSv8RQ4kx+VV7E/I+KW2mZrbPkNpf9KZhxNNOvX6s7kz3mR8/baBsKr3bZQ9qoBUpdhIgmsRqaG6+NJBfeYKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648669; c=relaxed/simple;
	bh=c3LcmWLfPYEecp6xMea+yBJAv9xT9oeJmmfpoiuh59A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJ/TwEzmEUMpr1HWUKYl7s+0MvUbBafSA9a0n+0yoSAol8RF/gDWsVh2m5jk/8wuUeaC0pnp02Q9UOi43Xwh8RkY/G45kbfxePP/JLqdgWwLujR4gMK71pjQ5/OpyGqhKosaL+hWhwX0Zo+pMhKix/BPaOpW2SkMR4YIXrgZUl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFScAUIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFScAUIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F107C116C6;
	Mon,  9 Feb 2026 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648669;
	bh=c3LcmWLfPYEecp6xMea+yBJAv9xT9oeJmmfpoiuh59A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFScAUIkinZuOqc8lKiFLW9vHiUmICxVuBEm5cnxGye1tTOr6/LqklJ8bs6yii8tQ
	 nOWnIEQ5PGUYn5cQab9QnKjrLSp/paUQlp960z8VKmgAZmjTSlp8PsRkN17XK4JJSR
	 1B7hF7hgsZWxYPGb2HPGOj4rjKWxRZt/pCwoASg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Zhaojuan Guo <zguo@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/41] scsi: target: iscsi: Fix use-after-free in iscsit_dec_conn_usage_count()
Date: Mon,  9 Feb 2026 15:24:42 +0100
Message-ID: <20260209142257.576369347@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 9411a89e9e7135cc459178fa77a3f1d6191ae903 ]

In iscsit_dec_conn_usage_count(), the function calls complete() while
holding the conn->conn_usage_lock. As soon as complete() is invoked, the
waiter (such as iscsit_close_connection()) may wake up and proceed to free
the iscsit_conn structure.

If the waiter frees the memory before the current thread reaches
spin_unlock_bh(), it results in a KASAN slab-use-after-free as the function
attempts to release a lock within the already-freed connection structure.

Fix this by releasing the spinlock before calling complete().

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reported-by: Zhaojuan Guo <zguo@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Link: https://patch.msgid.link/20260112165352.138606-2-mlombard@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_util.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 58b3eb589bc77..29ad78fcdd5f8 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -873,8 +873,11 @@ void iscsit_dec_conn_usage_count(struct iscsi_conn *conn)
 	spin_lock_bh(&conn->conn_usage_lock);
 	conn->conn_usage_count--;
 
-	if (!conn->conn_usage_count && conn->conn_waiting_on_uc)
+	if (!conn->conn_usage_count && conn->conn_waiting_on_uc) {
+		spin_unlock_bh(&conn->conn_usage_lock);
 		complete(&conn->conn_waiting_on_uc_comp);
+		return;
+	}
 
 	spin_unlock_bh(&conn->conn_usage_lock);
 }
-- 
2.51.0



