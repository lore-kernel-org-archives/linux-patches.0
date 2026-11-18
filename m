Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042260;
	b=r0ouj70EuVvL7IBVEBRB+qrdTchf2YH21VC1KezS07YnYJmI9ng5h4H5f73/kUpKnNo4
	 jTwovJ027OApsAe4JTeq+Vx68tl5d3H7uMFSGTxi9SMxBQxc8QCG4774kJD2ki7oyOqzw
	 KLfQw9VI7fYSi0W6QuoAaUrQxdN3CT7elMqmrc8FwjlB7gxXik3mqQE8eCZyQ3KmyJ0Ru
	 h22pWapYEmRo5SzjSaJvmHa45qpiFGFtOjm8Bo6ZmpTuO/EhnpEbDwqAh6y3+8swEkZ80
	 zGLf1prR4HiEKeA4/sATgj0RIVtQqaw+ZVGPIDbLgc+9s0eMcl9r7nQE4cBp106Sj/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=U4FLHJcEdg1ZTyPuWXgbPuTmYd9wJY4pcWHfE7ZvMkI=;
	b=Z1TU2mIEWFsb5awMYEM7T0i8KpsGUgDKh5kJKlYrxIqBxeHSAIhHSUYFZAmRYZy7td0s
	 kA6La7FrWFYKGWHNM6Gl2UjDEwTdo2XSLv/YY2889OpJ2epqrPE7GU+F/RY0lmIKi5w+C
	 WRuVGDgTD6pJgcqbb2H6+9Dq3uLAX58ZRUTx6Slyr5IpvzyPkZS/vdc83vLQVdJ1Q8TSR
	 MCrKQ4Ds7DFYBYoTS21GLAQRHylwv4YinW/iHRnfo0t+JRMLBZLTAIF/11bLgv1Uxj6Ro
	 wg4pQLlgP2dD4wACY9zgTnYaI0XXUQS3hPRAni0qVxWNUHwk4QlxO/kaWp3rg+v/HwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BrSR4uFO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7405C606A31C;
	Wed, 18 Nov 2026 22:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BrSR4uFO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A461F000C4;
	Wed, 18 Nov 2026 22:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042260;
	bh=U4FLHJcEdg1ZTyPuWXgbPuTmYd9wJY4pcWHfE7ZvMkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BrSR4uFO6QiJ7gPIheQl5wqHL/F4kqJUwYjvMi5XSv6d3gWG6J83y/oyGT2f9oIMf
	 91fbVU7bfvsFGuHG7bzMGalOOom12oxl95177vIZaIP2UwQ96U8oZlW9GgOlKLyIl7
	 Cngu0z5pEIAb4PRfGa+UYPNKKPkO1fUuuiWVlgCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3106/3318] platform/x86: ibm_rtl: Fix potential OOB read at signature search
Date: Wed, 18 Nov 2026 16:02:08 +0100
Message-ID: <20261118150453.168207243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5fb25a6025331..5af21d805590b 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -233,9 +233,9 @@ static const struct dmi_system_id ibm_rtl_dmi_table[] __initconst = {
 };
 
 static int __init ibm_rtl_init(void) {
-	unsigned long ebda_addr, ebda_size;
+	unsigned long ebda_addr, ebda_size, offset;
 	unsigned int ebda_kb;
-	int ret = -ENODEV, i;
+	int ret = -ENODEV;
 
 	if (force)
 		pr_warn("module loaded by force\n");
@@ -270,9 +270,9 @@ static int __init ibm_rtl_init(void) {
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



