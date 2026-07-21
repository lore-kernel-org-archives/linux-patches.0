Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CCD386C39;
	Tue, 21 Jul 2026 19:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660827; cv=none; b=ARzF7HgC9H045Mpu1ASlYvJtg07BY2GULoEQJHy2aivLr25GGB3fj8Uxm7uP8gyL3EfBlIPLwf42bkbA/zSPM6DXcJTkCOUwbpCmid2M4FI8tpIYg2r/Jpq5XUW+XL8uo0094eAchXnSUNxgbyV5dTSYo74ib27r6FweX+i2MXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660827; c=relaxed/simple;
	bh=uTd1KHFwpc5achNXek6VcjLC4rkJg2OMhvvgtyjeC6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/J0hEREnm8UJFaIbgCwUP/MgsWt8eBTC8i4vvhxv5t9AUgfKwsxvsHhV1nwg8kpiVs6OG+FUxDL7gnMvuzEF3Obci6/KEUfHyK5CnX5lCe7rULCorekLDGuZ/Mm2qnRMKm1iJalz0YlFsQYpaJgURHRUuGlxO6u9SXH+kj4QfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6VnlmqH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6VnlmqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FE01F000E9;
	Tue, 21 Jul 2026 19:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660824;
	bh=DEoJLD5KM1DHWV6DesWwiCgomhg8mh9YAlqLh/A3brY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6VnlmqHSJmNj4kwkk8uujNtGN8q5lcARRXUWRDJgmhVFsqHKewmyKJG2U/ZTUzzh
	 kE7TkpUP2C7h0nji8LTX87an401xl01QYwl5Mu/cCTiQA/vg3UY2z1MFNz2A7ZVWaQ
	 fJLFuLhlCFEJjRFj1CJDpSdkcwYl5BW6iWBUeTY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1126/2077] netconsole: dont drop the last byte of a full-sized message
Date: Tue, 21 Jul 2026 17:13:19 +0200
Message-ID: <20260721152619.376737190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit c0ebe492329a4d29592e2240df17e56724849f1f ]

nt->buf is exactly MAX_PRINT_CHUNK bytes, but scnprintf() reserves one
byte for its NUL terminator, so a non-fragmented payload of exactly
MAX_PRINT_CHUNK loses its last byte (emitted as a stray NUL in the
release path). Grow nt->buf to MAX_PRINT_CHUNK + 1 and bound the
scnprintf() calls with sizeof(nt->buf); the transmitted length stays
capped at MAX_PRINT_CHUNK.

Alternatively, nt->buf could be left at MAX_PRINT_CHUNK and the NUL byte
reserved by routing exactly-MAX_PRINT_CHUNK payloads to fragmentation
('len < MAX_PRINT_CHUNK'), at the cost of fragmenting those messages.
But it would look less sane, thus the current approach.

Fixes: c62c0a17f9b7 ("netconsole: Append kernel version to message")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260616-max_print_chunk-v1-1-8dc125d67083@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 57dd6821a8aa90..bfab0a47678c9b 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -184,8 +184,10 @@ struct netconsole_target {
 	bool			extended;
 	bool			release;
 	struct netpoll		np;
-	/* protected by target_list_lock */
-	char			buf[MAX_PRINT_CHUNK];
+	/* protected by target_list_lock; +1 gives scnprintf() room for its
+	 * NUL terminator so a full MAX_PRINT_CHUNK payload is not truncated
+	 */
+	char			buf[MAX_PRINT_CHUNK + 1];
 	struct work_struct	resume_wq;
 };
 
@@ -1692,7 +1694,7 @@ static void send_msg_no_fragmentation(struct netconsole_target *nt,
 	if (release_len) {
 		release = init_utsname()->release;
 
-		scnprintf(nt->buf, MAX_PRINT_CHUNK, "%s,%.*s", release,
+		scnprintf(nt->buf, sizeof(nt->buf), "%s,%.*s", release,
 			  msg_len, msg);
 		msg_len += release_len;
 	} else {
@@ -1701,12 +1703,12 @@ static void send_msg_no_fragmentation(struct netconsole_target *nt,
 
 	if (userdata)
 		msg_len += scnprintf(&nt->buf[msg_len],
-				     MAX_PRINT_CHUNK - msg_len, "%s",
+				     sizeof(nt->buf) - msg_len, "%s",
 				     userdata);
 
 	if (sysdata)
 		msg_len += scnprintf(&nt->buf[msg_len],
-				     MAX_PRINT_CHUNK - msg_len, "%s",
+				     sizeof(nt->buf) - msg_len, "%s",
 				     sysdata);
 
 	send_udp(nt, nt->buf, msg_len);
-- 
2.53.0



