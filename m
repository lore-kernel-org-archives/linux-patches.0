Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826756;
	b=VJqFYvX74DaUCVl4WnMbaxijz1sm9vwga028OCOW6vMhms3qwSPvsFqtBvKPBRoCH25Y
	 LbAJy/EFJmiK7XdFM0rG9hXIP+H2RbmuRe272nWOvIIcJZBDfl6wzq4jBvfnPJWynoZgL
	 h5AqUI745NU3eWLA/XXhY9UFq5TiCxga5kZ5oIw3IBhydg1KYSbL/xHI5OBWTDae95WgN
	 d0bVOBe2AMNWYNPmzj1rYN+ncRD4tIUhcM5hQWwQzkitV3TtNiLa/jqZixiQHKDPAo/JG
	 sTFtHIV4MX1ReeQ+JEodiR2hpKCIhxsbUC1Ra72HFRZxhkizMFxPxM+yCNC8BGcH+9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QU0gnZBHoXI4XqIQwM2Nu+yGmIw3L/IsAkcYGnCBiKA=;
	b=5BGRMWbpZv8IS2FnUg0sXpAXAbYdA5oqdkjd0lujXvGOHQb5k4tVypPGQfCd7HpRPlnT
	 e2GptfM8C/XoJHBaSp/UgFblRma8wy6gZLVwDX3/ybjetQPJ3dkuypRLJY+9rNzBKIMr3
	 zbNkzR0UdYRWI2W765Qc4dRKKqv/a40cJ2t0Rqj7fAlGhstkeO3mINsp/CKUHnGdwHOAS
	 f3vXbOqRAN74U7xhq/75gdycQ2pJkQe2u4C+5ji9YIttW2rnrTjJW5E0WZQZNW3laQMK2
	 FY710s4+Ezj5Sk6Sfhu0KI4i3fV66aKGByxubwmWay8i+IH/a5HTQsBGMG+nyVU6rPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Wz9032o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8987260B9086;
	Wed,  4 Nov 2026 21:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Wz9032o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDBC1F00A16;
	Wed,  4 Nov 2026 21:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826756;
	bh=QU0gnZBHoXI4XqIQwM2Nu+yGmIw3L/IsAkcYGnCBiKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Wz9032oX03TPwPSZA5AFL+A2j0SW30o3G7PzlfXD0KmejYZSYVfNtYfMqGpIV+03
	 D1n0ARU8cemQ1E8QqyWGrh8mpEGjcgdIsBh87tJ+mJkczxUagD6bvDelZ7iut0K0RS
	 fG1rOjpz09GMe+g3AWRYzhvK6hYmLh1AjgdOKcD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ihopenre-eng <ihopenre@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 002/547] ksmbd: wait for negotiation before receiving another PDU
Date: Wed,  4 Nov 2026 16:03:06 -0500
Message-ID: <20261104211038.473764943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 68f410faedaf6ee74d81e574733c50ebcc1bd8ed ]

The receive thread queues a request and can read the next PDU before
the negotiation worker finishes. While need_neg is set, the next PDU
can cause ksmbd_init_smb_server() to replace conn->ops. A pipelined
SMB2 request can therefore make the worker handle an earlier, shorter
SMB1 request with SMB2 operations and read beyond its buffer.

An SMB1 multi-protocol negotiate may be followed by an SMB2 NEGOTIATE
that changes conn->ops again. Wait for work queued while the connection
is new or needs negotiation to complete before reading another PDU.
This keeps the operations stable for both stages of negotiation without
changing when need_neg is cleared.

Fixes: dc8289f91238 ("ksmbd: fix slab-out-of-bounds in init_smb2_rsp_hdr")
Reported-by: ihopenre-eng <ihopenre@gmail.com>
Reviewed-by: ihopenre-eng <ihopenre@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/server.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 0827c8c510066..e0d00ed22461f 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -382,6 +382,7 @@ static void handle_ksmbd_work(struct work_struct *wk)
 static int queue_ksmbd_work(struct ksmbd_conn *conn)
 {
 	struct ksmbd_work *work;
+	bool wait_for_neg = ksmbd_conn_new(conn) || ksmbd_conn_need_negotiate(conn);
 	int err;
 
 	err = ksmbd_init_smb_server(conn);
@@ -404,6 +405,10 @@ static int queue_ksmbd_work(struct ksmbd_conn *conn)
 	conn->last_active = jiffies;
 	INIT_WORK(&work->work, handle_ksmbd_work);
 	ksmbd_queue_work(work);
+	/* Negotiation can change conn->ops, finish it before reading another PDU. */
+	if (wait_for_neg)
+		wait_event(conn->req_running_q,
+			   atomic_read(&conn->req_running) == 0);
 	return 0;
 }
 
-- 
2.53.0



