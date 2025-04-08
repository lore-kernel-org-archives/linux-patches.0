Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAAF19AD5C;
	Tue,  8 Apr 2025 11:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112386; cv=none; b=Vz4X4fzG9KV/DxlxvHo18+zqOQ20h2uTbM9mGYl1akDcDMZgN6wwBh9JiWJHsErCPftIsMIOL5q+xToZE8qoPIlKwQOEjv8Z0Y+8A3lHZ9iPOYqvb6nC7rt+5WikNnoS/v0xIBKBTyI9MB7VBDxYhHQO7LBxI2S/lfZzETvzfpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112386; c=relaxed/simple;
	bh=jyXgNkV3Mmof4wEPuDHNojYKIy3/TCB6BxUVBzXRRq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugLNgJ5HvdPaBcfacWPq8+hZtZo0DW2MQZDHoyqOSsbVYZEIjE7xJ07ythPoZUg1iVz9QJg7T3v0cP1s6GUOQG1FWYfI2ijtIWRymX2p7uAh2EmbNckpoYm3X+i55DR48D/nIvd9wbY4anlv0TFfrFDuXLzSq3oBHur09RTU8yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYtbdmm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYtbdmm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD6FC4CEE5;
	Tue,  8 Apr 2025 11:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112385;
	bh=jyXgNkV3Mmof4wEPuDHNojYKIy3/TCB6BxUVBzXRRq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYtbdmm6dYoDWN+qyyA4O9czdXP2ETlip5R/iHR4EL2qjauUFY5oo25XAXYTfD68/
	 4cQlZDBY3gkIVoVgy3ynst3W2ChI+V2iEa5JzA9ZexTKENgh6DgWJMVk+H06DnbsA5
	 iHd3Z52BMa4vClWr3DwNb9EJ5c69bG8V/j/Xe5nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/279] mptcp: safety check before fallback
Date: Tue,  8 Apr 2025 12:47:13 +0200
Message-ID: <20250408104827.718802645@linuxfoundation.org>
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
index 83e93a7e9b40e..cfb6aa72515e8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -872,6 +872,8 @@ static inline void __mptcp_do_fallback(struct mptcp_sock *msk)
 		pr_debug("TCP fallback already done (msk=%p)\n", msk);
 		return;
 	}
+	if (WARN_ON_ONCE(!READ_ONCE(msk->allow_infinite_fallback)))
+		return;
 	set_bit(MPTCP_FALLBACK_DONE, &msk->flags);
 }
 
-- 
2.39.5



