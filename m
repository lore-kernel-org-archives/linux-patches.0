Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477E711718
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA0AC433C7;
	Mon, 11 Sep 2023 15:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444649;
	bh=phpVBx9nMIUktAkaDqbbM24mFDQEHITVmlKQsOQuE2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gpgoh7acPC1R1TRQpaLJ0As6444NhQEaSPqvRYQLOUVTlNXd4Vlpg842B4/Gd01e9
	 N6hx6xWp7vp/6GoRCMf0IojRax6O+jlWQMcSUZqxgGveXjG7zx68RD2SfIcWqfAEiE
	 NHz5ovKG2T7SRApOI5cUImZt1Q7Py6eaPp89Z+cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/600] cifs: fix max_credits implementation
Date: Mon, 11 Sep 2023 15:41:40 +0200
Message-ID: <20230911134635.599572606@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 5e90aa21eb1372736e08cee0c0bf47735c5c4b95 ]

The current implementation of max_credits on the client does
not work because the CreditRequest logic for several commands
does not take max_credits into account.

Still, we can end up asking the server for more credits, depending
on the number of credits in flight. For this, we need to
limit the credits while parsing the responses too.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c |  2 ++
 fs/smb/client/smb2pdu.c | 32 ++++++++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index bcd4c3a507601..6b020d80bb949 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -34,6 +34,8 @@ static int
 change_conf(struct TCP_Server_Info *server)
 {
 	server->credits += server->echo_credits + server->oplock_credits;
+	if (server->credits > server->max_credits)
+		server->credits = server->max_credits;
 	server->oplock_credits = server->echo_credits = 0;
 	switch (server->credits) {
 	case 0:
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ba46156e32680..ae17d78f6ba17 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1312,7 +1312,12 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 	}
 
 	/* enough to enable echos and oplocks and one max size write */
-	req->hdr.CreditRequest = cpu_to_le16(130);
+	if (server->credits >= server->max_credits)
+		req->hdr.CreditRequest = cpu_to_le16(0);
+	else
+		req->hdr.CreditRequest = cpu_to_le16(
+			min_t(int, server->max_credits -
+			      server->credits, 130));
 
 	/* only one of SMB2 signing flags may be set in SMB2 request */
 	if (server->sign)
@@ -1907,7 +1912,12 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	rqst.rq_nvec = 2;
 
 	/* Need 64 for max size write so ask for more in case not there yet */
-	req->hdr.CreditRequest = cpu_to_le16(64);
+	if (server->credits >= server->max_credits)
+		req->hdr.CreditRequest = cpu_to_le16(0);
+	else
+		req->hdr.CreditRequest = cpu_to_le16(
+			min_t(int, server->max_credits -
+			      server->credits, 64));
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -4291,6 +4301,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	struct TCP_Server_Info *server;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
 	unsigned int total_len;
+	int credit_request;
 
 	cifs_dbg(FYI, "%s: offset=%llu bytes=%u\n",
 		 __func__, rdata->offset, rdata->bytes);
@@ -4322,7 +4333,13 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	if (rdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
 						SMB2_MAX_BUFFER_SIZE));
-		shdr->CreditRequest = cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 8);
+		credit_request = le16_to_cpu(shdr->CreditCharge) + 8;
+		if (server->credits >= server->max_credits)
+			shdr->CreditRequest = cpu_to_le16(0);
+		else
+			shdr->CreditRequest = cpu_to_le16(
+				min_t(int, server->max_credits -
+						server->credits, credit_request));
 
 		rc = adjust_credits(server, &rdata->credits, rdata->bytes);
 		if (rc)
@@ -4532,6 +4549,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	unsigned int total_len;
 	struct cifs_io_parms _io_parms;
 	struct cifs_io_parms *io_parms = NULL;
+	int credit_request;
 
 	if (!wdata->server)
 		server = wdata->server = cifs_pick_channel(tcon->ses);
@@ -4649,7 +4667,13 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	if (wdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->bytes,
 						    SMB2_MAX_BUFFER_SIZE));
-		shdr->CreditRequest = cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 8);
+		credit_request = le16_to_cpu(shdr->CreditCharge) + 8;
+		if (server->credits >= server->max_credits)
+			shdr->CreditRequest = cpu_to_le16(0);
+		else
+			shdr->CreditRequest = cpu_to_le16(
+				min_t(int, server->max_credits -
+						server->credits, credit_request));
 
 		rc = adjust_credits(server, &wdata->credits, io_parms->length);
 		if (rc)
-- 
2.40.1



