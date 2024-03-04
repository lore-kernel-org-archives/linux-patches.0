Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E87178B69;
	Mon,  4 Mar 2024 21:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587646; cv=none; b=pybaVJGPJGgHDjj5ZCq8o9GryMmaBTRSZWR1envrshY+YayiUfMsyHu43HrxHD3/bbykqhZZKBV+YguBaeNYgFWL4iimLuBUaUwlTyocSIr+6uxNgPXJ4G+JBsP8dyPWpon44oX6aULQb4scralxxE5VetWj7ZeVyJS9Y+2EbFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587646; c=relaxed/simple;
	bh=EdcRcSvB/CcdIk4OX9UC0eqdo69Unc/JwRqUFknfcC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=td4eE2G7QpNh2bXzgqVNLcc5K394UWDMfwwekf1RAc5eNZDXw75oPlgmm2F8kWkfxApcp2A6ErQDyTmqtlQf1Bvpc0qcrRdWYYw4/EoJmYiz8XxNGnq2sv+IL0EjRJZj3MEXhVIxfQ5WpIgInAFyP2OjW+2HyZlis4buZa42sYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFQiJlkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFQiJlkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108BEC433F1;
	Mon,  4 Mar 2024 21:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587646;
	bh=EdcRcSvB/CcdIk4OX9UC0eqdo69Unc/JwRqUFknfcC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFQiJlktIee04eJg+AIwS//I+ZIgu3yRoKmBIT8PNdyJh2zjE1MR01a5XH/ItB+Us
	 V1R6UwpYpqKVOflNBu+ppvrM1XlHEyxhcrbQo8t0KJkOseDIYfO0LQfWFGfrracAur
	 y5RSZ/DCWUIfwdKcmNtn3hIl3Tx98lGY2AIdcagQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3f497b07aa3baf2fb4d0@syzkaller.appspotmail.com,
	xingwei lee <xrivendell7@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 011/162] netlink: add nla be16/32 types to minlen array
Date: Mon,  4 Mar 2024 21:21:16 +0000
Message-ID: <20240304211552.189273592@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 9a0d18853c280f6a0ee99f91619f2442a17a323a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/nlattr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index dc15e7888fc1f..0319e811bb10a 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -30,6 +30,8 @@ static const u8 nla_attr_len[NLA_TYPE_MAX+1] = {
 	[NLA_S16]	= sizeof(s16),
 	[NLA_S32]	= sizeof(s32),
 	[NLA_S64]	= sizeof(s64),
+	[NLA_BE16]	= sizeof(__be16),
+	[NLA_BE32]	= sizeof(__be32),
 };
 
 static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
@@ -43,6 +45,8 @@ static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
 	[NLA_S16]	= sizeof(s16),
 	[NLA_S32]	= sizeof(s32),
 	[NLA_S64]	= sizeof(s64),
+	[NLA_BE16]	= sizeof(__be16),
+	[NLA_BE32]	= sizeof(__be32),
 };
 
 /*
-- 
2.43.0



