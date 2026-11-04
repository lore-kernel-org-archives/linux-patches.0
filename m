Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831944;
	b=O0il+J+lPU22QrQE3PUYnH1CyT3gwxRf5reWNer65tzK/cFpyCOQm9WwjPA9kTqtZtkX
	 zq6pEwcnfZw5QjwUcAeHql6XRztsPXCtyqc6mUgIaHYqauehjOB1FjVHGIyrRyt4Q4MsY
	 8NWlMobMiThALz4TW++XRiQk5u8nF/vbE9k3CHc2NW6ppeZVsqVQ9DeNurC0ErgfuWOso
	 iHWmXgcvei5BQrYx1nYBCEvm+Z4dS0cfeSafFKddZma9C2d00/t3vluZ5w+neb5suCNBS
	 QXHtnJ/SSzgQA3DG9DNptvBAPjZbrbZMlWPemx4U3+w8EGHgKCL6OZo8QxnkAHK1JQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VES2nKn26BUlzHbaZuJR8+XjaImSStX+fXL4cadpk8U=;
	b=eQGn0m7WWjUYIJGIDvov+lzhGMD5PxZuNuDl52xNZFx3X1ayYYS8hOttci7ZLzBRH72y
	 DSpRsyyYr96RChFwMPTHNBVCOFKh+o3h7BvmOqJWs+ZVTDlloimtqXHxgnF1EURdFVXOv
	 A6rRnbAFYkFrcDMNZAZVllKlVwR8MjivvxqEHWRPJ7voLPBfpypvDm32Da+eTAJ/DtQOo
	 fw5Yzw2NVYLH/VFK7V5T2E1or7mHlZztl9aikYj6sqAFFk6V8b+cHhf2wTioLhUFTRX+p
	 /63H8toNCz6MsDpxyTZLqLwhga/hrnytZA/V5OvneH6WotoomyStCjXpbXgHjhAOYzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qWDJpgd7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1604606A331;
	Wed,  4 Nov 2026 22:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qWDJpgd7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2BE1F000C1;
	Wed,  4 Nov 2026 22:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831943;
	bh=VES2nKn26BUlzHbaZuJR8+XjaImSStX+fXL4cadpk8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qWDJpgd7raA7Awr0XUBF5SACm9Ae/GUTdkU1OZYHZEANMOW0R3vimaVzDvmwZQ/BG
	 sy84NjNviH+gmXTUiJrJ6X46y5oo5OlMa6iiiqn8MJmF9KU1qVeLvG5i8jG3UlrrW9
	 ZdwAxaeSn6KSk4P0hjb817xCGlDfJREMhmLmG4sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.18 1004/1005] opp: fix use after free in _update_opp_table_clk()
Date: Wed,  4 Nov 2026 16:12:17 -0500
Message-ID: <20261104211111.139965026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1579,6 +1579,8 @@ static struct opp_table *_update_opp_tab
 					       struct opp_table *opp_table,
 					       bool getclk)
 {
+	int ret;
+
 	/*
 	 * Return early if we don't need to get clk or we have already done it
 	 * earlier.
@@ -1605,9 +1607,9 @@ static struct opp_table *_update_opp_tab
 	opp_table->clk = clk_get_optional(dev, NULL);
 
 	if (IS_ERR(opp_table->clk)) {
+		ret = dev_err_probe(dev, PTR_ERR(opp_table->clk), "Couldn't find clock\n");
 		dev_pm_opp_put_opp_table(opp_table);
-		dev_err_probe(dev, PTR_ERR(opp_table->clk), "Couldn't find clock\n");
-		return ERR_CAST(opp_table->clk);
+		return ERR_PTR(ret);
 	}
 
 	if (opp_table->clk)


