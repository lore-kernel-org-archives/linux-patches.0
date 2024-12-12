Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848C613792B;
	Thu, 12 Dec 2024 15:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017103; cv=none; b=QVdCea+nL4lfvuNZIwgF0bmjIOuhXx7t4AISETH+uHqF9dJF+MUXSPX/70IRDKbjqFAncTqRy2DooZkHZMStEnQEvDId1ljJxwAf1hkQ/e9T4trtMxmDRvKSNv3osEP8u1NNRDs7lu2rNnJMVleSIRnBJBPUAmBryr2C2GrbG/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017103; c=relaxed/simple;
	bh=m4m3EPgE1YVS7dBpLSo/pLsvuOGHt97UzbqshcFedKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZiLZrRWD1NM/nb0PKjeQyRL1ZRsaE0uQBqR5DQ6xl31Iu19xek1OWa+U0W4ITBJcjGCOvNXFfifsUDREHKgc8CULgVKvcLaSJiCjPprHN/oHCOUv0SZUvKL7AQ6D967er1CGL4otVLOI5uyd+UuGjlFSUHxX6RK/cF7V2yDfVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ev72Gob7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ev72Gob7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DAFC4CECE;
	Thu, 12 Dec 2024 15:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017103;
	bh=m4m3EPgE1YVS7dBpLSo/pLsvuOGHt97UzbqshcFedKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ev72Gob75RV2VumLs5U420pgmgq1po+2p/C2GsoVsm7rCCFjpQMREvAQwp+aqOS55
	 ECbvwpeHBUmGsI26AmeO7NubMJYNUfXMLCTTPRyoESaOCNx1trNnaY1j5Tr1/Cpbd+
	 aeHdPtlCy6Egxjdw+FxKwMF8PaAIs0uT61MutgXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 383/466] smb: client: memcpy() with surrounding object base address
Date: Thu, 12 Dec 2024 15:59:12 +0100
Message-ID: <20241212144321.904994069@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit f69b0187f8745a7a9584f6b13f5e792594b88b2e ]

Like commit f1f047bd7ce0 ("smb: client: Fix -Wstringop-overflow issues"),
adjust the memcpy() destination address to be based off the surrounding
object rather than based off the 4-byte "Protocol" member. This avoids a
build-time warning when compiling under CONFIG_FORTIFY_SOURCE with GCC 15:

In function 'fortify_memcpy_chk',
    inlined from 'CIFSSMBSetPathInfo' at ../fs/smb/client/cifssmb.c:5358:2:
../include/linux/fortify-string.h:571:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  571 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index c6f15dbe860a4..0eae60731c20c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5406,7 +5406,7 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	param_offset = offsetof(struct smb_com_transaction2_spi_req,
 				InformationLevel) - 4;
 	offset = param_offset + params;
-	data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
+	data_offset = (char *)pSMB + offsetof(typeof(*pSMB), hdr.Protocol) + offset;
 	pSMB->ParameterOffset = cpu_to_le16(param_offset);
 	pSMB->DataOffset = cpu_to_le16(offset);
 	pSMB->SetupCount = 1;
-- 
2.43.0



