Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1F925A2B7;
	Tue, 25 Mar 2025 12:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905616; cv=none; b=Swa56ZVBEKJQIsiQyhI50qqlNoiBPzQwIBVQVtMbEfx6mAiXTZw1oTzBnzt8hAPSS15xsSEztIibBJhwVNJ1AYWwmh0yraczB0ndRkEKBrHjCuks5I111rETtt1GuV6eO14BfV9PP7Yi2AZtg0wYz4mgQVW0EI4gDa2jl0wsfE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905616; c=relaxed/simple;
	bh=OBwoZUAfsAzTo3jX2S1O3c4HNUEptGHwxOnp0zw8EYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFHBYaMVDaJ2KEwaCnGx6KbgNphC03VAvejAC7CMS3lgF3UY12Ibu7VYlQ4xtlCmBVNufHkgDp1Y92Z8IGi4fyTPn1UOZoAcNbyDPmVVt67SmXgEdji1o5h66rqBZQNQuCOTfsBXkb9AAY54pDKn0QfgoRrkIBOFHi8yYSIy0nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s38a7fUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s38a7fUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D792AC4CEE4;
	Tue, 25 Mar 2025 12:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905616;
	bh=OBwoZUAfsAzTo3jX2S1O3c4HNUEptGHwxOnp0zw8EYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s38a7fUvkUWPSmj7EK2F/1JHLeyUaECCaAtlHP2U4FBkr/oiQ0dI+WIn9j4GmuSoT
	 +xPikLJ168MDPHm2Lpnlza+nDfxBeh3dqRLa7MSzKjF8LWE27U1dHk5hvEx1/MZWqE
	 mP2zotVn0oyZ4fAf0xxr0qtFLHlNfvtNJPMD8Ylw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/198] mptcp: safety check before fallback
Date: Tue, 25 Mar 2025 08:20:31 -0400
Message-ID: <20250325122158.453189591@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 77e727d81cc24..25c1cda5c1bcf 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -981,6 +981,8 @@ static inline void __mptcp_do_fallback(struct mptcp_sock *msk)
 		pr_debug("TCP fallback already done (msk=%p)\n", msk);
 		return;
 	}
+	if (WARN_ON_ONCE(!READ_ONCE(msk->allow_infinite_fallback)))
+		return;
 	set_bit(MPTCP_FALLBACK_DONE, &msk->flags);
 }
 
-- 
2.39.5



