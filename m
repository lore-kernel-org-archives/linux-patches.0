Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B1E1C9B6C;
	Wed, 19 Mar 2025 14:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395220; cv=none; b=ZJ1SuEf2qto3Gw17WYHkDrDrMthNK5oMiAznaiBg2JsufI+/T3WAKhfwUDtksghyd0Clv57m8iHOf4nn4t6R3AtZ5xW+OctJuZ2TyYLZ87zzCmt9gELPJxAsJbhKMsy0wGZLubSnl8FmY0LOu6gnGhSrHDyQ+Yr3+DQvBJzZy7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395220; c=relaxed/simple;
	bh=U6dLSraKUc/JSHhNglrGU5h1WYOz3nnmjQ9f9cSqeY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bd3SibVWlwDfaUDuPFhmL2vWSRTs7wcqiS4kEXLPbVLne4MF3I8FgtfGcwvWugpgVHvWWoI6AsqALLs/xBG37Ak7R/cNtfZCiU0f+gFFTt4kKMkzX0aJ/ACw+bBuHaPC0yE3G+LO2Cq5TW7bIsAiMTXe8bqeKyv7QzS2l5DzD38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZjQj++S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZjQj++S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7B0C4CEE4;
	Wed, 19 Mar 2025 14:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395220;
	bh=U6dLSraKUc/JSHhNglrGU5h1WYOz3nnmjQ9f9cSqeY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZjQj++ShT7iidm0bz9l9dYpoABDZw5NbT5s92R7ymrBI0t0w5PYcJto/JgqQKXsr
	 42Y9qqwuctvDgtSfESq0MqAmi4b2EoKxFJgqMH7mb7P+Fq4whq3zXdx1dDw3utDjQg
	 TaRG2++Mca26edOD7m9/fBzdkWOPdW9hOxiKJ3mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/166] mptcp: safety check before fallback
Date: Wed, 19 Mar 2025 07:31:01 -0700
Message-ID: <20250319143022.460093076@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0bb0386aa0897..d67add91c9b90 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -1103,6 +1103,8 @@ static inline void __mptcp_do_fallback(struct mptcp_sock *msk)
 		pr_debug("TCP fallback already done (msk=%p)\n", msk);
 		return;
 	}
+	if (WARN_ON_ONCE(!READ_ONCE(msk->allow_infinite_fallback)))
+		return;
 	set_bit(MPTCP_FALLBACK_DONE, &msk->flags);
 }
 
-- 
2.39.5



