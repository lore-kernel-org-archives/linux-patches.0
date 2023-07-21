Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780B21F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED868C433C9;
	Fri, 21 Jul 2023 16:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956135;
	bh=yP7whKuukUFTKHrP3igh2R+xGSNiId5N9vm0RdS58Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejQ9HyLxbNhdGZu9he32dOrZhwGc4YU3TY2/Me97A2Ki7CuLVdFkh5qO/rgoZ1t+I
	 A8FCzE0LpC1n7xmYNYLS3HHy3TUjKxPPw2/Tn9w6042w+SHMuhqs2g5y+h74rNhuOK
	 nGpnaua3Uu7/cSviXJdxyHF+kJasH7QPNIOromnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sachin Sant <sachinp@linux.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.ibm.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.4 129/292] tpm: return false from tpm_amd_is_rng_defective on non-x86 platforms
Date: Fri, 21 Jul 2023 18:03:58 +0200
Message-ID: <20230721160534.367204554@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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
@@ -518,6 +518,7 @@ static int tpm_add_legacy_sysfs(struct t
  * 6.x.y.z series: 6.0.18.6 +
  * 3.x.y.z series: 3.57.y.5 +
  */
+#ifdef CONFIG_X86
 static bool tpm_amd_is_rng_defective(struct tpm_chip *chip)
 {
 	u32 val1, val2;
@@ -566,6 +567,12 @@ release:
 
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


