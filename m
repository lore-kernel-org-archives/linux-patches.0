Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5222F423149;
	Tue, 31 Mar 2026 16:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975542; cv=none; b=BF42UPKwdSJbm+DCD9TytPdNNefukM4QJVcn/Y4HHkU/SEn25WM41q+Bx4ghRDre+QUrjuvMMoqP/hzwJLBGiN1x4vaehXbGWp9BzESna5/Omjmk2F+gFQsVQb+c+JWBUbec9ZRKOsPWmo5camDZ7M3170RD2R0N6IpH9ZKLCCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975542; c=relaxed/simple;
	bh=lbnU6DfXrjZAfIcnYTfzYQ/pmg1i1+s8wgUYuO88EBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9bY7rsa8wF1p/shZznW+xVc0/4jkyMXWVQTCnksNTOWtrX8/9grSzpIFivtAhWhXULcSs/3b9IMWP1UIvdCCrp0FYaMqnK5gAEz2ZASPjpRxx0hq+aU9nOw44jOhD+GowuKMd8cBBmmIRKWPd/CStC1OvSiGE81+/5jjJHnPWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WiOQlwQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WiOQlwQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40D3C19424;
	Tue, 31 Mar 2026 16:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975542;
	bh=lbnU6DfXrjZAfIcnYTfzYQ/pmg1i1+s8wgUYuO88EBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiOQlwQAoXscH+I67OVeCtPhZ1sH3wiRj4AwGJwbZJvb0YAsICFQvOVM1kdF1DyPo
	 MoWKXhsr45Z+Utn+MJ4ZNjJSEJsF0Y5BefbiND3jeZYCGmnPqBoFKBh9ZbR3+dcW6Q
	 hn6iZYyOHBDRC6yVqqFQMdAO4aOgUZ2q9dJI6L2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GuoHan Zhao <zhaoguohan@kylinos.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 334/342] xen/privcmd: unregister xenstore notifier on module exit
Date: Tue, 31 Mar 2026 18:22:47 +0200
Message-ID: <20260331161811.194015903@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index b8a546fe7c1e2..cbc62f0df11b7 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -1764,6 +1764,9 @@ static int __init privcmd_init(void)
 
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



