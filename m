Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1283A3F329D;
	Mon, 17 Aug 2026 14:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977250; cv=none; b=J1ywUT0JRald3UME5AD0VMHBepsiEYHJbOquxlXZ0fDVvc2VCSRLzef/1QJlGXmySrgIpjAVyK124UgLll0RR+G2G3KHkW9pLaxzbywLNBuzvQkzdCm/MdQXpahGZV8SKlJo5iK1w+0kJYHl4D9nyj4NwikPWyGxlKG589Jsvd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977250; c=relaxed/simple;
	bh=wj9Hv4pfqAObmoS9+OSO5+tJ6Ehx9SZXVCAiySNHBcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFHlRCqlD2AAKBY09LAKycEpxJwaQ/MqnHpPhRSCcLwcGBsy10dwFTdfp548UA5+lD+WqKQtGz4s/VKrtFWGuGLfnecUZRZUSeNEROOiQwcU2cLqgCMCkvfzBF7X2M+gM2JtL+hW7ELOXMOCr6RTXeFRoniu5txndzIcxbELzGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+g3foH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+g3foH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5DF1F000E9;
	Mon, 17 Aug 2026 14:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977249;
	bh=NMNajD2fFr34Z+XDLAqVAvItHAEL1fNo8xZw0iwoltQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+g3foH0xNRyo0te7CIFrja6KmGdpVHzxkMgGbiM65m4YV/8n+ZW5ChkbWs8/5Pkq
	 aj3z9sfW01BlyvHWKGx4KtE+tvy62phrDc7bD3oQhYLrB6PKOqDSK+cnK1dlqQLy4S
	 GpHMf4taGUOrXKhQd15YU9x0TZDwxKEaJNMQkKlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Leech <cleech@redhat.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 263/456] scsi: libiscsi_tcp: Bound SCSI Response data segment to the connection buffer
Date: Mon, 17 Aug 2026 15:30:53 +0200
Message-ID: <20260817132550.292723231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit c1dea15f819cded9b3faf58f8bec72323568b6e6 ]

iscsi_tcp_hdr_dissect() receives the data segment of several PDU types
into the fixed-size conn->data buffer, which is allocated for
ISCSI_DEF_MAX_RECV_SEG_LEN (8192) bytes.  For the LOGIN_RSP, TEXT_RSP,
REJECT and ASYNC_EVENT opcodes the dissect path already rejects a PDU
whose DataSegmentLength exceeds that buffer.

The SCSI Command Response (ISCSI_OP_SCSI_CMD_RSP) path also copies its
data segment (sense/response data) into conn->data via
iscsi_tcp_data_recv_prep(), but it does so without the same check.  The
only upstream bound on in.datalen is conn->max_recv_dlength, the
initiator's advertised MaxRecvDataSegmentLength, which is commonly
negotiated well above 8192 (open-iscsi defaults to 262144).  A target
that returns a SCSI Response with a DataSegmentLength between 8193 and
max_recv_dlength therefore overflows the 8192-byte conn->data buffer.

Once the same bound applies, ISCSI_OP_SCSI_CMD_RSP is handled exactly
like those responses: bound the data segment, receive it into conn->data
when present, and otherwise complete the PDU with no data.  Fold the
opcode into that case group rather than duplicating the check.

Fixes: a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld")
Suggested-by: Chris Leech <cleech@redhat.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Acked-by: Chris Leech <cleech@redhat.com>
Link: https://patch.msgid.link/20260716065848.1653431-1-sammiee5311@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi_tcp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 883005757ddb8..8e9f6e14c6e5a 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -759,13 +759,6 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
 		spin_unlock(&conn->session->back_lock);
 		break;
-	case ISCSI_OP_SCSI_CMD_RSP:
-		if (tcp_conn->in.datalen) {
-			iscsi_tcp_data_recv_prep(tcp_conn);
-			return 0;
-		}
-		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
-		break;
 	case ISCSI_OP_R2T:
 		if (ahslen) {
 			rc = ISCSI_ERR_AHSLEN;
@@ -773,6 +766,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		}
 		rc = iscsi_tcp_r2t_rsp(conn, hdr);
 		break;
+	case ISCSI_OP_SCSI_CMD_RSP:
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
 	case ISCSI_OP_REJECT:
-- 
2.53.0



