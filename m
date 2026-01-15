Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EC83D301C;
	Thu, 15 Jan 2026 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499831; cv=none; b=CVvlEU2xFqH5njGfzbBYHrl3ErXCPzy9ENfdo24MuCIoO/kHC6olfclZVJQsNdDSqZX88vSGzVEmN0O4uU73OlmdRTEOyCbDh85T6nKkGNa8m2Z8ODKLoj4Io5CPB4ge2WOZQxebtJqnfdmpKT6NXZ/Wbj4o2R6lCa1LgmDtBk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499831; c=relaxed/simple;
	bh=mIDh2jrlc3tJuVnB84L+/UoKMb6J/hMMd9Dv+CrixMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tt33NXVZCQcziskxOF+KKExQ+AVYAejwY7PMpmgsxQ8VdcV/r4BPqRI+B55MmyfGnHSje8Xfff0Rw8BmP/9AVnPSk9rBevTiE9qAxiEp/K8APwgvJD0kouLE/rxnYHFx9S1gKCUxczlKcqAWcJWuLtQos7IYyj39hn30KLLX4IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03oQxGOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03oQxGOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B22C19425;
	Thu, 15 Jan 2026 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499831;
	bh=mIDh2jrlc3tJuVnB84L+/UoKMb6J/hMMd9Dv+CrixMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03oQxGOdDhY7PE9jbPcYfu/YyQJ5ZWMi3jf9dSuWDaCbYObRnb9QVyaMkVTgDXZ1M
	 HuvyEScxZ5vAjh3kVJ/XmPWAP5B5MkqYYakVzsM6C9GB6dHtmDsrcQMMuP2EcNOFzf
	 f98hSOD+iJw2CB7gtfMXcE66yPSv6bUFEX1U8s1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 364/451] mptcp: pm: ignore unknown endpoint flags
Date: Thu, 15 Jan 2026 17:49:25 +0100
Message-ID: <20260115164244.074846427@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ GENMASK(5, 0) => GENMASK(2, 0) and applied fix to mptcp_pm_parse_addr() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/mptcp.h |    1 +
 net/mptcp/pm_netlink.c     |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -72,6 +72,7 @@ enum {
 #define MPTCP_PM_ADDR_FLAG_SIGNAL			(1 << 0)
 #define MPTCP_PM_ADDR_FLAG_SUBFLOW			(1 << 1)
 #define MPTCP_PM_ADDR_FLAG_BACKUP			(1 << 2)
+#define MPTCP_PM_ADDR_FLAGS_MASK			GENMASK(2, 0)
 
 enum {
 	MPTCP_PM_CMD_UNSPEC,
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -721,7 +721,8 @@ skip_family:
 		entry->addr.id = nla_get_u8(tb[MPTCP_PM_ADDR_ATTR_ID]);
 
 	if (tb[MPTCP_PM_ADDR_ATTR_FLAGS])
-		entry->addr.flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
+		entry->addr.flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]) &
+				    MPTCP_PM_ADDR_FLAGS_MASK;
 
 	return 0;
 }


