Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA75D20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A929C433C8;
	Fri, 21 Jul 2023 19:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967235;
	bh=cLVnscSZzd4+xNdDB9Yip0knvi+t/y96oFzaBcpgx8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGu+fj1Wwe5dxq2EVa58DuCZjTN8x3oEifPFiM2HB51ngMbpzpQLA91ALFoxPfx3q
	 OvMQd9BiWI9W0P//WlyT64NUQh22u+6q0KYpMjj0kk+ljyI8dEMwudvWs9SuVIqtnF
	 ovA4N3pwensxZLRjOEGJ1iRXBdnUPvYzNFO/LEmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sachin Sant <sachinp@linux.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.ibm.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 092/223] tpm: return false from tpm_amd_is_rng_defective on non-x86 platforms
Date: Fri, 21 Jul 2023 18:05:45 +0200
Message-ID: <20230721160524.785552133@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jerry Snitselaar <jsnitsel@redhat.com>

commit ecff6813d2bcf0c670881a9ba3f51cb032dd405a upstream.

tpm_amd_is_rng_defective is for dealing with an issue related to the
AMD firmware TPM, so on non-x86 architectures just have it inline and
return false.

Cc: stable@vger.kernel.org # v6.3+
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Reported-by: Aneesh Kumar K. V <aneesh.kumar@linux.ibm.com>
Closes: https://lore.kernel.org/lkml/99B81401-DB46-49B9-B321-CF832B50CAC3@linux.ibm.com/
Fixes: f1324bbc4011 ("tpm: disable hwrng for fTPM on some AMD designs")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-chip.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -515,6 +515,7 @@ static int tpm_add_legacy_sysfs(struct t
  * 6.x.y.z series: 6.0.18.6 +
  * 3.x.y.z series: 3.57.y.5 +
  */
+#ifdef CONFIG_X86
 static bool tpm_amd_is_rng_defective(struct tpm_chip *chip)
 {
 	u32 val1, val2;
@@ -563,6 +564,12 @@ release:
 
 	return true;
 }
+#else
+static inline bool tpm_amd_is_rng_defective(struct tpm_chip *chip)
+{
+	return false;
+}
+#endif /* CONFIG_X86 */
 
 static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {


