Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852FD1BDF0;
	Wed,  3 Jan 2024 17:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lILBwQpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF252C433C7;
	Wed,  3 Jan 2024 17:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301593;
	bh=Sq83oY4qM/PgqxorxgHFm56TVY5VHruqbsufOKjxZ9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lILBwQpwB52WLLUmFtaf77A8Rf+QvKpscFBLMwopA8Vn+uBHLiDuUuYhYy5fXTMIe
	 sXSDgXd1NT8bjkpcdPreo8OCAZ1XH/+azMpNO/nmNsPdamYaDl9A4AVRQgT8+lXRkt
	 cz8DbVKJg9IFUwjkhBjJrCYOdGOpu+98bag9o4E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 72/95] ksmbd: avoid duplicate opinfo_put() call on error of smb21_lease_break_ack()
Date: Wed,  3 Jan 2024 17:55:20 +0100
Message-ID: <20240103164904.729844356@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

[ Upstream commit 658609d9a618d8881bf549b5893c0ba8fcff4526 ]

opinfo_put() could be called twice on error of smb21_lease_break_ack().
It will cause UAF issue if opinfo is referenced on other places.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c1dde42043662..e1c640ed7acc3 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8221,6 +8221,11 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 			    le32_to_cpu(req->LeaseState));
 	}
 
+	if (ret < 0) {
+		rsp->hdr.Status = err;
+		goto err_out;
+	}
+
 	lease_state = lease->state;
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
@@ -8228,11 +8233,6 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	wake_up_interruptible_all(&opinfo->oplock_brk);
 	opinfo_put(opinfo);
 
-	if (ret < 0) {
-		rsp->hdr.Status = err;
-		goto err_out;
-	}
-
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
 	rsp->Flags = 0;
-- 
2.43.0



