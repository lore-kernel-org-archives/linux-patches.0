Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828997;
	b=xFZEZgovUtPqYUykW3hkO/aS1xMxye21iwbT4pmyB2ImYX28/Queu6GBs788nAij46x1
	 tjyIxz7cPwcuUcbx6t76A4k0JA42wjE5qr8VgbNiDc2RtAtcj2FBvw8wF/2Uu2I4inZsQ
	 GoKdndk8tq/oVXF+LZolOlxRypWHi3XglwVqkibjIORNw7Cbj74aGiuiFF83Aw18WREGc
	 Cl2uVneQz5oaLPC7aBEcu5nTBaE588MHwqCNCIYL/KhgHJSonlgiA79dYhzniIHUXlDqh
	 BPg3vDqAilwZkTppaUf0Ase/prdPg+pFgiQyVTkmm744EQ9OweaaphKWmefAfYckWtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JKbNKydSP71li3fRDheE84Kq8xTmvlPQXsy1ntId0N0=;
	b=F5TKDzEJ6joa4nMtdEA0NRZKRfN0CowVgEtKpWlUBw4WJTptmmmfnDmAub3JHGk4gUvy
	 ee53xwyQMErie1Fxvrvd20KMoLfFsTIJ5qJJS+zkIPo0jK5aOG1ymhLbn5Nq2WyIiXhEc
	 VT9tPBcSZi1X1sCMtx7seab/cmhFucW99FHGXpyHMAFmO2ATl7xr94QymJVGVtag0Gu1L
	 GClvZMLPX1WdQUtbAAn3Uw00cc8IdSSSOpMMaPAAMPU4RNE+sNkCYfd4eUWUPTIVfwiU1
	 NZ9T3lxwmeRi2gIcR2/YTo8nHUq+UWN/YCODxWK2vbpsKZh2QYhSbCXhW1XfhMpB6aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8OqBFA2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C1F607F2A2;
	Wed,  4 Nov 2026 21:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8OqBFA2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F091F00A15;
	Wed,  4 Nov 2026 21:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828997;
	bh=JKbNKydSP71li3fRDheE84Kq8xTmvlPQXsy1ntId0N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8OqBFA2O03SJlkNnPPzl3AuZPXWP/Ai51F7SOSkpzt+UKJaiNrxEk/R2CtuDErCY
	 CPpXTGcFjiVoa07ZtolKGliQ8/LgOBg6VYgVQOgjkjBNjKGUg70aqkaF8BzAdWOTrK
	 YH+GHINbdFdfPgilGToYm+wAlXsWy/ogTX56iJSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 377/547] smb: client: bound POSIX lock data area by response length
Date: Wed,  4 Nov 2026 16:09:21 -0500
Message-ID: <20261104211049.012149003@linuxfoundation.org>
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

From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>

commit 8fc9af68c57156ff64769f30e831553cd03b3000 upstream.

CIFSSMBPosixLock() receives a TRANS2 response whose server-provided
DataOffset and DataCount are not required by validate_t2() to describe an
interval inside the response. A server can therefore make the client read a
cifs_posix_lock beyond the response buffer and return those kernel bytes
through F_GETLK.

Use smbCalcSize() to obtain the full response length after any multipart
TRANS2 reassembly, then reject data areas that extend past it before
dereferencing them.

Fixes: fc94cdb94462 ("[CIFS] Fix new POSIX Locking for setting lock_type correctly on unlock")
Reported-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Cc: stable@vger.kernel.org
Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c |    8 ++++++++
 fs/smb/client/trace.h   |    1 +
 2 files changed, 9 insertions(+)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2380,6 +2380,7 @@ CIFSSMBPosixLock(const unsigned int xid,
 		cifs_dbg(FYI, "Send error in Posix Lock = %d\n", rc);
 	} else if (pLockData) {
 		/* lock structure can be returned on get */
+		unsigned int rsp_len;
 		__u16 data_offset;
 		__u16 data_count;
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -2391,11 +2392,18 @@ CIFSSMBPosixLock(const unsigned int xid,
 		}
 		data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 		data_count  = le16_to_cpu(pSMBr->t2.DataCount);
+		rsp_len = smbCalcSize(&pSMBr->hdr);
 		if (data_count < sizeof(struct cifs_posix_lock)) {
 			rc = smb_EIO2(smb_eio_trace_lock_data_too_small,
 				      data_count, sizeof(struct cifs_posix_lock));
 			goto plk_err_exit;
 		}
+		if (data_offset > rsp_len ||
+		    data_count > rsp_len - data_offset) {
+			rc = smb_EIO2(smb_eio_trace_lock_data_area,
+				      data_offset, data_count);
+			goto plk_err_exit;
+		}
 		parm_data = (struct cifs_posix_lock *)
 			((char *)&pSMBr->hdr.Protocol + data_offset);
 		if (parm_data->lock_type == cpu_to_le16(CIFS_UNLCK))
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -42,6 +42,7 @@
 	EM(smb_eio_trace_ioctl_no_rsp,			"ioctl_no_rsp") \
 	EM(smb_eio_trace_ioctl_out_off,			"ioctl_out_off") \
 	EM(smb_eio_trace_lock_bcc_too_small,		"lock_bcc_too_small") \
+	EM(smb_eio_trace_lock_data_area,		"lock_data_area") \
 	EM(smb_eio_trace_lock_data_too_small,		"lock_data_too_small") \
 	EM(smb_eio_trace_malformed_ksid_key,		"malformed_ksid_key") \
 	EM(smb_eio_trace_malformed_sid_key,		"malformed_sid_key") \


