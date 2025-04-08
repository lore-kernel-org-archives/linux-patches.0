Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADBD266EEA;
	Tue,  8 Apr 2025 11:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112722; cv=none; b=Iuu3lB6YdZ7OMiI7e0vDMonA0gglksHa3QrEhQa691sblV0YHsH84pZP8xDOXVL58+JDxhJoW2R2kAtcSkWhuKswyFK7M9jnl11KMx2DhjLD2+O5219UrTTIYIWFlN/6AMKPK3nhsaJqDC4GX/61QXVKyTfoUYFyU8FHoeQo4vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112722; c=relaxed/simple;
	bh=9/BgZtQgoQbPQcj/Bc5tlfZrFb1LK3IiH1VaGZvdEac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyg1GmUC1ghJBtwW+s78wWGkqLmW+82myzw8Zlj4a2rVNgHj1EyuqhBvJUQZSstFzBP8Nmja6lLacQn9PHBDg0ok1s8o7JEfp0JzsLZ9oNwTGXrvDGOkSYfpcfH/WvkMWWZ5Vk+7+5wjLm7fb7vt6yQlHhKXJkVeAeG4ZmocrMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbBM8Xpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbBM8Xpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17078C4CEE5;
	Tue,  8 Apr 2025 11:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112721;
	bh=9/BgZtQgoQbPQcj/Bc5tlfZrFb1LK3IiH1VaGZvdEac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbBM8XplXcRtgEybLPlICBbSuy3APOVvAC46XaAU4JKavIx60fMa/l6jOzf7TeciE
	 jpvqIajAiABj0aj2SfyO+a4VGuRHl/2rFrEkLdwbN2v5iHZaMIDfUk70Ismc2AYRac
	 m2DPvxIVAxohMO+oNEDIdUntbcYoNULpQ6TXF3dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/279] bpf: Use preempt_count() directly in bpf_send_signal_common()
Date: Tue,  8 Apr 2025 12:49:17 +0200
Message-ID: <20250408104831.029352497@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit b4a8b5bba712a711d8ca1f7d04646db63f9c88f5 ]

bpf_send_signal_common() uses preemptible() to check whether or not the
current context is preemptible. If it is preemptible, it will use
irq_work to send the signal asynchronously instead of trying to hold a
spin-lock, because spin-lock is sleepable under PREEMPT_RT.

However, preemptible() depends on CONFIG_PREEMPT_COUNT. When
CONFIG_PREEMPT_COUNT is turned off (e.g., CONFIG_PREEMPT_VOLUNTARY=y),
!preemptible() will be evaluated as 1 and bpf_send_signal_common() will
use irq_work unconditionally.

Fix it by unfolding "!preemptible()" and using "preempt_count() != 0 ||
irqs_disabled()" instead.

Fixes: 87c544108b61 ("bpf: Send signals asynchronously if !preemptible")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20250220042259.1583319-1-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 60acc3c76316f..dba736defdfec 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -799,7 +799,7 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 	if (unlikely(is_global_init(current)))
 		return -EPERM;
 
-	if (!preemptible()) {
+	if (preempt_count() != 0 || irqs_disabled()) {
 		/* Do an early check on signal validity. Otherwise,
 		 * the error is lost in deferred irq_work.
 		 */
-- 
2.39.5



