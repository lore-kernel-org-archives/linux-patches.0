Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA251FB40
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF376C433C8;
	Fri, 21 Jul 2023 16:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956030;
	bh=Oxgdi4g396zCwsMl/G1VUZUjqRDnVmIsTYYSZyBJP5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JOtnM57BZFMPuE8cWHT3n7cDg5ZW9NktnjAfiksUASKawuqou0crwqpAzEN+/d6A
	 yPfOdOTNuHIoKyZHsWRxAHSF6H6aMdiQKgsTc9oOvTVejwg/Q78xZ3DkdGoj60M4i5
	 Y+WFIu+KEN0or/ZLs0Je4aqn4rFFbN2+wS9jSOkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Winston Wen <wentao@uniontech.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.4 109/292] cifs: fix session state check in smb2_find_smb_ses
Date: Fri, 21 Jul 2023 18:03:38 +0200
Message-ID: <20230721160533.494854644@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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

commit 66be5c48ee1b5b8c919cc329fe6d32e16badaa40 upstream.

Chech the session state and skip it if it's exiting.

Signed-off-by: Winston Wen <wentao@uniontech.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2transport.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -153,7 +153,14 @@ smb2_find_smb_ses_unlocked(struct TCP_Se
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		if (ses->Suid != ses_id)
 			continue;
+
+		spin_lock(&ses->ses_lock);
+		if (ses->ses_status == SES_EXITING) {
+			spin_unlock(&ses->ses_lock);
+			continue;
+		}
 		++ses->ses_count;
+		spin_unlock(&ses->ses_lock);
 		return ses;
 	}
 


