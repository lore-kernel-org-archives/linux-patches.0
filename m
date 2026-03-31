Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64943A1E8C;
	Tue, 31 Mar 2026 16:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976186; cv=none; b=OGVaJ94FN76vEYs+OUWTWHiAJArpiB/jdbiW067Gs7hdxYC1z6oTZqXsU6OO9IuxDIEOGJBK7a+bWAYgospzkZsUVpJ/ckqbKJRz0sxJM0OZ0IuliFULVvGYHvSm06PbU7K/QOkZiIk7K9Lpfp9eWSRUjWkteQk9J2Pogh7higY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976186; c=relaxed/simple;
	bh=OYiPiBadIbQzq6e2MmrFqjkWwf7hhTubvUYqlQbu0uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLX7+Edh7iCUFMnjU51W/199WCEybEeKiFF7qFWAptiG8xI3/C4P+hw/CGOIkhZYAbqX8eEBPjorlcqlBBm7J4xEL/Let9nQBkwtCLrjQWaqiwxVLkbixhaB63kMuaeVqnolfp/s4fnp9VKdMMneDHWBiNpI0xCZqrg6Eu7yvYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEPdoF1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEPdoF1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594C7C19423;
	Tue, 31 Mar 2026 16:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976186;
	bh=OYiPiBadIbQzq6e2MmrFqjkWwf7hhTubvUYqlQbu0uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEPdoF1OgQ/Ry4cCqdJoIOovCQVzboIXhZyz+pqXschxlEmVXx1gcN1is0z389RYh
	 yHUHpWtyYPI2ADtCFosiBbCJkgSJkIihdQ8GR0XiYNcwkxoWH+5Bd0QoDG3nBJ8oQ2
	 s2+yaSnOnVoktmRc2AoWAoNWp22Te6lp74pgcgsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GuoHan Zhao <zhaoguohan@kylinos.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/244] xen/privcmd: unregister xenstore notifier on module exit
Date: Tue, 31 Mar 2026 18:23:09 +0200
Message-ID: <20260331161750.586533557@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: GuoHan Zhao <zhaoguohan@kylinos.cn>

[ Upstream commit cd7e1fef5a1ca1c4fcd232211962ac2395601636 ]

Commit 453b8fb68f36 ("xen/privcmd: restrict usage in
unprivileged domU") added a xenstore notifier to defer setting the
restriction target until Xenstore is ready.

XEN_PRIVCMD can be built as a module, but privcmd_exit() leaves that
notifier behind. Balance the notifier lifecycle by unregistering it on
module exit.

This is harmless even if xenstore was already ready at registration
time and the notifier was never queued on the chain.

Fixes: 453b8fb68f3641fe ("xen/privcmd: restrict usage in unprivileged domU")
Signed-off-by: GuoHan Zhao <zhaoguohan@kylinos.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260325120246.252899-1-zhaoguohan@kylinos.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/privcmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index b366192c77cf1..d7d9d427e51a1 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -1784,6 +1784,9 @@ static int __init privcmd_init(void)
 
 static void __exit privcmd_exit(void)
 {
+	if (!xen_initial_domain())
+		unregister_xenstore_notifier(&xenstore_notifier);
+
 	privcmd_ioeventfd_exit();
 	privcmd_irqfd_exit();
 	misc_deregister(&privcmd_dev);
-- 
2.53.0



