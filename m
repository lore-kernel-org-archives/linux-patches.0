Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562CA40DFC4;
	Mon, 23 Mar 2026 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274549; cv=none; b=Eny+ToosJVo9JGzbnHEoHUvaocKY8Hc8UDm0LECYJFy95r7Vo7PMTC/OshQ+ETepE2pPjfb08EvzJdrDnsry3PjoDNd6Icp+ibY8Y9sRZPphMA+F5iVKA2Nz39zqWjku1qTc3G1cCemc5Snb5LK556x06NLEXIkHd/KCd4xilHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274549; c=relaxed/simple;
	bh=2RQRbrDwnr0lHBnybZlTD1KHrlvxNhkTnMF6UlY2mNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAAxiyiUyU9yZ60OGEekeOB4l9J744zCvUQd+ycflh1y7J+rX4VGeXPT/Q0w6m+ZNY+ez0Yu30SonL9ZlciiTiNtk3zL8qTGXCs+VeBFUfjuC0ez/weNwqGDem6nXSzgj0FLlbX1Qm7vGIjk8Cc4HUnCZT4swEkVmUqqEKG+yx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxpaKV9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxpaKV9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC02C4CEF7;
	Mon, 23 Mar 2026 14:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274549;
	bh=2RQRbrDwnr0lHBnybZlTD1KHrlvxNhkTnMF6UlY2mNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxpaKV9csHPRJuaSGZx8nJdhvuvzCNPPuwy+jM2AX7H4XXAjivPWqRD6yuDKB2aR1
	 e114Vj3VnpWa3boA5ufmg0GlQcErUpBfT9ydVjXubD0JgDSFZwbE5wZ5mlScUDGWt9
	 JRGzEg02sIxiRul3AXD+f+bHySotS1Sqa5XySo5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/212] LoongArch: Check return values for set_memory_{rw,rox}
Date: Mon, 23 Mar 2026 14:44:12 +0100
Message-ID: <20260323134504.750031229@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 431ce839dad66d0d56fb604785452c6a57409f35 ]

set_memory_rw() and set_memory_rox() may fail, so we should check the
return values and return immediately in larch_insn_text_copy().

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
[ kept `stop_machine()` instead of `stop_machine_cpuslocked()` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/inst.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/inst.c
+++ b/arch/loongarch/kernel/inst.c
@@ -260,6 +260,7 @@ static int text_copy_cb(void *data)
 int larch_insn_text_copy(void *dst, void *src, size_t len)
 {
 	int ret = 0;
+	int err = 0;
 	size_t start, end;
 	struct insn_copy copy = {
 		.dst = dst,
@@ -271,9 +272,19 @@ int larch_insn_text_copy(void *dst, void
 	start = round_down((size_t)dst, PAGE_SIZE);
 	end   = round_up((size_t)dst + len, PAGE_SIZE);
 
-	set_memory_rw(start, (end - start) / PAGE_SIZE);
+	err = set_memory_rw(start, (end - start) / PAGE_SIZE);
+	if (err) {
+		pr_info("%s: set_memory_rw() failed\n", __func__);
+		return err;
+	}
+
 	ret = stop_machine(text_copy_cb, &copy, cpu_online_mask);
-	set_memory_rox(start, (end - start) / PAGE_SIZE);
+
+	err = set_memory_rox(start, (end - start) / PAGE_SIZE);
+	if (err) {
+		pr_info("%s: set_memory_rox() failed\n", __func__);
+		return err;
+	}
 
 	return ret;
 }


