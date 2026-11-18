Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056821;
	b=2P6VMqVd0xNkEFKw3ai6ggUnny0wD1CEaI5SvcThh3YlhUioKhXlXbq6/S1DFYN9iUX+
	 oNVu9tnwwuT3RmXoOrmbrQZ8BoCE93wSvCB8/CxDVuUd5Ms23mnIReV/Us1HBga25M/I/
	 tXhMZzJzmCTC2C6SYv1dl9C729FmawuuHsc7J5ZN6exzWEosRWAiYavTbeR8F0ZFV5uh2
	 1CX6lV2eMpYbSpHLCXOfC0EnhUdUsxZjV8mjdtp/OLFli86gLlN6sgTrXjaudvmQ5CKkT
	 UMUJ3VongzZ29xRWmfwmRMflFT2ImvmKua2nJywJzu57svxp/9M5TquietQvCVAe1Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=YprnZxpUk1QQJQR7065KqJHXNSvxFaq3jjXmXN1ayQQ=;
	b=22S7wxMdaTbjZmkG4+W84biWX/gGvotWGrxobfzWqe6T2LpQd80h+/RJDc4EYWRDbPgW
	 sUqjLscET4qSFEcS4ErJ5ljd4qfz8FJ0DBz/Suo5mhO/rpsU62qJ+P51hCuMHuqN/4MoZ
	 s86/kmrGm6Vj4E/jaa5J7xHStp2mCQc7HcL5ZCnKlimpBkfvZvAYLlvc6qo7KicBPIjR4
	 Ch/jDESihq1O1NuCF60JAUN++qjnCDFalpCKRPhLqSoBCezudKZGSsyo1pRJ2O0oWnBo/
	 lw6r20DrB72IYvNQnLnGF8DVjNz/yYUNf4d/CpINLJC+l6AJLLK8G99SNqLwpFBavMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUOGcmCD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E4960A2608;
	Thu, 19 Nov 2026 02:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUOGcmCD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8C11F000C7;
	Thu, 19 Nov 2026 02:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056821;
	bh=YprnZxpUk1QQJQR7065KqJHXNSvxFaq3jjXmXN1ayQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUOGcmCDGAA0XIZpo0zitP4qkMzZriygK5dmeeqvbmg11K+Q4TiUfKq0RqxMBOzru
	 ik2sNhZqMLFSprYqyJVewfuTz0PwRzlhN6mR6K0RKB9tWmH9bLFlrGZZCl96vwb6gC
	 TSZ72rs4U9Q27p00obYATKZj9qqYlWV/pur/1iFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2083/2214] platform/x86: ibm_rtl: Fix potential OOB read at signature search
Date: Wed, 18 Nov 2026 16:02:39 +0100
Message-ID: <20261118150133.967541035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f1d81af2521ad504a20481fef12c358d26e6c3a6 ]

The loop for signature search fetches 22 bytes of struct ibm_rtl_table
at each check, while the loop count is calculated in 4 bytes unit,
which means that, at the last entry, it fetches over the limit.

Rewrite the loop to use the byte offset and correct the boundary
condition check for avoiding the potential OOB access.

Fixes: 15dd100349b8 ("platform/x86: ibm_rtl: fix EBDA signature search pointer arithmetic")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261021064012.457870-1-tiwai@suse.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ibm_rtl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
index 10cab7bdfe150..d358d684dfb05 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -223,9 +223,9 @@ static const struct dmi_system_id ibm_rtl_dmi_table[] __initconst = {
 };
 
 static int __init ibm_rtl_init(void) {
-	unsigned long ebda_addr, ebda_size;
+	unsigned long ebda_addr, ebda_size, offset;
 	unsigned int ebda_kb;
-	int ret = -ENODEV, i;
+	int ret = -ENODEV;
 
 	if (force)
 		pr_warn("module loaded by force\n");
@@ -260,9 +260,9 @@ static int __init ibm_rtl_init(void) {
 		return -ENOMEM;
 
 	/* search for the _RTL_ signature at the start of the table */
-	for (i = 0 ; i < ebda_size/sizeof(unsigned int); i++) {
+	for (offset = 0; offset + sizeof(*rtl_table) <= ebda_size; offset += 4) {
 		struct ibm_rtl_table __iomem * tmp;
-		tmp = (struct ibm_rtl_table __iomem *) (ebda_map + i*sizeof(unsigned int));
+		tmp = (struct ibm_rtl_table __iomem *) (ebda_map + offset);
 		if ((readq(&tmp->signature) & RTL_MASK) == RTL_SIGNATURE) {
 			phys_addr_t addr;
 			unsigned int plen;
-- 
2.53.0



