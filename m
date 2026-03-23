Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F11D3A6B88;
	Mon, 23 Mar 2026 13:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273940; cv=none; b=jb0AYEABo39ZCvzCVLRse6SJcT2IUTB6OA6AvmLLtnHDx7Z2dtrOcCcgdtpTPp+bpb/vGv65EGLIcZO7T7V1fBpMjlFeIza4/By9f8HoSGs+gK12VKHmVYFmh22PM4fZfSXX7czFahs2TX9TtH3N+QZLVz7fx3buVX0VXT+Ykrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273940; c=relaxed/simple;
	bh=eKQJKbyS1FSAiEQFKp5+kUb5g7Ns5hc8vIU0D7wGd3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNrj4t6rw3WY1lEKYqMSBHHGiItl1eNSmhJenGY2Ad3nJ6gYzGPH8wG+H/g4Jy86tLYXp34YqqsKSZBbG5YFVahrgEzS3CdOSiWCNdmiVLYlAUtMwALbkfZoGJ0D4NYV/sdkXMhVoUa2mT20N1uR0b199du9VbW1uyq2xX15hQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDvhhb8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDvhhb8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B91C4CEF7;
	Mon, 23 Mar 2026 13:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273939;
	bh=eKQJKbyS1FSAiEQFKp5+kUb5g7Ns5hc8vIU0D7wGd3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDvhhb8FAsXEJkJS48amcmUPYt9/TVAVoeA331XlgH4AkZJepFOWHagp/cgNi8dBV
	 2T/ofpuFUrEbvCSxA71qQsuRTQpHVI1h+SVdwxSTin5PaPULriuYftljq/bIBq/Jct
	 +y/0OsGkusE2LTvBflcmxBKlnaox2CFWP1hUHkUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 030/220] LoongArch: Check return values for set_memory_{rw,rox}
Date: Mon, 23 Mar 2026 14:43:27 +0100
Message-ID: <20260323134505.530530226@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


