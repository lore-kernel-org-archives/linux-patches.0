Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B8B26A0DD;
	Tue,  8 Apr 2025 12:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114920; cv=none; b=h43VCvDFdcfpgtIVV5qdqKd0ZeuDCSnFeDI0kVOWY/+FsAaiNg/dAvFzIUQGAUW5/gbbYLstAWjiyaFPdY6PJ8LxfirOtX4hDcunOd5BB2WI4LxAcOjbHN85QcSiVw4/j4iwu8fcvbEv7gDFIhLv2e4vw1Kvwv7Wo11xaqAmz1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114920; c=relaxed/simple;
	bh=qeWa/JHMirQJNZmaGdJru67TIiD5f665lN6l9evsqX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZEmzHINg3HYfUr5RRrfrmgTIQb5gyQNOfNpzhLmjOllMvI2LnatYWzJS9iQyT7wIw/AqNzxuiuctGcvTCBxo1NC+J/HFYU4YLadjdamtfCDeG/XsjS3UuQJq50+5Pmppd2uouL/8v8h8GuoMXN5224mAN2vYEvHV38E96dejXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCSm99bD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCSm99bD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57835C4CEE5;
	Tue,  8 Apr 2025 12:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114920;
	bh=qeWa/JHMirQJNZmaGdJru67TIiD5f665lN6l9evsqX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCSm99bDm7E0c12Lx9pO7PzlR2WgDQctwsCU3GFs3KCBFrtQb+rvhgYj1pqjhS1Ed
	 EfZCA5BMVFENO7MA+Ty54nn4wgI9cIS1dIZzQcJT/n5T0JVt6igqSCiym+UpbowF5w
	 5SMGs93ARx1k60Tbdr9P+073aPvSQX1PQUdRXZt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 283/499] ksmbd: fix r_count dec/increment mismatch
Date: Tue,  8 Apr 2025 12:48:15 +0200
Message-ID: <20250408104858.273996458@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



