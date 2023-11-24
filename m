Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3AD35F1A;
	Fri, 24 Nov 2023 18:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1R58pnN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A89C433C7;
	Fri, 24 Nov 2023 18:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851106;
	bh=L0S10EUq8BQ+dV3Fi0bhhWIdfbvR0ULk6yQJUIoHd0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1R58pnN8ceZJchjJFytXRannqVdgOuAODGEyqmr1ljDl9pQd7240R7oLhXRsCVAlo
	 aJNf7NRVsaNj0DqYqHvflUeoQVKmLdhWWZ/Qcnzt7kmUR9tdX4AH8hYQh3v5v0v2pW
	 duYsUaHeb5LpMfWK+xkDmeTnBvMwjZp+B6rSfGTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.5 298/491] ksmbd: handle malformed smb1 message
Date: Fri, 24 Nov 2023 17:48:54 +0000
Message-ID: <20231124172033.525718629@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 5a5409d90bd05f87fe5623a749ccfbf3f7c7d400 upstream.

If set_smb1_rsp_status() is not implemented, It will cause NULL pointer
dereferece error when client send malformed smb1 message.
This patch add set_smb1_rsp_status() to ignore malformed smb1 message.

Cc: stable@vger.kernel.org
Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb_common.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -372,11 +372,22 @@ static int smb1_allocate_rsp_buf(struct
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


