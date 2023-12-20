Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E8A4BAA4;
	Wed, 20 Dec 2023 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01iB3rCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DBFC433C9;
	Wed, 20 Dec 2023 16:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089039;
	bh=z89P7zCIbe6E0oaKw7r/t0y31ir0TA339cbA4auE7t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=01iB3rCv+SiCOxB04zAS3O2y9iV31L3T51gxjFLhxxt/fKQufaKVg0xMb2XO7gFjh
	 ip6SXPPZjWcQD7dBnS7Fg1CbqWzkbwN527icDz7FUb13jgy3sqprEfbiV+ynI7XeYu
	 fwzd8GBvRIto8p+SqBP77tixN5HU6WilWNIns1vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 147/159] ksmbd: handle malformed smb1 message
Date: Wed, 20 Dec 2023 17:10:12 +0100
Message-ID: <20231220160938.174761376@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 5a5409d90bd05f87fe5623a749ccfbf3f7c7d400 ]

If set_smb1_rsp_status() is not implemented, It will cause NULL pointer
dereferece error when client send malformed smb1 message.
This patch add set_smb1_rsp_status() to ignore malformed smb1 message.

Cc: stable@vger.kernel.org
Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb_common.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -366,11 +366,22 @@ static int smb1_allocate_rsp_buf(struct
 	return 0;
 }
 
+/**
+ * set_smb1_rsp_status() - set error type in smb response header
+ * @work:	smb work containing smb response header
+ * @err:	error code to set in response
+ */
+static void set_smb1_rsp_status(struct ksmbd_work *work, __le32 err)
+{
+	work->send_no_response = 1;
+}
+
 static struct smb_version_ops smb1_server_ops = {
 	.get_cmd_val = get_smb1_cmd_val,
 	.init_rsp_hdr = init_smb1_rsp_hdr,
 	.allocate_rsp_buf = smb1_allocate_rsp_buf,
 	.check_user_session = smb1_check_user_session,
+	.set_rsp_status = set_smb1_rsp_status,
 };
 
 static int smb1_negotiate(struct ksmbd_work *work)


