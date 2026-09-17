Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D953B3A48E3;
	Thu, 17 Sep 2026 15:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660646; cv=none; b=jps+Tzh8pvIl7D4ao6xmLjaFbcltR2MD+1SFW/asykRiRJqKJXdM9SMgQSalOrEiPXxZRsk3VMqz8/puM48ILLUM0QbJWLBXLJ1GtaN1HRNZ2gOr/k8XYj8jiYlYhqiPOu78Iv3r99FcEJpY0MhbDp6L8S6514Tc00NTj1pmlzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660646; c=relaxed/simple;
	bh=v5Bl0h5HJkOksfCSN/4N8mmkVLzxL4oOUbW+N3wcaAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYsemymIuCHAjGJmTPaf/QmJNWT4wnb3dpb+9NMSwvrvlquwcm/PXmdwgDjlN3/cxUxJkuNgDfkRtTQzsD2QGLZRWnNO0rBOFyIQAbeL1qOgdW/F1J+XWylSkCcJLoEOCJdOJOvcVWuY+QnQUd1AfaO4LB8EIWxMc6vszeYP7jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJ9gPznn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJ9gPznn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FDB1F000FF;
	Thu, 17 Sep 2026 15:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660644;
	bh=exfv/a7DGCuSzJbSpdOLHikI2rUOV73kUIsOGay9nGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJ9gPznniWM51OvX9k053TE7t4xUcGWUVuYVmBRShMaTjRSNuM78/yNuF1gTY07Yw
	 N1BQQGlQ7ez87f/P78nhOlwqmfX3L3h2nSf+/ogHEeA7RLa8ikaFo6wzXSttadEVB4
	 sTKeGidVmviZY9slNCVJK8f3pQPvTFawQgA+kDEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	Diego Oliva <diego@bynar.io>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 7.2 624/733] smb: client: reject short READ responses in CIFSSMBRead()
Date: Thu, 17 Sep 2026 16:15:32 +0100
Message-ID: <20260917151408.093701561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
@@ -1719,6 +1719,14 @@ CIFSSMBRead(const unsigned int xid, stru
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


