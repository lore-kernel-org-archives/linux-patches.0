Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772F5364C8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGUC02uB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294B8C433C9;
	Wed, 15 Nov 2023 19:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077590;
	bh=+kMNfm4ZmMYnwdYqQW2vFdlW2WAPiDDdNRU9w75BEwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGUC02uBS58NTBDnFsrv+Z3m5cb/fe99Mujg30WyMzH9Y0BDIhMd2JyLvK5OZKzLP
	 IIt5R1TjLl3CfYwzdvWTzbCV4ydaG+5VJGHbPmATY5v5sFyU7I+t8ufsV0Fi8L/FND
	 0O58rQ3aetsvNbIU+YhK4/nfcEEdjPbgnhsog4a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 375/603] dlm: fix no ack after final message
Date: Wed, 15 Nov 2023 14:15:20 -0500
Message-ID: <20231115191639.412649169@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 6212e4528b248a4bc9b4fe68e029a84689c67461 ]

In case of an final DLM message we can't should not send an ack out
after the final message. This patch moves the ack message before the
messages will be transmitted. If it's the final message and the
receiving node turns into DLM_CLOSED state another ack messages will
being received and turning the receiving node into DLM_ESTABLISHED
again.

Fixes: 1696c75f1864 ("fs: dlm: add send ack threshold and append acks to msgs")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/midcomms.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 6bc8d7f89b2cc..2247ebb61be1e 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1038,15 +1038,15 @@ struct dlm_mhandle *dlm_midcomms_get_mhandle(int nodeid, int len,
 
 		break;
 	case DLM_VERSION_3_2:
+		/* send ack back if necessary */
+		dlm_send_ack_threshold(node, DLM_SEND_ACK_BACK_MSG_THRESHOLD);
+
 		msg = dlm_midcomms_get_msg_3_2(mh, nodeid, len, allocation,
 					       ppc);
 		if (!msg) {
 			dlm_free_mhandle(mh);
 			goto err;
 		}
-
-		/* send ack back if necessary */
-		dlm_send_ack_threshold(node, DLM_SEND_ACK_BACK_MSG_THRESHOLD);
 		break;
 	default:
 		dlm_free_mhandle(mh);
-- 
2.42.0



