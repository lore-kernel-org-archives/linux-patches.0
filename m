Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2B21BDF0;
	Wed,  3 Jan 2024 16:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wclb9RI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A1AC433C7;
	Wed,  3 Jan 2024 16:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301145;
	bh=qWIsaQRs3qaLsAcrQUFEBjk8vVXFmx5/+MAZnHU33xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wclb9RI0LjTkA3u/sprFqWGX5AwPAfziw9/irY28Hs/Exl2lrFvFOR2OCQ8U8r5/j
	 kUwDBELyXMPnKWJuO80/7xrmddQiK/gelRdwtsZUEzyJOhO9vb43cU4ppaq7O4mdGw
	 atOM6NLXWsq/LJh/dzLH93NSpf/pzDfbFYLnuejM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/100] ksmbd: fix passing freed memory aux_payload_buf
Date: Wed,  3 Jan 2024 17:54:31 +0100
Message-ID: <20240103164902.370094514@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 59d8d24f4610333560cf2e8fe3f44cafe30322eb ]

The patch e2b76ab8b5c9: "ksmbd: add support for read compound" leads
to the following Smatch static checker warning:

  fs/smb/server/smb2pdu.c:6329 smb2_read()
        warn: passing freed memory 'aux_payload_buf'

It doesn't matter that we're passing a freed variable because nbytes is
zero. This patch set "aux_payload_buf = NULL" to make smatch silence.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b81a38803b40d..42697ea86d47b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6312,7 +6312,7 @@ int smb2_read(struct ksmbd_work *work)
 						      aux_payload_buf,
 						      nbytes);
 		kvfree(aux_payload_buf);
-
+		aux_payload_buf = NULL;
 		nbytes = 0;
 		if (remain_bytes < 0) {
 			err = (int)remain_bytes;
-- 
2.43.0



