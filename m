Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021878;
	b=dqNcxha77Fm3nWLsu4vVY85JBAsavRIoEJhb7zmP6L/DJIdjydV9xrR0FvY9IkSuaUGn
	 7C9HKSYGWjKKWBibvg3/AxHxDeFvrn/kFP7tgT/aCWAletQIPax+ezr7TfLqfY2MJewF5
	 hnr9apL3iGiGHC4l3pZTtpYwN/XHLZdU6iT/CVc8d0Yz+6ZEYhzg33lHdwiy8g+WwXS3w
	 bRT+oUlxJn2q7d5mQUUHmXDbQO47e/vwupFWXP5o4ndFZ513zrPa1gKyIowykZ2hpW0S8
	 GPrHdrWliBMLqeDVPqGqw1XSL5PlRO6SC2fGV/kTwisabHX78AnKK3VMgvnn2B2sL7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x141RWEQ09s48AY0yzJIfsYzJ49+VzOeCUfJLY0hArg=;
	b=Ux1LFlxXyOEANcZWDlJ0LH4jEXs2xI6YGGqmNoQYGefMlPKR731VbLr6OwxIZ9WhwroT
	 qITNho0dIefGWLgQj4lZ63Zz/8uQBxUJKYauGmcFy+krz3hAVkQqSNEG3elfrzrJ3I1mi
	 L2lReL6gODKkRLbRssCqp1jNm4AVDuzY0u43i+U+51t4grFJ4lrZODtUGQqEbD4dxJbXC
	 PenwPSDJsdkCmdyZWhZO+HurO+vbgyz/zIzfLDH7xYVw4yEtT1W9oqzI7g0Xs+tWi0V7k
	 9rVj0AXnnV7LzHynIm26PHfStKE3XMzDFpntwTjohOoG69empccCIixgfdxtDXEiNkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B95I6vN8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4F5606A338;
	Wed, 18 Nov 2026 17:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B95I6vN8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABC11F000C7;
	Wed, 18 Nov 2026 17:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021878;
	bh=x141RWEQ09s48AY0yzJIfsYzJ49+VzOeCUfJLY0hArg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B95I6vN8Ij+fMt3lmeoBIgOkJAoGT7CiszS2p2YM1c4fmj4zN5vaX1K+besabDvgZ
	 Y5XrGWhh6Z/naiRIWZb/5V5vMAcxIG3hW6VWzPYdGyXmzVSogiJ2UYXFDTeI0eMCFH
	 mIZqZ5F7QviNSRsXDj9B1g+fC6mocHy307vPBb3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Kulikov <dar1knessx@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2464/2651] ksmbd: use the resolved share path for the share root
Date: Wed, 18 Nov 2026 16:01:44 +0100
Message-ID: <20261118150413.737998323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Kulikov <dar1knessx@gmail.com>

[ Upstream commit 03b47bdc9ac8e9dacbf1d66a1dfc54b328e283f2 ]

If the share path is a mount point and crossmnt is not set (crossmnt = no,
or ksmbd-tools that predate the option), the share root looks empty to
clients: QUERY_DIRECTORY on it returns only "." and "..". Files created
in the root go to the mounted filesystem, but a directory query cannot
find them afterwards, so e.g. "rm" of a file that was just uploaded
fails with STATUS_NO_SUCH_FILE.

An empty name refers to the share root. For it, ksmbd_vfs_path_lookup()
looks up share_conf->path again starting from its parent, and the mount
on the last component is not followed, which gives the directory covered
by the mount. All other names are looked up relative to
share_conf->vfs_path, which was resolved through the mount when the
share was set up.

share_conf->vfs_path already refers to the share root, so return a
reference to it instead of looking the path up again.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Signed-off-by: Denis Kulikov <dar1knessx@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 674e4fcd80cb2..f88daeb5ef873 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -65,12 +65,13 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
 		if (for_remove)
 			return -EINVAL;
 
-		pathname = share_conf->path;
-		root_share_path = NULL;
-	} else {
-		flags |= LOOKUP_BENEATH;
+		*path = share_conf->vfs_path;
+		path_get(path);
+		return 0;
 	}
 
+	flags |= LOOKUP_BENEATH;
+
 	CLASS(filename_kernel, filename)(pathname);
 	scoped_with_init_fs()
 		err = vfs_path_parent_lookup(filename, flags, path, &last,
-- 
2.53.0



