Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2CD1DF965;
	Tue,  6 Jan 2026 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722206; cv=none; b=JVw9YIRd0tbajvQjsvh/wqtewzslZ4ypNgZzt7WZOnXhYA3WxdAXXYv+0DnvtW1ru3BrMut6tRSngwZv8J5ASbjRO0XiDAd9TldsujKyqg/uEv+QnCeTvo+Q1Uvwro1N82xXvZHF+1Qwzm0RvrqxCClvsxoOmEOq2yWv4Um+r5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722206; c=relaxed/simple;
	bh=veHRAwMoWI3dtoEyE9Q7trsTMfkmGmaQeu/PcSymCFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUuaEv8oDHAbqQAVusBx/BehOzcF6qgSGqDXgYhQq2TAUO0H9qZcAj1In80tCHoRjAd5QJv0gcmbRnAh6ypl2xlXbSK4CuL7ShJxqeyUaGyxHxbYCuF2O+tTtdT1UhFD+I10i6g9j4/vNwKnDfy9wAqEQwHrRugkZe22jSLys/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1Q2fs76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1Q2fs76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DB6C116C6;
	Tue,  6 Jan 2026 17:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722206;
	bh=veHRAwMoWI3dtoEyE9Q7trsTMfkmGmaQeu/PcSymCFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1Q2fs767KAQJrjehb7bbgZ1zMzD/MFvEI1JkeeZDbymmqP0yG4hZzPAj4XFc+nTl
	 jaJ+JpzFVzqZc2BTVg+qjqcUXW7km2f06dWmwbK93+e0RNk4VpZ5Fw0IClUCxlGctV
	 3SZgbb9cQQD7qKVNMw0vOf//3R7WoAkATOTMnK/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 194/312] LoongArch: Fix arch_dup_task_struct() for CONFIG_RANDSTRUCT
Date: Tue,  6 Jan 2026 18:04:28 +0100
Message-ID: <20260106170554.844496690@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit a91b446e359aa96cc2655318789fd37441337415 upstream.

Now the optimized version of arch_dup_task_struct() for LoongArch
assumes 'thread' is the last member of 'task_struct'. But this is
not true if CONFIG_RANDSTRUCT is enabled after Linux-6.16.

So fix the arch_dup_task_struct() function for CONFIG_RANDSTRUCT by
copying the whole 'task_struct'.

Cc: stable@vger.kernel.org   # 6.16+
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/process.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/loongarch/kernel/process.c
+++ b/arch/loongarch/kernel/process.c
@@ -130,6 +130,11 @@ int arch_dup_task_struct(struct task_str
 
 	preempt_enable();
 
+	if (IS_ENABLED(CONFIG_RANDSTRUCT)) {
+		memcpy(dst, src, sizeof(struct task_struct));
+		return 0;
+	}
+
 	if (!used_math())
 		memcpy(dst, src, offsetof(struct task_struct, thread.fpu.fpr));
 	else


