Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCE11C32EB;
	Tue,  8 Oct 2024 13:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392988; cv=none; b=rA6wUSfl5Z8vlh1SRVCg/tNph/Je3tpXmfAhQ7mLymGlbwlUVborQK2JjqmZGT0KuwoJyEp+rX5V/l+9nkQEmJT09UvVWxumetOtfy113FqGarYOZPmF6JcGaCn4FCzvMvpRy1FxRD7sCtUQKx+iZ7vSyaW6pM8D+EqD99GUhf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392988; c=relaxed/simple;
	bh=98RcWH8Mmbc00GzguhW9oTxXeRllHo6MYmVId/NELHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4QOp/yBmC7/5tTmU84Hd4oK7siOO2sZItiR+aGiB2b2+Nc/AYUdHsBOLU4nVr6h4ILSM/MVs34sCA1ljIbfJVc4Aqk/t4ihoog6++tcPED1kjt1uZ+G1ZouqN2yWw743cQtzpPkzIzGQYJYu5CRLm42WuEuLJcaC3dk01iY8z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qu/Ih3K5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qu/Ih3K5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5B1C4CEC7;
	Tue,  8 Oct 2024 13:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392988;
	bh=98RcWH8Mmbc00GzguhW9oTxXeRllHo6MYmVId/NELHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qu/Ih3K55kidoNquWgM7d+SwjoMND9vSYwjVAt1QaskQywXm5Ypf06GksREVZcR+3
	 jJNjMG4pD8S4iHLnWbpHWvrhix31ix45huqfNOa45cHIeK82GdCxxO2CI5tSNm+6Ko
	 HnMuqS8NSgcyltwfIIDvJooUUxMSFJ5GEiCC7lCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/386] static_call: Replace pointless WARN_ON() in static_call_module_notify()
Date: Tue,  8 Oct 2024 14:04:07 +0200
Message-ID: <20241008115629.413533155@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit fe513c2ef0a172a58f158e2e70465c4317f0a9a2 ]

static_call_module_notify() triggers a WARN_ON(), when memory allocation
fails in __static_call_add_module().

That's not really justified, because the failure case must be correctly
handled by the well known call chain and the error code is passed
through to the initiating userspace application.

A memory allocation fail is not a fatal problem, but the WARN_ON() takes
the machine out when panic_on_warn is set.

Replace it with a pr_warn().

Fixes: 9183c3f9ed71 ("static_call: Add inline static call infrastructure")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/8734mf7pmb.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/static_call_inline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/static_call_inline.c b/kernel/static_call_inline.c
index 7bb0962b52291..5259cda486d05 100644
--- a/kernel/static_call_inline.c
+++ b/kernel/static_call_inline.c
@@ -453,7 +453,7 @@ static int static_call_module_notify(struct notifier_block *nb,
 	case MODULE_STATE_COMING:
 		ret = static_call_add_module(mod);
 		if (ret) {
-			WARN(1, "Failed to allocate memory for static calls");
+			pr_warn("Failed to allocate memory for static calls\n");
 			static_call_del_module(mod);
 		}
 		break;
-- 
2.43.0



