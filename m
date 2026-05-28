Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BB93368B5;
	Thu, 28 May 2026 20:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000527; cv=none; b=sJWKxBlQ06hcM/OjjEvOFQ46+KgkFjooquURs26Q/FM5bn+sbzCz4zz6FrEq71t0Mmn2a1GMH8eMOU53xJ5VdEps7Txs5O7yzK9Ok2h1cD1/5cv/yjL0RMADBPbPHR3qFDpLa/ikV3TdN5ciVqqYbN7rjo1fv4KcdRntE7Rc+bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000527; c=relaxed/simple;
	bh=FAg3RgOvKm8isZRhgI8Ac5xFCO9OaUI036uLentQC6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAcnfMhnS+qRwWp/yOr0DFyPL9WGjWdbwEbaVdAEYqxg2ur1cQPs9tLpSAHvFuQGlzvAX9EJds01tOAILj23s4lO70iPuuzeef9anGQPXP723LGZmru3s5cY+BcWC2NkgLNLrS2WeXQrQLaAb85jJ9jLI5bs5KoWJaqtXFLez90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSmSHora; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSmSHora"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2381F000E9;
	Thu, 28 May 2026 20:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000526;
	bh=WRnt2BtcMIqPSNj62HfSgjePJneXPLqM3g27suBZBq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSmSHorawXnUNTXNRXcx9+whTFrOmrXbr0yocov1B+QV3cWmx83JTs93mYaIche5n
	 QM/XstzJCzkEKic4X5TMSQQL2KRfDMzFPSU/ZYVgy9aN4rHnZ1WbHv8OKLdCy49Tzf
	 7a5A2lCdyfa505QIuWIjlcQoXX1e+FiPKtMavtzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Erazo <mendozayt13@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 049/272] smb: client: use data_len for SMB2 READ encrypted folioq copy
Date: Thu, 28 May 2026 21:47:03 +0200
Message-ID: <20260528194630.755607386@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Erazo <mendozayt13@gmail.com>

commit d4d76c9ee1997cc8c977a63f6c43551c253c1066 upstream.

In handle_read_data() the encrypted/folioq branch
(buf_len <= data_offset, reached via receive_encrypted_read for
transform PDUs > CIFSMaxBufSize + MAX_HEADER_SIZE) copies the READ
payload using buffer_len rather than data_len:

	rdata->result = cifs_copy_folioq_to_iter(buffer, buffer_len,
						 cur_off,
						 &rdata->subreq.io_iter);
	...
	rdata->got_bytes = buffer_len;

buffer_len comes from the SMB3 transform header OriginalMessageSize
field (OriginalMessageSize - read_rsp_size); it represents the size
of the decrypted message after the SMB2 header.  data_len comes from
the SMB2 READ response DataLength field; it represents the actual
READ payload size and may be smaller than buffer_len when the
decrypted message contains padding or other trailing bytes after the
READ payload.  The existing check `data_len > buffer_len - pad_len`
only enforces an upper bound, so a server that emits
OriginalMessageSize larger than read_rsp_size + pad_len + data_len
passes the check and the kernel copies buffer_len bytes per response,
ignoring the server-asserted DataLength.

Two observable failures with a crafted server (DataLength=4,
buffer_len=20000):

  - the kernel returns 20000 bytes per sub-request to userspace and
    sets got_bytes = buffer_len, even though the response claimed
    only 4 bytes of payload;

  - on a partial netfs sub-request whose iterator is sized to
    data_len, the over-large copy_folio_to_iter() short-reads,
    cifs_copy_folioq_to_iter() returns -EIO via the n != len path,
    and the entire netfs read collapses to -EIO even though the
    leading sub-requests succeeded.

Use data_len for the copy length and for got_bytes so the kernel
honours the server-asserted READ payload size.  For well-formed
servers (where buffer_len == pad_len + data_len) the change is
behaviour-equivalent.

Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Erazo <mendozayt13@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4781,7 +4781,7 @@ handle_read_data(struct TCP_Server_Info
 		}
 
 		/* Copy the data to the output I/O iterator. */
-		rdata->result = cifs_copy_folioq_to_iter(buffer, buffer_len,
+		rdata->result = cifs_copy_folioq_to_iter(buffer, data_len,
 							 cur_off, &rdata->subreq.io_iter);
 		if (rdata->result != 0) {
 			if (is_offloaded)
@@ -4790,7 +4790,7 @@ handle_read_data(struct TCP_Server_Info
 				dequeue_mid(mid, rdata->result);
 			return 0;
 		}
-		rdata->got_bytes = buffer_len;
+		rdata->got_bytes = data_len;
 
 	} else if (buf_len >= data_offset + data_len) {
 		/* read response payload is in buf */


