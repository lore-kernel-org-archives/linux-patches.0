Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A6C355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301100; cv=none; b=mvaPBYKgFLWXHjZ4vIBhvd+5TrVyICq0rxgWWK2W4HKZWDya8Hnr0zYxIknh2/6+p1stqkZ+1CpAqcChMZDrUVS31hTgxYjfs7WHq0rCj0IOJ2nAqvb5CEMjTPU0v8rTJ+mSQx+cYvlt3/RVr2XWCby3D/d6b52COzr3e6VAG3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301100; c=relaxed/simple;
	bh=pFE7KMqNgpCOcihLdheVtz6wir2jtJW5f5QbLKUawRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miBu2rhf+bx7UIG/RLGjIGrJxROuk/IOG2rwY37pmBIT0GcKWK+qYNPXhOhQpnBmtIUMLNEffbxeohFmnUDGeOXAjZIvhmVdNPCF+EOMGrEPiJ6jOTmjtr0zS0HYEfeoH2CbMW8F0Spbr0nnSHADQVyL2lctN5Xlt/tFrmKUEGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gaqiy8fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gaqiy8fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924A6C19423;
	Sat, 28 Feb 2026 17:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301100;
	bh=pFE7KMqNgpCOcihLdheVtz6wir2jtJW5f5QbLKUawRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaqiy8fjmfvQLxCUE2qM9b1Ue/fh+F3AIOzny2aC/j/Lugo7r6cGNVXi4FSonHuYw
	 8qAi/nx4Ne9es11fE9qtZK1lXfccV/lCVNLZLa57zsj6KiX9984PU9ZvtxMPtOPAtV
	 6GC+01gnjSHV1P44LmeyWJxd+v+Mkdys5P87ZBOTcd6uZx9a9CYAi5h+Y0l0ObCZxw
	 AYY8eobHncdJVYkJ9PO5IjFJqt2m7hh4wljCHIUBfcRQjiz4iQHeyLOfXFmtNkhCPD
	 gjyWftBxqX0JeIDkJogRlK5+4DfayCXgXHvgbiHNHOCFzFDEoyt3Yfa0GIO9DtKa3U
	 zvCFNmuHTh7Ig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	sungzii <sungzii@pm.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 252/752] netfilter: xt_tcpmss: check remaining length before reading optlen
Date: Sat, 28 Feb 2026 12:39:23 -0500
Message-ID: <20260228174750.1542406-252-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 735ee8582da3d239eb0c7a53adca61b79fb228b3 ]

Quoting reporter:
  In net/netfilter/xt_tcpmss.c (lines 53-68), the TCP option parser reads
 op[i+1] directly without validating the remaining option length.

  If the last byte of the option field is not EOL/NOP (0/1), the code attempts
  to index op[i+1]. In the case where i + 1 == optlen, this causes an
  out-of-bounds read, accessing memory past the optlen boundary
  (either reading beyond the stack buffer _opt or the
  following payload).

Reported-by: sungzii <sungzii@pm.me>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_tcpmss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 37704ab017992..0d32d4841cb32 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -61,7 +61,7 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			return (mssval >= info->mss_min &&
 				mssval <= info->mss_max) ^ info->invert;
 		}
-		if (op[i] < 2)
+		if (op[i] < 2 || i == optlen - 1)
 			i++;
 		else
 			i += op[i+1] ? : 1;
-- 
2.51.0

