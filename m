Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032656;
	b=ic2OB8k4jD1Pc7DE9o06jy3uDX476wYRNvifLx5w0IQC+7dTMV6DdDYFGaaWx+P2W1g8
	 UU9RF60Taz6SR8vyzRmlxiw39rDRa32dBOv9s+a1pTSKr0TAjxJ3z6wgrKbSh7TwD8J5e
	 FL9PueWlYUVip3LCMPOgwMRVutZjIozmM4TM3LPgwen2E7TahPQSN9vMLLBWIaZ8Rz3nI
	 WWj9C0hLnx6TD59s46u4EBh6LgBJssqXzOU1zYZtHL8+I8loxI48WGdJ+hBn03OKC70Q9
	 g+YeRcGJBYSI+G2fMhyZ6CyV3+phv/eug8vEr9ztTB7DC8Q4gEs9tupl6J8pz2we1RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Pr7ryA9P8ILcC+4x9KsrSNME0XiKxT3n9Aa2YNzLGxk=;
	b=mEC/6k6o6zuD8XV1o3CcjardcC0zQkocJpw3azaJ57wrPF3XJygsF5jX9ZI3RbLltckS
	 Bk+mKJDaI/vMXIIClbuHg6mJoKs49PUYj6XjBPHYFUfjxG/i1gV53j3wARHzf3uod/GSa
	 aqn0rn8a/1yqg5xhVrQG4N7wX6J9R4H6abt3fhywu3sAoBIb0VH76elOLsgJe2GnajlHd
	 h8YWSqY9etJdip0ouGGQXg0EYzj2KA/bwmoweosHatKVAmPCRa1Ou0z8Oxy6BmNSCP0Si
	 FY2ZJaBek8f2MHN+Q1ZjQWObbZNqP1N2CccxJgWXh4mPOqxE3jWWGr0W03wustmycuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8yB9SZ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9937A606A325;
	Wed, 18 Nov 2026 20:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8yB9SZ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F021E1F000C4;
	Wed, 18 Nov 2026 20:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032656;
	bh=Pr7ryA9P8ILcC+4x9KsrSNME0XiKxT3n9Aa2YNzLGxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8yB9SZ8YXfRJuEnGW0MAW7L5AQ7cafiu+aXvlegLTdC4HT30utrUkKBfxGb50WlW
	 Ts52WdCRMsesfAcNfEWFab89MyD7+9x9fYu45V/KT+Xq+K98zsuvgp8M/kS4TjLmDB
	 tUC254gUCEk0ZpQo8bSDSCnkgoRwvORJcuHBXej8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1489/1756] platform/x86: ibm_rtl: Fix potential OOB read at signature search
Date: Wed, 18 Nov 2026 16:00:16 +0100
Message-ID: <20261118150108.234858851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



