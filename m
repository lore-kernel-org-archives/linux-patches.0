Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8583B268C6F;
	Tue,  8 Apr 2025 11:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111783; cv=none; b=EFdOzRApfM/x5lKmyuuTbzOJO73GaIsab/JRS3KoFikgeKAd6X9UeebtI21ajVFzxvX8ZxQxe41PzDV5LU/5fkuNqJpP33afPojN4UBE4LgX8CqNHBh23EnE6ailj3328l0MtmXCIdl6iSY6lbvZU7en5JtAu0Hk4o+ljsM5w6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111783; c=relaxed/simple;
	bh=SSBFxZpflptORheHvXfInpv14nu0xxcv9lTbvRfDMWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3j2HxZsJxkQUFILKZwN+lBmCYNSM2Q4wULgjKM4p8uKGwoLoeCQHd4rsZDs+lXHlu2WDcaDKoly3DL1VkOM0GlvfH1s9ancXqi3XuT97X+qlrUjVxTavDOXHIyUigaurI1qsjFsGlE64vy+UrS9rAmDaS3VvhW8dgtY3FGUatA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPK10sAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPK10sAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1578CC4CEE5;
	Tue,  8 Apr 2025 11:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111783;
	bh=SSBFxZpflptORheHvXfInpv14nu0xxcv9lTbvRfDMWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPK10sAFutNkAg3swqE5cTKMNAa5R3wQ435XXZHIBIIy7hOlH+GnwhVKOfrxbPqA7
	 mrjm1YtVbobAvKAE0dUXt05ItoOZUQVahm2Pkja/EDD6pSc0kw1L4kmqjTRnPPdlBR
	 LzLPaKSK3H6pxndp8KWnIUr23MEvvOV1+Ytn7RoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 559/731] ksmbd: fix r_count dec/increment mismatch
Date: Tue,  8 Apr 2025 12:47:36 +0200
Message-ID: <20250408104927.277339444@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit ddb7ea36ba7129c2ed107e2186591128618864e1 ]

r_count is only increased when there is an oplock break wait,
so r_count inc/decrement are not paired. This can cause r_count
to become negative, which can lead to a problem where the ksmbd
thread does not terminate.

Fixes: 3aa660c05924 ("ksmbd: prevent connection release during oplock break notification")
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 28886ff1ee577..8e6d226dc4e0a 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -724,8 +724,8 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 	work->conn = conn;
 	work->sess = opinfo->sess;
 
+	ksmbd_conn_r_count_inc(conn);
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
-		ksmbd_conn_r_count_inc(conn);
 		INIT_WORK(&work->work, __smb2_oplock_break_noti);
 		ksmbd_queue_work(work);
 
@@ -833,8 +833,8 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 	work->conn = conn;
 	work->sess = opinfo->sess;
 
+	ksmbd_conn_r_count_inc(conn);
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
-		ksmbd_conn_r_count_inc(conn);
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
 		wait_for_break_ack(opinfo);
-- 
2.39.5



