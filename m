Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09787478E25;
	Sat, 12 Sep 2026 13:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218135; cv=none; b=e7jLXanzocXxCRwhOgn4V1UCfFe/eAZsStOCZWBCEGeiOHdUZsMeLNof/L94e1/aFLp/iVCWVoLrcc77Q0Yc5e9MPNEPl35AyX4RjCA4tEAQn6mXj6ZFeOaP3kLX5ZwPn3WBI46mENracUYbWg6rdSQv9FG6Zu3ZOuwQMS1FK2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218135; c=relaxed/simple;
	bh=+hpabMe2ZQLkxqQF5Mk8D3nc1zu7KXa9MqP+sFDf+Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nikx1PmgUefS6InG2KNTXo0HtbR9Wl7oswsverxklogbr4Pls9rxdukurDbItK0VlrNzYmTXZa8HoyscSJycCwrYfwIZI48iRvFsmIThERCwyGHR+aKeQQm2Hxetu9APHa5prpMPAGETcFQl+UwB+VsN0dbK/mUPUijFVhqK8Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSeQpuxf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSeQpuxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4DD1F000FF;
	Sat, 12 Sep 2026 13:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218133;
	bh=PnTIJqTqaqlTBDpkdPYNAvuoeeXMN5cEW0hWjfrSyCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSeQpuxft75z7bCMMnn5CeuKDA2/60MMeuAaYK+u1pgGpJ+3QTtyRmOZIxdTXoIHE
	 TgWPS86D83LPs9jaaW7MpgxyjI9adBQQAMsb8GyIExM5UXwZZlOC/2lU2/fqhakG+e
	 pAn7v3CcVgR6CFUVeqoCRDH8Y47cb4CxggJOfr38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1065/1376] nfc: llcp: avoid userspace overflow on invalid optlen
Date: Sat, 12 Sep 2026 08:58:11 +0200
Message-ID: <20260912065631.294737298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 915929cd724f9..b2028016ed971 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -319,6 +319,12 @@ static int nfc_llcp_getsockopt(struct socket *sock, int level, int optname,
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



