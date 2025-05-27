Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8611D63EF;
	Tue, 27 May 2025 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367880; cv=none; b=GwfSgyMZAayMdt8euPInwt1MciIPZrL7NQCEFtiJKpYdvs/NAxfcWLRNygnI39yZ/IWEuvRcq6PgF+QOPvdH6tqNBWCRkIGMFsA+Axh9R9m9tm3l7WzOvMymwyRSzgfTezpd0e0D5krg2ELpBhCc6/KDkutS9ZxCkrUIs+yFLLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367880; c=relaxed/simple;
	bh=+F6VX9T6mJZ8JeucictaDgezntIh0PEFxFocIVZ1pc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiLMHU/t3/M5pUsdRUw1Fbv2nuc8SMkqtu+FXvPqRk8zn7mh7bMXDNUaMCRN4/CO7Ldq6Tx+qtJn5qG4PG6/k8FNIX+nQLfCZ2gp3LamwfHlF3rWkd1fVgGK9C/f0MskSUj2fi7u9xGHFb6z3ufk2/jN3mjCpyl3lu5psOKoQGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3u71qOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3u71qOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C252C4CEE9;
	Tue, 27 May 2025 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367880;
	bh=+F6VX9T6mJZ8JeucictaDgezntIh0PEFxFocIVZ1pc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3u71qOsz/IS8QaGCR4gDIHVTjuGL0lBdasqNDL1Q6zT8bYYLL6eoPygAp/kEQN5/
	 hhe7Tlr0X7kq1mYlmUH3QVNiQN5wg1p8FnKAmplSZxfxlre8D3cg6hQ1NIsfhNiKBZ
	 uNTrnrnPYrk/c0RDdlMgGtNfW7R+mC+/L+biPopM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 511/783] xfrm: prevent high SEQ input in non-ESN mode
Date: Tue, 27 May 2025 18:25:08 +0200
Message-ID: <20250527162533.952102974@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e3aa43a50a6455831e3c32dabc7ece38d9cd9d05 ]

In non-ESN mode, the SEQ numbers are limited to 32 bits and seq_hi/oseq_hi
are not used. So make sure that user gets proper error message, in case
such assignment occurred.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 82a768500999b..b5266e0848e82 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -178,6 +178,12 @@ static inline int verify_replay(struct xfrm_usersa_info *p,
 				       "Replay seq and seq_hi should be 0 for output SA");
 			return -EINVAL;
 		}
+		if (rs->oseq_hi && !(p->flags & XFRM_STATE_ESN)) {
+			NL_SET_ERR_MSG(
+				extack,
+				"Replay oseq_hi should be 0 in non-ESN mode for output SA");
+			return -EINVAL;
+		}
 		if (rs->bmp_len) {
 			NL_SET_ERR_MSG(extack, "Replay bmp_len should 0 for output SA");
 			return -EINVAL;
@@ -190,6 +196,12 @@ static inline int verify_replay(struct xfrm_usersa_info *p,
 				       "Replay oseq and oseq_hi should be 0 for input SA");
 			return -EINVAL;
 		}
+		if (rs->seq_hi && !(p->flags & XFRM_STATE_ESN)) {
+			NL_SET_ERR_MSG(
+				extack,
+				"Replay seq_hi should be 0 in non-ESN mode for input SA");
+			return -EINVAL;
+		}
 	}
 
 	return 0;
-- 
2.39.5



