Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6878E35CB6B;
	Mon,  9 Feb 2026 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647306; cv=none; b=UZVB4l0ysIFfk44FHXNMKvAT+fSWbweo1ECIySz66uzP8yaw7a3d6Ji/ZWw2eVQqdhgZ1FL4JT0RR8y/XWJJ/qEORfBTS2Po2COsJPHlcOvJUj1zNJanE919frtArNUsEYgXr1X/kBKUqy8FnM3C3ZJ9k27ysbR8jhBBr9c3qvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647306; c=relaxed/simple;
	bh=MeqTtlxnQBkEBSG5iyyl/nPG9FiGTY5L3cy32I/RssI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQWImdKXc8fnWH10FHjjdM9aHyW3x2CkSYm8Q6RHJe4x3X/jpC76ScHOeazRFhMCN0hZ4die/+c2++f6heHubOO3T27YytnVJT2zKDSqohHfTwm4JkXASf7lGP1Mi8nL4yFR8nD3aCFXAiKNcDOwu41lhbDRGfRP7hs1nxptjws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6Sfr7xE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6Sfr7xE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E801FC116C6;
	Mon,  9 Feb 2026 14:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647306;
	bh=MeqTtlxnQBkEBSG5iyyl/nPG9FiGTY5L3cy32I/RssI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6Sfr7xEv4FrrvQxt/Nd9sVecZmI7znwwAh+tS7GVee7EWM8I5xvG6rPuGeMTnB5y
	 0ddMxb/Jn8fURqw40BHxUIgaIR8egVzdnfhpihQOBiNSxxC3otfSCdZzn9LN4FUGZA
	 8CDJ/5OupCm5osUlTSxoWzCsL+p+9f9bXj/bELUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 061/175] smb/server: fix refcount leak in parse_durable_handle_context()
Date: Mon,  9 Feb 2026 15:22:14 +0100
Message-ID: <20260209142322.656688103@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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
index 244a5665f26df..470b274f4cc98 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2822,6 +2822,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 					    SMB2_CLIENT_GUID_SIZE)) {
 					if (!(req->hdr.Flags & SMB2_FLAGS_REPLAY_OPERATION)) {
 						err = -ENOEXEC;
+						ksmbd_put_durable_fd(dh_info->fp);
 						goto out;
 					}
 
-- 
2.51.0



