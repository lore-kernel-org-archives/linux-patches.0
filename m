Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CD91E504;
	Thu, 23 May 2024 13:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470271; cv=none; b=jSk6KbHXovGRNvrCA77IdUcesAA7n36EPGrq0nlLKJh7/wV8YKxtEbTIFIfuBXx8fccz3A1LMT0vtHUSO9981kMkR/rZE2sbY6A6RCneqpQWpUGCxc+nzRTHfH66rrozpri+4tpmCQe86ypf/x3vvvr/6bnV+d/3r/eQ40zyPAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470271; c=relaxed/simple;
	bh=NzXdNlWRESErEhnq6IazWZwIMWEMpykvdphgCdSk4Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/BQAK1n4JbrBR4toMtZ5kNVzGrnFPs1JEO3ZDq7Tc9DX/IylFOAA5hqtI48AsXhZcSqBZBkbo9rdyH0uPkXeama8yeidjTPw1I1qurB/pFss8XuzZ7pmeUDaWXDO7txYV705h0dKUt7Iye+sSMlh9Ce087rdVWZKqbjHqH3svA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkW/TND6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkW/TND6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E930C2BD10;
	Thu, 23 May 2024 13:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470271;
	bh=NzXdNlWRESErEhnq6IazWZwIMWEMpykvdphgCdSk4Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkW/TND6+34YQkECMzi5qKMaM8C9q4kxE6wPfqsJsXQFlU0Ob1yolYbAaER2e2Jwn
	 KzbQRVEra25SCr7pzKu+ybu8qc1O/uVZcAs/+trqC/7L0c9noD4J35ljVOe51HttUd
	 TJrswPMSFobd7+PTJAKpOV8IVe4Hg8o4si5kP7kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.9 19/25] KEYS: trusted: Do not use WARN when encode fails
Date: Thu, 23 May 2024 15:13:04 +0200
Message-ID: <20240523130331.107439190@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
 


