Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9F520FAAB;
	Thu, 27 Nov 2025 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255696; cv=none; b=EK+yn6CuEbEyI0uo5xVmVIFwXLyXBZ6Ddv1oXfWNM/BV9oyNOLSJ1eIxOzRxCZ0GEqTQAFMhqjBgBB2tTgblVc0vUgkT7IRRuydi7el2kPKA5iuNzXgm4W+C/3M0ZOCVf6yud/96DhpIFD/ud0jg5542rDNgfZZNCDA5c+JEm3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255696; c=relaxed/simple;
	bh=oql9lePDm+YmHWPfaep3wovbc2N+jpQlOdZllh97awY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrmAQJDiSa0rLGq6BxnUpzIq6Gd4i1Uc4M5UZpGjVBm3qbNRD836NZXO5WaJIe6ml2oM4qHFsE94KxCeRFECsisbyrruIFDEol73OAsq1inO+fr20TWhtOnOz/obloRURYRgVmVmE2YjXagzhg+FPm2Wexgt2u9lhqsCDY5iPyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDUBcgAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDUBcgAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF777C4CEF8;
	Thu, 27 Nov 2025 15:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255696;
	bh=oql9lePDm+YmHWPfaep3wovbc2N+jpQlOdZllh97awY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDUBcgAKTPUnhjNWBIcUhXwBCzLWPBPZmvPOXIRqg57OaXE3J4qwh1ZbCoXjwxhxm
	 mSxcjWtJtWKx9miUiW7ZfmiTu+3L7u4L81PJ+15FmgPHPVwUBWI9NH5mpVr38ReOmq
	 VzH/7x/KB7UZ0WDLij/RN0byWNNXUuaDD9uPwClI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 082/175] xfrm: call xfrm_dev_state_delete when xfrm_state_migrate fails to add the state
Date: Thu, 27 Nov 2025 15:45:35 +0100
Message-ID: <20251127144045.960349511@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 7f02285764790e0ff1a731b4187fa3e389ed02c7 ]

In case xfrm_state_migrate fails after calling xfrm_dev_state_add, we
directly release the last reference and destroy the new state, without
calling xfrm_dev_state_delete (this only happens in
__xfrm_state_delete, which we're not calling on this path, since the
state was never added).

Call xfrm_dev_state_delete on error when an offload configuration was
provided.

Fixes: ab244a394c7f ("xfrm: Migrate offload configuration")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 721ef0f409b51..f8a5837457a35 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2158,10 +2158,13 @@ struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
 		xfrm_state_insert(xc);
 	} else {
 		if (xfrm_state_add(xc) < 0)
-			goto error;
+			goto error_add;
 	}
 
 	return xc;
+error_add:
+	if (xuo)
+		xfrm_dev_state_delete(xc);
 error:
 	xfrm_state_put(xc);
 	return NULL;
-- 
2.51.0



