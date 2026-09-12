Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5051E1EB5FD;
	Sat, 12 Sep 2026 07:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197804; cv=none; b=NJ3eib8ZeKE0y23iVNf3eg/Qa3WXM4VWCpAEK9dqBlTL6X6B4gcAGMxdu09axq3j3kcs0N7UVjKNmsrwuw53SrwfSBThpe52GXYcZKxnDHQ9y8i8uaWLmQxzfJvn5bmm2KoO63GKtRcDEbshhOdtJODIuvch3k9qwTzl9zOvsb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197804; c=relaxed/simple;
	bh=L1hvD33OkhQ/kRVFYqJ4Npza/hUvJSqUsZ2AF514kf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+yk/DmJdW7MfT7cpAp7DK/UtzqEL9J8yMzX67Kgu2Kksk3EmATJ5VNiSlm1AcOTM9/MFKMJymArLombyC+DRtSz6sOzR8uK9ZFgtpHYzgb+5/Nr37QPIqMO3mVLFOC8IQElUe6ZjuSB6ynIpY97JPYXO1Qim1WJADQcn+2zCr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zq6a//G0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zq6a//G0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721C91F000FF;
	Sat, 12 Sep 2026 07:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197803;
	bh=x+TBsWIPI0U+AGCKnOGEs1SNdUBffYABehxrHX7tAQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zq6a//G0IE7j4emCvJqT51pkqBH4OH2PUbvB20j0wOldFj3KU4YwbcqHNnZKU6/Vz
	 EkJS0pGqGnef1YWi8XQ+p4/ZneTM9otTSsKB/v+fh93Sn8I8xuTGZtqA/cc1O4H2o+
	 Mh6bpwEl8uD5NqzkvYmiELM8Ai61KBVUOccPWV0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0250/1815] time/namespace: Validate nanosecond field in proc_timens_set_offset()
Date: Sat, 12 Sep 2026 08:33:20 +0200
Message-ID: <20260912065654.853487012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5fa0af66cf3f7..3aff27bb0a154 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -293,10 +293,12 @@ int proc_timens_set_offset(struct file *file, struct task_struct *p,
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



