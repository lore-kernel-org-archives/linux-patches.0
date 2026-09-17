Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677D43AFB01;
	Thu, 17 Sep 2026 17:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666562; cv=none; b=YBM07xI+53x3e8GgshQACyAzIdaNJVCZNNFiKnvDYrlyH9zJ36Z9bb6M4l2WslMvcaF1kd8AkBw+l2B4YY1RXagbT5ahvPjw8/eF6c/xhxY+sdpKueqbq8wQ0hjl/L8hFRXU52ZeqmRztQFv1+vN3JatHO8UiyQ07EeAGdEKFDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666562; c=relaxed/simple;
	bh=NQLc0SxH+sRJi0T9JzXfBJH1dY8voffzDfjDmaFF7sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpbxiKlkTgfJ6RSp/nChLu7vuEDcJ46nQxZ7LBWg7LFCBmCUofnV8vnskaWq/dGZY+91LV2qBig3tDh9TFWjvF5qdQNFwZpWB0FxkuDRigRcHld6KQpCgN+jG2ENtdVIor4jrOOxaFRwkr7tdgIdOnmaGMJGxoP1zk7w9uIxdjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbpHOMTK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbpHOMTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F5B1F000FF;
	Thu, 17 Sep 2026 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666560;
	bh=pi1ywKF59yIvGjtDsd7DS78Fk17X4mOkWcPWbOVjBJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbpHOMTKO9X3KLfn5NHsErx2HG/gUqWYIkZIy9AfvOgfKKFN1pPWhwxlG6YqkuVwQ
	 Aj7iwtZANTd/1fquqIm/GU38EIv6E+E3TQEjpRuCNgqqSnX/T729LM2aU635YUlAWl
	 QcSDxcmIbZTvan69bqPpAmbUTJmD1a8+zaylqa8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	Diego Oliva <diego@bynar.io>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 6.18 1079/1250] smb: client: reject short READ responses in CIFSSMBRead()
Date: Thu, 17 Sep 2026 16:14:34 +0100
Message-ID: <20260917151621.388589154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diego Oliva <diego@bynar.io>

commit e6142a8bfc230c7263eb8b0475249c958ce49367 upstream.

CIFSSMBRead() reads DataLengthHigh, DataLength and DataOffset out of
the READ_RSP returned by the server without first checking that a
whole READ_RSP was actually received. The length of the response is
recorded in rsp_iov.iov_len, but nothing constrains it to be at least
read_rsp_size before those fields are dereferenced.

A malicious or compromised SMB1 server can return a response shorter
than the READ_RSP header, so that parsing the header itself reads past
the end of the receive buffer. SMB1 is not negotiated by default;
reaching this code requires an explicit vers=1.0 mount.

Reject the response unless it is at least read_rsp_size bytes long.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org # 6.19.x
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1693,6 +1693,14 @@ CIFSSMBRead(const unsigned int xid, stru
 	pSMBr = (READ_RSP *)rsp_iov.iov_base;
 	if (rc) {
 		cifs_dbg(VFS, "Send error in read = %d\n", rc);
+	} else if (rsp_iov.iov_len < tcon->ses->server->vals->read_rsp_size) {
+		/* check that the received response can hold a whole READ_RSP */
+		cifs_dbg(FYI, "%s: server returned short header. got=%zu expected=%zu\n",
+			 __func__, rsp_iov.iov_len,
+			 tcon->ses->server->vals->read_rsp_size);
+		rc = smb_EIO2(smb_eio_trace_read_rsp_short,
+			      rsp_iov.iov_len, tcon->ses->server->vals->read_rsp_size);
+		*nbytes = 0;
 	} else {
 		int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
 		data_length = data_length << 16;


