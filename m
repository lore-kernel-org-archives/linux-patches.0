Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216657;
	b=bzkqTopKmxweYsY9jplFBzn/SvCUWBZi2ryfHbnvSGkIhyFzA1YjxOis4uiLh+RJbTia
	 TEqXS1V8HNYCXDPmPPZ749fi4PePkPupYSHyojy5eAOycaSdxzCGjN/JqPepYAdRkgmw2
	 bpE5A9V4L2V0b8W8Fqr2G+XbTCk4PMuN/u+5+TmlsfkO2fSIjffRqGIMmfIwgWdMwyT86
	 re31oSqyI3S83gUCAdW6cBseU7TvOTNMebLwx4Tfx01cdyK/uU8BCdsGiy58GnEco3zN7
	 1A870TQ9TL8za+CYFgVA+3Unv9lm9H/Yio9b0tC35maA3t7t+jKy6DVBDdS9gykMrEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tt6mZfnZxgYZp8604CDmpAL282/3FvfFqj0c8SB65K8=;
	b=hZT7dSqxsvnbf5zSOi+z9/++xT5/a7ia1avs2i27DrYq/qK26Umtc3ItXBfEmlEUT2Hc
	 Azs4mc+Zk7CuiCwDw1+4kikmK1MEDuzlIHAT8GLTQIF7RPfsnoSE6iBlWpXSNUMFoIqBJ
	 /jlVOFIDXB1mxCdx+RfJXtFdTGYXFoFFOctwNs+gDXs/yDOL6ksBNsOHZjniJTfEQfb/6
	 0fsfuj99Macf/ikxs1D7ugpL04Im+RS4+5j9t2HS/9x2ZiqhICbnCa7R2Si+LhcLO4s3i
	 pknmx5YxaWYyTzits+x9k/kDb67NUl+0CtWYIbg3uUZql/9vR9S302CQkcIwRvUu1QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNm2fs9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFB7606A31A;
	Wed, 28 Oct 2026 19:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNm2fs9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671651F01825;
	Wed, 28 Oct 2026 19:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216656;
	bh=tt6mZfnZxgYZp8604CDmpAL282/3FvfFqj0c8SB65K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNm2fs9EJvJ2BchHfuFIeGlWeWM/Gdo8WnUWZzWVeJSsAnvVipNpHYwrqbBHrKyjP
	 NXnhRghJOtF1C95Qnd8rMEEx7HNKzil5Q8jrN4SK3Xrz+kFDhxAKMhUrlTnicmGr25
	 5e0xHnUt5WbfFP7RXew4aZKWftteKSCI86eAAIYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1632/1887] time/namespace: Validate nanosecond field in proc_timens_set_offset()
Date: Wed, 28 Oct 2026 18:02:08 +0100
Message-ID: <20261028170536.604014169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aec832801c26c..439a5e6f5ae4c 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -398,6 +398,11 @@ int proc_timens_set_offset(struct file *file, struct task_struct *p,
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



