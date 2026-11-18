Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050436;
	b=KlEuTBFBeyXzXZNdnkhKhrV3U7W0L7YdsRCHEb/GdcnyYGW+tsD6N/ZP8YRHzBfTN1HG
	 V76VVxZDq9GL2S8SGGHRx6sVGjz9w4SGH8viVzoGjSo2+dNVuSmJ81p2XPU0UAbN7mUR6
	 0ptPKoLQozR8wGoo/cM06e98It5T0NHlynC/o744hrrzHCnaoJ8mmWU8PC3+IMN9r1H7W
	 isgwOreR2wWD8CndW7DVNBWgIGqM6fN5KgycljLI2zNN73Aa1+weuOQ3kSwGr7B/a5Zxs
	 oFuun5p3zLnv2K3m98+8D5fjzShUzvnrmy7gd2GiQHCoUh+f2CtMmEKYK5RhlEjB40g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FESc9jkncuBdQeDxGGtVMBGtAaOPBXxjovsx9z7yMYs=;
	b=S3CV3abSBCzKCvOV6WBf06kKSYeLC7X4cktNI6saQWKtUUlcY6rwY1icMSEK2JjDp+8J
	 Xuq2w/hVd57PCNXI6EgFFK19zrwFus4N1AVwCyJe4mBC1BK29HiKvj7JG4ayxwwSVUPGf
	 wwtJkB4W0EceNZ1D6N+KJ6ccVpfcbdEtFUBkrPqS6AIeByqFvS4o6wyaT/Nrg4mXNNVy2
	 sszY7m+ZyX6Hv0CCHOayhxnbWPQFRIhLmHsKUvqTxkzmrtNZjZdkTjn8AoKw43x12RUgj
	 UnA7F4ZkP4kaIYabaoNGhrCEeBonY4bI1Yv5zRHgY4WjWanmis6AzkCndRT2kLSDiyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M9xgjWPi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91DC606A330;
	Thu, 19 Nov 2026 01:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M9xgjWPi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B5A1F000C4;
	Thu, 19 Nov 2026 01:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050436;
	bh=FESc9jkncuBdQeDxGGtVMBGtAaOPBXxjovsx9z7yMYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M9xgjWPitj0ah8pmK6P92BCoAB/Rk09E2HsWJJ+eOQapnfNmPIhqzN8AG8Oy6gWFQ
	 FUrI63sO259wkF2p8JSlBXzq8g7e9FupQUfd1EnT9XmkwYKZvwIXeYSutwlKoLdy1t
	 EeTpbV13JW4N269nL4QgEr/GC39lRkLDJp6FD6lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2670/2857] platform/x86: ibm_rtl: Fix potential OOB read at signature search
Date: Wed, 18 Nov 2026 16:01:44 +0100
Message-ID: <20261118150337.712269526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



