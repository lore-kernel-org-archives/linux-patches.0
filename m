Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C023EDE4E;
	Tue, 12 May 2026 17:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608693; cv=none; b=RDOO7HRR0loN/NpeQjY3wY1Lk5NIfVnS3cL5Kzvh7EdbTw9RcV3v6N6GQKzWtyCF9MHa9fbn1zCgI9T0Nm6gtSXlSSADcy4uy4xAl42botSrrp1ZteJTohWuRq93wdNqS2kMlteYAV/F3vnHdKV9wK0lYPhCspTSQoGmylJ5J6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608693; c=relaxed/simple;
	bh=IjKyAXcZ0SG/qh0kglMsJTGfAqqKYD/KkEs03AiVEQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEajuNZ1n5zTpzZHW4/GSeJ3aM3MhyPBYi47QoJnwveFaHi6wKHS39cj6xT4MIhZFBEAUfcB9VDIuSLd28QGmuYC4zmm+PWdpxR/zkouCUFuOEQfqNVw2qEwPWg+CA2K5m9ywn9tJxRcvXSaK1D65lOHewlF/7YyAlfkeX/HDiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWqaXUx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWqaXUx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25965C2BCC7;
	Tue, 12 May 2026 17:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608693;
	bh=IjKyAXcZ0SG/qh0kglMsJTGfAqqKYD/KkEs03AiVEQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWqaXUx/AnyitLmk4xYC7TxfBDj8CziDu5cXWyNqzPRGcTlwtvaIERanQCaehpRsd
	 pXRFwyoP3yagE51popEZJNGmkr+bbDGKf2ffYdQP372WNHjp958oSBOoLyzi6DlAdu
	 GTXttiVcxMznewMS6aLpRf0/i53NZhG4kfrgcSAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 179/270] smb: client: use kzalloc to zero-initialize security descriptor buffer
Date: Tue, 12 May 2026 19:39:40 +0200
Message-ID: <20260512173942.217359689@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Bjoern Doebel <doebel@amazon.de>

commit 5e489c6c47a2ac15edbaca153b9348e42c1eacab upstream.

Commit 62e7dd0a39c2d ("smb: common: change the data type of num_aces
to le16") split struct smb_acl's __le32 num_aces field into __le16
num_aces and __le16 reserved. The reserved field corresponds to Sbz2
in the MS-DTYP ACL wire format, which must be zero [1].

When building an ACL descriptor in build_sec_desc(), we are using a
kmalloc()'ed descriptor buffer and writing the fields explicitly using
le16() writes now. This never writes to the 2 byte reserved field,
leaving it as uninitialized heap data.

When the reserved field happens to contain non-zero slab garbage,
Samba rejects the security descriptor with "ndr_pull_security_descriptor
failed: Range Error", causing chmod to fail with EINVAL.

Change kmalloc() to kzalloc() to ensure the entire buffer is
zero-initialized.

Fixes: 62e7dd0a39c2d ("smb: common: change the data type of num_aces to le16")
Cc: stable@vger.kernel.org

Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Assisted-by: Kiro:claude-opus-4.6
[1] https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dtyp/20233ed8-a6c6-4097-aafa-dd545ed24428
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1685,7 +1685,7 @@ id_mode_to_cifs_acl(struct inode *inode,
 	 * descriptor parameters, and security descriptor itself
 	 */
 	nsecdesclen = max_t(u32, nsecdesclen, DEFAULT_SEC_DESC_LEN);
-	pnntsd = kmalloc(nsecdesclen, GFP_KERNEL);
+	pnntsd = kzalloc(nsecdesclen, GFP_KERNEL);
 	if (!pnntsd) {
 		kfree(pntsd);
 		cifs_put_tlink(tlink);


