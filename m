Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830950;
	b=ZGL37he7JjBctDFVfInKtrZkCIgYHCC9XZvBlXNAVXiheCMjmp78iIi8FXAt9KPUMz4k
	 FZdAxjZvurpnIc5QVZV0zi3yTPnurJcycxtEfPY+qt1Klad3VRBIgFNTzPMkt/JiEv4wW
	 Ndp8yrz+uZsRzadeHfrjGZPnYaznck5bmVs2H1bsR/jSYM0X5xvJ2oDGpeZyl9eLv8O0b
	 /0EQISkgCWaD04hhoElWXL9kSul9qMTOg+3tJwCtjpfDMEAnNlFcJ0ZgEnGj0HGNr9NwZ
	 CzOJEsp+0mbk00yV6Y7uc8Vy2imXp0Aer0BVhEDXhew7lkiqf4ClALdlSdhsCZUIwSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TEZgOW6TzYUH+1IvgWbwl2Ez/VZSttR9Pnia4Af9YPs=;
	b=coRVs7ANVmMTlpajx8KUM1VQdXIcdJJKa+jlQVCgvtHAhnAsEYa8hqwZ3CnTd8EHAnPu
	 jbzv6O7CtnX31DGYIjmMThA2mMWxl4W3EcDQlPPBzZboBZHI8AJlXYCOujnjUa9B2N8ed
	 aE0wCeqn8838wq3DimUhkXE7luCn3zMcsaVDZLScFewdt5kGhF+NEyWNgKoBrtvKaCR3M
	 56Wf5k7KaIneIN3W9cMoMRKdAUVuyUp53F5YiPUfPoHoFFv2m4p+ZYy/RHoQVKvrBNbqf
	 MtcuP6iyZ23lT5q1lz9Qw2VqeuqwrApHHkFqqXoZSUCACoFQhc4/nUE7YwKCQv/xzAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZaV6vGO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A752606A844;
	Wed,  4 Nov 2026 22:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZaV6vGO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060C91F000C1;
	Wed,  4 Nov 2026 22:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830950;
	bh=TEZgOW6TzYUH+1IvgWbwl2Ez/VZSttR9Pnia4Af9YPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uZaV6vGOlvZodRyg80lDt7WqqOjnN7Nvbvazk9restNBrm0tSy85SQtF0CM6DZZUn
	 gPIjMHS1eCdfOH80rhlRt4hbHBAhGT09c9EkxjcBjAecD4RgnrGAmQTRPkufFEAcUX
	 ozbjVvL3e5JjTHeQMEo88NmZhJdYs1Yg0728j2BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0418/1005] ksmbd: fix AsyncId zeroed before use in smb2_lock() cancel response
Date: Wed,  4 Nov 2026 16:02:31 -0500
Message-ID: <20261104211055.802572045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit 7b461610882c8baa64d56dade57cdbfb686739fa ]

release_async_work() zeroes work->async_id before the CANCELLED path
calls smb2_send_interim_resp(work, STATUS_CANCELLED), which reads
work->async_id to build the response's AsyncId field. The cancellation
response for a cancelled blocked-lock request is sent with AsyncId=0
instead of the id the client received in the original STATUS_PENDING
response for this request.

Checked against every other release_async_work() call site in this
file: smb2_read()/smb2_write() don't send a further async response
afterward (their status goes out on the synchronous path instead), and
smb2_notify()'s two async paths already transfer the id to a separate
struct before releasing, so this reordering is scoped to smb2_lock()
only.

Send the STATUS_CANCELLED response while work->async_id is still valid,
then release the async work afterward.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index fba9c75b9f878..edbac6c9b577c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7914,22 +7914,25 @@ int smb2_lock(struct ksmbd_work *work)
 				spin_unlock(&fp->f_lock);
 
 				list_del(&smb_lock->llist);
-				release_async_work(work);
-
-				if (work->state == KSMBD_WORK_ACTIVE)
-					goto retry;
-
-				locks_free_lock(flock);
 
 				if (work->state == KSMBD_WORK_CANCELLED) {
 					rsp->hdr.Status = STATUS_CANCELLED;
 					kfree(smb_lock);
 					smb2_send_interim_resp(work,
 							STATUS_CANCELLED);
+					release_async_work(work);
+					locks_free_lock(flock);
 					work->send_no_response = 1;
 					goto out;
 				}
 
+				release_async_work(work);
+
+				if (work->state == KSMBD_WORK_ACTIVE)
+					goto retry;
+
+				locks_free_lock(flock);
+
 				rsp->hdr.Status =
 					STATUS_RANGE_NOT_LOCKED;
 				kfree(smb_lock);
-- 
2.53.0



