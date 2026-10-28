Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210142;
	b=XHzQ+LdyM9z0hA+fo4WldGYQGAtL3od+7foMo2K5YfUf7HYKVOLo8YFOvkovpKmYkmvy
	 QsjfuBqwyzafgrfKuqhELAM5VoJ2AMj/MMEvt+xocdUbuty31Ag2kxbe1b35eATmMOtDB
	 0KhpaI4q5clfiNMVHPaNIwHRBLR5syrcm7aHnqPSTSR14ASpsMd5t1Yt8FsBsK6OzIHEK
	 K0dP/KpZQD9NFfREjfDxAPAMinGaahfCV8vL8mWfUrobt/hn/Y0nJzShjjqyw7X7XBMPW
	 wAEW/qx2StlY6NsdMOtMoWjfYT/k7G2EXVYZ0BkHxDF/WEkm6Xg5tQfL9BZq4gv07hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HIFjIz42B0rZfyyzfvpLfzH8mGEizYkPkrlJt08EIFQ=;
	b=JSskwIukwQ7R+EMDUD0D+uppEUEUkEt0ARQTzjc9EqBLaVB1OQzVoG2GZZOT8w6jdWwQ
	 T99F/aU0hBZ675BZwvl6ervHxXVrjf/d+gXExH2Qai57FR58bBskUVcekkEqeWMfbgbl0
	 zOfY9w2wm2DKSrxarMmeubStUDeSeC1zVHsW6CBqX2Wu8n5WNqRvc0FlXjPd8lKMXUkBK
	 MkzOeLD3chrmsOLKw97nVQp9fr9k4WANMMr7VG0r26HgcFm/tAkViyY4ZeyRcPAQOh/Tv
	 3CJkpKUwFMNmaoMnEnAtLW7b2rcTlygdD9RGjKnTSfvfUJWh1tdw8bQ8JRJa+YUJ6UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JEwQQSt4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12684606A31D;
	Wed, 28 Oct 2026 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JEwQQSt4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C141F01828;
	Wed, 28 Oct 2026 17:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210141;
	bh=HIFjIz42B0rZfyyzfvpLfzH8mGEizYkPkrlJt08EIFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JEwQQSt4PFshkNMmP316JLvGK460HFpJz81QRkQ5MMQL8Gj0LkHHCeQvVhJRKBqVf
	 /fMWQC/mWAOR9ZiCC0X1K1bqO+kXnG33+DeTsY9ZjFL+kcufCu6RFNnVUpwnfplbIb
	 u/ABoZ2BpiDIMBAs1tlBHm6kFYohOIwB6SRy/XTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 089/168] smb: client: fix heap overflow in cifs_do_set_acl()
Date: Wed, 28 Oct 2026 18:00:25 +0100
Message-ID: <20261028165945.196813555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3152,6 +3152,7 @@ int cifs_do_set_acl(const unsigned int x
 	int rc = 0;
 	int bytes_returned = 0;
 	__u16 params, byte_count, data_count, param_offset, offset;
+	size_t cifs_acl_size, bytes_available;
 
 	cifs_dbg(FYI, "In SetPosixACL (Unix) for path %s\n", fileName);
 setAclRetry:
@@ -3170,8 +3171,7 @@ setAclRetry:
 	}
 	params = 6 + name_len;
 	pSMB->MaxParameterCount = cpu_to_le16(2);
-	/* BB find max SMB size from sess */
-	pSMB->MaxDataCount = cpu_to_le16(1000);
+	pSMB->MaxDataCount = cpu_to_le16(min_t(unsigned int, CIFSMaxBufSize, USHRT_MAX));
 	pSMB->MaxSetupCount = 0;
 	pSMB->Reserved = 0;
 	pSMB->Flags = 0;
@@ -3183,6 +3183,15 @@ setAclRetry:
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
 


