Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C1D41A8F;
	Sat, 30 May 2026 18:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166239; cv=none; b=O9XCntrH7atiFMCceiLkxZsO7ztjazY5r4yDGBPlE3WritsKbs5FRHvjgYuJWkiRVydh2noDa9qNQk4e68QgUQQfbeFx3Ora4n3AS4DutvERqSuV6s+/YYmc5gbp62O3d8iDbzXlByZ3uAs7QZsiDqn/E8RnSaQwwirBbU4Ej1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166239; c=relaxed/simple;
	bh=dM78LdjFJP6WRR1FnDtsVt71Bbk47I7znTGyit0FJjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTHqWpc43kWyaGvNE9KLpVSl3RHgqL85uNJRHduFpXpBHi5OtW1sFDwr73YAJZt5qR1zZO7YKGuP4B7YGsUL56GDwclzHSTvA6+bppE7AnDujBJj4gN28fORMygREVgUQgRopdAFU0/eJkxnwgzUuwkkCNr0f7FAAbS/tFk60/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnbJRRHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnbJRRHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA2D1F00893;
	Sat, 30 May 2026 18:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166238;
	bh=1rOcPPnRXhEe/o8N2CYVhfd0N7mIpSCVrlKfilyDJJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnbJRRHZ3TKBOmeH0rQwAAWDiw0U0nRWBTwnFUsrPgIh+tqQuc7FN/7XJfpY+PmUW
	 2RKRKUI4ha5zrqyGsi7pJrm7FKBC9EYmVdVVs7dRDIfvKnSIcGjpZi5i4eIAwUgAyr
	 +ukPEModC2dARgUl2BZCXo8bp79/SK+IShT7KvB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taegu Ha <hataegu0826@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/589] ppp: require CAP_NET_ADMIN in target netns for unattached ioctls
Date: Sat, 30 May 2026 18:03:14 +0200
Message-ID: <20260530160233.167442126@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Taegu Ha <hataegu0826@gmail.com>

[ Upstream commit 2bb6379416fd19f44c3423a00bfd8626259f6067 ]

/dev/ppp open is currently authorized against file->f_cred->user_ns,
while unattached administrative ioctls operate on current->nsproxy->net_ns.

As a result, a local unprivileged user can create a new user namespace
with CLONE_NEWUSER, gain CAP_NET_ADMIN only in that new user namespace,
and still issue PPPIOCNEWUNIT, PPPIOCATTACH, or PPPIOCATTCHAN against
an inherited network namespace.

Require CAP_NET_ADMIN in the user namespace that owns the target network
namespace before handling unattached PPP administrative ioctls.

This preserves normal pppd operation in the network namespace it is
actually privileged in, while rejecting the userns-only inherited-netns
case.

Fixes: 273ec51dd7ce ("net: ppp_generic - introduce net-namespace functionality v2")
Signed-off-by: Taegu Ha <hataegu0826@gmail.com>
Link: https://patch.msgid.link/20260409071117.4354-1-hataegu0826@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index b2b5a994dd0ee..a15b3eebb6d62 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -950,6 +950,9 @@ static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
 	struct ppp_net *pn;
 	int __user *p = (int __user *)arg;
 
+	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+
 	switch (cmd) {
 	case PPPIOCNEWUNIT:
 		/* Create a new ppp unit */
-- 
2.53.0



