Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36D7275B18;
	Fri, 21 Nov 2025 13:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730963; cv=none; b=cR3RCJfNKtVy4XM6Wr5SJQ7Y5+aFH3rvr6PHOaLytPpPsEbY44mWMOWtz/cdEI8TDnIcrmWpZltbv42kHAGhlaUPTSpVcPw1hbiElCnodFI1916SUlJlyT/OuVV88HiCvDTYDBqkbRRJWq99lhpdS/B9I9W+RIzmThROEumwCrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730963; c=relaxed/simple;
	bh=a7dFFkwf6WadK1kgrG0wp0VE6xK4wTqIkHyMEMd5Z+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0qWopgvYAbQh4PSh4Mg2f7eQmaAHwZRXNGMl5h39a/NjReXjtvOOAKWebhuqJWJ5amyX2/4A82c2y0z40BKjbhTl2x0dWXQIGkMczaihMWvTs+7zrWOkJdZ1EMOdXK2kYgCUVQ2Id/+hKS5mjC2yp69cnjA52yO3OAKdns6RKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBtE4oGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBtE4oGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF37C4CEF1;
	Fri, 21 Nov 2025 13:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730962;
	bh=a7dFFkwf6WadK1kgrG0wp0VE6xK4wTqIkHyMEMd5Z+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBtE4oGN/IzYQAyhvNmiCBtwPoVRxnBx82bnap1AAuP4qFBLQjxe/uwU+eKt5Fh1G
	 JhD83F3zinybXUs/fvziwFWafZaGu2WmLauOaUIUKjQCQ6gfq8uwN0PF0eXWHzt+5I
	 TUdKYt2hDxkF9dcfXnJ9iMMkiBMGmxkqP6Jw7+oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 041/247] smb/server: fix possible refcount leak in smb2_sess_setup()
Date: Fri, 21 Nov 2025 14:09:48 +0100
Message-ID: <20251121130156.077774328@linuxfoundation.org>
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

[ Upstream commit 379510a815cb2e64eb0a379cb62295d6ade65df0 ]

Reference count of ksmbd_session will leak when session need reconnect.
Fix this by adding the missing ksmbd_user_session_put().

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
index 409b85af82e1c..acb06d7118571 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1805,6 +1805,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 		if (ksmbd_conn_need_reconnect(conn)) {
 			rc = -EFAULT;
+			ksmbd_user_session_put(sess);
 			sess = NULL;
 			goto out_err;
 		}
-- 
2.51.0



