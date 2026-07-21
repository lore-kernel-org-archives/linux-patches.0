Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B88E415F1A;
	Tue, 21 Jul 2026 19:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662706; cv=none; b=DsUOuuG0NJ08/93oVtP48AtJwTLtllqj1wX3SNxLc0PZeP6jtuWFYxwNzIK6yH0h/KoaN+lyp6slKX+35eESLwbawRF0Brp3zXa0n4FZLqXAT49+PHGCai7vMhBpJRWdk/7coNM9tkbZ4OpU/NhvQLS3GYTuPoaVeR4S9baLmCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662706; c=relaxed/simple;
	bh=oygVAL/t/iAmDZU/Rouu7gjWJHs0YllCj5+NrDuEDhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o82MR7bGgQ8e46hI/VgpCrTKlKvc8cV3THTeMjDj7fpavLbWXRlJN4Twcx625j/Z/X1WpCioAilXne9eePv08eSExF0K6q3p3EVPfj12Hk/miV7I7Ag4+WZ1NaXy03Patp1gcdEtSNnTyCu4Nfnd4HyKrxLZLPa4+Y5IfLU9Uvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHDqSKEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHDqSKEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D8A1F000E9;
	Tue, 21 Jul 2026 19:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662700;
	bh=SFOBui828588mPX0D1R/X2dKyGAtTp3E5blb8tjAlaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHDqSKEXTNgGXoa4gTYyXfNfZniBlHmFrUH5D6JQKfOE0CkCExzyW7eEHXSHoS4yA
	 f7HRrx7ot/dA1YA6oMfMCUkOPeMZ1WZVtF13nMIb6AptxmUZdtdLzx+LD2ZolUuoQH
	 FztK48Z1bHjS6ZG+Qrd7th/Ov2iRPMYJDoXUTp34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Hicks <code@thicks.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0543/1276] apparmor: aa_getprocattr free procattr leak on format failure
Date: Tue, 21 Jul 2026 17:16:26 +0200
Message-ID: <20260721152458.271153354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit fea23bf73f0cae8ccb1d0684e4a3003874771f41 ]

aa_getprocattr() allocates the output string before rendering the label
into it. If the second aa_label_snxprint() call fails, the function
returned without freeing that allocation.

Free and clear the output pointer on the uncommon formatting failure path
before dropping the namespace reference.

Fixes: 76a1d263aba3 ("apparmor: switch getprocattr to using label_print fns()")
Reviewed-by: Tyler Hicks <code@thicks.com>
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/procattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
index e3857e3d7c6c26..7ed6e4fe3f55ac 100644
--- a/security/apparmor/procattr.c
+++ b/security/apparmor/procattr.c
@@ -54,6 +54,8 @@ int aa_getprocattr(struct aa_label *label, char **string, bool newline)
 				FLAG_SHOW_MODE | FLAG_VIEW_SUBNS |
 				FLAG_HIDDEN_UNCONFINED);
 	if (len < 0) {
+		kfree(*string);
+		*string = NULL;
 		aa_put_ns(current_ns);
 		return len;
 	}
-- 
2.53.0



