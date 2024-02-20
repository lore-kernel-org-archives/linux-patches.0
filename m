Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD881509AC;
	Tue, 20 Feb 2024 21:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463831; cv=none; b=aWxgUHZOeSJlMQpnkrOmYw3uPqysCC0Ak0U4F5YOE9aZ2D+W6XLcjzVEt7Sp96mzikk184VRRTKKoR6sc9mMoVhcgpTa+QLjKCyo3yYWEka9tS/e3qMWA1o1+R3YVO2HBkfQ5K0xvw92aVb1Z8lsTfv88sQgmetbnRVJMy+sxNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463831; c=relaxed/simple;
	bh=tg3RJbNy7rBPdcbriuFX5uuzL/EQpDs94VoPCG08oGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngv7Qdh8+kbFi1ySrvv4aQq2UeRhuCwG22HQUWQGVC6vAWWl/x74WeqUDP3Cbjz4m3eFgEvFQFMBxt6gwm9Zqksxnp96ps3ngFbC17anJB0dmJv8/ib8xY2oCrfSNmAV1dADtHHUmDvXO8h+WZZ8iOB/rT+2NudJd1OZLxSJKJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H//mtuxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H//mtuxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB3FC43390;
	Tue, 20 Feb 2024 21:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463831;
	bh=tg3RJbNy7rBPdcbriuFX5uuzL/EQpDs94VoPCG08oGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H//mtuxEnP+9RptHFnXHQLNKr+ht18WmEbtPBSZl7+ppJTEo/kBQaWzgqyQNSE4Ry
	 k0S2wJ3mUGyaFOq0aeBU+7AbmO5w+knMRersx0vtRmb0EvjPRCF0duDuJ277fVnNuv
	 EU5QEmRhySvqstwtDtIngDWydMmj8jpgPaY/g1C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 166/331] ksmbd: free aux buffer if ksmbd_iov_pin_rsp_read fails
Date: Tue, 20 Feb 2024 21:54:42 +0100
Message-ID: <20240220205642.743102137@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 108a020c64434fed4b69762879d78cd24088b4c7 upstream.

ksmbd_iov_pin_rsp_read() doesn't free the provided aux buffer if it
fails. Seems to be the caller's responsibility to clear the buffer in
error case.

Found by Linux Verification Center (linuxtesting.org).

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6173,8 +6173,10 @@ static noinline int smb2_read_pipe(struc
 		err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
 					     offsetof(struct smb2_read_rsp, Buffer),
 					     aux_payload_buf, nbytes);
-		if (err)
+		if (err) {
+			kvfree(aux_payload_buf);
 			goto out;
+		}
 		kvfree(rpc_resp);
 	} else {
 		err = ksmbd_iov_pin_rsp(work, (void *)rsp,
@@ -6384,8 +6386,10 @@ int smb2_read(struct ksmbd_work *work)
 	err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
 				     offsetof(struct smb2_read_rsp, Buffer),
 				     aux_payload_buf, nbytes);
-	if (err)
+	if (err) {
+		kvfree(aux_payload_buf);
 		goto out;
+	}
 	ksmbd_fd_put(work, fp);
 	return 0;
 


