Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0420F145351;
	Tue, 27 Feb 2024 14:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044054; cv=none; b=rsoYxlac9o3VLRDaveKv9mYfpd7GEr0QwdA560mU2c4ij/azRwtMiL7hvDtL69SkvY2ABjdVijqa181QKNvsRfqxA+276yIIOX3irwxUqWapPoCYg1FBe9qo3Mj3sakuBZP2meX9DTlX/b99rl43G628/ywaCVl5/h1UxpNpbWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044054; c=relaxed/simple;
	bh=assZ9TZioukfYaYFrlaf95Vb+HUKhNFX7nfvZBJabXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpfahcZhxbyuPZ0uGGEGzg3Q6c1FYYxLKUB/wDaJbYn7WDIhIqP9PPFqoNIS2CVUxlZd+zGVmMpr3KYvfu/U0nTKcjDvovgHu+TLZY/dNfP9gGb2Cb8HsXQ5lcNVjoYOU/7itHCtFlL7zEt/AS4hV17ckBltTEBQSEO5cGEJ+/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFvJTXtm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFvJTXtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03230C43601;
	Tue, 27 Feb 2024 14:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044053;
	bh=assZ9TZioukfYaYFrlaf95Vb+HUKhNFX7nfvZBJabXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFvJTXtmFdj15HuMlPh/kudEMCv30DC6FryWYMXzG+QxqaU42VjK4lFkyiK5NvQwx
	 RYJthOk54pY1SKXUbzTta0vzvuuxhByKq8sgZbFlfyPwkGZp/fBD3T3EBUXKS5Lhtp
	 GAOAy7DLMQW7llpAbfYmumC+/ToJ1JznJo4qOJpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Guruswamy Basavaiah <guruswamy.basavaiah@broadcom.com>
Subject: [PATCH 5.10 006/122] smb: client: fix parsing of SMB3.1.1 POSIX create context
Date: Tue, 27 Feb 2024 14:26:07 +0100
Message-ID: <20240227131558.911439966@linuxfoundation.org>
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

[ Upstream commit 76025cc2285d9ede3d717fe4305d66f8be2d9346 ]

The data offset for the SMB3.1.1 POSIX create context will always be
8-byte aligned so having the check 'noff + nlen >= doff' in
smb2_parse_contexts() is wrong as it will lead to -EINVAL because noff
+ nlen == doff.

Fix the sanity check to correctly handle aligned create context data.

Fixes: af1689a9b770 ("smb: client: fix potential OOBs in smb2_parse_contexts()")
Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[Guru:smb2_parse_contexts()  is present in file smb2ops.c,
smb2ops.c file location is changed, modified patch accordingly.]
Signed-off-by: Guruswamy Basavaiah <guruswamy.basavaiah@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2030,7 +2030,7 @@ int smb2_parse_contexts(struct TCP_Serve
 
 		noff = le16_to_cpu(cc->NameOffset);
 		nlen = le16_to_cpu(cc->NameLength);
-		if (noff + nlen >= doff)
+		if (noff + nlen > doff)
 			return -EINVAL;
 
 		name = (char *)cc + noff;


