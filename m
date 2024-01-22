Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AED6E2C9;
	Tue, 23 Jan 2024 02:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975403; cv=none; b=kAfDOfbvVJCe8f5uQmAe2y04r1XHsWjKGG7xOQIi1BLyt0+5SMmp5+GwfbX+hlWpSBmRWwCV7GGZP99WhSzdH4dJNyGgNTRT1/g/Sk3C465TDkz02jCD3iuI3CO1k7bPWAdTzTL38gcobVEmJfVyAQY+NkB3eCj9o1FEy9EFkpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975403; c=relaxed/simple;
	bh=niVqhAeSAGz5yoqcV+FHneehsL1wIHT+2KibdrHfyTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjdDREg/l86xRtXWYLTN1ji3/LXObYEkIU2TgJWKh+rt13rPpeCa60X0ujzImxXiUZ677dyEzhEXFDV8m9QVrjJ8HhhCNzVSWYXPk6lU/TeM3548uWfFAJbKgtFTHGIk19ToM3yb8W9bGwAGyIJpqG8giVjtxndjSLj3PjAVjK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNF3ZoQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNF3ZoQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A9CC433C7;
	Tue, 23 Jan 2024 02:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975403;
	bh=niVqhAeSAGz5yoqcV+FHneehsL1wIHT+2KibdrHfyTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNF3ZoQc9WUvgeF19pQHtPEPjJTp/Vs1P7SZ4jDgp1E8U1EV41lX6T2oyuW4UPvb+
	 1CTLSGoRB/WRWemIfQSpzIWGZEDqB5Iuevsfp7SBA3GG/5dsWfks2bHqZQNn4YSKLw
	 QWEcTUQ0ZrYwwdBuLAtLPEgm3dsEnIEb47CY+dw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Tom Talpey <tom@talpey.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 337/583] ksmbd: validate the zero field of packet header
Date: Mon, 22 Jan 2024 15:56:28 -0800
Message-ID: <20240122235822.343610392@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Li Nan <linan122@huawei.com>

[ Upstream commit 516b3eb8c8065f7465f87608d37a7ed08298c7a5 ]

The SMB2 Protocol requires that "The first byte of the Direct TCP
transport packet header MUST be zero (0x00)"[1]. Commit 1c1bcf2d3ea0
("ksmbd: validate smb request protocol id") removed the validation of
this 1-byte zero. Add the validation back now.

[1]: [MS-SMB2] - v20230227, page 30.
https://winprotocoldoc.blob.core.windows.net/productionwindowsarchives/MS-SMB2/%5bMS-SMB2%5d-230227.pdf

Fixes: 1c1bcf2d3ea0 ("ksmbd: validate smb request protocol id")
Signed-off-by: Li Nan <linan122@huawei.com>
Acked-by: Tom Talpey <tom@talpey.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb_common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 6691ae68af0c..7c98bf699772 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -158,8 +158,12 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work)
  */
 bool ksmbd_smb_request(struct ksmbd_conn *conn)
 {
-	__le32 *proto = (__le32 *)smb2_get_msg(conn->request_buf);
+	__le32 *proto;
 
+	if (conn->request_buf[0] != 0)
+		return false;
+
+	proto = (__le32 *)smb2_get_msg(conn->request_buf);
 	if (*proto == SMB2_COMPRESSION_TRANSFORM_ID) {
 		pr_err_ratelimited("smb2 compression not support yet");
 		return false;
-- 
2.43.0



