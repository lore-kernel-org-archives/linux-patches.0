Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DC87CF0F;
	Mon,  8 Apr 2024 13:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582203; cv=none; b=fZpYEpg7GPesI9jS1vpv3zdWRRFEPQekQO728ZJRSTHFnryJtzHSR1vGTFcVwnLcQyZSsKqZKC6L7BNQsIHV0OuBGFr5fOZCDu4wQ1+LbNuu8SxQ97uDEDHlcLvZq1lRCvXH5iNRp0RTz4DuyM5T4kk1Cm1YoNdn8hjxn/Af/r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582203; c=relaxed/simple;
	bh=S+YJUH8QCxqTDF9pjJYONp20ACRpqstV66NGFJ6zuag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rh8iZk0cmJN6vsl6ViJyuzfePe1wnFthSAwtGrxaaFxPlUb8u91QIzi/fze66zE69MkVehxWomKzxts7jAc34eTmCN+lMGhQiFdMetrQU7k250eYWNmR2wWq8MACmrpqUV4h5ISbQsv52NmlenVOQUC3TNb1k4SyGIScX6PhIVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jm8051CI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jm8051CI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4795C433F1;
	Mon,  8 Apr 2024 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582203;
	bh=S+YJUH8QCxqTDF9pjJYONp20ACRpqstV66NGFJ6zuag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jm8051CIEY52uSsQC2QaTYxBoDEoLZGt8ZluxZLIR1ZshsfTYrij7RfgaejDbiMi4
	 3czOvqGpEn2VM7cV1btjM8B9EJaylczqpmrdkfl9TzssqlTtTIVQFBGeXM+cmkfK/Q
	 rKKvmJDfUhKvNk+rB3YUokErM8y0azM+co1I3vvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/138] KVM: SVM: WARN, but continue, if misc_cg_set_capacity() fails
Date: Mon,  8 Apr 2024 14:58:20 +0200
Message-ID: <20240408125258.900480733@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 106ed2cad9f7bd803bd31a18fe7a9219b077bf95 ]

WARN and continue if misc_cg_set_capacity() fails, as the only scenario
in which it can fail is if the specified resource is invalid, which should
never happen when CONFIG_KVM_AMD_SEV=y.  Deliberately not bailing "fixes"
a theoretical bug where KVM would leak the ASID bitmaps on failure, which
again can't happen.

If the impossible should happen, the end result is effectively the same
with respect to SEV and SEV-ES (they are unusable), while continuing on
has the advantage of letting KVM load, i.e. userspace can still run
non-SEV guests.

Reported-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Link: https://lore.kernel.org/r/20230607004449.1421131-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 0aa6b90ef9d7 ("KVM: SVM: Add support for allowing zero SEV ASIDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1fe9257d87b2d..0316fdf5040f7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2214,9 +2214,7 @@ void __init sev_hardware_setup(void)
 	}
 
 	sev_asid_count = max_sev_asid - min_sev_asid + 1;
-	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
-		goto out;
-
+	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
 	sev_supported = true;
 
 	/* SEV-ES support requested? */
@@ -2241,9 +2239,7 @@ void __init sev_hardware_setup(void)
 		goto out;
 
 	sev_es_asid_count = min_sev_asid - 1;
-	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
-		goto out;
-
+	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
 
 out:
-- 
2.43.0



