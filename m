Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750FA13B2BF;
	Tue, 27 Feb 2024 13:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040758; cv=none; b=rDlk5St3eTn7f7JZ4hjD+ECKLo+5VLshXvrfBFRh3VIA/l2U4wKNihiGki5D2uN/g/Vmq8hl/EakLu2krTUI436tOWZaA3HyP4h2GlsyB7kCJ7kELXO88XL3mZnBPnrG3CBbI/NUnrBaNLJJC1gGVSXwf9r/f0OAaQbcwSpUsv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040758; c=relaxed/simple;
	bh=+eMpxwge0fvk2wC0K724+pG7GV5mUfTC9v8Tf89iUYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClBM7ESzVDsxQuSv+yCyHpXlRo8TQQIELfgenWP6f+1iBH0hOzEt/mMCad9dX61PEtmEgIO1UEyRp5GSa7OZDgZSvI156PesoP6O7NsjzXB3R9bA+J3eTuRym7ISLF5cbeXg5nH4uelS4eY2JuXtTiwFyuL+His4dC1dR48x4Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4WKwjg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4WKwjg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3765C433C7;
	Tue, 27 Feb 2024 13:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040758;
	bh=+eMpxwge0fvk2wC0K724+pG7GV5mUfTC9v8Tf89iUYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4WKwjg7JW37i/Ify6+ODfzQfVZXLCY0AROTeA61SqVrLjLY8YSPGw2fvYTkCZ+JM
	 D/xvL+8ThIFxPIwO9WjIt2LOm7JsI4TNy/uJX6fdtwGwSq9YbTc2WloTbVHpiaYdgy
	 GGW9YaMCzWJOsFR80STkg+NY7kK+CQQDNZVWRIRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+65e940cfb8f99a97aca7@syzkaller.appspotmail.com
Subject: [PATCH 6.7 100/334] fs/ntfs3: Fix oob in ntfs_listxattr
Date: Tue, 27 Feb 2024 14:19:18 +0100
Message-ID: <20240227131633.724357511@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 731ab1f9828800df871c5a7ab9ffe965317d3f15 ]

The length of name cannot exceed the space occupied by ea.

Reported-and-tested-by: syzbot+65e940cfb8f99a97aca7@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 071356d096d83..53e7d1fa036aa 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -219,6 +219,9 @@ static ssize_t ntfs_list_ea(struct ntfs_inode *ni, char *buffer,
 		if (!ea->name_len)
 			break;
 
+		if (ea->name_len > ea_size)
+			break;
+
 		if (buffer) {
 			/* Check if we can use field ea->name */
 			if (off + ea_size > size)
-- 
2.43.0



