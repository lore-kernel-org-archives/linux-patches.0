Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C14613EFFB;
	Tue, 27 Feb 2024 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042460; cv=none; b=NBMd3bXVqgKuH7tmCTDystEc5JtRU8fdUOe5ZRG5xeZleWW9nWror1E4AZiSItGt65PXuCWt75xhwg4Vor+421uBPXV1KT0kEC0HlPvi49rVh3lspONwL6F0xQ+FRGS3nrMwMtyZCIU4Y6cL+EAvxeN6ELtBEfhyYsdVYrKLfhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042460; c=relaxed/simple;
	bh=xNVAEo8CwFdCuOsDnSX0pS3/Z9HNUFGNaPcZvziAY3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEVYuAypJgp2YcD4TBM1Ttdo/AHfdKPiRPdyqIyV6KpdGlzj2bO2UOxPsDMGCabgh3W/psL3NrTvw/LZXv6J8LIBOS9CwhcCRdrppHnBi85isGWz5Vb7op+nEj/XSzw6hlhRrxnaO0sZoIuQUEq2wBqEH0vEHG0DXIaFxEKjwgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDhmqhrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDhmqhrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6660C433F1;
	Tue, 27 Feb 2024 14:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042460;
	bh=xNVAEo8CwFdCuOsDnSX0pS3/Z9HNUFGNaPcZvziAY3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDhmqhrNoQ5mRBG5Us+xPbIWwgkiZJSp2C9/aXDhbXH8VWvqSgYgy/Ua/a+zfFiH+
	 sPoHx7rXZ2N3XofUYQ09ksWc3M9AvEztQ0KRR+k0GNhBTxlE7BZfkR2gmO2QKa0yRG
	 GIkhzGL41gimyt0f6KDAhIFfTuGrRcPY8+h5XIhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 279/299] devlink: fix port dump cmd type
Date: Tue, 27 Feb 2024 14:26:30 +0100
Message-ID: <20240227131634.663948444@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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
index 91ba1ca0f3553..9b5ff0fccefdd 100644
--- a/net/devlink/port.c
+++ b/net/devlink/port.c
@@ -574,7 +574,7 @@ devlink_nl_port_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 
 	xa_for_each_start(&devlink->ports, port_index, devlink_port, state->idx) {
 		err = devlink_nl_port_fill(msg, devlink_port,
-					   DEVLINK_CMD_NEW,
+					   DEVLINK_CMD_PORT_NEW,
 					   NETLINK_CB(cb->skb).portid,
 					   cb->nlh->nlmsg_seq, flags,
 					   cb->extack);
-- 
2.43.0



