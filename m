Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033386;
	b=xq/AlXyCKsGkeycNDvP8LEA2ydXdAVxYGoTyg9fRWHik6LUTEZN39Exwt/sNSfFLLLFP
	 kFcmNqRmir7kWTkk2R9P/m7F+ZSzxrVNpv2Drc4chrlDKGzEaSCmZcnyn1lza0C2R79b0
	 Y7ESTLQvz6FhanY3r7X9Qmn/tM/Va5YUmLYDwQ8jWFe8ez4U0lzI9yDmtPNDigAOeKFaQ
	 Ntwp7GloHtuXr6kMm9w/R4lVEoXT+et/NBohjTROA07Ze2xQTlCL7IG1a1vR2KFUW9LRc
	 O3rgP+r1Ah4WkTt2Etf3DHJbhzmUt7bsfLfP/xGdWkzMbxlCckvSZxVn24z9YYfKhDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w92P6uW07E4/YbfxxJObTQdSH31TsQ7iINntHSTnWrM=;
	b=fdMB67Ebtw7iMa38ybkb5V+iDiFoOQ6TjOSIvqYTaIGBuelQf73mBSobfLPpp3tRLVMq
	 DPQn90qQm2TWFU+HKGQiHGHmdnZW+DNHZiC89aNNjLrt0x07Azbtt4tiPzKXkLdir0ra+
	 BMUb9zz5ftKG0cbyoi/RUSAZEKI/gJsQAn98easSUGAi7rOiIPsank7ki0vzK8uuJKrqg
	 1cTfOmq/aXxPHCI6ZNWuRVJ2Bv4OnqRPwk61RYKIpxKKUPnV1ZmWIbyC5QvfmV603XGhW
	 cM9HZS/Or2wHmj7kYiYXtWnsm2PxEZL/+LQ+f0RnroJ1zt72MEqbd/AFifoIElkTvnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J48bKKa3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF1E606A31C;
	Wed, 18 Nov 2026 20:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J48bKKa3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F881F00933;
	Wed, 18 Nov 2026 20:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033386;
	bh=w92P6uW07E4/YbfxxJObTQdSH31TsQ7iINntHSTnWrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J48bKKa3vCOJ1C8uByEizSeEfvAyodcKozMnbS15cI2JEARCzKjy/ZOJtQhwC2Rd2
	 Xs+HqZvYuh+WWS5HXp6CFKRdZoLA9FTgBFrGlAIQnLuomL68IEECgQ+LfzthY8UC7b
	 lSmzwDenf1B2RSmjiAn+ju3zpHtBvBo64E08AfaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Manuel Diewald <manuel.diewald@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.12 1751/1756] apparmor: fix NULL pointer dereference in unpack_pdb
Date: Wed, 18 Nov 2026 16:04:38 +0100
Message-ID: <20261118150119.238178722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgia Garcia <georgia.garcia@canonical.com>

commit 7681ca43d2b1c776e62fe77e3167835fb1ab8319 upstream.

pdb->dfa could be NULL if unpack_dfa fails, causing a NULL pointer
dereference.

Fixes: 2e12c5f06017 ("apparmor: add additional flags to extended permission.")
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Manuel Diewald <manuel.diewald@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy_unpack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -800,7 +800,7 @@ static int unpack_pdb(struct aa_ext *e,
 	}
 
 	/* accept2 is in some cases being allocated, even with perms */
-	if (pdb->perms && !pdb->dfa->tables[YYTD_ID_ACCEPT2]) {
+	if (pdb->dfa && pdb->perms && !pdb->dfa->tables[YYTD_ID_ACCEPT2]) {
 		/* add dfa flags table missing in v2 */
 		u32 noents = pdb->dfa->tables[YYTD_ID_ACCEPT]->td_lolen;
 		u16 tdflags = pdb->dfa->tables[YYTD_ID_ACCEPT]->td_flags;


