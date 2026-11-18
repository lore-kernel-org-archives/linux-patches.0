Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027674;
	b=P3+g92Iw67jy661d1ukxROGuarmdCNNKEx8jvAkR8gL0/k50FfdvTpQumUEEv977W/Fn
	 N3lO9ZCxKtWKlLQ12NBMNb55pU08VxC3iY5nVEFsQwbklPTHeY7BFFtNMlfxfXJVVFzH5
	 Unwcw1bj6LltjJbQdWXjc4V7xE5c7+1/wJXQGSjYgNcuKIA8vsqgN0GdsfZ9/BfEGwLkv
	 /n7wyoqpDPkmaS00lvKsO87BV/kMUGIdJfqisBDzRLWKdrfpx38o5ukJdYDBMQHCFRK+m
	 sMOLiwOAAwpMYoyWF+Oj8olj8TdcTuLHOmyzMMJxJhDrS/a41d7VqAPLMi8SMnRwl3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FNWTL0bhz3DqgKxpUpLmd7Yd5PpY5fjJM2mkUujqLp0=;
	b=FlDXpzubJZFHrolwZ4/vhaYGwkeclVVLMqidNJHoF4Pd9DeM4PJWVynp2aidalzyyuA8
	 DxG2IekZ46dk6SoQrfk4Vdto52H0sAZ3y3mBLh8CoCg1sWxojNQRJCpvjxVN3r4nl0lF0
	 A6oa3VttjOVo8B+g95CfJK0MGIap3tkqUrMgkpSPO/WlEwlQGITOX7QcwOzHulXHDWX1Y
	 9gzzhk9p0VAxsDL3t7sCI7/uY3UiF9Jx5+/GJIQtuyyrs/mUSpK36FGC8HsjMEZGrIDOk
	 JgGsz259MQgMRi/47xV/toXe4jQIqxcxANwKvfWZaLbhhu4zzQ3vig/tI4oXCe5492g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0y559a/w";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B463660A2608;
	Wed, 18 Nov 2026 18:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0y559a/w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FE31F000C6;
	Wed, 18 Nov 2026 18:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027674;
	bh=FNWTL0bhz3DqgKxpUpLmd7Yd5PpY5fjJM2mkUujqLp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0y559a/wmGs6JbMrR/ioL+I3xaWIpwEo83mTpQsNsyH3/keJb/IvzX15sRU7zOTej
	 REo1PrUSVZtwCEMP0bQfPAqC1oBqyArq9XxRGDdf67lJWxM8+O8/OtdHEHkbF0NUJ2
	 Udgv+LPtmukDLKRiMhQpTNAQg4chv+skirXR0JcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1866/2151] platform/x86: ibm_rtl: Fix potential OOB read at signature search
Date: Wed, 18 Nov 2026 16:00:01 +0100
Message-ID: <20261118150229.775503390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 139956168cf94..82fda8d9178be 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -234,9 +234,9 @@ static const struct dmi_system_id ibm_rtl_dmi_table[] __initconst = {
 };
 
 static int __init ibm_rtl_init(void) {
-	unsigned long ebda_addr, ebda_size;
+	unsigned long ebda_addr, ebda_size, offset;
 	unsigned int ebda_kb;
-	int ret = -ENODEV, i;
+	int ret = -ENODEV;
 
 	if (force)
 		pr_warn("module loaded by force\n");
@@ -271,9 +271,9 @@ static int __init ibm_rtl_init(void) {
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



