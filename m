Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054269;
	b=eHnFNB2cB2JOfBNnebJDhfx4iwsQwmJb1xC4/u973Hy8d/Qw/OoGwatAvqr8YKmcpRRd
	 uqwEK/4RJw4FFOSg+Sx/ZlfT1xQj0Sy6m4R9Cw7FTzTIsMOUHq00VCeYoh9e4LkN3jI3V
	 mB36p/adQUks40/a1+n8A4f19FbsClETjnEr0W5jN2qyiBQcdyJs8nukylWABldMxRDv5
	 p9FYy+pMzMN3xb9BxQGYPDJHPPCViG4cegNtnhpIrzE2Y+4JCjXr0C8ojqjRl3ovIAx/g
	 EODMYD4ln4JYaSpv2LDzWcQihDidee6VPtFCxTjYcMoX5LnC0p5YuOhG6HYgl9IkGAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ise3hdIQMN0y+dNV+EhpsIK7n1KFb6nsPaUEzPr5h8=;
	b=DKdtNxW1E0HhJ1agFeyvBHUmlFxkIU1iHmkF5s2b4TMc3YrnGDbfvDLFuhEzlKxVShMX
	 b7TwUVtyAVglFarIU0c0OkjLPpY0SUeMMXvEKC317d57ZCETXyyhnPTi7wnWedZXsmVbp
	 47w4Zky+Es7C894ai0GKnSkUwdFd0h0jSAMYaMHl+DCDMsqK9erx5COFZNV/XGt0Ra1f/
	 lXrMWR5JbYe2jBcbwkJ5Dv4fnO7Ytcf6yljP5cgRyP5XRluulutWs6i6geRjZB7IfzzVR
	 yE0wCy/a8YD6c1yXxRWlYcQ5NXWUPhUQdmiTQlnCSNpuHjY5Ybnghxc0qkNQUJm2eig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qFdLXayZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA75606A325;
	Thu, 19 Nov 2026 02:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qFdLXayZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1C41F000C4;
	Thu, 19 Nov 2026 02:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054269;
	bh=3ise3hdIQMN0y+dNV+EhpsIK7n1KFb6nsPaUEzPr5h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFdLXayZ01ez+YqHlzrLEsBTvOi8mIC2lic+hcwgx9uPoCCnMegiqqqZS1yGzeSFY
	 3Z6HmzipKCuccosexFlEp8RIPG+KhhI6yFLrCmid5mQL0Z49LCQf9XsfDi5rBmbNo7
	 BixedKS/LHFSA8UM5XhRhP5FxDdS8oPdgoTCiE64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1216/2214] ksmbd: enforce the read-only share flag when creating a stream
Date: Wed, 18 Nov 2026 15:48:12 +0100
Message-ID: <20261118150100.434991733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 09139429fab3a5114c18d7c15fb161511d4d66c9 ]

When a share is read-only, smb2_open() rejects opens that would create
or truncate a file. Creating a named stream on an existing file with
streams_xattr sets neither O_CREAT nor O_TRUNC, so it passes this check,
and smb2_set_stream_name_xattr() then creates the stream. On a Time
Machine share, opening a missing AFP_AfpInfo stream also writes one. A
user who can write a file at the filesystem level can therefore add
streams to it through a read-only share.

Do not create a stream or synthesize AFP_AfpInfo when the share is not
writable. Existing streams still open normally, and a missing stream
opened with FILE_OPEN still returns STATUS_OBJECT_NAME_NOT_FOUND.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: eaff8e924f60 ("ksmbd: synthesize empty AFP_AfpInfo xattr on first probe")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: omitted the AFP_AfpInfo synthesis guard because that synthesis branch is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 74a0c3b68633f..da69dd9488f2e 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2538,6 +2538,9 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 		return -EBADF;
 	}
 
+	if (!test_tree_conn_flag(fp->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE))
+		return -EACCES;
+
 	rc = ksmbd_vfs_setxattr(user_ns, path, xattr_stream_name, NULL, 0, 0, false);
 	if (rc < 0)
 		pr_err("Failed to store XATTR stream name :%d\n", rc);
-- 
2.53.0



