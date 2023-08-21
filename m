Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93781170E
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291A7C433C7;
	Mon, 21 Aug 2023 19:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647510;
	bh=g0G3QE/venAKgn7airmwYdbVu5an341Yj8q+jdZU8sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYjtX+9rrHzXbK5MFowi6euEV8N/+fzxKwF8dkf/CewlMlo/lQncVRPAHphhJfjY5
	 Ht2dO9H+0vOlY0gP05oVmrcdk//38gc7jmoAt9uC9/BmXggxvj24qPMTnC5uQrY5K9
	 EfJo6QFLQZFATKGs3E41Kdrkck3jiNIB+TFhVq6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Winston Wen <wentao@uniontech.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/194] cifs: fix session state check in reconnect to avoid use-after-free issue
Date: Mon, 21 Aug 2023 21:40:19 +0200
Message-ID: <20230821194124.561438040@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Winston Wen <wentao@uniontech.com>

[ Upstream commit 99f280700b4cc02d5f141b8d15f8e9fad0418f65 ]

Don't collect exiting session in smb2_reconnect_server(), because it
will be released soon.

Note that the exiting session will stay in server->smb_ses_list until
it complete the cifs_free_ipc() and logoff() and then delete itself
from the list.

Signed-off-by: Winston Wen <wentao@uniontech.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 3ca593cdda76e..ba46156e32680 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3841,6 +3841,12 @@ void smb2_reconnect_server(struct work_struct *work)
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		spin_lock(&ses->ses_lock);
+		if (ses->ses_status == SES_EXITING) {
+			spin_unlock(&ses->ses_lock);
+			continue;
+		}
+		spin_unlock(&ses->ses_lock);
 
 		tcon_selected = false;
 
-- 
2.40.1



