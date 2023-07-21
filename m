Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7855620F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA728C433C9;
	Fri, 21 Jul 2023 19:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967170;
	bh=Oxgdi4g396zCwsMl/G1VUZUjqRDnVmIsTYYSZyBJP5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnpUo3khHhvj6ioCpsRfHWfjFMdGINsroHpl0vzfpLKFgA1gJ9fFw2P7P1umnC0zz
	 /AZqDZUPLPFc70RjOHWDBjGRWyBpHlolBhVShzqy5pUMIpgGgBpKQj4EGzdtUS3X1u
	 SKSaCiOROBAckXC8MdqbD0W+dFwgy0toFc986qzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Winston Wen <wentao@uniontech.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 068/223] cifs: fix session state check in smb2_find_smb_ses
Date: Fri, 21 Jul 2023 18:05:21 +0200
Message-ID: <20230721160523.760338761@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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
 


