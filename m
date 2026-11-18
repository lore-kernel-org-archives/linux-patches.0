Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044712;
	b=B9DEQIcNeStuU08bf9NI7NWTCvZKjKvgIuqaMhY0UT59F1ajIxOYEnb/jl0ah056p3zR
	 jGij8QVFFSzPP55kjV9vZqdTfNL4bIp7lIKHKaeWoYEie+vVBEE1zLTGUif7D8bjIMFp+
	 J8OYfgZ0x/CD+v8Zg/J0C8hEQxngnc9Al6ReM5AX5RoeCOrsAPaH7QOBlXCiog7ygj40O
	 w+g+UoWcJFjmrXuTFVTAmP6S7mjofu/MBnGK3uCHKzhbU8rSLkOCm6fiMzoGldhXwQXAe
	 /JqnTdPxS7gii+6nPCFYXhP5Hiw8yETlXpuMBONjOxz4iPScjzR5EdlUtc34QJxEZeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i82tDaLwCRstTRz0CJ7KwnujRk00MX09WBFTKjBE/sA=;
	b=MUTCdjrZAE5a//rOzA0vcIgFPhBiqlE8rGlnDNiiwJ3YssFdmX5qO1/PZSURqEIsqIMQ
	 E9ZzJ2r42FTV3QW5VKpx3A1+JrHd3GOP38uPoLvGQGBA0PRMgmpYk3UCQXtsqxEg6v8XY
	 39MhS/6meKjLf4btL5atduwFI7+3NreIQNGkgUMv8vzpuN0G6BxkfyONrwJCmIDJtp0UY
	 V1fntO9nWHK8TBSPg46D7H7u8JzbyIVv98/rF+pp0knh37stDlqmS2YZzvYfDnTJ8tyW1
	 OQdGKBe1y5lDm5jEKer2yyJsWzATewZdOzx7c+KEqKiVIygDpg0BvkrL9bNXojG/5sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1vU2V6ZE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145A0606A32A;
	Wed, 18 Nov 2026 23:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1vU2V6ZE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639B91F000C4;
	Wed, 18 Nov 2026 23:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044711;
	bh=i82tDaLwCRstTRz0CJ7KwnujRk00MX09WBFTKjBE/sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1vU2V6ZELmUp81t/BqaPZru9aCdEGHQwsFXlarcvxVDanoy9me4t5TlxrlJ2ziwBH
	 Y4aOth2rMDN31jATTTrWNPvaqv9eR5uNsGdrS2StQfivasvDkTXYBD7Hs4Ia7WoLU0
	 E3f9HpIF8c7m1U7jQqLgyZDgSr5IR+4rI3CrQUUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.1 0663/2857] opp: fix use after free in _update_opp_table_clk()
Date: Wed, 18 Nov 2026 15:28:17 +0100
Message-ID: <20261118150225.422990524@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

commit 1f6de65e3314519ce462bfd3a1d29e918f97e4e5 upstream.

dev_pm_opp_put_opp_table() frees the opp_table which is subsquently used
by dev_err_probe(). This causes an Oops during boot on gs101-oriole.

cpu cpu0: error 000000006b6b6b6b: Couldn't find clock
Unable to handle kernel paging request at virtual address 006b6b6b6b6b6cd3
...
Hardware name: Oriole (DT)
pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : _of_add_table_indexed+0x80/0xbb0
lr : _of_add_table_indexed+0x6c/0xbb0
...
Call trace:
 _of_add_table_indexed+0x80/0xbb0 (P)
 dev_pm_opp_of_cpumask_add_table+0x70/0x120
 dt_cpufreq_probe+0x23c/0x480
 platform_probe+0x64/0xb8

Fixes: 84f05af0975c9 ("opp: Use clk_get_optional() to avoid leaving opp_table->clk as an error pointer")
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
[ Viresh: use return value of dev_err_probe() ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/opp/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1472,6 +1472,8 @@ static struct opp_table *_update_opp_tab
 					       struct opp_table *opp_table,
 					       bool getclk)
 {
+	int ret;
+
 	/*
 	 * Return early if we don't need to get clk or we have already done it
 	 * earlier.
@@ -1498,9 +1500,9 @@ static struct opp_table *_update_opp_tab
 	opp_table->clk = clk_get_optional(dev, NULL);
 
 	if (IS_ERR(opp_table->clk)) {
+		ret = dev_err_probe(dev, PTR_ERR(opp_table->clk), "Couldn't find clock\n");
 		dev_pm_opp_put_opp_table(opp_table);
-		dev_err_probe(dev, PTR_ERR(opp_table->clk), "Couldn't find clock\n");
-		return ERR_CAST(opp_table->clk);
+		return ERR_PTR(ret);
 	}
 
 	if (opp_table->clk)


