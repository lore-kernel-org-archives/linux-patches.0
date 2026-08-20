Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E07937F73D;
	Thu, 20 Aug 2026 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238904; cv=none; b=goXjvrB+bCLEM1KF94t2uoUEk80+Lix204c8HT9cXw5EW7tDv1qFNtteJsXXiokrYjvzKVyPWQBKL00TONuiI2lvy7ysobSw73EhBzFvXnIaz1MlaCrMKuk13g9fGxeCfSrs/3wF3Wt6i8E/WvxLjlcSLyjxr/D33UC2sXCGKxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238904; c=relaxed/simple;
	bh=+LAuLSDUJgFMF+gD3kci/SwjGAtoYRhlaVa0Y1c69Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaAnCrjivYLeHvpBwLrgZDjQWRf+l0NK/2Xxqqc13NftVDHsGLCbZd9zYctFg/+AuIbwysDowv77N+f3kiAEgzjhX88FhV0psBoGDOeNUTtdV0s6KZhgSajcCGvW6PiIoEMxlH3FeB0b376JzdIYtitizrYZi4CvBCduTrTZ7y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJUXgf0S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJUXgf0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EE81F00A3A;
	Thu, 20 Aug 2026 15:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238903;
	bh=F9udtAGMFagI2KWpbaaJhi/5uCa2y0Z38aUdLFllz48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJUXgf0SqbEMzyeEt7VdzRanBwK7rYmpPAgmdQMWCVEI5qXvh/FXF3bTbTC+icXOg
	 OITiR+E5SGpQ2DbX5lQ/gjNhdbq2z+8uwzA4jAs6n72QwH2N2s7JCSiI8NI5MdYCTD
	 5dTheNopiljSjCC9fhTf06E6+FmhqXktMiCgb64E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haren Myneni <haren@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	George Wilson <gcwilson@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 042/217] powerpc/pseries: papr-phy-attest - validate cmd.length, plug mem leak
Date: Thu, 20 Aug 2026 16:53:30 +0200
Message-ID: <20260820145238.886787077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Wilson <gcwilson@linux.ibm.com>

commit 5b17f3f34391372faf03e79d947e0c50ab6dd258 upstream.

In papr_phy_attest_create_handle(), the params->cmd.length is not
validated before use, which can result in a buffer overlow.  Check it and
return -EINVAL if it is either 0 or exceeds sizeof(params->cmd).

Also, params is freed on the success path but not error. Free it on
errors after memory allocation.  And free it on negative fd.

Fixes: 86900ab620a4 ("powerpc/pseries: Add a char driver for physical-attestation RTAS")
Acked-by: Haren Myneni <haren@linux.ibm.com>
Acked-by: Nayna Jain <nayna@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16
Signed-off-by: George Wilson <gcwilson@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/papr-phy-attest.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/papr-phy-attest.c
+++ b/arch/powerpc/platforms/pseries/papr-phy-attest.c
@@ -230,10 +230,17 @@ static long papr_phy_attest_create_handl
 		return -ENOMEM;
 
 	if (copy_from_user(&params->cmd, ulc,
-			sizeof(struct papr_phy_attest_io_block)))
+			sizeof(struct papr_phy_attest_io_block))) {
+		kfree(params);
 		return -EFAULT;
+	}
 
 	params->cmd_len = be32_to_cpu(params->cmd.length);
+	if (params->cmd_len == 0 || params->cmd_len > sizeof(params->cmd)) {
+		kfree(params);
+		return -EINVAL;
+	}
+
 	seq = (struct papr_rtas_sequence) {
 		.begin = phy_attest_sequence_begin,
 		.end = phy_attest_sequence_end,
@@ -246,6 +253,9 @@ static long papr_phy_attest_create_handl
 			&papr_phy_attest_handle_ops,
 			"[papr-physical-attestation]");
 
+	if (fd < 0)
+		kfree(params);
+
 	return fd;
 }
 


