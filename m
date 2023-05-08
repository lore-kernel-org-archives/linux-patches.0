Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C37168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56355C433D2;
	Mon,  8 May 2023 09:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539640;
	bh=FP+6WMatnJ6yw/t+QN82S89te6ngdMsGhLt4tLlvr+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5cQ7gc+EGtVQMLkUgvCxQgduGHOhji2/NJDYqauOS8LDH0QA1fuvUz0VncBD3qfD
	 VztzDdzq5jSkdfMM26BwZY3PWxcCoRKE0Zk+Q11Y9Gq7WwLv5JAdpRl/CuWEMEfXUG
	 fAwmFBZtNriLu2e2irpDdH/8nVIsly3wICOyhFoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 090/611] ksmbd: fix memleak in session setup
Date: Mon,  8 May 2023 11:38:52 +0200
Message-Id: <20230508094425.093392375@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit 6d7cb549c2ca20e1f07593f15e936fd54b763028 upstream.

If client send session setup request with unknown NTLMSSP message type,
session that does not included channel can be created. It will cause
session memleak. because ksmbd_sessions_deregister() does not destroy
session if channel is not included. This patch return error response if
client send the request unknown NTLMSSP message type.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-20593
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1799,6 +1799,10 @@ int smb2_sess_setup(struct ksmbd_work *w
 				}
 				kfree(sess->Preauth_HashValue);
 				sess->Preauth_HashValue = NULL;
+			} else {
+				pr_info_ratelimited("Unknown NTLMSSP message type : 0x%x\n",
+						le32_to_cpu(negblob->MessageType));
+				rc = -EINVAL;
 			}
 		} else {
 			/* TODO: need one more negotiation */


