Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061814;
	b=h++eZ78rXZjNIWqxUCEOY4U2uEXetOJrDEuXNWexhqakMs8g6hXNb7MFAxqIbcJEIFrQ
	 S/IkbafpGeJy3FtOwWZ06JdWEtWpSNctxxlwivdzX7S+FTKVy4tYif+7Tx6lEQjCyTGGE
	 EvP5SaWzjlBta03QPELbVUz0OFmPVVQmSeaWjHxmhCBZSSZb3umWpcHzOJaKsgdtzdwXf
	 NmIx9FZpZa+tmm/SfP9elJs6zfRehduatmY+jHRVcon4VKd0kPThLy/zQ9Dd/aT3sbNFm
	 lX1xelEBt22DDAa0wMy/iGAVEkoXTeZJpa70sae0CiiTlABwzUs4wmS9HKn66Fjk7xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vrg1npWPAJ1m65wRQEhMKgx4O8OwBprafr2tKd2tchg=;
	b=H83C1uXyvHUigV0rIEuEP7UDTcjK5jzE9DbNKwrhKMjA2Xr1JF5GMLRauHsbhFbg5rfO
	 +YDfxcK6i7kq6dXaYv8VjHnIC0YhtJLfCwjnd3KN0412eUpptaKu6ZPGTeOpzkZyKaUhS
	 UXbldtV+xRI66Ky5ButPg0IUbOLxjricUkSszHTM/8w7m4k20mFcKT1foEx9r9hXX2IyS
	 ZhYCPrlRwF30tkzKh0KelXGqLR76X+4jNs8CyLloO/kAPVSfWxnpX9a+Rl9PzgppBzNZw
	 AH/yC7p+empUYKKeXmPob030ypJtW9Q+anodcH5Z/Q9nt9FwZKwOZMVFzwrVDNlaLTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAb9p7FM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A8E606A332;
	Sat,  7 Nov 2026 14:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAb9p7FM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD9C1F0089F;
	Sat,  7 Nov 2026 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061814;
	bh=Vrg1npWPAJ1m65wRQEhMKgx4O8OwBprafr2tKd2tchg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAb9p7FMX4tBOIJmQ288K5csA/jUzXbmupPczbd2AorjaRuwEh+lmSEiPWSGnG6DB
	 KgSe5DbEDIKBYlq/ZmD48jDW+X7RDrobevhBzIO6/dRDO5kPmOWvHbKmatUcW1y2T/
	 o/kxa/BP+TzgmWd4b5vBDD9MkONSZ5Zw0Wgh2lB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.12 0840/1536] opp: fix use after free in _update_opp_table_clk()
Date: Sat,  7 Nov 2026 08:47:36 -0500
Message-ID: <20261107135021.142044142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1512,6 +1512,8 @@ static struct opp_table *_update_opp_tab
 					       struct opp_table *opp_table,
 					       bool getclk)
 {
+	int ret;
+
 	/*
 	 * Return early if we don't need to get clk or we have already done it
 	 * earlier.
@@ -1538,9 +1540,9 @@ static struct opp_table *_update_opp_tab
 	opp_table->clk = clk_get_optional(dev, NULL);
 
 	if (IS_ERR(opp_table->clk)) {
+		ret = dev_err_probe(dev, PTR_ERR(opp_table->clk), "Couldn't find clock\n");
 		dev_pm_opp_put_opp_table(opp_table);
-		dev_err_probe(dev, PTR_ERR(opp_table->clk), "Couldn't find clock\n");
-		return ERR_CAST(opp_table->clk);
+		return ERR_PTR(ret);
 	}
 
 	if (opp_table->clk)


