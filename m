Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4C5168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFFAC433D2;
	Mon,  8 May 2023 10:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543374;
	bh=vK4A3y81Tr8OSsacmMmkW+QGcYmmuSZEv8eIUrYi1oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arwi8duZETlSRV/lHsUjegZEy9RSq6jWFr2Ep2F/eTjgjlLd8yMm2quyE2jq5OW/w
	 BBnPdCyg1x0npj5N9pR81ktbtoh/Bi5EJ0LiypLCMSBRt3Mid8fd7U+WAs9PG/CLwo
	 jlAuxAzhkYo/Mrg50Fxq78fGfdg9vO0DBx0Fo69Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.3 069/694] ksmbd: fix memleak in session setup
Date: Mon,  8 May 2023 11:38:24 +0200
Message-Id: <20230508094434.796926052@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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
@@ -1794,6 +1794,10 @@ int smb2_sess_setup(struct ksmbd_work *w
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


