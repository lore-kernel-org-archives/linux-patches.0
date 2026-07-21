Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599473C10AB;
	Tue, 21 Jul 2026 22:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674047; cv=none; b=hxb/noQ8GmuAWPshGQr/OSTdnqZzuM5Kr93a0t/Fx/PS2fASNWiwyLZ3Afixlq+PS646fnKtV8My/giP9zuEccyv/URIX6Y6spRwy9W8bzrm00WYMUQ7tvZ9k7sc1hRY+qWqci2mui2iTx3a78Acg+MMAOkO+CiAYj3KpQH7jtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674047; c=relaxed/simple;
	bh=J6ZnDi0I54wOj6VZvF2IgAuL2AsSyV2dCVPPWblZl4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bb26RQWYf2WBaYH0UeTAnlsvtSqCAt+q+7v6cMyOuzc9yqg8VRSuyee/Yi6TZCF8v4D1NtoRXN9a669ogeZkg0nUsEcD0zsJOSY79+EPouKZK1tGD3K5lDYj9vDCD4BScAlQuDJ0RrvzGV9VSR2PZwYqK+ix8Ynk5z/l6B6J9W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gRsFfI9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gRsFfI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E601F000E9;
	Tue, 21 Jul 2026 22:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674046;
	bh=vRIb9FGMeytVePDxiadV0alyZe+611mGHhHpimFzgLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1gRsFfI9m01j7qhiIVF8bsfXx5py9BJDBpnzKjXeUxwR5KLsB5U+3pgAC74xMAzVC
	 aJNWsEEON/cq820iN0kep/29IB45SkoIElyIbjYC8R768t0PVSHDJb3cnG0fMcsCwo
	 GT4OiccDAZURDVCNmEgIW+tzzsM/x2kGXmgad3sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 392/699] gue: validate REMCSUM private option length
Date: Tue, 21 Jul 2026 17:22:31 +0200
Message-ID: <20260721152404.537751052@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang <q.h.hack.winter@gmail.com>

[ Upstream commit d335dcc6f521571d57117b8deeebc940836e5450 ]

GUE private flags can indicate that remote checksum offload metadata is
present. The private flags field itself is accounted for by
guehdr_flags_len(), but guehdr_priv_flags_len() currently returns 0 even
when GUE_PFLAG_REMCSUM is set.

This lets a packet with only the private flags field pass
validate_gue_flags(), after which gue_remcsum() and gue_gro_remcsum()
read the missing REMCSUM start/offset fields from the following bytes.

Account for GUE_PLEN_REMCSUM when GUE_PFLAG_REMCSUM is present so that
malformed packets are rejected during option validation.

Fixes: c1aa8347e73e ("gue: Protocol constants for remote checksum offload")
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/gue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/gue.h b/include/net/gue.h
index e42402f180b75a..e5246d5d3e87d1 100644
--- a/include/net/gue.h
+++ b/include/net/gue.h
@@ -77,7 +77,7 @@ static inline size_t guehdr_flags_len(__be16 flags)
 
 static inline size_t guehdr_priv_flags_len(__be32 flags)
 {
-	return 0;
+	return (flags & GUE_PFLAG_REMCSUM) ? GUE_PLEN_REMCSUM : 0;
 }
 
 /* Validate standard and private flags. Returns non-zero (meaning invalid)
-- 
2.53.0



