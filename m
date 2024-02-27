Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2F413AA2F;
	Tue, 27 Feb 2024 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041358; cv=none; b=rjk+SJ7xCWc0zEV10MBhXK468XpzB/nzMaiiezvsAxjRafloYf03NQ/E/oIfV063ZhCiQcQ79iWScNPwQK//KwaDncB3pTEGCEkctR7m89659QHOi+z+H7rirMt/n3rINQ6Wis9cXrMuCHJbK+OeqXlJPwHlJ8yO3MKMAON35pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041358; c=relaxed/simple;
	bh=XT9v6lU12BNrz764gelMk7sBPOmLzA/4anLbF0/KI7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAI6P2T6jresn8L8f6kb3sjYPVg1SHtqmBqTLKb3hvp/dMJ4LRwTGsG2P4x3SMTBpYg4CtjieBZ+IZL4nFTo40SC32tCibafR6Bcq/JTtqTPQcmo2UP4gAgNE2R9FjvHsQi7MaBrrZhMg5k4qv3Y5j9vysjhcXSfdOVPeW7G8jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvCaauly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvCaauly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A3DC433F1;
	Tue, 27 Feb 2024 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041358;
	bh=XT9v6lU12BNrz764gelMk7sBPOmLzA/4anLbF0/KI7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvCaauly6PZuW+wmOxSf1vSMOnG+KCHCcZu9x+74m68NsyBE4JQ5J0dDgPJA90k1t
	 IxSeo8jtG08rfIyp9Nm0SJS2MGUcnUSNSaFw0nezfm9VcSIGwCoUumuW0kToilP3Zs
	 ydpue/Q1uAoe+1CfNwZ9wyJxM1hATZ+vVNs5UGvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 281/334] devlink: fix possible use-after-free and memory leaks in devlink_init()
Date: Tue, 27 Feb 2024 14:22:19 +0100
Message-ID: <20240227131640.053366078@linuxfoundation.org>
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

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit def689fc26b9a9622d2e2cb0c4933dd3b1c8071c ]

The pernet operations structure for the subsystem must be registered
before registering the generic netlink family.

Make an unregister in case of unsuccessful registration.

Fixes: 687125b5799c ("devlink: split out core code")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://lore.kernel.org/r/20240215203400.29976-1-kovalev@altlinux.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index cbf8560c93752..bc3d265fe2d6e 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -529,14 +529,20 @@ static int __init devlink_init(void)
 {
 	int err;
 
-	err = genl_register_family(&devlink_nl_family);
-	if (err)
-		goto out;
 	err = register_pernet_subsys(&devlink_pernet_ops);
 	if (err)
 		goto out;
+	err = genl_register_family(&devlink_nl_family);
+	if (err)
+		goto out_unreg_pernet_subsys;
 	err = register_netdevice_notifier(&devlink_port_netdevice_nb);
+	if (!err)
+		return 0;
+
+	genl_unregister_family(&devlink_nl_family);
 
+out_unreg_pernet_subsys:
+	unregister_pernet_subsys(&devlink_pernet_ops);
 out:
 	WARN_ON(err);
 	return err;
-- 
2.43.0



