Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1291A76A4;
	Tue, 30 Jul 2024 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359812; cv=none; b=V1b63nsaIPHtcXOt4JbvxAVfcH+Yf2QMnxqSiysrKa+H80hrlFMuN//sy/y3yZL0f2x/f+Lahnl1tTSHKQHr1H6Tc1CoTobAIG1bWN0eEwdHEQ+hPuJ/qbBEmBCE3oM9lt28+fRdXinEYJGrr8Rd2RY0O3JkJOMDsolWeHGfnCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359812; c=relaxed/simple;
	bh=zGF3yf+rSGc01y27kGuSInQgZlZ+3SqAmJkMcD8PvIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnIOwNx3B8puNZ5vrbKi8UNUr9OOcIRpIhVv6on6EFCqGxKtIXXuqhG1R6i8wwiGwRbBIoiuB4ll699EeHFvm5zS/g6XQ5lXhCO2lqBwb3nQQPQOpLOpS3OXIuOq6vp0v0iEM7RY8MSkW54KcHQVkvNF+fz+d0WXC+CxSEFiyPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F37qHFVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F37qHFVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4BEC4AF0A;
	Tue, 30 Jul 2024 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359812;
	bh=zGF3yf+rSGc01y27kGuSInQgZlZ+3SqAmJkMcD8PvIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F37qHFVD1q85iRvXpN/tXuxvmZK5I83AJ9KT4kc19XnH41u68VAMwUEjPcJY4Ox+X
	 QELocDSWaYKBySWZ7iT85HZIq5Uz4SyOH0Ko3IKKQqTi48DpuITd8Y8RKYTnaJXLs2
	 SSIKuVE9XSDcBxA2nCMOD+OpVii+nwn560TcRm3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 517/568] kdb: Use the passed prompt in kdb_position_cursor()
Date: Tue, 30 Jul 2024 17:50:24 +0200
Message-ID: <20240730151700.363215695@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit e2e821095949cde46256034975a90f88626a2a73 ]

The function kdb_position_cursor() takes in a "prompt" parameter but
never uses it. This doesn't _really_ matter since all current callers
of the function pass the same value and it's a global variable, but
it's a bit ugly. Let's clean it up.

Found by code inspection. This patch is expected to functionally be a
no-op.

Fixes: 09b35989421d ("kdb: Use format-strings rather than '\0' injection in kdb_read()")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240528071144.1.I0feb49839c6b6f4f2c4bf34764f5e95de3f55a66@changeid
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 2d65da509f699..4799f6250bb26 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -206,7 +206,7 @@ char kdb_getchar(void)
  */
 static void kdb_position_cursor(char *prompt, char *buffer, char *cp)
 {
-	kdb_printf("\r%s", kdb_prompt_str);
+	kdb_printf("\r%s", prompt);
 	if (cp > buffer)
 		kdb_printf("%.*s", (int)(cp - buffer), buffer);
 }
-- 
2.43.0



