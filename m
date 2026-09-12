Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A5D23909F;
	Sat, 12 Sep 2026 11:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210924; cv=none; b=WkXVglPV69ZIP2DJYD8uYarR6gW69XTsfIhg8eBr9gk1p/06M+pF/x/xIbZsO6144hSq/lAl2yO3K+nb6TVKeQi8PYpNEeDSmAiZJvGSGvwFbTHTfk8TAiL7n9y/c5CETgPARYdiN0lkyl79KQ4u03DrXBhaRzgJtSzPvSVl0GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210924; c=relaxed/simple;
	bh=lgCL/pqhRVZBDDJQrrodX5EJWtvq+6atY2U0BNBgUPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFChDFys6jw2bLrQO5OlkljJ+H0qISKHZ1N3A1gONjpFvYKSL07BnNGXWlxbl9W2Hxtm2Q8FI1cZMd1PMxOqxZ+YZ8H0NGPBJJfRekF1lxFiMnSTBME3MNRXPcg+RB5NBk8D4eZvWZnC7ZCDy8ggwngMLl2yAwRNB+O/2rIIHQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K26628E3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K26628E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2B11F000FF;
	Sat, 12 Sep 2026 11:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210923;
	bh=Tlas3cdE7PGHw4dAPLAkn547OFyqU+IU2hGP4IC725U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K26628E3kq9TpXLFZvO6dyLm6HmEcVOWDtqHPDbWC2kTVEENAtbjC0kVepLDABrNf
	 +giiLqgweBTarvQsC3y1xTg8s9CkKYzigJG6PDkbVKVO6SsDteGQO3EPF1tnFwmnJ2
	 OVpuWOi/tFdoq2hArvt2vYYjGWF+/qALy0jMosBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1125/1518] nfc: llcp: avoid userspace overflow on invalid optlen
Date: Sat, 12 Sep 2026 08:54:54 +0200
Message-ID: <20260912065648.903953319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



