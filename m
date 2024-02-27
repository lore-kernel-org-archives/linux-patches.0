Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8562713B797;
	Tue, 27 Feb 2024 14:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043959; cv=none; b=Y1UDFQ8d0YEkTfjKbi/Z0UocZ6bGfvfDTNVOcvKWtfMRPKzuyeBDhy7dTm27c3u+lhcbGONkfkNOIXoND/OG99EsT8dqs0tKykC+RnpOfoMHQ7oBVj5qCboRkb3AkKOdGrsQaUll05JjQi89QqzxoMMNtiasYfMHzegzztJ3xzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043959; c=relaxed/simple;
	bh=4GCbryDBro+o1OD7FixdjyEoSYOiFk/WCCNdY2uBjHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvGFmp7V2/qmxH4ebjwcEvzEh+aEzEKU6WvxoxqhA8wOaVT6EMUsoPlj990TRKAzRtzeoOtKSFpGeBfkp/vNFLRY9bSSmktn+TGEbxq11wHQZcIVBJ6FwhQLToFfIylNr526ihVT24GcRb7hxapFtnrfe15biWr5nV2s09nDc8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeemoYVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeemoYVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B894C433F1;
	Tue, 27 Feb 2024 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043959;
	bh=4GCbryDBro+o1OD7FixdjyEoSYOiFk/WCCNdY2uBjHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeemoYVjtzuto/iQbDRCupdAPdPQyvxuQiiEtpW4+qXda90unXYfgnRJuowBW1+bc
	 CUAFCSi2SjdM/jgHNPjJmHi8r87qhZdyF7fqP3LfO+D/t2cJXHYfanGVqJ1+TpBSye
	 yBdDUpBlA87Wnv6W4DAVlLnB5I9novCHbvzajCFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Guruswamy Basavaiah <guruswamy.basavaiah@broadcom.com>
Subject: [PATCH 5.10 004/122] smb: client: fix OOB in receive_encrypted_standard()
Date: Tue, 27 Feb 2024 14:26:05 +0100
Message-ID: <20240227131558.845826743@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit eec04ea119691e65227a97ce53c0da6b9b74b0b7 ]

Fix potential OOB in receive_encrypted_standard() if server returned a
large shdr->NextCommand that would end up writing off the end of
@next_buffer.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[Guru: receive_encrypted_standard() is present in file smb2ops.c,
smb2ops.c file location is changed, modified patch accordingly.]
Signed-off-by: Guruswamy Basavaiah <guruswamy.basavaiah@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4892,6 +4892,7 @@ receive_encrypted_standard(struct TCP_Se
 	struct smb2_sync_hdr *shdr;
 	unsigned int pdu_length = server->pdu_size;
 	unsigned int buf_size;
+	unsigned int next_cmd;
 	struct mid_q_entry *mid_entry;
 	int next_is_large;
 	char *next_buffer = NULL;
@@ -4920,14 +4921,15 @@ receive_encrypted_standard(struct TCP_Se
 	next_is_large = server->large_buf;
 one_more:
 	shdr = (struct smb2_sync_hdr *)buf;
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
@@ -4951,8 +4953,8 @@ one_more:
 	else
 		ret = cifs_handle_standard(server, mid_entry);
 
-	if (ret == 0 && shdr->NextCommand) {
-		pdu_length -= le32_to_cpu(shdr->NextCommand);
+	if (ret == 0 && next_cmd) {
+		pdu_length -= next_cmd;
 		server->large_buf = next_is_large;
 		if (next_is_large)
 			server->bigbuf = buf = next_buffer;


