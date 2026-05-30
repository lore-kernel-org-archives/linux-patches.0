Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065042D7D2E;
	Sat, 30 May 2026 17:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163992; cv=none; b=rMJ6HNepVU/jucrIb1vWL/ipfMlEMnWcZXIOJ+jZdLI3mAdnOBY2NE80LMNP9eaOzYuVc0zjfQeWyybTNsu8rXzjYNyrEo74Fajue+IwohTMor61FMB6RHUUz9EkwCXPT/NV/9Q4mTarUhL9a3CBCqMRxVUR9HQtUZu3KM7L9s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163992; c=relaxed/simple;
	bh=IRXEMpDxUK/V+6UxUfS6wjQrMAGQgn5jQoZMZaMPslI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZdnK0gXo+aRoa5GOXlcLiQ4pNLrG1c3VtC6FWtamuqXe0vqSUSP1ueZWqv7GkD4YZ32EQWJ2RiLJzjifGcocGM8PAOGpu+XU+q9zOvyJuonBrgDRF8JSv2eskjyH+QCZhFOZGrSVwKlAeIHrxXy4q6iGaAyXF+q7cYQHXATKp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8WSHv/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8WSHv/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB9D1F00893;
	Sat, 30 May 2026 17:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163989;
	bh=7cdxXKxvJTxvhMnmm8fdDqLE8mdB6jOAp5U5mOlj1Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8WSHv/ePUwEOBjOVN5lbYf6DuWVX1BKxpL+dYTsbxZqprMvXhc9t8fQwbHBZj2vB
	 7SPbPy2VQa0cn2dyIvBRnS1Xyv4BsV4S1haxJVI8NgjC22jl7ECHFQwn+2dIfdRYI9
	 04xIuaep7E3+ID7zmEeeTrlBSfqapskBSkUIex5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taegu Ha <hataegu0826@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 421/776] ppp: require CAP_NET_ADMIN in target netns for unattached ioctls
Date: Sat, 30 May 2026 18:02:15 +0200
Message-ID: <20260530160251.345704377@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
index 91a19ed03bc7d..bf75bc6954459 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1061,6 +1061,9 @@ static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
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



