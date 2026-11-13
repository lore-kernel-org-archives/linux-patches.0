Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585987;
	b=Ku9DC6rnRfwY3DjjFVKnRbaqo4SEHEniYQisEifeLXUxjF4yjyim8ahWF6oz3QNbDUE/
	 U0Dz8fRGDGTDV0ACW/S47C1sUx1ZsTQdWshUwIu2jNBWP3m9YZDTElCmshxi3Q9g/RXLW
	 siUlGmRCkUA4Fcxmagx3vA+B/+b5zWePkuJiJzdCgbrPeuVhJCT7Ds+pu0Vt4uJLXqluf
	 BU8zMo4clWXgaEE0LkXQOocEWoS223BpZW8OePcLuED74ZCAptmGRYdExID4IhKAiSLCN
	 ZlwfrIriG/aCiL/uwDGszsbJRRRhyb4l4Ut7kM5/mgP9El2sVfXpEYJ3FC1vzXSXxtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sst7vM9loLHHujXcsBA6kPveb2z49Ro5jyD/nWGn4DI=;
	b=qwAEqppgL3iGQOoRIhUKls7f0We8TXn3dqv28TiFCzFQzox+ZodvMpjxDWU6R7LlyGDX
	 UAKFIMfMV+++tYZpSQWeCtCLV6WdK6Y5pxq5Z1GRWms9K3F5qbP4zN/rPlVke0l2L3gx3
	 XOd3dabZKTs1qtYKA6d6yRfjr8MSlI8S6gfFoHK5Ssfc6bzkq693eMN2H18KHJ11GLlD2
	 kA3A+iGnu6IGQz3b9g9LIamXpxfykKaV4Z7NCp8mC9FYi6e4QNmLN+m8NFB13S2TMTZvr
	 aVNra15GavxNAaj0sCiTqXGVWeCqPcM4L8uHj+f7aCyGeeEwFubOr/EuA4wBlT8hvLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JafsCkyc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120DB6072338;
	Fri, 13 Nov 2026 16:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JafsCkyc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B217C1F000C5;
	Fri, 13 Nov 2026 16:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585986;
	bh=Sst7vM9loLHHujXcsBA6kPveb2z49Ro5jyD/nWGn4DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JafsCkycPgCNkdt8M/TLsu67Dvg4TsY8Ozv7CNWnGVLzi5DLpyCsbIYBSBDPCaAvW
	 NGPhgUtQ67Uhbtxiw56Hjume2DgivH8Zs4mXg5S4KEaCnUo2At4Kx7hzBVAuvDtNT9
	 oPy1RJejp2d2eGZjPjOtf/j2KYPWUsz6zE0wyNd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/686] smb: client: bound POSIX lock data area by response length
Date: Fri, 13 Nov 2026 10:42:44 -0500
Message-ID: <20261113153822.040975702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>

[ Upstream commit 8fc9af68c57156ff64769f30e831553cd03b3000 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 8 ++++++++
 fs/smb/client/trace.h   | 1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 14d5c1924ae2b..1049a64241bc0 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2338,6 +2338,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "Send error in Posix Lock = %d\n", rc);
 	} else if (pLockData) {
 		/* lock structure can be returned on get */
+		unsigned int rsp_len;
 		__u16 data_offset;
 		__u16 data_count;
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -2348,10 +2349,17 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		}
 		data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 		data_count  = le16_to_cpu(pSMBr->t2.DataCount);
+		rsp_len = smbCalcSize(&pSMBr->hdr);
 		if (data_count < sizeof(struct cifs_posix_lock)) {
 			rc = -EIO;
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
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index a56fbacf28d14..670612d1a4497 100644
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
-- 
2.53.0



