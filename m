Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C684E20CCEC;
	Fri,  6 Dec 2024 15:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498446; cv=none; b=CoTiBbGrH4tkHUc6MxB9pyDFUru864C5uLJ/hNnwcpJgBnz62jh16eajdHtVfTpZBcuLC9brmtwoy9BZrrIdknrwl11GLzZJ2xoMgPlfuxeZq7eJsUeXNGy4//YQaFYn7UC5e6rf/oPFzBgmoO2Nd78a5STT0jtmu3n3ndYc/0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498446; c=relaxed/simple;
	bh=O7z9gvNcVO56uQSGprT6GkKg28GV+wnMGMWqYCa3ogA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q03SvMGYpHEh9vo72ziXtjOThQt3ykAKXpXGjop/bv8UbRTK0GJJPuUEQEB2hQ0NTTNSTQRVIudBGaZ3hdRd5BUj16doKlsDn0kvxfLz6cBazuP/r/o9DsYFAR8chEuQxck3RX39DejQlonfIIy2gxhobpqApUYXzEn6JQemvVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4Or92Ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4Or92Ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359D7C4CEDC;
	Fri,  6 Dec 2024 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498446;
	bh=O7z9gvNcVO56uQSGprT6GkKg28GV+wnMGMWqYCa3ogA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4Or92UlDf3One6dfY75L5Jty0cK4cftWFDHndzcpnunZu/BNFC+BvCZplGCEISiJ
	 sUE9PJo2xrpyTTZfYCIGZHoz45YTBZTJYxeMd5HDC3E37dmXgxTHRfyp4hk3rTIzfZ
	 eBFw6bZKpsdwthWJZAfgZs2c1j2hCZ37wO7OGFug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 556/676] um: Always dump trace for specified task in show_stack
Date: Fri,  6 Dec 2024 15:36:15 +0100
Message-ID: <20241206143715.086023183@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 0f659ff362eac69777c4c191b7e5ccb19d76c67d ]

Currently, show_stack() always dumps the trace of the current task.
However, it should dump the trace of the specified task if one is
provided. Otherwise, things like running "echo t > sysrq-trigger"
won't work as expected.

Fixes: 970e51feaddb ("um: Add support for CONFIG_STACKTRACE")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20241106103933.1132365-1-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/sysrq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 746715379f12a..7e897e44a03da 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -53,5 +53,5 @@ void show_stack(struct task_struct *task, unsigned long *stack,
 	}
 
 	printk("%sCall Trace:\n", loglvl);
-	dump_trace(current, &stackops, (void *)loglvl);
+	dump_trace(task ?: current, &stackops, (void *)loglvl);
 }
-- 
2.43.0



