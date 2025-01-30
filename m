Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53243C13D;
	Thu, 30 Jan 2025 14:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245685; cv=none; b=WR1yrLWyK7N3ia+5au7A2dO7M+8MoxLGgkMN6GhzVcAG+v9b98md5JNaXfg1Ap9Ey6V6JvSX0pLZvT8TioMXuQ7r4jsdZEARxSieRJQLM2TtlxuYhbN8gYuo5dHCjroiVEU1/g4YugwPx778tELQPXnFzlAzQ1/AuwAEAheQhYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245685; c=relaxed/simple;
	bh=FQqgCjEOROfjkIsfrzZGRZjdjeJdfk81hdM85CB1lX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6hk5JDpuGDbAiTyortySLOgmVaG6CD4dNHjNjea7OFzICcIE3Lg3v6mxMBBwMht/tkx58dzQXGZes4QNAqrpCix0Vv5twabGERkRLIAaKsZFKKqfk5q18iVGjmoofAWjJ+b8UNcwSx5EPq/PxPGjrUhCyOk/zF25ChVa4vjbGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XuRgTUMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XuRgTUMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A64C4CED2;
	Thu, 30 Jan 2025 14:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245685;
	bh=FQqgCjEOROfjkIsfrzZGRZjdjeJdfk81hdM85CB1lX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XuRgTUMbhrz9LexlFxiWE50e9aihMl40+8Wp/VpbBQzEf8IlX/CQoi0xXtgkMez26
	 dCBvHVCWgc7u+e0J1D+QrrdvOokMPRvCTtTYKYa4/zLEclA2l78l1haFPVwIQkAw+x
	 O6p0n6rG7r3Kpk8vK7qPajusmnjDc9uAT471NBxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Zhang <hawkxiang.cpp@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 06/40] scsi: iscsi: Fix redundant response for ISCSI_UEVENT_GET_HOST_STATS request
Date: Thu, 30 Jan 2025 14:59:06 +0100
Message-ID: <20250130133459.964771949@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

From: Xiang Zhang <hawkxiang.cpp@gmail.com>

[ Upstream commit 63ca02221cc5aa0731fe2b0cc28158aaa4b84982 ]

The ISCSI_UEVENT_GET_HOST_STATS request is already handled in
iscsi_get_host_stats(). This fix ensures that redundant responses are
skipped in iscsi_if_rx().

 - On success: send reply and stats from iscsi_get_host_stats()
   within if_recv_msg().

 - On error: fall through.

Signed-off-by: Xiang Zhang <hawkxiang.cpp@gmail.com>
Link: https://lore.kernel.org/r/20250107022432.65390-1-hawkxiang.cpp@gmail.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index fde7de3b1e553..9b47f91c5b972 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4104,7 +4104,7 @@ iscsi_if_rx(struct sk_buff *skb)
 		}
 		do {
 			/*
-			 * special case for GET_STATS:
+			 * special case for GET_STATS, GET_CHAP and GET_HOST_STATS:
 			 * on success - sending reply and stats from
 			 * inside of if_recv_msg(),
 			 * on error - fall through.
@@ -4113,6 +4113,8 @@ iscsi_if_rx(struct sk_buff *skb)
 				break;
 			if (ev->type == ISCSI_UEVENT_GET_CHAP && !err)
 				break;
+			if (ev->type == ISCSI_UEVENT_GET_HOST_STATS && !err)
+				break;
 			err = iscsi_if_send_reply(portid, nlh->nlmsg_type,
 						  ev, sizeof(*ev));
 			if (err == -EAGAIN && --retries < 0) {
-- 
2.39.5



