Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE2135973;
	Tue,  8 Apr 2025 11:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112308; cv=none; b=fM+P3FjY9vODW3vWwFKJWzrgWyf0xDDVLOE2t6R8qiYGOeqMcbSPbfL524BkcxFG0fzdVLb8Svpvt2be2dDSfGUILVP1qu2AXxZVJId1M1cfWrOD7kXZJkwxfyYGj5aDX0WqY8LVsnSlMRJZIjQrMMNQZ0zA9NYOmc84+LAbaVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112308; c=relaxed/simple;
	bh=9QEO8RQAORjNXA1x5BK2+pBkWRUj6KXc+NMnzMc0nCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmP50eDQUJnjU2Z4ytoXqaDdFCGvMNJw7E/kCs7F85dLt6QIRnN0Ket5EVxpeYnkJExGvfK7e7utyqvU6yriAvlbhiC2I7jjpDuyC0K7lzHGIVB6vXe5rLLuFVyYSBWYeD/Ydywvtn6Mkqx1I7F6QppHe21M0pHjqAK0UKqeEpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ravrf7yS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ravrf7yS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1D7C4CEE7;
	Tue,  8 Apr 2025 11:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112307;
	bh=9QEO8RQAORjNXA1x5BK2+pBkWRUj6KXc+NMnzMc0nCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ravrf7ySGK/OapCqtVUgyh7D3d9uJSvqOqK6eWr+dAfyy5Riq8TZUYj+OKg+hJAxi
	 9Q14hak2TnQupgKdlFOaKO9pvvaXmr0VTZEIKmJWnGRrDrg4oUsAXgdMv7IhSnPndI
	 2rEOrdBtHN5qTa7/Jc1fle8ds7niey4LZDbp4b1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pravin B Shelar <pshelar@ovn.org>,
	dev@openvswitch.org,
	Kees Cook <keescook@chromium.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/279] openvswitch: Use kmalloc_size_roundup() to match ksize() usage
Date: Tue,  8 Apr 2025 12:46:43 +0200
Message-ID: <20250408104826.929081205@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit ab3f7828c9793a5dfa99a54dc19ae3491c38bfa3 ]

Round up allocations with kmalloc_size_roundup() so that openvswitch's
use of ksize() is always accurate and no special handling of the memory
is needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: dev@openvswitch.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221018090628.never.537-kees@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a1e64addf3ff ("net: openvswitch: remove misbehaving actions length check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/flow_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 1cf431d04a468..b8607c3fee4be 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2281,7 +2281,7 @@ static struct sw_flow_actions *nla_alloc_flow_actions(int size)
 
 	WARN_ON_ONCE(size > MAX_ACTIONS_BUFSIZE);
 
-	sfa = kmalloc(sizeof(*sfa) + size, GFP_KERNEL);
+	sfa = kmalloc(kmalloc_size_roundup(sizeof(*sfa) + size), GFP_KERNEL);
 	if (!sfa)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.39.5



