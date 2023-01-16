Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEBA33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C647AC433D2;
	Mon, 16 Jan 2023 15:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884613;
	bh=3wwBBVkWstLN0luvKBxUywDjCehgOV5OpIoKRTbN4UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmfXCzJgIPJcF0uZC0kqm3vUQJUoHclzdJ1QB0+u1ssojFl/Y5l0ekms458oOR+M+
	 E/BoHB4CmSf+XpmbvPKwML5nQsR1Dwj3mRhSLu5nUVglRn1BHvrakve1Pgm0kAOcj6
	 dd5wUD9Des0kRdjKvnlV66kTiB7MoDoREe0avrDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 042/183] cifs: fix double free on failed kerberos auth
Date: Mon, 16 Jan 2023 16:49:25 +0100
Message-Id: <20230116154805.164086133@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@cjr.nz>

commit 39e8db3c860e2678ce5a7d74193925876507c9eb upstream.

If session setup failed with kerberos auth, we ended up freeing
cifs_ses::auth_key.response twice in SMB2_auth_kerberos() and
sesInfoFree().

Fix this by zeroing out cifs_ses::auth_key.response after freeing it
in SMB2_auth_kerberos().

Fixes: a4e430c8c8ba ("cifs: replace kfree() with kfree_sensitive() for sensitive data")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1479,8 +1479,11 @@ SMB2_auth_kerberos(struct SMB2_sess_data
 out_put_spnego_key:
 	key_invalidate(spnego_key);
 	key_put(spnego_key);
-	if (rc)
+	if (rc) {
 		kfree_sensitive(ses->auth_key.response);
+		ses->auth_key.response = NULL;
+		ses->auth_key.len = 0;
+	}
 out:
 	sess_data->result = rc;
 	sess_data->func = NULL;


