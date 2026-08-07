Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8610A2F0C74;
	Fri,  7 Aug 2026 15:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115890; cv=none; b=Iwv4MrDa8TbiBbnrwpZV30hg7+uQVWPClhIsoVKbaSx369eeXY3fXTI3Me6kj5TC9skF0UAC7JImY4LJeQvt6pKjE8/3tCUzuViS5aXCFy6qi7F/Iw4BhlIzmVw5wnC9MV2sTXnH6DtXh3bnho7aZSIuBf7TVlnxjmr9XjMxuGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115890; c=relaxed/simple;
	bh=jyTxajKml6fw9DyvxbeDgIMjjYUuHAubL76plThpnng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyCz6GjqOsX5cs72FiHndQiwkUn3IMu0WECNtEcFCBXXXYHo8KboGpwJMpVqUpQH59A6SCLyVjdguz3bowCBVidzh/bQduejAl4lFTBvsiHI/SE4nQPqdsmaBsOxjj9iD5bC7XiPuhkZjWV/SFqf1X+r5oHX91T7BwbsqtD7XPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNEw+sGT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNEw+sGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E1F1F000E9;
	Fri,  7 Aug 2026 15:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115889;
	bh=k9MKJUXld6bPVl9wlFdOD6NiUYQAT+JJzN6WXl8pz18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNEw+sGTGaStKuH6it5/RC4DiFasRAHNZMMjQg0qiEisBhenW5+2+hq53ASv+ZVdY
	 pG0TkKTSTQix/19ojoUVvMqr2rpUZUmneJ9vXmq361zWe8RkEnGN//OCl+oQTkgbTQ
	 GUYDxSbCcO1yF42LWyqcLJPceXqo4NhhbCE8IHUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Leech <cleech@redhat.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/261] scsi: libiscsi_tcp: Bound SCSI Response data segment to the connection buffer
Date: Fri,  7 Aug 2026 16:36:35 +0200
Message-ID: <20260807143416.202748797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c182aa83f2c93..4d23205129432 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -763,13 +763,6 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
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
@@ -777,6 +770,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		}
 		rc = iscsi_tcp_r2t_rsp(conn, hdr);
 		break;
+	case ISCSI_OP_SCSI_CMD_RSP:
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
 	case ISCSI_OP_REJECT:
-- 
2.53.0



