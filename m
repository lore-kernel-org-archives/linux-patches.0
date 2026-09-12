Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04886343893;
	Sat, 12 Sep 2026 09:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206654; cv=none; b=NqEG1WGluuGrhtXJnDLK3cbc86oDZjd2qUgyE5uMGa8lzl4ox+lB8wiGS87ccoovpQO2OP0wVWj+/mGEJTwAjHs7b3dK/PaQAVzzADaWeNFxVN0bHUeIHPsU+pDae/8Cgj5PRKdhJ+R33qDrfJvx5cliXOLHXGVunQ1Jr0vQC34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206654; c=relaxed/simple;
	bh=t1sjun0N+jj0dqZsDWpUFjPZDPltFVeGXUmDFc31D2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Afl11SbXzFO2V3fJXthcqIuaHez11IBTRTyjLnGDlUd2wa16QCgVvjjgAuJZTHwCBMhx1OKleFxJdG5zv/nUZPy3vvO7xU+ST8REYW5vKECq4UvfP1bE7GPpsJ020Jg9WAnnrtN4vUjXRECbQeIKTAVIE28ZK9GWzV93VywiqX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyNioCeR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyNioCeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073461F000FF;
	Sat, 12 Sep 2026 09:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206652;
	bh=/NHuWIacECqlPkmdMAMHQIPcJBF5hEhM5YSbFK6g04s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyNioCeRCdiwOtAghCGOeRfvv6148uy7cqoy9fKFK6Rm5aUfFF2E4SxVgYMrKkO89
	 LIev0Mh5xThhBrlXqLfQ7sQva7vR+qLCGIFyKnm6vZQ8ZIpu6nlT67s79guC7ptmBY
	 OQVcsD9LxXT7OYxQmRC5O+mCBzp/hvbJVj++1hLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0251/1518] time/namespace: Validate nanosecond field in proc_timens_set_offset()
Date: Sat, 12 Sep 2026 08:40:20 +0200
Message-ID: <20260912065629.161449524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
 kernel/time/namespace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/namespace.c b/kernel/time/namespace.c
index 6feb75b52b5cd..8c5d997324d9f 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -294,10 +294,12 @@ int proc_timens_set_offset(struct file *file, struct task_struct *p,
 			return -EINVAL;
 		}
 
-		if (off->val.tv_sec > KTIME_SEC_MAX ||
-		    off->val.tv_sec < -KTIME_SEC_MAX)
+		if (off->val.tv_sec > KTIME_SEC_MAX || off->val.tv_sec < -KTIME_SEC_MAX)
 			return -ERANGE;
 
+		if (off->val.tv_nsec < 0 || off->val.tv_nsec >= NSEC_PER_SEC)
+			return -EINVAL;
+
 		tp = timespec64_add(tp, off->val);
 		/*
 		 * KTIME_SEC_MAX is divided by 2 to be sure that KTIME_MAX is
-- 
2.53.0



