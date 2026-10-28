Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207776;
	b=x7+FvFMt8Rua5zG69hvEXbnMS3OPnhID0FWUYyQPzSLjoa6vPnn0SChzUkB7Paz5qmY7
	 yn68+IgcrfTEfQuGl5xzzP7SJzbbxmwuPHpf2LJHoNY/5aGLRV7d4GWGa20iCjBMuCDF9
	 uQ9yaDJKfhcSGQ8+x3qTedJzZV04wgZ3NOYZWZJXEBY+Wug0hQD/vxXzh9mC6QZ4yQYWU
	 rMzNTKZJEUSvCRlPYQxK5p+UywrmZ6Caa/oPFPmLHo4YjhpjUpeizTkbZjUkR4PfwVLfi
	 1acqbl0ZXxVOklFBX4aT9GtTF5s3vU1932D1QVuKqKr4OBIMMes3FX0tp9hzUIsDmXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h2L/iqoGqcqycG+uQ+j7fwTDQPRuhsXCNyKP0mjFmMI=;
	b=XTHJZ9HuRXyDpYu3MCQG0RNYst9UOTQf3DhGuNLo591Sgr97w9YtMi2BWSV8PG6sryd/
	 kxQ4y8S6foFwdSiaxZaHr9vWc11Qqgmb7KhdgJXckejBSxUQygkBi3seBu62WoB+FrO1w
	 T3NodlZsHBnX+iRo8zG/l2SqhGFh/4k5Cs1lubfUcC7aEkZhvfIX+XXu/Ac7LPlWhJLB8
	 dkNs0oQEdiv5rGvtyYmhHCL7lywk2SQOgHDSZTwipY4VWQxyGaIEWRJchbVRx3o1aRjL+
	 2QXR35/wgZbMsY+XJ0j9q1kfvnyxAhiSj/i2hptuhkWKx10ZaCx3NcQeVuYxLA8q9Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VnCGtFlW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98A9606A31D;
	Wed, 28 Oct 2026 17:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VnCGtFlW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0477F1F01825;
	Wed, 28 Oct 2026 17:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207775;
	bh=h2L/iqoGqcqycG+uQ+j7fwTDQPRuhsXCNyKP0mjFmMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnCGtFlWheROLc3mkcc0IWEA06mEWvPM7QIMTRm7x2Ivw4j+RdB3R55QHW15WHz1s
	 v/Xol8KQFgU1dXlwa373GgWqqLg8lNm3v7COnHUo5jCfILYZwKDvMz37B3f0fDnvx8
	 KdHD3QzB/Xn4bsC3M7XYXvM0C7xnOdoMH4ptFeXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 128/247] smb: client: fix heap overflow in cifs_do_set_acl()
Date: Wed, 28 Oct 2026 17:58:51 +0100
Message-ID: <20261028165950.435140810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 1dac61e2c29d1a71784604b48cf3b1234a65ec29 upstream.

cifs_set_acl() validates ACL size using posix_acl_xattr_size():

        4 + (count * 8)  // 4-byte header + 8 bytes per ACE

cifs_do_set_acl() then calls posix_acl_to_cifs() to write the CIFS
wire format into the same buffer:

        6 + (count * 10)  // 6-byte header + 10 bytes per ACE

An ACL that passes the xattr-based check in cifs_set_acl() can
overflow the heap when posix_acl_to_cifs() writes the larger CIFS
format.

Validate the CIFS format size against the remaining buffer space and
USHRT_MAX before converting--data_count is __u16, so sizes above
USHRT_MAX truncate the on-wire packet length, causing the server to
apply a partial ACL.  Replace MaxDataCount = 1000 with
min(CIFSMaxBufSize, USHRT_MAX).

Fixes: dc1af4c4b4721 ("cifs: implement set acl method")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3188,6 +3188,7 @@ int cifs_do_set_acl(const unsigned int x
 	int rc = 0;
 	int bytes_returned = 0;
 	__u16 params, byte_count, data_count, param_offset, offset;
+	size_t cifs_acl_size, bytes_available;
 
 	cifs_dbg(FYI, "In SetPosixACL (Unix) for path %s\n", fileName);
 setAclRetry:
@@ -3206,8 +3207,7 @@ setAclRetry:
 	}
 	params = 6 + name_len;
 	pSMB->MaxParameterCount = cpu_to_le16(2);
-	/* BB find max SMB size from sess */
-	pSMB->MaxDataCount = cpu_to_le16(1000);
+	pSMB->MaxDataCount = cpu_to_le16(min_t(unsigned int, CIFSMaxBufSize, USHRT_MAX));
 	pSMB->MaxSetupCount = 0;
 	pSMB->Reserved = 0;
 	pSMB->Flags = 0;
@@ -3219,6 +3219,15 @@ setAclRetry:
 	parm_data = ((char *)pSMB) + sizeof(pSMB->hdr.smb_buf_length) + offset;
 	pSMB->ParameterOffset = cpu_to_le16(param_offset);
 
+	/* make sure we can fit the larger cifs_posix_aces in the buffer */
+	cifs_acl_size = sizeof(struct cifs_posix_acl) +
+		       (acl->a_count * sizeof(struct cifs_posix_ace));
+	bytes_available = (CIFSMaxBufSize + MAX_HEADER_SIZE(tcon->ses->server)) - offset;
+	if (cifs_acl_size > bytes_available || cifs_acl_size > USHRT_MAX) {
+		rc = -E2BIG;
+		goto setACLerrorExit;
+	}
+
 	/* convert to on the wire format for POSIX ACL */
 	data_count = posix_acl_to_cifs(parm_data, acl, acl_type);
 


