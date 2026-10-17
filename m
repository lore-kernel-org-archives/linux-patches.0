Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8CD3CCA19;
	Sat, 17 Oct 2026 18:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260274; cv=none; b=FYY3PRC55bm/sW+ObOpM82FNHF6kTbYFr5Ub/hQJvpUGMpBA5IBaTgtn2ppKfORaxsoIQvlREV7k34LZYkMEldtTNPcFyuxqEUZnrdVxaC+ZmBTtgjg3e88MGqzotODb7oMF+KCaGO4w+eW6QBbfoE9rqIQKpagcJNpF5jqNYG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260274; c=relaxed/simple;
	bh=+RgR5ZL0Bz+kvmTy7ojpqIVtpIg3GwsVKN4u3BxQCak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6OcPxfcr7dwHcSSRTLH1bdAElElETEt7qtSiTwkgSsURIIXS2nzsY3GoIN2PqYrChBqECh/kka9LmJVT/0+2i4HqhwUz3fq1NuX93hBQh4edmUZQdXHPHDmghm3WGyyHmqaBooNgAHx+jGIGz/AQJkKFFTc5JZMQEB7sEFngNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGq6Bbyr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGq6Bbyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C27D1F000C4;
	Sat, 17 Oct 2026 18:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260272;
	bh=eU0zCU6HQr75X5QImYHQeXadqDq3/4SaUQ4hBOHhX/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGq6BbyrYVf1oWfXmSCK5ifrwzU9Jsn7nxHby5nuOYn6Lj2knxN+veX2jTpf0urS+
	 aj//bahYVt9P8UEwyUD1kk38VuHd1iQZyVn5NMTrlJKCxPrcrq4psRjbPfTJntByAQ
	 08w9yZ2oKD/wNvu/b8TISITbeD2CYHztZ6MlEB+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1489/1674] time/namespace: Validate nanosecond field in proc_timens_set_offset()
Date: Sat, 17 Oct 2026 18:02:41 +0200
Message-ID: <20261017160509.366761207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0775b9ec952af..95a18cae6647b 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -416,6 +416,11 @@ int proc_timens_set_offset(struct file *file, struct task_struct *p,
 		    off->val.tv_sec < -KTIME_SEC_MAX)
 			goto out;
 
+		if (off->val.tv_nsec < 0 || off->val.tv_nsec >= NSEC_PER_SEC) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		tp = timespec64_add(tp, off->val);
 		/*
 		 * KTIME_SEC_MAX is divided by 2 to be sure that KTIME_MAX is
-- 
2.53.0



