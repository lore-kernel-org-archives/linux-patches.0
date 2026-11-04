Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830923;
	b=xxV0lkiOf/cZJTXG9/oZexd/y+uSjthYXJ1Rer598dLH5ORImOmVCCfdk+jZ4oQeUvoc
	 J1F8KRQeE2bxNPoZIcBdb6SFndpUoHw5Rlj20crSNe/ZMBp42csMHiRYNMfkRdOa1vXM5
	 oYg9Lg+RwoAye5601O3AZlnQTZquoK+T9/k016/5XHph1SGxCHuejyOlKCtyDWSaYxTLj
	 i0YAPewjAPfIOhWnn5ONIdNIjiJnEBYNEGkR/hGHPUSAKiYxFoGvyUoQhDzhT0gyyKOx3
	 Jm62qKrkyfBq58jy8xxHjlk5/NnY/QWDOC+fpCKjEZ73IRYNdmbpN701bYA1W5LlHzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CDPUlNQXWoLIlWNonOV3Yf/sf0puoHIzFH1e9k3Hunc=;
	b=N85s3bTt8eRiFvaQAjneevAq8KC1FDQivg8QcffxJtmgb923ghghvQ5Qh3RiViOfB/T2
	 SamQ36yEva79QXAXhfDUxEK3+7langkGunq4VWsmMMtUSMvt14oKeTS5GZywTlU90GQbT
	 uHAJf0HBKal+eKerVc7UYquvx68E8Zn949PSgLFpZBPnB121d2EqPon2VTHArwzwUN0ML
	 +bhpe6wGn1GpJ5P8rh+5p1P2x2gafHQR1qiSnwd2EmaEV6mllYLEgj3rG3PugmdkHHCl3
	 RMYvHiJLaBwM53cGH3Hx1T7hMYw1sxO52BAVKMztZMsLguFgSA+yl9yFKYltaJKGH5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wyMZ3FRQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EDF606A33B;
	Wed,  4 Nov 2026 22:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wyMZ3FRQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BE11F00A16;
	Wed,  4 Nov 2026 22:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830922;
	bh=CDPUlNQXWoLIlWNonOV3Yf/sf0puoHIzFH1e9k3Hunc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyMZ3FRQYvjP3YB9rExu5h127tQOy51AXVdh6pK2647U1nHAhk03c61rADSP+uhV8
	 tVQWrDCFucLtKXyctVaisCE77mzDJF59DzNwJiCh72kejlQAYKRDgqyaqxZntBxXBV
	 tOoIBz5FCLZgfGjGKptnZBTemv8v8yii6MulVz6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0404/1005] ksmbd: preserve access denied status for copychunk
Date: Wed,  4 Nov 2026 16:02:17 -0500
Message-ID: <20261104211055.395598843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f7c0366e0a80bf8cd5eacc5479927abb50958b5e ]

The copychunk error mapping handles -EACCES in an independent if
statement. The following error chain therefore reaches its final else
clause and overwrites STATUS_ACCESS_DENIED with
STATUS_UNEXPECTED_IO_ERROR.

Join the -EACCES check to the remaining error chain so an access failure
is returned as STATUS_ACCESS_DENIED.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7909d1ce67937..8d078d0abbe14 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8073,7 +8073,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 	if (ret < 0) {
 		if (ret == -EACCES)
 			rsp->hdr.Status = STATUS_ACCESS_DENIED;
-		if (ret == -EAGAIN)
+		else if (ret == -EAGAIN)
 			rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
 		else if (ret == -EBADF)
 			rsp->hdr.Status = STATUS_INVALID_HANDLE;
-- 
2.53.0



