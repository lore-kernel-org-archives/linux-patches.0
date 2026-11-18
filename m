Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027621;
	b=Ef/qiRFQ9AchyrteOFtbAf5of1QuOk15KG2QDJx84OV2SF5UHNwU47tv9qHLIekNM/eJ
	 klcfDEmTmDOzGAmIoA9nP9mlHD20aGzXigUWUa3gFe2o+Q0V+72rL3D0Wq7FNxoszvXgE
	 OXu7S/z5cidgm1YoKZlQ3C4mfE0vDmw0y6yZFvL0PgxpPVzUuftG9L5a3LL0XJ5zvhJF5
	 xwowUU6T4xd9rcXcsX0nTZ7WyftFmTyuxn6jVWmoJhxDJ0cPLPmbHpelr6Qn4vmg5aC5L
	 A7c52Jv/43J5T+HIxmh49ryYkStw+oonFNGVTuAwxvV1085BUJpS1GSUg83HYeEP+ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jPnLTUFxmjkyvzLx3PY9yAyhv0zKm6QICefRLVDLM8U=;
	b=tAhj4CSOzcLZfM05hd9nLeAhetHskgf+ac9AQAIY5yocbafQwhq33Z9rnuLOuWtOUnk4
	 56twwJQQ/UgKAc6uxvD2acky5S7XEjGWswgg0oAMZtKiU/xFSEYabbaACUpmaO1sOHJuQ
	 CzTJjp4C3fRK5FU4lFqaDwVhnAAkjchiwOYeJ3AwH85KJQvwNJ8CmsNiHG6IKG1iJmUiS
	 H8YADEtsXXI88fikbqTHeZlRZbR1bhR/v9nGcZG1SDVJhbL2yAJM7tvEUvHL3Kba03ORX
	 o7mZxAxlcwcsph72FjT31sgBOZ97DqYVCo41A4THZ4GtfclzOg1gRvdX2Hmbc15KUcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rudF0FJe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0CA606A337;
	Wed, 18 Nov 2026 18:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rudF0FJe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C161F000C4;
	Wed, 18 Nov 2026 18:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027620;
	bh=jPnLTUFxmjkyvzLx3PY9yAyhv0zKm6QICefRLVDLM8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rudF0FJeLC5vBNuSflsSQod70W+s9asn3Er2aybf9bhXDcS82FLwQB9ZEhJci36Bc
	 PHaG6hJPjujzwbFpAtOpSKXl/G4dntGfWd7NYhifdOvWS7+UTin/6C/YyFs/XOdaIt
	 lzJfnzbEE8+OCUhSv5ppzwduTrDeUWGDcsL9tImI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed Alquraini <mohammed.saad.alquraini@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1853/2151] ksmbd: reject foreign RPC pipe handles on IPC$ read and write
Date: Wed, 18 Nov 2026 15:59:48 +0100
Message-ID: <20261118150229.298223897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 79e1990ddb0d1..ea04cb2662246 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7001,6 +7001,16 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 
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
@@ -7317,6 +7327,16 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
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



