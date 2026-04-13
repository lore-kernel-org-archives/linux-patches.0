Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BEF30C361;
	Mon, 13 Apr 2026 16:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098576; cv=none; b=edknzCotQBnjns+u79suNxM1liqtAcummAmQIig9VpoYCbEc54RwOYT7ftBB2/rVSBiprKUrBdMwg6qBjJgkkRse/gadE6Dd2P17dbKXcNpCYcYIpHnQZ7LqkGi3VTpqq32Nx/CjmJdUqq5N6NmX2PHB0pcb7yhat17vYvs3o94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098576; c=relaxed/simple;
	bh=6VQFNCUvIfVhnchIiWN5jOStlYzwzzPfKL1GopQk2C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nO5thDAAxFa7ulEx5gx9y+/PUQ1TE9jttwITRXm8E+XOkMEiY81O/IdSK/JxZDYF3MM/Z75MRE+ZyHsgySLx6xc6PR+Efe/BtKOZh9GHxr8o5F6kDOBJcy3uNq7uMmjVR01XAzFQuIQlntZoyI+fpq2FYZQED11R3Q9963Jwi+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9ugjVsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9ugjVsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B10EC2BCAF;
	Mon, 13 Apr 2026 16:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098576;
	bh=6VQFNCUvIfVhnchIiWN5jOStlYzwzzPfKL1GopQk2C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9ugjVsqgigyOJKIJwQXWqMrkG0/oEXrt2Ly3XzKiiQCbTC2OT1TbS/yn4uV65O9W
	 7vZ3+2XiDETgRYmjbsTvA44R/ec7Gh6b8khR9zflnzN0gbi8+YV6PCjiRPJ7n49//Q
	 RkYZ5mj3QzCka56R8mfTKDegvgBQ2AolPlN+3a+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3f497b07aa3baf2fb4d0@syzkaller.appspotmail.com,
	xingwei lee <xrivendell7@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 541/570] netlink: add nla be16/32 types to minlen array
Date: Mon, 13 Apr 2026 18:01:12 +0200
Message-ID: <20260413155850.712743099@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 9a0d18853c280f6a0ee99f91619f2442a17a323a upstream.

BUG: KMSAN: uninit-value in nla_validate_range_unsigned lib/nlattr.c:222 [inline]
BUG: KMSAN: uninit-value in nla_validate_int_range lib/nlattr.c:336 [inline]
BUG: KMSAN: uninit-value in validate_nla lib/nlattr.c:575 [inline]
BUG: KMSAN: uninit-value in __nla_validate_parse+0x2e20/0x45c0 lib/nlattr.c:631
 nla_validate_range_unsigned lib/nlattr.c:222 [inline]
 nla_validate_int_range lib/nlattr.c:336 [inline]
 validate_nla lib/nlattr.c:575 [inline]
...

The message in question matches this policy:

 [NFTA_TARGET_REV]       = NLA_POLICY_MAX(NLA_BE32, 255),

but because NLA_BE32 size in minlen array is 0, the validation
code will read past the malformed (too small) attribute.

Note: Other attributes, e.g. BITFIELD32, SINT, UINT.. are also missing:
those likely should be added too.

Reported-by: syzbot+3f497b07aa3baf2fb4d0@syzkaller.appspotmail.com
Reported-by: xingwei lee <xrivendell7@gmail.com>
Closes: https://lore.kernel.org/all/CABOYnLzFYHSnvTyS6zGa-udNX55+izqkOt2sB9WDqUcEGW6n8w@mail.gmail.com/raw
Fixes: ecaf75ffd5f5 ("netlink: introduce bigendian integer types")
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/20240221172740.5092-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/nlattr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -30,6 +30,8 @@ static const u8 nla_attr_len[NLA_TYPE_MA
 	[NLA_S16]	= sizeof(s16),
 	[NLA_S32]	= sizeof(s32),
 	[NLA_S64]	= sizeof(s64),
+	[NLA_BE16]	= sizeof(__be16),
+	[NLA_BE32]	= sizeof(__be32),
 };
 
 static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
@@ -43,6 +45,8 @@ static const u8 nla_attr_minlen[NLA_TYPE
 	[NLA_S16]	= sizeof(s16),
 	[NLA_S32]	= sizeof(s32),
 	[NLA_S64]	= sizeof(s64),
+	[NLA_BE16]	= sizeof(__be16),
+	[NLA_BE32]	= sizeof(__be32),
 };
 
 /*


