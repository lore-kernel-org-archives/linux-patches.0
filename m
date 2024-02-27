Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D72978B61;
	Tue, 27 Feb 2024 14:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042657; cv=none; b=gkJdf/muYGF7VUHTZClQROHC+0jpLEY6yHcwMqIrJdsBRx0yhl5pWxFAg1G1T7jlY5t8AV0zC/t1/B5elrNILmEAdYv6PoQQT7Ukxx0ed2FhcvjPLasx4VxJhWjCIhe/ZxdcLhAbJzPToJMHPZQ+siyeERBNGUFsmVsT6Hdt2+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042657; c=relaxed/simple;
	bh=mtsQjASXF3GoRNmjiBdECPS6J4vlJcjLMR5YoKxozFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbMZB5JcjyFIzQDL8WPknYY51ycb0OqiaQGMSCo3zpLz26IOR7+plYAGZGMsA0wNtxn3o1s5ZxZo1MAWTiSG0UwWywrSRlc2EzO8ih2ALwcBArQtf5d0x4XghWAPaoX1dpv2iylzchs31Fqz7E5zLNuhxbJs66DTCdp79rZUA1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WS00/QDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WS00/QDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6EFC43390;
	Tue, 27 Feb 2024 14:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042657;
	bh=mtsQjASXF3GoRNmjiBdECPS6J4vlJcjLMR5YoKxozFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WS00/QDafy3hCUM3cfbXHpzzHZELRODDek0z5M0SQpJiV/yn/CVqMKJGdWCtnVZto
	 RO8IK4LtEXMkaxJBOtmpkQLNQhQiOofs9giX3YYcyR1I2NKpaiGzldBifdix/ev7z/
	 tOi5qA1GV277Y4/BEyQ1bATAk+ZUiIWG6+FStfDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/245] ksmbd: free aux buffer if ksmbd_iov_pin_rsp_read fails
Date: Tue, 27 Feb 2024 14:24:22 +0100
Message-ID: <20240227131617.646067828@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 108a020c64434fed4b69762879d78cd24088b4c7 ]

ksmbd_iov_pin_rsp_read() doesn't free the provided aux buffer if it
fails. Seems to be the caller's responsibility to clear the buffer in
error case.

Found by Linux Verification Center (linuxtesting.org).

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7e8f1c89124fa..0613b8d14409c 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6175,8 +6175,10 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
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
@@ -6386,8 +6388,10 @@ int smb2_read(struct ksmbd_work *work)
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
 
-- 
2.43.0



