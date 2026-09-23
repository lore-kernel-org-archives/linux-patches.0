Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1355A4756D2;
	Wed, 23 Sep 2026 14:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174072; cv=none; b=SQKnQrg8bPTxA69o5PV+iF4EpYpwsP4XeDOtimQrk6Tf3nwIaMrm2Mx7RDUhrEGQmhy0OqZkS0cIocQOD68B3HmGHS55V+qptn3OdxBNq5HfbYDPxTKKvV8jLKgdM7yNnmk5yGVzLm89O3ZhP8APlPgGVdPPCEEYJO0hQpFPxLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174072; c=relaxed/simple;
	bh=TFBo04e9MeZ2oyr4OOgSq0pB+F6X3sD3D9ejYuSSkMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pr6dHnZec7fLGeyID2piBwlzhTvvuZbmaL6pCfWs+AYQuunrHwNBtjAdpTNtZRzpHuiw1FYbO50Y/6WWb7nBluR8nVyKT44a5meS+UgqcwdeVUE5DvdMoMOTYHpayASDTbRIss2ZU2IjNkO5RvGhafHALL1x6yVVqTyDcAnh12I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0kviGQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0kviGQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698611F00898;
	Wed, 23 Sep 2026 14:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174071;
	bh=KMNHU9bKcGC5J3a5jqmpt6kLf1npKu7xjSsX2EsYg+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0kviGQND0+da+NHqvE7GE6SX6Kfw9Z/LONvbNNDTb+KU1TFqZb/3mt90Q4ipWzz0
	 r2OS3tFRryB+FmLqlGwxiCA6i1n2S3rJ9mq2OZ5KQoKBBN1paZHpPsE5vr2xQ8/NG/
	 1uJpjjT8pOcJQgKmd6iunztx8gWGkQTLwyxiyF8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 425/438] smb: client: fix server->total_read for compound encrypted PDUs
Date: Wed, 23 Sep 2026 16:07:26 +0200
Message-ID: <20260923140655.936234757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit f73726b83e4756fdaa099e1bc1143293bd57ad79 upstream.

In receive_encrypted_standard(), server->total_read is left at the
full decrypted frame size when walking sub-PDUs of a compound encrypted
frame. As a result, cifs_handle_standard() passes this full size
to smb2_check_message(), causing the PDU length guards to incorrectly
validate the entire compound frame instead of the current sub-PDU.

This allows truncated non-last sub-PDUs to bypass length validation,
leading to out-of-bounds reads in smb2_get_data_area_len().

Fix this by setting server->total_read to the true length of the
current sub-PDU: next_cmd for non-last sub-PDUs, and the remaining
pdu_length for the last one.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5383,6 +5383,7 @@ receive_encrypted_standard(struct TCP_Se
 one_more:
 	shdr = (struct smb2_hdr *)buf;
 	next_cmd = le32_to_cpu(shdr->NextCommand);
+	server->total_read = next_cmd ? next_cmd : pdu_length;
 
 	if (*num_mids >= MAX_COMPOUND) {
 		cifs_server_dbg(VFS, "too many PDUs in compound\n");


