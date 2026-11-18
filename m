Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032640;
	b=K4iI6JRkx/BnqU2SsV3FULDJ8eEs/7hkMuEtNvMKnfpPeyzmgWclx2Aae0ulAsHbFjKr
	 jUBAyL3IlkvH+WX24iuQrabsif3kyS/kG695cC1wBWHmUP1S3oxOjaObPcggPOYJp4Whr
	 dXk0ovN/IBPyoCmVOJqNlCeDpltiMk+tBbt9dueSD0E9yzDbYfjveuFfWkX+YRBdrepju
	 GaUh/QrZI3R1hYic/6WcB1ki67ECknB6PA6/oe7nfyKJtl131j788BJf8dAVspQcufCxr
	 z79+LB5MeaBB4MeiJjvVSaJv8ARYCRYQZrKWxTaSPjS8jh9vpwHNHQ5wITibXe/SH4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZN22gq2YDZrcqxAD4xFT/BhNN/ea5j2mns8HGGslEbU=;
	b=EsuC8gqrWtE/OnJJ3hTLek42BLkqzT/yUYS7yfzEZODQMJVhVNYA2J+xVmjGPIvUaB4Z
	 AvHrzHu+JtY93MN2sRsQtynWOmUNCOLr8EwuOOv4ohaLAD3PUdcY1+sz5lY7ecPaSm94x
	 Q/YiMCCa7JH/0KCPMdr2EHguZJxLwZJrrDbu9Kk4KojndIQr0eaFp35LSNUOcfy2062d7
	 01UACUt8oYIbEDa0E8p5dKBeA8mRccNEsnSx7doFnLX73j41QUVOMmMPPCwPDGa42xzAY
	 WmHN7yFtdcalpk4NGAhZ/KM0GD3aX8PfL1RmDWbDUKSn7HHXjo8i6o4jx4IZLBbQ/RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQQGcwSG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566FE606A31C;
	Wed, 18 Nov 2026 20:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQQGcwSG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7A21F000C4;
	Wed, 18 Nov 2026 20:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032640;
	bh=ZN22gq2YDZrcqxAD4xFT/BhNN/ea5j2mns8HGGslEbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQQGcwSGmKnIOhqB5LDmGjZECmHWvCJSAo+u3IQ63Ix39Vnq7MndAe9HyFGNO8Bn1
	 NjUdWkR9tEdxYjpT3hKCBpML4kkXsDFxmHqR+raN6Tm8YcBguozoxb8jx3l8yb/Rzj
	 3kaOirkgJScPui+rMC3VoyxWanJkluiwqvfN+4Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed Alquraini <mohammed.saad.alquraini@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1483/1756] ksmbd: reject foreign RPC pipe handles on IPC$ read and write
Date: Wed, 18 Nov 2026 16:00:10 +0100
Message-ID: <20261118150108.010921914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Alquraini <mohammed.saad.alquraini@gmail.com>

[ Upstream commit da25995071e5e0f3aa9a41160b00b2f833127b3e ]

RPC pipe handles on IPC$ are allocated from a single server-global IDA,
and ksmbd.mountd looks a pipe up by handle alone, with no session
information.  smb2_read_pipe() and smb2_write_pipe() take the handle
straight from the client request (VolatileFileId) and pass it to the
daemon without checking that the requesting session opened it.  An
authenticated user can therefore issue an SMB2 READ or WRITE on IPC$
with another session's handle and receive that session's in-flight
DCERPC response, or write attacker-chosen bytes into its pipe stream.
A tree connect to IPC$, which every RPC client already has, is the only
requirement.

Validate ownership before the transfer, the way the sibling pipe paths
already do: under sess->rpc_lock, ksmbd_session_rpc_method() returns 0
for a handle the session did not open.  smb2_get_info_file_pipe() and
the FSCTL_PIPE_TRANSCEIVE ioctl already reject such handles; read and
write were the remaining gap.  Reject them with STATUS_FILE_CLOSED, as
the ioctl path does.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Assisted-by: LLM
Signed-off-by: Mohammed Alquraini <mohammed.saad.alquraini@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d2058cd162ab0..c33d2de8c8cd4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6946,6 +6946,16 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 
 	id = req->VolatileFileId;
 
+	lockdep_assert_not_held(&work->sess->rpc_lock);
+	down_read(&work->sess->rpc_lock);
+	if (!ksmbd_session_rpc_method(work->sess, id)) {
+		up_read(&work->sess->rpc_lock);
+		rsp->hdr.Status = STATUS_FILE_CLOSED;
+		smb2_set_err_rsp(work);
+		return -ENOENT;
+	}
+	up_read(&work->sess->rpc_lock);
+
 	rpc_resp = ksmbd_rpc_read(work->sess, id);
 	if (rpc_resp) {
 		void *aux_payload_buf;
@@ -7256,6 +7266,16 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 		goto out;
 	}
 
+	lockdep_assert_not_held(&work->sess->rpc_lock);
+	down_read(&work->sess->rpc_lock);
+	if (!ksmbd_session_rpc_method(work->sess, id)) {
+		up_read(&work->sess->rpc_lock);
+		rsp->hdr.Status = STATUS_FILE_CLOSED;
+		smb2_set_err_rsp(work);
+		return -ENOENT;
+	}
+	up_read(&work->sess->rpc_lock);
+
 	data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
 			   data_offset);
 
-- 
2.53.0



