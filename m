Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF3114C585;
	Tue, 20 Feb 2024 21:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463280; cv=none; b=VLe5cnbxERzXndRtQVYG88WtPuW5T+hFFFcJzw5cPTU3yvePA+ViXoczZHjjAUktWHc8aMAyV8OELl/f9TsnwG1KqLXBM1ir3SwmjPrWdbXa5bNWR6PckugTl65yQwNbCU2dabqBg7DObWM7C/mswORz3ihWs6XBJ31o8+XvPsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463280; c=relaxed/simple;
	bh=PVkZjKjxyhYP2ucsabGrFtaiWrDK/J6L7XG3pySUJDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awBgU7gPweZ0l0YxteVyeflpsk/lrZQoMe2biSerbBaxSlefxr/rUnGBTy535c2g2GeuHFZhJEfKQKVgx+LxWcPu+J01HF98XJ9GduLOjcnJjZ7ik/y//EbJHI1be83V8LOWiJ1KcbKQvCgn8lb8Tc1Tn7XuAuvQq3JUqCWcedg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSzfRqXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSzfRqXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39439C433F1;
	Tue, 20 Feb 2024 21:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463280;
	bh=PVkZjKjxyhYP2ucsabGrFtaiWrDK/J6L7XG3pySUJDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSzfRqXlhGe51ivFlVEai4ngXxrH1AAJ9bjf/CSnYmxi8Lmofohigre7PAqSmQg3k
	 MUgnLJ8SxtPicDQfouJS4tGOMQkx0Mc67xdmPaDKqRucFvZqExA2kMMJwDDpqiZmyy
	 6Sm+kt9Y4Ny6FFA6fe07gkELZAENMBzshcZmrepw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Guruswamy Basavaiah <guruswamy.basavaiah@broadcom.com>
Subject: [PATCH 6.1 192/197] smb: client: fix parsing of SMB3.1.1 POSIX create context
Date: Tue, 20 Feb 2024 21:52:31 +0100
Message-ID: <20240220204846.827230793@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 76025cc2285d9ede3d717fe4305d66f8be2d9346 upstream.

The data offset for the SMB3.1.1 POSIX create context will always be
8-byte aligned so having the check 'noff + nlen >= doff' in
smb2_parse_contexts() is wrong as it will lead to -EINVAL because noff
+ nlen == doff.

Fix the sanity check to correctly handle aligned create context data.

Fixes: af1689a9b770 ("smb: client: fix potential OOBs in smb2_parse_contexts()")
Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Guruswamy Basavaiah <guruswamy.basavaiah@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2184,7 +2184,7 @@ int smb2_parse_contexts(struct TCP_Serve
 
 		noff = le16_to_cpu(cc->NameOffset);
 		nlen = le16_to_cpu(cc->NameLength);
-		if (noff + nlen >= doff)
+		if (noff + nlen > doff)
 			return -EINVAL;
 
 		name = (char *)cc + noff;


