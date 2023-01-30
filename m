Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4777228EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C168BC433D2;
	Mon, 30 Jan 2023 14:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087340;
	bh=//nUVaek03QVesbOXFgFBkXNU6I9qUBGK2xjkqOsWVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3xlU8wT1JOB2d/cdmgERZvRrvs6yVLr3po1vQO78pOpMABTwcF48T569NQlb0rKE
	 ngnH1nsaNqHDXtwOtws1vSKTs7fV8qLNdoI4aTysDs8RAz9+7ULOaSkECk+kudxTRp
	 p5Crnh8HMCSjXa0vaDBsAa+g69vTLrrRSXwy4lCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/313] cifs: fix potential memory leaks in session setup
Date: Mon, 30 Jan 2023 14:50:11 +0100
Message-Id: <20230130134344.882638176@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit 2fe58d977ee05da5bb89ef5dc4f5bf2dc15db46f ]

Make sure to free cifs_ses::auth_key.response before allocating it as
we might end up leaking memory in reconnect or mounting.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsencrypt.c | 1 +
 fs/cifs/sess.c        | 2 ++
 fs/cifs/smb2pdu.c     | 1 +
 3 files changed, 4 insertions(+)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 5db73c0f792a..cbc18b4a9cb2 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -278,6 +278,7 @@ build_avpair_blob(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	 * ( for NTLMSSP_AV_NB_DOMAIN_NAME followed by NTLMSSP_AV_EOL ) +
 	 * unicode length of a netbios domain name
 	 */
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.len = size + 2 * dlen;
 	ses->auth_key.response = kzalloc(ses->auth_key.len, GFP_KERNEL);
 	if (!ses->auth_key.response) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 0b842a07e157..c47b254f0d1e 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -815,6 +815,7 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 		return -EINVAL;
 	}
 	if (tilen) {
+		kfree_sensitive(ses->auth_key.response);
 		ses->auth_key.response = kmemdup(bcc_ptr + tioffset, tilen,
 						 GFP_KERNEL);
 		if (!ses->auth_key.response) {
@@ -1428,6 +1429,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
 		goto out_put_spnego_key;
 	}
 
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
 					 GFP_KERNEL);
 	if (!ses->auth_key.response) {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 92f39052d311..2c9ffa921e6f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1453,6 +1453,7 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 
 	/* keep session key if binding */
 	if (!is_binding) {
+		kfree_sensitive(ses->auth_key.response);
 		ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
 						 GFP_KERNEL);
 		if (!ses->auth_key.response) {
-- 
2.39.0



