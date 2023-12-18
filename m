Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4687D129EF7;
	Mon, 18 Dec 2023 13:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdtEhzQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23DAC433C7;
	Mon, 18 Dec 2023 13:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907975;
	bh=+ab/kW6/P5Po4KMjpLW/NHy/poFlg1ZUjQL3Ke2FrFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdtEhzQv0Sxuy49iglica1vufbwwFQZkLBz7ta3STgR/91IyQ1jG5LtZ1wioFyXDS
	 KLXNtg/wQpHf2wn5cWQr3B+4Y0QGvLTG1nkfhITEQks9HXxuysgafldg1lt+s/ll31
	 NF3nfF9jrVQzhFK8D012vdG9AS1RmmJv7VhJWlH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 092/106] smb: client: fix OOB in receive_encrypted_standard()
Date: Mon, 18 Dec 2023 14:51:46 +0100
Message-ID: <20231218135058.995875170@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit eec04ea119691e65227a97ce53c0da6b9b74b0b7 upstream.

Fix potential OOB in receive_encrypted_standard() if server returned a
large shdr->NextCommand that would end up writing off the end of
@next_buffer.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5065,6 +5065,7 @@ receive_encrypted_standard(struct TCP_Se
 	struct smb2_hdr *shdr;
 	unsigned int pdu_length = server->pdu_size;
 	unsigned int buf_size;
+	unsigned int next_cmd;
 	struct mid_q_entry *mid_entry;
 	int next_is_large;
 	char *next_buffer = NULL;
@@ -5093,14 +5094,15 @@ receive_encrypted_standard(struct TCP_Se
 	next_is_large = server->large_buf;
 one_more:
 	shdr = (struct smb2_hdr *)buf;
-	if (shdr->NextCommand) {
+	next_cmd = le32_to_cpu(shdr->NextCommand);
+	if (next_cmd) {
+		if (WARN_ON_ONCE(next_cmd > pdu_length))
+			return -1;
 		if (next_is_large)
 			next_buffer = (char *)cifs_buf_get();
 		else
 			next_buffer = (char *)cifs_small_buf_get();
-		memcpy(next_buffer,
-		       buf + le32_to_cpu(shdr->NextCommand),
-		       pdu_length - le32_to_cpu(shdr->NextCommand));
+		memcpy(next_buffer, buf + next_cmd, pdu_length - next_cmd);
 	}
 
 	mid_entry = smb2_find_mid(server, buf);
@@ -5124,8 +5126,8 @@ one_more:
 	else
 		ret = cifs_handle_standard(server, mid_entry);
 
-	if (ret == 0 && shdr->NextCommand) {
-		pdu_length -= le32_to_cpu(shdr->NextCommand);
+	if (ret == 0 && next_cmd) {
+		pdu_length -= next_cmd;
 		server->large_buf = next_is_large;
 		if (next_is_large)
 			server->bigbuf = buf = next_buffer;


