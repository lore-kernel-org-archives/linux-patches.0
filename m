Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADD22571D9;
	Mon, 24 Feb 2025 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408146; cv=none; b=mKmdoBNaSsvqzQVl5HftYe8aOt8oM8lGpgAKCt8U3Di8zShv1IfchAf50/4qyQET4w8XINyyyfNLzSlwqC37ap7DaxoPmPHLnrjvlQBrC+PEbph2lRgY6U/xTZ173+TurWiGKWR4jHl0eetHapNLzX+2A+PfqyKevQ9qakkfAbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408146; c=relaxed/simple;
	bh=O3FeYP0wrESoVFB1UNbR1k1LotdhGLgPIh809egmFcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6bDSAzAVq/7xpFNCFKDNtDoRVwSebDQoMiRzoo39QQT75idaEgTHgJ/CRQzJfo2Hjc+Asgxcny5owRIqbnqho8V6v54ZKhCbnJqkDbd8cVryfcURBIw5vGn1ZIgqgQSYAXApMjooZPeKxS/MIzLrdpAkAXQjHv7b6Rnbnmfq+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnV0OKK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnV0OKK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8F6C4CED6;
	Mon, 24 Feb 2025 14:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408146;
	bh=O3FeYP0wrESoVFB1UNbR1k1LotdhGLgPIh809egmFcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnV0OKK2mGJ/MFGgzLJpiEB9nhV3WN37xVOh/JffNzdbabM2w6xPwuHH+rLVGb3Rk
	 OINFSXkhtn8olkCby7/h8ik8nCOz+oLXNiRrvpguowyRwnU2Fv6YAI1ex9lrAw6pm6
	 xR/cOaU7mlbMrG3yOLBigcDgTAllJgHQju8pdCqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.6 114/140] soc: loongson: loongson2_guts: Add check for devm_kstrdup()
Date: Mon, 24 Feb 2025 15:35:13 +0100
Message-ID: <20250224142607.495910481@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


