Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217286;
	b=2HA2HDsicFYhwvRaqdO598L+CEdtdjisixByG0+oIBuSBNfWAruBn3nXOQnQNpWEhy/S
	 Z470UJvY5s/oulg54zg/udEUMMTZVdSyw1TKGa2aWhuagzf30ed5pm03ryQxQBdgOosiM
	 Gcf7QG0o6MinVRFIjL5OnOQ45eEzH2rtt1Ow9INXXN1a8/EaThTnlS2/5/SApbjIZ72G+
	 CNKTwaVPALs5L8FgOST+Cwao7EDNXkgNOJWQH8TfqBWczUyQ3uUX2rrMz3Cziq3/qURvK
	 fAtYRm+mepSNwDL5srNCgoyUlkhqHxbzAvpOD6qa036AE44SwuONH/Aa38C/sASVHWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IEAkjQxqRVK2j8X2D4RoeMnii3Kms98ZwACF2k7zi0U=;
	b=fA+LwpV7BUhazz8+xCg6bKnZQVP/sD+LuCiOgjKfEPPSlaFvpOopQTXs1IWVHoNZNfN2
	 9GcGZ1DwWk4s4tKp/UvrfLzLqBnxd1yFmZuzavyYIhhPxWrKg2Tt7sjM0KoDmYcZIZllB
	 ueufpDloUVCkSBkiiFUksSG8gZicHPOkSGB1nsVLvAbGtckOu6nt86zEe+7W+p3yM19nP
	 angPlRqqMyoXiOEwVBmBeoQpHfAVPfESj6R77sTGessgPtqwftwMzw1loRYWJySRdMH7Q
	 8vq9NTXky+BF9zVqHh1B+niYgjXaa+nnGBl0olQLUZKkeSx2/2GeGBmSCUQEhhSfQng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yN0JiMJD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4363606A31A;
	Wed, 28 Oct 2026 19:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yN0JiMJD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3186E1F01825;
	Wed, 28 Oct 2026 19:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217285;
	bh=IEAkjQxqRVK2j8X2D4RoeMnii3Kms98ZwACF2k7zi0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yN0JiMJDHTUQ7fV2+OKB+gaX3Mpx03RbIm8Rp3PVdAB7SCdEk4X87MGmkNSllHSpT
	 9V0uDQmsNpReMRW0hhAYbro5sqbDAKw+Uq2pRYb3Wom7YI40eVQd8qNlKLxiBTyrDo
	 4ozlXz5Iy5+nBY5kULzaKD/WSXKFudBMxF4BLQks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1851/1887] ksmbd: fix r_count dec/increment mismatch
Date: Wed, 28 Oct 2026 18:05:47 +0100
Message-ID: <20261028170541.571990277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9272b33340fc8..932e31a20216e 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -792,8 +792,8 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 	work->conn = ksmbd_conn_get(conn);
 	work->sess = opinfo->sess;
 
+	ksmbd_conn_r_count_inc(conn);
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
-		ksmbd_conn_r_count_inc(conn);
 		INIT_WORK(&work->work, __smb2_oplock_break_noti);
 		ksmbd_queue_work(work);
 
@@ -902,8 +902,8 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 	work->conn = ksmbd_conn_get(conn);
 	work->sess = opinfo->sess;
 
+	ksmbd_conn_r_count_inc(conn);
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
-		ksmbd_conn_r_count_inc(conn);
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
 		wait_for_break_ack(opinfo);
-- 
2.53.0



