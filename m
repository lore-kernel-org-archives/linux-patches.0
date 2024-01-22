Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6A9145B07;
	Tue, 23 Jan 2024 00:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969676; cv=none; b=XKJA33sgHiLtI6LB8zdrKkAgarmVumTXE0fR+T325DsuaG3a4hMPM6Dtr/pTla7998A7Cja/cdptkKnH9Vb5vTTQn9Bjq7QK6+Bz+8365lCWCC+BtZnXMYz+DnqXwFJzWSCguxmjpAkXBeKHS4UVlKnUaIIv6CqVYriQ3vF/qEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969676; c=relaxed/simple;
	bh=iVPfVDj3lgQwTdQFyjaAQPXfFKnWQ8ePWhoPIv6oINE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDuJk4+/xjRS4TXXIVdfXqNr5fZrwuEd3gK5fXe4a5Oujm+MdmhWAYNEonOzqwV5XEk3b7uZF1/HQOV0pE6lb+n2UQbquq7fmYH5wIpLM1ex5Tzpr3Wc2PGW0xu/C2OUD6DMiEi8/EYf+FALgVkXzYDQPi03eXlpFcw56Us29EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGRXeUOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGRXeUOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA22C433F1;
	Tue, 23 Jan 2024 00:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969676;
	bh=iVPfVDj3lgQwTdQFyjaAQPXfFKnWQ8ePWhoPIv6oINE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGRXeUOQ6oaEkKY8f8vTnWA0VT9m5Hr7Ov94PZMnfLEu31jd2mK1kqEIAdxDER9tM
	 cf/CZRELxtdS6tHb9srByMEBG5X6wKF3hg9X/0O/a99L9AFjG+lXEWOacVgt0I21p9
	 +FaHsFlztx4CDiFvoaQIAPVGuAY4BTMHIXzaS5Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Tom Talpey <tom@talpey.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 373/641] ksmbd: validate the zero field of packet header
Date: Mon, 22 Jan 2024 15:54:37 -0800
Message-ID: <20240122235829.635063167@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



