Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6A82594BD;
	Sat, 12 Sep 2026 19:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240186; cv=none; b=XI+Yg39qXdDfvr+AvGNyvyjp7Yq21XQfoHTGVT7Mrug3doOA/bNwDG0dlToPXusYUyS92oJenIiFKo1CoLPKuZIEezGu/oEvJ0qicaNFgm/0bbalovEJCVInhWJesOLN7uqNQ8TumAMDDVmsjGnfVafJ/lPQeHUiYBvUo3hSpMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240186; c=relaxed/simple;
	bh=mhrS9oRwvKdKf3eAi3IdVDQ6cBHBBxGqmq9UrvMNYeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PemWg/oHfPHHRbV398/knZg692b+wW4oNvGSU0h9RZqE/893PAzQCTEc1Mm5hS7E1WU25jPumzvIctIm5hH22ir75nNaZsuykYp125ImmOSRoXAwQnwt5uLFUpL/bAFn2nsNQ4x+RHJIq/2QDFWGJbNBeEzsbepvj5weW+dhqAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+lwHpek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+lwHpek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503DA1F000FF;
	Sat, 12 Sep 2026 19:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240185;
	bh=M8VaZ13mSpvA8/MExV+fJGftTzoBp4XWKUGM08HedCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+lwHpekLXKZXa7/HHcVOb9/3Zz1OqwEL+wwbSBCrogmDHtQI1EG9NSx7MRnSQGtv
	 l9FKfUANDJVlHOXUvWxKN/0kPNOFQJBn5o1QjjK/KrcotJVXh3AGgFcRgWwLjgN2iH
	 5SxkxKiaTxZ9VdhPcbW0w6J5kfJ1E0wngY31rXSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 773/935] nfc: llcp: avoid userspace overflow on invalid optlen
Date: Sat, 12 Sep 2026 09:03:23 +0200
Message-ID: <20260912065544.558400012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 99985bfa8336fadcc69190ba2dcbd5386af3d661 ]

nfc_llcp_getsockopt() casts optval to (u32 __user *) for put_user(), so
the kernel always stores 4 bytes regardless of the caller-supplied
optlen. The existing min_t(u32, len, sizeof(u32)) only clamps the length
reported back to userspace; it does not constrain the store. A call with
optlen < 4 therefore writes past the user buffer, violating the
getsockopt(2) contract for all five supported optnames.

Reject any call with optlen < sizeof(u32) up front. 'len' is int, so a
plain size comparison would promote a negative optlen to size_t and slip
past the check; an explicit 'len < 0' test is added first to catch
negative values before the size compare.

Fixes: 26fd76cab2e6 ("NFC: llcp: Implement socket options")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260521-fix_llc-v2-1-ab44cc09179c@debian.org
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 57dea580c0291..0ba5ffe0ce6d1 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -314,6 +314,12 @@ static int nfc_llcp_getsockopt(struct socket *sock, int level, int optname,
 	if (get_user(len, optlen))
 		return -EFAULT;
 
+	if (len < 0)
+		return -EINVAL;
+
+	if (len < sizeof(u32))
+		return -EINVAL;
+
 	local = llcp_sock->local;
 	if (!local)
 		return -ENODEV;
-- 
2.53.0



