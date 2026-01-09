Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC7D35971B;
	Fri,  9 Jan 2026 12:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961219; cv=none; b=AS+/Bh+8HULLrXiz1hGNf2OlYEcuZMc8j8wT0deTHzFCx63hOyG21giudirbcaG8InH54qfaXrf38aSyv9XmaBbrn5BgJI1dLl8NzyvkAATts8F2eTm0sYFGbhACDqSZoeYPtJE0SAd8aC/8mMkjiTbfUBVkjduP1BnvMej/Jtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961219; c=relaxed/simple;
	bh=JH5yilMbDU6TIzVxuhF99NBJ3bn5b5iLK19ySpTOCes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAeqhwS7MMcXvIoImsQXOjC4fJfB8xsmtYHV35ePMXjSdGU4F/9FfNu8VGqfxTBALpP+L3j+79B90CxyaKk1cm0BtiA0QOuO+3TB7cX+eeW9RXE8kMdlnF3oAoNRWAUFQeCSGG/bhjWH1K7vhH2RvL18ovP+RUzEdcGj+bC2dO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nznsprjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nznsprjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09149C16AAE;
	Fri,  9 Jan 2026 12:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961219;
	bh=JH5yilMbDU6TIzVxuhF99NBJ3bn5b5iLK19ySpTOCes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NznsprjymA98tZM0S8xZHZIYXQY4egeZJ1srNKa4/umqKSYR0fzIHchitC2989oOo
	 HW+HTlUgYJAiPGCBESCgUcKjXOlmo3kATFu7YK6glLA67HN98R/j2OTKfOAd9DTtrQ
	 sGBrVitMMmCgc7ZTkkcB5g6t/hgkfPuaUTCmhvig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 644/737] mptcp: pm: ignore unknown endpoint flags
Date: Fri,  9 Jan 2026 12:43:03 +0100
Message-ID: <20260109112158.241067741@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 0ace3297a7301911e52d8195cb1006414897c859 ]

Before this patch, the kernel was saving any flags set by the userspace,
even unknown ones. This doesn't cause critical issues because the kernel
is only looking at specific ones. But on the other hand, endpoints dumps
could tell the userspace some recent flags seem to be supported on older
kernel versions.

Instead, ignore all unknown flags when parsing them. By doing that, the
userspace can continue to set unsupported flags, but it has a way to
verify what is supported by the kernel.

Note that it sounds better to continue accepting unsupported flags not
to change the behaviour, but also that eases things on the userspace
side by adding "optional" endpoint types only supported by newer kernel
versions without having to deal with the different kernel versions.

A note for the backports: there will be conflicts in mptcp.h on older
versions not having the mentioned flags, the new line should still be
added last, and the '5' needs to be adapted to have the same value as
the last entry.

Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251205-net-mptcp-misc-fixes-6-19-rc1-v1-1-9e4781a6c1b8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ GENMASK(5, 0) => GENMASK(4, 0) + context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/mptcp.h |    1 +
 net/mptcp/pm_netlink.c     |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -88,6 +88,7 @@ enum {
 #define MPTCP_PM_ADDR_FLAG_BACKUP			(1 << 2)
 #define MPTCP_PM_ADDR_FLAG_FULLMESH			(1 << 3)
 #define MPTCP_PM_ADDR_FLAG_IMPLICIT			(1 << 4)
+#define MPTCP_PM_ADDR_FLAGS_MASK			GENMASK(4, 0)
 
 enum {
 	MPTCP_PM_CMD_UNSPEC,
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1435,7 +1435,8 @@ int mptcp_pm_parse_entry(struct nlattr *
 	}
 
 	if (tb[MPTCP_PM_ADDR_ATTR_FLAGS])
-		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
+		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]) &
+			       MPTCP_PM_ADDR_FLAGS_MASK;
 
 	if (tb[MPTCP_PM_ADDR_ATTR_PORT])
 		entry->addr.port = htons(nla_get_u16(tb[MPTCP_PM_ADDR_ATTR_PORT]));


