Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F3D6A03B;
	Tue, 23 Jan 2024 02:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975340; cv=none; b=mJ9xwfXee6P1h+osK0fhF9AEam1aSeIoXkX0PO9USpL16EZ/LIkP+RQvR7MaUARtyTsQkLNPMCej15S0oDZsgzKkDuAGYvMD/OT1Mk3079qpWJ6ttBgXFjAJr7ojylw4Ff9XcxvXdRvcxLAdZqyZ08w/QPMv5Ko5Nb5tyi321QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975340; c=relaxed/simple;
	bh=h3VoQEETzUmAC9R36otMF+EObEAhkdXzNF2wqZPux48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvjYcuxcXueyWlRkPGAEidm/hJgPREDq0xXvKNO1Bp1iBSWiZW+oZaierTbq9MfaQF+26Gw32Synk2HBIklvmbFYmWY7xi7X77BUPHv7qteKxtEC680VqCKJSov3TItLoQtY+FsXkAuVKVVwy/dXPNZTgVq5sm1O8cUi9clvqKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4PNbqaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4PNbqaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D70C43394;
	Tue, 23 Jan 2024 02:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975340;
	bh=h3VoQEETzUmAC9R36otMF+EObEAhkdXzNF2wqZPux48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4PNbqawE7NWj7TblMmL2vk/I3uNm/y0upyoy37V29JhhBiqFXjHPd8zcBhQ4SjvE
	 UGvrRUIt9eJlGVtazul+HPLaE+irAW6gCVSMIFmx5jyjIxgQuHUNWOXRY+bUVGFunE
	 p6yM72TMjZ5qr4SDPsxtV640rIHJ63nDIWiwn3iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/583] f2fs: fix to check compress file in f2fs_move_file_range()
Date: Mon, 22 Jan 2024 15:55:28 -0800
Message-ID: <20240122235820.471219458@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit fb9b65340c818875ea86464faf3c744bdce0055c ]

f2fs_move_file_range() doesn't support migrating compressed cluster
data, let's add the missing check condition and return -EOPNOTSUPP
for the case until we support it.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index a06f03d23762..e36a3208a3e9 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2818,6 +2818,11 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
 			goto out;
 	}
 
+	if (f2fs_compressed_file(src) || f2fs_compressed_file(dst)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	ret = -EINVAL;
 	if (pos_in + len > src->i_size || pos_in + len < pos_in)
 		goto out_unlock;
-- 
2.43.0



