Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1019190063;
	Mon, 24 Feb 2025 14:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409133; cv=none; b=kl7mpb8WtYk2Xr9khZutN06PpuJHreZGOya8P4F0ouJyE/xmTH81KGy+fg+5nruqvDQXvBaYLScQorfnSJD34Pc6W9RO9sPho4YSA9EyUM4YVbHOYlFVcfZx5wr2l0SedwIKDqLLcsZ6woPDagvtbGGekW771b09FJxzAGSBmFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409133; c=relaxed/simple;
	bh=pZlQTBTgKaE1tku/tqwnDYmc/dG9f/Lt5vQLN/UqmTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTnJjyxawIFeiXY6FCaH+VDKvHfeUBT6R705spawwxGsyu6kSDA2zU/uCPzLNA6f1a/McJrmQJ6UgNRmCHRN18mllg0OyeBRZv9gh2v1JghdU0TW5fRuN3ccMlJW57Z+ZwLIXSO2Dv5pDPpedUf2MsznKsOwgCqFmjVLgi2bKVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cfkjjch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cfkjjch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA737C4CED6;
	Mon, 24 Feb 2025 14:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409133;
	bh=pZlQTBTgKaE1tku/tqwnDYmc/dG9f/Lt5vQLN/UqmTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cfkjjchYqTrB6R1Or8al+8rixa7vJRgNhgchKxmf5nX3tY6FZ8MBOyr4vjOZ3yT3
	 T0D/GyZ3E42hWY0diD0jAPbqWZjixHYyzap5/Vh1svpFrQ7iceAPo+kpvHIOyuaMpB
	 p1JjZsoQV8UfWl29w8NjuyznldcXfoh2M0zneSus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.13 107/138] soc: loongson: loongson2_guts: Add check for devm_kstrdup()
Date: Mon, 24 Feb 2025 15:35:37 +0100
Message-ID: <20250224142608.686562331@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit e31e3f6c0ce473f7ce1e70d54ac8e3ed190509f8 upstream.

Add check for the return value of devm_kstrdup() in
loongson2_guts_probe() to catch potential exception.

Fixes: b82621ac8450 ("soc: loongson: add GUTS driver for loongson-2 platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://lore.kernel.org/r/20250220081714.2676828-1-haoxiang_li2024@163.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/loongson/loongson2_guts.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/soc/loongson/loongson2_guts.c
+++ b/drivers/soc/loongson/loongson2_guts.c
@@ -114,8 +114,11 @@ static int loongson2_guts_probe(struct p
 	if (of_property_read_string(root, "model", &machine))
 		of_property_read_string_index(root, "compatible", 0, &machine);
 	of_node_put(root);
-	if (machine)
+	if (machine) {
 		soc_dev_attr.machine = devm_kstrdup(dev, machine, GFP_KERNEL);
+		if (!soc_dev_attr.machine)
+			return -ENOMEM;
+	}
 
 	svr = loongson2_guts_get_svr();
 	soc_die = loongson2_soc_die_match(svr, loongson2_soc_die);


