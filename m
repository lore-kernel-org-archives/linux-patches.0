Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753CF4E80CA;
	Fri,  9 Oct 2026 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557462; cv=none; b=oWeo7U76iEOTpiYcwCvmLYbR1fkp8FjM/R+jMYQNVVrUpVwanF9pSp4ySZaL9I2r+BCTP41bx1Z0XuKVrbonqcMJrnD+tcDgMow3CtXqjcbIahtmQf9VTFrtns+G4jtJRZ0qSA8DzvR/5/Y9U67TCUlorfGe4pc/zLgSWm6WHOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557462; c=relaxed/simple;
	bh=M3AeYm+hQHtWv/2iHYSWssZqaAZvHYYbKdMmhrihI0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHZf0dqNeBvBhCJIiyf5QWt6qSdI3VIIKsp1nROvt68XF/3Lk96vHSZmRXlcJXpUlvaSd8IVvYj/Uc3/KAVVOuxsOuY4AbTzjnwyezUAPJ3N8rUVeT/UbnuecXa0qC5Ge7IwJrm+/n9ij0fgTmbQ9UaZgi2xp3c66Yq0MtMR1ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUXGl1cv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUXGl1cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49EE1F000FF;
	Fri,  9 Oct 2026 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557461;
	bh=xHsrv2noYBuLXDUreiW7pdEmgrZ8TQJZP7T7AARfqQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MUXGl1cveNW2LiT7eRJbuR8JQZCMlonSt76d4O6S47tlDeSKrHIeOTycAiKp5zGvH
	 8R0o321UxIqDxvFJq/btNLNoFlWckhaMOE4EbNfPTdBGlzjWzXPN79rmskdydA0zEO
	 /nNLCuTItZ20omM8BwtY0VcyRUNn7g5GEYr6zNbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 368/428] smb: client: require stable pages for signed connections
Date: Fri,  9 Oct 2026 16:11:45 +0200
Message-ID: <20261009140954.264112693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 53c5c2c1095eb21e214811fec16cd75f89d72ee2 upstream.

When signing, cifs computes the SMB signature over the pagecache folios
in place and then hands those same folios to the socket.  If a buffered
write mutates a folio while a write subrequest is still in flight, the
signature no longer matches the data that follows it, the server rejects
the write with STATUS_ACCESS_DENIED (-EACCES), and the error is latched
in the mapping, so the next fsync()/fallocate() returns -EIO.

Mark the mapping for stable writes so netfs_perform_write() waits for
writeback to complete before modifying an in-flight folio.  This is
only needed when the connection is signed.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -88,6 +88,8 @@ static void cifs_set_ops(struct inode *i
 		else
 			inode->i_data.a_ops = &cifs_addr_ops;
 		mapping_set_large_folios(inode->i_mapping);
+		if (tcon->ses->server->sign)
+			mapping_set_stable_writes(inode->i_mapping);
 		break;
 	case S_IFDIR:
 		if (IS_AUTOMOUNT(inode)) {


