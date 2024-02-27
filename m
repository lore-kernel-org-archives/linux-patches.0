Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3839B13AA55;
	Tue, 27 Feb 2024 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041438; cv=none; b=ECOZM/WusRDc8M/HbREqL8RAgfNS/ZbgLII3ZXwtWbIHXZzjUPjMCCz1oHYGQ0uElRNz1+8coKnFFH+iyg8xN0lPhw2/cgQSZ/8Zo23Lhevrr0qoKhmYrCauFtVWA4sBqd5zJmiOGylnu2Wq1jzh7+nXS8e3kVjlEqVDqED9A18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041438; c=relaxed/simple;
	bh=rtNgeNMKHjchGOlLNddAiFOUaiYUI5mqidWYcXRAax4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nbi/tgCLrIPeRDeP5jOCyTgOqd5d2X/rHLAYuL+oIRvvzYuPzRszKvxB9lM7dlxqbuEfRs8RhyahR24nL2TrOAP0qs90o0zgU4pOfRCNkskG/gTKDoQ7zmtzlYnFcF6jLdFXsUWcmS43AQcRrQpPPck7eFvLlB8IkF1bPM5Nwyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3YuqX/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3YuqX/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEF9C433C7;
	Tue, 27 Feb 2024 13:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041438;
	bh=rtNgeNMKHjchGOlLNddAiFOUaiYUI5mqidWYcXRAax4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3YuqX/qgSuSTux/7cUhIfk7NPFfXZwnffYzocLoBkSIywysXeMYPpgpaUgsMKrt9
	 yrz1uPUG9W6EfT4k5++uzx3yBPYNcNsfGZ+S2/CS3Gd8QzMjhevJgTfftMvDOHB9c9
	 /4jkh9l1hiQrDPA7Tk6NXq0ExxderQxla6fRKg6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 314/334] devlink: fix port dump cmd type
Date: Tue, 27 Feb 2024 14:22:52 +0100
Message-ID: <20240227131641.217816671@linuxfoundation.org>
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

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 61c43780e9444123410cd48c2483e01d2b8f75e8 ]

Unlike other commands, due to a c&p error, port dump fills-up cmd with
wrong value, different from port-get request cmd, port-get doit reply
and port notification.

Fix it by filling cmd with value DEVLINK_CMD_PORT_NEW.

Skimmed through devlink userspace implementations, none of them cares
about this cmd value. Only ynl, for which, this is actually a fix, as it
expects doit and dumpit ops rsp_value to be the same.

Omit the fixes tag, even thought this is fix, better to target this for
next release.

Fixes: bfcd3a466172 ("Introduce devlink infrastructure")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20240220075245.75416-1-jiri@resnulli.us
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devlink/port.c b/net/devlink/port.c
index 841a3eafa328e..d39ee6053cc7b 100644
--- a/net/devlink/port.c
+++ b/net/devlink/port.c
@@ -581,7 +581,7 @@ devlink_nl_port_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 
 	xa_for_each_start(&devlink->ports, port_index, devlink_port, state->idx) {
 		err = devlink_nl_port_fill(msg, devlink_port,
-					   DEVLINK_CMD_NEW,
+					   DEVLINK_CMD_PORT_NEW,
 					   NETLINK_CB(cb->skb).portid,
 					   cb->nlh->nlmsg_seq, flags,
 					   cb->extack);
-- 
2.43.0



