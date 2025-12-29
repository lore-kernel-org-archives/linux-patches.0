Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140E93191A7;
	Mon, 29 Dec 2025 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025710; cv=none; b=hIM/wbbHyQpd4xmE6/VyIxqp3cl8zsiF9w6d9MxTMip4ahHA6Rn2fLC23fVXHlVxXmyGc0wFZs5E4K3CRZkor92giOFrvnukWbaPNVnG8uAZrRrYBaKjpl2QPv0FG/mgah1xqItZuq+1qm2CsVfFXs0lOHGoHXhRjQVzajoHdbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025710; c=relaxed/simple;
	bh=X0G/swgpvbjbAjmnoFnlNycuZ5q/ZZyvhN/itsL0o7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxob1WsyjkiNPfhU3ee+w2MLwf8LKeeiXpVgILkW1P0rly1CFGKE52KbV9rjzov1oR0TUEl8fkCEs0k7rI/t5+7fslzB1xwPJ6kbP0LNurj3xki1icIkhIXbYAAXGqprFw22pLpTCxvRwZXdZIaH4wGMYlWtFbOtBeQ/muKq8Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rnx0XOSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rnx0XOSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCD5C4CEF7;
	Mon, 29 Dec 2025 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025709;
	bh=X0G/swgpvbjbAjmnoFnlNycuZ5q/ZZyvhN/itsL0o7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rnx0XOSMvrpA/zdWtTXqHYQh4+xcJP92D8RYPMZVsHCbaUedKAqTHddReFv7Fb2CN
	 +KO9NzLsXeGDVGR1uVe9hkKsASzV/4gxpMnsZBRH+Avrb4DIRZEgR2UHoE/+XUl1XX
	 9XSlDV+LP0buM7/Os9PXA6aDG+lCuPzQskxhuC2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 276/430] mptcp: pm: ignore unknown endpoint flags
Date: Mon, 29 Dec 2025 17:11:18 +0100
Message-ID: <20251229160734.506795270@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 0ace3297a7301911e52d8195cb1006414897c859 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/mptcp.h |    1 +
 net/mptcp/pm_netlink.c     |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -40,6 +40,7 @@
 #define MPTCP_PM_ADDR_FLAG_FULLMESH		_BITUL(3)
 #define MPTCP_PM_ADDR_FLAG_IMPLICIT		_BITUL(4)
 #define MPTCP_PM_ADDR_FLAG_LAMINAR		_BITUL(5)
+#define MPTCP_PM_ADDR_FLAGS_MASK		GENMASK(5, 0)
 
 struct mptcp_info {
 	__u8	mptcpi_subflows;
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -119,7 +119,8 @@ int mptcp_pm_parse_entry(struct nlattr *
 	}
 
 	if (tb[MPTCP_PM_ADDR_ATTR_FLAGS])
-		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
+		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]) &
+			       MPTCP_PM_ADDR_FLAGS_MASK;
 
 	if (tb[MPTCP_PM_ADDR_ATTR_PORT])
 		entry->addr.port = htons(nla_get_u16(tb[MPTCP_PM_ADDR_ATTR_PORT]));


