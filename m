Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C25E27FB05;
	Mon,  9 Feb 2026 14:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648411; cv=none; b=KDyIDXpqGrUz7jLvJQvAOJhDNj6ZYxJxaViIb97UAPfeFWawCOKwNKx+rwrJlDlJBZuQtvtj5zBZ9md+ejB/r0Xn16XfdLX0ToXRqCgmBdaTr4vI9JkSF6uSDj6HD8neLedzmRV31KwOri2dmoIMN6gJdCa7Tn+tsBuhWMIhYFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648411; c=relaxed/simple;
	bh=HVD4MqOtMS54ssgubUJ4AJW5O58MR28I15SORJ2kk3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miU946B8zghP07WpMogR+Y0jyeLXsaNZfuHXiIG4t276qGUZ9PmMJo6gu6Dh7nqwSlxExBk7+AL8IQKfxQ/cNm57qE1KdZZWyztC7RRizE4Y75wyKNDno+CEBDxEUAc7xkKBv65d8fCPA2vup8Dk6eQXXH2+BpMgfGeJucsqfe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uz7gJk5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uz7gJk5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0905C116C6;
	Mon,  9 Feb 2026 14:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648411;
	bh=HVD4MqOtMS54ssgubUJ4AJW5O58MR28I15SORJ2kk3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uz7gJk5LlnSSqoPZFNd8nde2j3EgVEaMJyCmdISweyPAqncccZa3f9fIqUzOs43wY
	 4vt5HPkx3uZlQ1dgWJVg3GMNXJ3KMpRaRvQy3byTW06CH7kBCkxreSM9I+KAFTRLuC
	 GLQtQoCUg2/gWYJ9ZCIduyvXY5lqVAgmYAlkWifs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 30/86] smb/server: fix refcount leak in parse_durable_handle_context()
Date: Mon,  9 Feb 2026 15:23:53 +0100
Message-ID: <20260209142305.868536600@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 3296c3012a9d9a27e81e34910384e55a6ff3cff0 ]

When the command is a replay operation and -ENOEXEC is returned,
the refcount of ksmbd_file must be released.

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5cbe84938a729..da4d914c87ad2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2805,6 +2805,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 					    SMB2_CLIENT_GUID_SIZE)) {
 					if (!(req->hdr.Flags & SMB2_FLAGS_REPLAY_OPERATION)) {
 						err = -ENOEXEC;
+						ksmbd_put_durable_fd(dh_info->fp);
 						goto out;
 					}
 
-- 
2.51.0



