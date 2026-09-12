Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432742E718B;
	Sat, 12 Sep 2026 08:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203163; cv=none; b=mXktUjqyyTrVsyEaaJvfkNkHNyEe8d5nF6JOHUQB2Y1CXUlKWysk2SEQzRKaobGNUpj0iquVMirGFTsvSQd/YKIuP5KT5NUl9L6dF/Pp6nL1gTWA1WIS0BLVPueaPZ0XSsDixZAq/c4uoCrMXCY+15uPkMxOGy6RQImJPecHnWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203163; c=relaxed/simple;
	bh=IeG0ecUiey9m7FRN9GPkkp2pbFBHzEuIEX6MSnYLvLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWXK5ikHAIXHlebdee/q9ZweXKxp0Uxz3DXxLe+LYIVL04FwQk1xYVdtyaPmSUjppxxCfP1tPey0Xzdlf1jBv8fi+ZJ/6J1rURSLOmOUhEI/GtDytUIshI0tx+IY87xkGY7cKC2JkogEeXrg+6vfSN/YY8LzZPc3pJvuxHy3x5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qehwO38N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qehwO38N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478C61F000FF;
	Sat, 12 Sep 2026 08:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203162;
	bh=64BC+eUkOJeiPD52Aowa7m3HmDTyba9apL/9QqwV4Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qehwO38NkhzKCfx5mjzXf0fy21qa2pI8L/GLaHr91oVkHJj3qyKCw9n3JHGhQt6vr
	 Sdg4y53/Twj7UPPRTs/BLAxk9kYwf8lxDQlCvodV5Ly6j0qqf3ZoNd+jOKeZk9Cw+O
	 zx7IUJnRrfYPk+Uvp/JMKHK3Vp6NtPcfI/H4SpBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1352/1815] nfc: llcp: avoid userspace overflow on invalid optlen
Date: Sat, 12 Sep 2026 08:51:42 +0200
Message-ID: <20260912065720.764798960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index feab29fc62f44..4b162df0c3fcb 100644
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



