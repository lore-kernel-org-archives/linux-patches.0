Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B0431158A;
	Fri, 21 Nov 2025 13:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730959; cv=none; b=naRQ1rSLuO1P3IEqtZJxaKVZi95FnZF+6dCAj4CcZXyteu8Jyvwax0wZXnjMjLICYhVsqjjVRk+LIUqV7Jsqnhrgua3fTioAlNefSwpplcgPHM8NLfwI7kGHnYLBZGivsKhu+9KmpFdzNM1xmu3dMm3x6tC4bsg8RenqlQGMlA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730959; c=relaxed/simple;
	bh=e5+rlLO5w7v9DczBgtEKXHN+Uy/VKAayNH/IdAuEG3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKof0GKzK+trX8jW2Ux0c/CaMQHUhQSEpX7zZJ9U2rzFeFP9Zyyk3Lzx1N6b4S+6y1MEm8IZsHdD2f1I/PJVEfDc4fAuPsesASrYxatizim8I+9zhTEZaiJkZikmKpSCQvh6tgb5i1bhXoQY3et2c8X7zRygwlOF6Qwy4FMwAA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0flM0XE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0flM0XE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB38C4CEF1;
	Fri, 21 Nov 2025 13:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730959;
	bh=e5+rlLO5w7v9DczBgtEKXHN+Uy/VKAayNH/IdAuEG3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0flM0XEsXO2uk0Vx+Cj87DIq9jpU7DnADV7szfNSIMRPTReVIxXNDVWrC9z4Gk6C
	 jqaomMpasj5uppGncnTlASw9u8Aae3J3Aph+oaq/FQ0RQElRqO1uWM1Sc1k6+MvGOS
	 z5+r6gO3Nq0XVSyEpxoEtnZ/FuJ56K4aiSEYuP/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 040/247] smb/server: fix possible memory leak in smb2_read()
Date: Fri, 21 Nov 2025 14:09:47 +0100
Message-ID: <20251121130156.042281655@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 6fced056d2cc8d01b326e6fcfabaacb9850b71a4 ]

Memory leak occurs when ksmbd_vfs_read() fails.
Fix this by adding the missing kvfree().

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 287200d7c0764..409b85af82e1c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6826,6 +6826,7 @@ int smb2_read(struct ksmbd_work *work)
 
 	nbytes = ksmbd_vfs_read(work, fp, length, &offset, aux_payload_buf);
 	if (nbytes < 0) {
+		kvfree(aux_payload_buf);
 		err = nbytes;
 		goto out;
 	}
-- 
2.51.0



