Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080822DF73;
	Mon,  8 Apr 2024 13:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581580; cv=none; b=WUmyUSjAgtyM2PLxKsQfvjU/Jp1kQEtvqM5hRz0A70FCFVnTLisyeNMhg8jO1hJ7Z88mdNthDXRqVt5vJ4EwBMk4dR5TWBkyEUcoReZfkD6+xa82SXCxkMPVt8Ci07kykuj4YuwEC1o85VyC6KKt0unmR85U0hTvn0YeaDFjuHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581580; c=relaxed/simple;
	bh=C5jzM+G0U6DMZguxCPOMjdh2OrK+zl1TaMKsWGiN7/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIyJmZNC8EGB5WnlbmIZM9rGiIB5CF0g0wYR6kH4s+OcBzgMcwtAaalUmHh9r6+bSnHo3ifgkToGYHUeTzkfFdlpyYzx/v9fKNknwnSxjd1Ja+mUAk9kv3lZoAu7h+rOIlvbe07BWIXethA3QmBju4HqJ9UIE8ngEFPvZWM3E40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCNhsNbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCNhsNbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5FFC433C7;
	Mon,  8 Apr 2024 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581579;
	bh=C5jzM+G0U6DMZguxCPOMjdh2OrK+zl1TaMKsWGiN7/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCNhsNbeA9QPLSu8gQq1mrSLqjXNMOCsrwbm1HUG6bEL/W0bgwFQTFGjcoU7HOAw8
	 eYHSFkpQpiDC0fydkJmkujY9vBZU0DzmIZBRDEOwqyfh6LOIYCR/W9H+BEeQUGB0sx
	 DYotL/4njG9B0Znt6D3M2vvpnCgAZ3/V62RUuVig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Salvatore Albano <d.albano@gmail.com>,
	Stanislav Fomichev <sdf@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 002/273] xsk: Dont assume metadata is always requested in TX completion
Date: Mon,  8 Apr 2024 14:54:37 +0200
Message-ID: <20240408125309.358859480@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit f6e922365faf4cd576bd1cf3e64b58c8a32e1856 ]

`compl->tx_timestam != NULL` means that the user has explicitly
requested the metadata via XDP_TX_METADATA+XDP_TX_METADATA_TIMESTAMP.

Fixes: 48eb03dd2630 ("xsk: Add TX timestamp and TX checksum offload support")
Reported-by: Daniele Salvatore Albano <d.albano@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Daniele Salvatore Albano <d.albano@gmail.com>
Link: https://lore.kernel.org/bpf/20240318165427.1403313-1-sdf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 3cb4dc9bd70e4..3d54de168a6d9 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -188,6 +188,8 @@ static inline void xsk_tx_metadata_complete(struct xsk_tx_metadata_compl *compl,
 {
 	if (!compl)
 		return;
+	if (!compl->tx_timestamp)
+		return;
 
 	*compl->tx_timestamp = ops->tmo_fill_timestamp(priv);
 }
-- 
2.43.0



