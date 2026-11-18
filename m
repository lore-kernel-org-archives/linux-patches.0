Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035581;
	b=jPhVHow+jV8jkKp+QDEmhVxSzZPIlO4i7S+C0+YaCB9uDGnZ8RWCXmM8oNVSDWUFlHBo
	 b7frxdZQQQv+dj/FmMb4YXWhH7ovoAt1emTOkmECBzTIJPQi1jSCDeGn8lTSEAmFmey6b
	 KAU3YguZg2R2CMtqmY3b0a07yvHz2gQ8Ffu1Tu7wbwaSz44MsFQt9/i3niyvg9ouUM4DU
	 GtF/1oZotbGf5eaVYIv2D55eRm4o0FIYUAmflv3PmXYA6CtfzBFE8HHCs0rzvFxapOAta
	 LvI6JP5jPjPaOhlQJ2evDBOeOChXFTye9MX399kSb7+l841kSToAcizJBcxUMKeXDPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lYremBji8Sz8Ky5JLOS1DiEKeuH8tGUfFKLJG6kfqqg=;
	b=ztH/gNBrS7r3Hu5OcrRDbn5muP4P9YUXfG6YsTlDu5GWZp/mzgPf/dLu5bQFOpFC/JAu
	 xZYV8YJ/y7Ucwa9es7yT5quvXTSd9kjef3WfP8wT/0Mz+kjcJridbJniBdLX50n8qel7K
	 9ufAM+sbBl45MqRLWO06jU8Z+HlaE9r0JOIsJ1JHgKkL+wE0iR0HJhYTdOPoLoPf8Wi+b
	 TmvbQsUbZSLSW1nm9WiC9QM7S0B3mc04mUt2+q1MUpsQro9p+e5pTH5qEpqq0MlQ70sQn
	 okJ4EBMExVh9ufssZMTF0DHKNliY71HqqeVx34vHtrd2wzS4Y00h4ryWSjX7tI84ZwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D52OcYfd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6817B606A31C;
	Wed, 18 Nov 2026 20:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D52OcYfd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D2C1F000C4;
	Wed, 18 Nov 2026 20:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035581;
	bh=lYremBji8Sz8Ky5JLOS1DiEKeuH8tGUfFKLJG6kfqqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D52OcYfdC8E8YAq3MqAhhW3NoZs96J6cRuY8WNTWIU08kdReusyW2rzuVDNKIO2f3
	 tv/h0nh3bzIjtt41QamDqMk5xNmdd6nHJo0Crj2Q3Ttl+B1+GLetc0SwPzRcPFbHxy
	 lQJu85HnHTa9UpAylly+QWXeFdEryDl+J7qNLCTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.6 0756/3318] opp: fix use after free in _update_opp_table_clk()
Date: Wed, 18 Nov 2026 15:22:58 +0100
Message-ID: <20261118150341.353936980@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1485,6 +1485,8 @@ static struct opp_table *_update_opp_tab
 					       struct opp_table *opp_table,
 					       bool getclk)
 {
+	int ret;
+
 	/*
 	 * Return early if we don't need to get clk or we have already done it
 	 * earlier.
@@ -1511,9 +1513,9 @@ static struct opp_table *_update_opp_tab
 	opp_table->clk = clk_get_optional(dev, NULL);
 
 	if (IS_ERR(opp_table->clk)) {
+		ret = dev_err_probe(dev, PTR_ERR(opp_table->clk), "Couldn't find clock\n");
 		dev_pm_opp_put_opp_table(opp_table);
-		dev_err_probe(dev, PTR_ERR(opp_table->clk), "Couldn't find clock\n");
-		return ERR_CAST(opp_table->clk);
+		return ERR_PTR(ret);
 	}
 
 	if (opp_table->clk)


