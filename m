Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16FC3AFCFB;
	Sat, 30 May 2026 17:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160953; cv=none; b=RZAXhDGL8vphx4ilA3igkYyVS7gA2ZsKLC+qA13zMbKPAwKNdN46WvloxEwktWe5f5CjK5Bt5uUtr1lNJu29NEbD15U8Vex7cqyv69NWvRLDy8OL5RJBXjTU1/lpVMPlRD7RBwbRiQZBeXtradyTu6RsPR5Tv0q+Ja6XAk4OoXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160953; c=relaxed/simple;
	bh=mUvOx+MaaLjZ5LmLNlRMGEQs5liWWgKLwBalP8ZFaBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIx0F1sS28PnO/VDfY2H8RH2mq5Ubo3klgxXlOUuQ2sxQMVeH3tGk3OIr8XXIbM+kuUuQJ69Ual916TwZ0OIf8mAeZWR/tkWkZqu/sdqp2GS14DwGXm06Jrhsy05FGSSaK4P8G7+EwMLjEi05EQ6ufPf7oTVxukUKtJgmJo6Ifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KznRchGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KznRchGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED52A1F00893;
	Sat, 30 May 2026 17:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160952;
	bh=rUC46mSl69a5od/KAs/WqW9k+ZXdtrLJo78WGUkRGRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KznRchGQedW6uBe+SZ1sEtG8y2oe1A+qe8GtYjiI2LFlQX4Z+cPEqf5I+Jp0aChUO
	 KR+VDMMsse9OeYfDbaLxvOuFMCNzS24gwBehxvtWNwaAHR7DTNZs6orU3gS0buJCDX
	 J4HWyo8vB86k+sCAhrRKZNql0E5uFGd2IBzSSOJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taegu Ha <hataegu0826@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 483/969] ppp: require CAP_NET_ADMIN in target netns for unattached ioctls
Date: Sat, 30 May 2026 18:00:07 +0200
Message-ID: <20260530160313.641061670@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index f184368d5c5e7..89973d0959a68 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1062,6 +1062,9 @@ static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
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



