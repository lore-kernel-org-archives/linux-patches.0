Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D791933032C;
	Fri,  9 Jan 2026 12:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962960; cv=none; b=MbBvK+koQajR/ekS29aJ7RLcqlW1nqtnIXOYNDPywhJOTaytv5iUm/o/KcJ78sGcG7FN14pw+M3vJ/uH6oi3Mb6d0MAgDuuQa9ZP7pYjauBoX6Ptjrk/pSh8yrlqDUwNgDLk4Tl/D+9WOuVjBnu4LA9PMyw5+iiCw0qiQSFmYgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962960; c=relaxed/simple;
	bh=x6qQIB93cZgq9ZcqImbPIuN5JCFirZeAb4lazCO2Gdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCUI69UQHTcOLslqK7XDEDn1zFtdIsku5TeVGo8GTDHRxM/VLv/8Zsx3govpY8VMXU7frDR18UoryE2LF1qL+y0GVh7dGpohQ6NluUUFuQv9/jAVfd6G19PkAJkD6KjMpL/qzreQOebz4O67KCyAsTYGZFuL1VHOSNzaBKjnuqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rANM5kRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rANM5kRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A06C16AAE;
	Fri,  9 Jan 2026 12:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962960;
	bh=x6qQIB93cZgq9ZcqImbPIuN5JCFirZeAb4lazCO2Gdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rANM5kRYkKpn6hFKWfo+3b8r1fHbTpHjaG86Df3jiP0cMd81DXfP8xz7UawDMlrXP
	 LoUJVj2w9LsJz9kRdI/OYM++RZUYo4OqRkY+viwKEUqnCGYHPApWqTFbth8N5SPRHr
	 nsfuVCSQEyDA7IAXbJV/iiTk+ClONVmNSVXtY6W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 548/634] mptcp: pm: ignore unknown endpoint flags
Date: Fri,  9 Jan 2026 12:43:46 +0100
Message-ID: <20260109112138.211676374@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1424,7 +1424,8 @@ int mptcp_pm_parse_entry(struct nlattr *
 	}
 
 	if (tb[MPTCP_PM_ADDR_ATTR_FLAGS])
-		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
+		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]) &
+			       MPTCP_PM_ADDR_FLAGS_MASK;
 
 	if (tb[MPTCP_PM_ADDR_ATTR_PORT])
 		entry->addr.port = htons(nla_get_u16(tb[MPTCP_PM_ADDR_ATTR_PORT]));


