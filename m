Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061973;
	b=B0WRYByfi7trrFqW1zhQL1CXo1jCfsTEWVHP0oR9HSuXf3TOPN410gygYHpHD8IY0nqg
	 lhTyAqjwD7xnaHXvxE+LxemCUcsKjlu9lch0RICTknHn7nT2GQ6qgsHwcw4uoEX0zKxBZ
	 6vhIi5gy+5kdjr6eCeKw2pyExtW12z3r4g6UFaKOAoSf/Mb5Os9yukGj/vsLX7Xmhn0ZX
	 9cKBwf3i17PCv0HV3IS1pt70QEn0j1WYSO1sV45td1HW0pq38dY6nZTDnk5DK5FDv2kU4
	 BW4XNxC/SS6xiY0a2wZ9Frt3TjYXu6T7z7UoiR+UVl3LeJax4wNmFDlU6B2w+BpBVLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pna9LGZcHzLXdO70Pg+svQMfDKcvnNagqMj6ReBgJNE=;
	b=bFABz6HMm1kyo+CdiOMGjKiRGrASB8wchL1Oxaf+o5m2CzUKilGLBSUdDir4m3KMsHJm
	 uGJtduLNNsxytjAumMhwW/m3NHFdIAOC0ugxy/O6OLHGhvI7CJtN2zRd8aByQvJfYqBXn
	 sgZAWzbK41o25oc5EPvKVdXZjiI6hawNE5xuc7dP4JkXXOY3TAzXJcKy2UJQRply08E5l
	 7HrCdQzU9r3T939+rDE0uv3iiycznmu+NEh/59ZSdvtHI5YBjLs2sJIsNzsusZOcpNLnb
	 Enw8BUVWRHVwssG6kBS4gVG1qscDXVGF5Xf11CUhexDEOmG1zZxrrgCYECMOFfgoGCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpqNoaw4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E536F606A320;
	Thu, 19 Nov 2026 04:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpqNoaw4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462C91F000C4;
	Thu, 19 Nov 2026 04:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061972;
	bh=pna9LGZcHzLXdO70Pg+svQMfDKcvnNagqMj6ReBgJNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpqNoaw45E4AdK3K4vRCrEmfiPeuXJTltSDyZvQqspEkd5m4N0cTcAKjVfzfL25kX
	 Usk2BvLAF08evtY3F8v6PtFH+mrjJcU/0VFT4AyRT7DUEI4yLo3GQSUE5GvOqWWf9f
	 5vxmqdKCaQD5q2BSng1OklGI6k9XaXMboQwBjNno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1745/1848] platform/x86: ibm_rtl: Fix potential OOB read at signature search
Date: Wed, 18 Nov 2026 16:03:03 +0100
Message-ID: <20261118150032.563913803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



