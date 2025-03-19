Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EA91B87D5;
	Wed, 19 Mar 2025 14:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394931; cv=none; b=qHiKlq6QdcSS8yoMbyNmN65ruzO1wCij7cltpzMc0FaRH7BG/hjAmNoTdveIEYjEWwi9zYzlfqAAUI24JL/nihAcx61WxDPWFlmR4hqiQat4tTChiCfxZr7m+c25PjOhjdElu13AMCQScjNAb/YUGnD7XLUj16Alox4JnENkgEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394931; c=relaxed/simple;
	bh=jvWZhihzaUK81cKRXWhLZiL/UnYAfUkmx7PcMuiJ5Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAtLvPyBJSa7pMTuuE/xAvc8naCIbfR/iTXMtADdjuAo1zNW2orDCLaJg4kqdpqBEk4wqVudHccJzWsRQLyStAO28xNnGOloIGI5kGy7ybUXe3Bf5zCuXkiUU3XW1FRWZdxLkN0gUa5n0teWjQuoYh5p31YgSLMnlkrxQxDznUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULgAXel3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULgAXel3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12CAC4CEE4;
	Wed, 19 Mar 2025 14:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394931;
	bh=jvWZhihzaUK81cKRXWhLZiL/UnYAfUkmx7PcMuiJ5Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULgAXel3H3AhY2JErSq+sOe+ukapO/z4FrBDEn1P1N74Qa0UqoUpv6UsOFNmEj2tp
	 keGByiTbdqRYBiHo30m3cLC0im14xdviW53+eAv199uhB9CO7Cv4KB+gXzwoRmX33l
	 L264fo7L/VRHqMHquywMmL0jNDCWlaJrzayWJ/B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 145/241] mptcp: safety check before fallback
Date: Wed, 19 Mar 2025 07:30:15 -0700
Message-ID: <20250319143031.307683628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit db75a16813aabae3b78c06b1b99f5e314c1f55d3 ]

Recently, some fallback have been initiated, while the connection was
not supposed to fallback.

Add a safety check with a warning to detect when an wrong attempt to
fallback is being done. This should help detecting any future issues
quicker.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250224-net-mptcp-misc-fixes-v1-3-f550f636b435@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index b70a303e08287..7e2f70f22b05b 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -1194,6 +1194,8 @@ static inline void __mptcp_do_fallback(struct mptcp_sock *msk)
 		pr_debug("TCP fallback already done (msk=%p)\n", msk);
 		return;
 	}
+	if (WARN_ON_ONCE(!READ_ONCE(msk->allow_infinite_fallback)))
+		return;
 	set_bit(MPTCP_FALLBACK_DONE, &msk->flags);
 }
 
-- 
2.39.5



