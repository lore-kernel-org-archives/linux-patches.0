Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD15BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64859C433D2;
	Tue,  7 Mar 2023 18:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214021;
	bh=HapEm6m55CGAsUbOrNbTLoI77BEYbYxt1k5dFXrescY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQgAlryhgEzlkAQQmibZ6UC9M113D9Qxnmc3/b8Jcj5qqxagNiIZpAsigpK0LUONT
	 eKMRPPnYMKIrYxSXziXBwcaLIFp1cXpHVelrw86TYoCe0bvZzU8EqZMvbPSBuPFvUb
	 1h7UGMIJQdSs+BWxO5tHBSsAt1dKC6g2cyQkFBTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.1 695/885] fs: dlm: dont set stop rx flag after node reset
Date: Tue,  7 Mar 2023 18:00:29 +0100
Message-Id: <20230307170032.291592526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

commit 15c63db8e86a72e0d5cfb9bf0cd1870e39a3e5fe upstream.

Similar to the stop tx flag, the rx flag should warn about a dlm message
being received at DLM_FIN state change, when we are assuming no other
dlm application messages. If we receive a FIN message and we are in the
state DLM_FIN_WAIT2 we call midcomms_node_reset() which puts the
midcomms node into DLM_CLOSED state. Afterwards we should not set the
DLM_NODE_FLAG_STOP_RX flag any more.  This patch changes the setting
DLM_NODE_FLAG_STOP_RX in those state changes when we receive a FIN
message and we assume there will be no other dlm application messages
received until we hit DLM_CLOSED state.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/midcomms.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -509,6 +509,7 @@ static void dlm_midcomms_receive_buffer(
 				break;
 			case DLM_FIN_WAIT1:
 				node->state = DLM_CLOSING;
+				set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
 				break;
@@ -529,8 +530,6 @@ static void dlm_midcomms_receive_buffer(
 				return;
 			}
 			spin_unlock(&node->state_lock);
-
-			set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
 			break;
 		default:
 			WARN_ON(test_bit(DLM_NODE_FLAG_STOP_RX, &node->flags));


