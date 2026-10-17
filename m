Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDF93A8FEA;
	Sat, 17 Oct 2026 16:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255234; cv=none; b=PpuG3c1ixysq7H+eWn4xsWpQPTU/ARnGcMSLd7dgBxdFmS88Ks3ftpKza9lQFsbAQ8vYgUtX3M/DUE6wgNKww3A8xHE9Jz3WVQyyEZViyODJCx3UYmSgWQq7ozHhC3DDNwbMuWgnplYW0hzs8sAQ7hHBjrEb3EuwtRH5zxuv8S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255234; c=relaxed/simple;
	bh=VFd1JIq/G5qXz+W3DTMd/XO3GTwpg+Pjoz2Q+7Ul62k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtcYYff8g6haHE1Sm3BXB3QOOIbuxzX3t4npbdTJ+nccu7lCgV6FIgv7MlmKKAeBIDrMy+eGWeZGmGeV/6hkEaGANVYa8depmNZenvDV6os8WjjhNrLv+J5BF5PyoGSa/hQoMc3IBYwviY7HNJ/rIxSsQIZ3GEAXDC9bhcKVlKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejb0hXvk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejb0hXvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1A81F000C6;
	Sat, 17 Oct 2026 16:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255233;
	bh=CHzsruIzfVXB84zzVwKp4i1tW1NFrADaZpTT5FnJNPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejb0hXvkhkylJMNoEYDrEuc4NHduSiZ9/dVEANE5GfMaC97zv3rug2YGEJrP1DyGN
	 OrZhp69p7xIbaIwBtJEYWSlyXej+IXsJPCoJTKNVNo5oEFFKYF0Vcm0RP61RdGWR89
	 v3pJAECqFHxD2qKg/ojqEa6AI/c2KdMKCHlFpDyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 710/869] time/namespace: Validate nanosecond field in proc_timens_set_offset()
Date: Sat, 17 Oct 2026 17:59:11 +0200
Message-ID: <20261017160055.164570123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malaya Kumar Rout <malayarout91@gmail.com>

[ Upstream commit 06aba58e58492d2b8eae059274caed29025ea96e ]

The function validates tv_sec to be within [-KTIME_SEC_MAX, KTIME_SEC_MAX]
but never validates that tv_nsec is within the valid range of
[0, NSEC_PER_SEC-1] before using it in timespec64_add().

timespec64_add() expects both timespec64 structures to have normalized
values with tv_nsec in the range [0, 999999999]. If off->val.tv_nsec
contains invalid values (negative or >= NSEC_PER_SEC), it could lead to
incorrect calculations or unexpected behavior.

Add validation to ensure tv_nsec is within the valid range before
performing the addition.

Fixes: 04a8682a71be ("fs/proc: Introduce /proc/pid/timens_offsets")
Signed-off-by: Malaya Kumar Rout <malayarout91@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260704093429.89350-1-malayarout91@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/namespace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/time/namespace.c b/kernel/time/namespace.c
index 0775b9ec952af..09a4cc85a9fbc 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -410,6 +410,11 @@ int proc_timens_set_offset(struct file *file, struct task_struct *p,
 			goto out;
 		}
 
+		if (off->val.tv_nsec < 0 || off->val.tv_nsec >= NSEC_PER_SEC) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		err = -ERANGE;
 
 		if (off->val.tv_sec > KTIME_SEC_MAX ||
-- 
2.53.0



