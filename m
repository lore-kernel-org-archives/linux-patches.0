Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057A613BAC3;
	Thu, 23 May 2024 13:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470484; cv=none; b=Zz8rvXcoykXqyEwbFjRoP6olrHdulTnehmYcvegxzX1lmpgADsKY0FW2sdVcVk+uQRD3a08CC0LUFvkf8RIHLIbdXMxs6XmwbqPGK6hYxNrK0Aj/MIndBSeuNElLC/y0zOne7kFcpmFcsmVHgupZ5VPLigp6nfUR7k/TAB509gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470484; c=relaxed/simple;
	bh=wNFDdiWuvPW+DQoq784SCevZCg+2zfwLu/fDU994n5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/xzHCIfPpuFyGrh3uLuKfFZe/aZqbjpjEtBwwUPaYMR8uWZOqcn07zEFXZXHzBxJEpDYcverwzgKOuDLY6CaT13RV+DBVlfQ7tmCqD9zSwqLHj5/2yxN9MI4adoEr/dzqBwq3DMot+AaHMDX1Okvf/hEJSOj8j0D1dz48aCO9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EufFEFtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EufFEFtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EF7C3277B;
	Thu, 23 May 2024 13:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470483;
	bh=wNFDdiWuvPW+DQoq784SCevZCg+2zfwLu/fDU994n5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EufFEFtxRIOeHqLaBC74TJ2bKEbkXDIzKQ0Wfa3zjS8Jz16am6EwIVcUx/2IYd1xL
	 JR1ZO/ENdDFvVMb0PX2NvtCqWBBsJtJslbX2NE8BomnUBVSiO0cfrpBytQMzHV6eYV
	 rgnbbnNVOurivF+jBjaaqgkF01OX0Qcy0r6tY+Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 43/45] KEYS: trusted: Do not use WARN when encode fails
Date: Thu, 23 May 2024 15:13:34 +0200
Message-ID: <20240523130334.109073267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 050bf3c793a07f96bd1e2fd62e1447f731ed733b upstream.

When asn1_encode_sequence() fails, WARN is not the correct solution.

1. asn1_encode_sequence() is not an internal function (located
   in lib/asn1_encode.c).
2. Location is known, which makes the stack trace useless.
3. Results a crash if panic_on_warn is set.

It is also noteworthy that the use of WARN is undocumented, and it
should be avoided unless there is a carefully considered rationale to
use it.

Replace WARN with pr_err, and print the return value instead, which is
only useful piece of information.

Cc: stable@vger.kernel.org # v5.13+
Fixes: f2219745250f ("security: keys: trusted: use ASN.1 TPM2 key format for the blobs")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -84,8 +84,9 @@ static int tpm2_key_encode(struct truste
 	work1 = payload->blob;
 	work1 = asn1_encode_sequence(work1, work1 + sizeof(payload->blob),
 				     scratch, work - scratch);
-	if (WARN(IS_ERR(work1), "BUG: ASN.1 encoder failed")) {
+	if (IS_ERR(work1)) {
 		ret = PTR_ERR(work1);
+		pr_err("BUG: ASN.1 encoder failed with %d\n", ret);
 		goto err;
 	}
 


