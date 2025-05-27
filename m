Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE8219E7F9;
	Tue, 27 May 2025 17:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365646; cv=none; b=tUmIdSAu6Nd9zeeTReOCEkycEOpo8WhxfMJ48lEEGc/I5oqY+psdJv3NYdKCC3yQ9l04syt9k/eFMqXup63ELIICUVj6faNBxTbJTWgbRApl4l1PcxtQSiT5qiuwB5U0z6joCNnTYrtAPIsowVHkpZ/IlfWOIOfx7ktSJRujtSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365646; c=relaxed/simple;
	bh=T77tAHw90JZwljtoM4x1WG8T4h3ZJqKgbIic0tM+ysk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB+o/azTHKT70i2U7aeT8PDFM97Bdio0R2usuctnQUpRtNutRdT2oemiHhJBucdsEFHwcdH9j1qNe+pVFPDt/24wVT1tkwcYbdZNDS2S5spoI20HmRX6t2QA5YR6kBcN1ZFvyvrIGjymM6+grLotIkA8MaoiFJNUuw6ziDYf+jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMikIXOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMikIXOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6383C4CEE9;
	Tue, 27 May 2025 17:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365646;
	bh=T77tAHw90JZwljtoM4x1WG8T4h3ZJqKgbIic0tM+ysk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMikIXOQepuAjxSvFREdao+/uGmFwH/VI6ZvuCkZHLF6+jaTQdO9syLlcZC5rRN1V
	 alSXo56z+0KnjfRmIfa9UGZ0wGFAl6VMVdR2PNEkXnIGu4Dr1hYWz2n6ZI0roIej9/
	 rkAwfeorrTZbqVzXKnUIRvmCVxUitT9tPHLyIa+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 413/626] mptcp: pm: userspace: flags: clearer msg if no remote addr
Date: Tue, 27 May 2025 18:25:06 +0200
Message-ID: <20250527162501.785854630@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 58b21309f97b08b6b9814d1ee1419249eba9ef08 ]

Since its introduction in commit 892f396c8e68 ("mptcp: netlink: issue
MP_PRIO signals from userspace PMs"), it was mandatory to specify the
remote address, because of the 'if (rem->addr.family == AF_UNSPEC)'
check done later one.

In theory, this attribute can be optional, but it sounds better to be
precise to avoid sending the MP_PRIO on the wrong subflow, e.g. if there
are multiple subflows attached to the same local ID. This can be relaxed
later on if there is a need to act on multiple subflows with one
command.

For the moment, the check to see if attr_rem is NULL can be removed,
because mptcp_pm_parse_entry() will do this check as well, no need to do
that differently here.

Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_userspace.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index e35178f5205fa..bb76295d04c56 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -589,11 +589,9 @@ int mptcp_userspace_pm_set_flags(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		goto set_flags_err;
 
-	if (attr_rem) {
-		ret = mptcp_pm_parse_entry(attr_rem, info, false, &rem);
-		if (ret < 0)
-			goto set_flags_err;
-	}
+	ret = mptcp_pm_parse_entry(attr_rem, info, false, &rem);
+	if (ret < 0)
+		goto set_flags_err;
 
 	if (loc.addr.family == AF_UNSPEC ||
 	    rem.addr.family == AF_UNSPEC) {
-- 
2.39.5



