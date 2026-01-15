Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD35F27AC5C;
	Thu, 15 Jan 2026 17:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498479; cv=none; b=R7r6pFZ9TGVfKgxD3ONvARE+5IEV+t2iuTapUlaOij3xb/grhNb/68aWJJwP7rulqqT10BMwMTLE2YhnoFFYoBzfitfKHsr3PHyvvaNedfxwYinCqFQerKdVbPpsutbmB/fhba7nuxVmd/a28fIJk65pdAAyxgkxuPd7+i+g3OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498479; c=relaxed/simple;
	bh=8658TILv8TMCQ/RyrtLoEVKDyU8dGfkHnNTXbunxkSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRMJvUkH8OJU8Va2qwxCfpqF9VCsF3GaDLKNn+1STyLDPJB8EMPhiKadrEQWa8Q5lakYZ8gzAbBGeHXcIqU1HQ1EPyZsvDHbDiR0FjlLpiogJcylMxxhzR/7VtSzIhzEFWrVLOLyuUYrbWqL5yAYPZz/QIikXKL3uVYwEixkJh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhwKFMiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhwKFMiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4591EC116D0;
	Thu, 15 Jan 2026 17:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498479;
	bh=8658TILv8TMCQ/RyrtLoEVKDyU8dGfkHnNTXbunxkSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhwKFMiSCm7Fqs4u+Q6LZYYi6ekrnquGWrq/M5GtvWtCywWQre76ZbClDAKocY5zu
	 edPCd0CMdByNx3AGCgEJwAjXcx1L1Zq1P+C2OBjWc8e6ZAG+Vyp+GMPyjWKZ5c1LhT
	 u7InJULta1aVp1zGSMNjOnSeCNaqMjg5FXzOPApw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 446/554] mptcp: pm: ignore unknown endpoint flags
Date: Thu, 15 Jan 2026 17:48:32 +0100
Message-ID: <20260115164302.412625992@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
[ GENMASK(5, 0) => GENMASK(3, 0) + context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/mptcp.h |    1 +
 net/mptcp/pm_netlink.c     |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -74,6 +74,7 @@ enum {
 #define MPTCP_PM_ADDR_FLAG_SUBFLOW			(1 << 1)
 #define MPTCP_PM_ADDR_FLAG_BACKUP			(1 << 2)
 #define MPTCP_PM_ADDR_FLAG_FULLMESH			(1 << 3)
+#define MPTCP_PM_ADDR_FLAGS_MASK			GENMASK(3, 0)
 
 enum {
 	MPTCP_PM_CMD_UNSPEC,
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1294,7 +1294,8 @@ skip_family:
 		entry->addr.id = nla_get_u8(tb[MPTCP_PM_ADDR_ATTR_ID]);
 
 	if (tb[MPTCP_PM_ADDR_ATTR_FLAGS])
-		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
+		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]) &
+			       MPTCP_PM_ADDR_FLAGS_MASK;
 
 	if (tb[MPTCP_PM_ADDR_ATTR_PORT]) {
 		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {


