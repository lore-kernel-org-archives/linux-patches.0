Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032831;
	b=smt31NTUK0zfkQzDW73GyAHOA/uuBL94KcuEqieiJ2qFMPRU1/Syl9moEdsRu+d6jt0J
	 0dwz5GB9fCA6pcm1GruubRcG8/TboqThznrykVKMK+J9bYdamzBBX05AckVNUXpL3IPHz
	 iW7aNgm5W434Obsl81PWsLBKe0LUevYD44u27DGEHFU6s0kH2KimgSJVb+ze2eex7pVkY
	 LkQb3w0EzThvPR2WkeTf42x1qqLcL5T43c9RgaNkbIeb+BFuDQJK8YRkC5zrwv/Ghwqup
	 Tj5BeN9f4x7OarLhAPJ0E3rXrEc1IvVq7UtzJIcbPE9WQLZZ538gVAw5GNwQ0Y0E9NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PYaLPCNbH6hPpvC4KkdFgsv3efRCITNN/ipUIli2Ja8=;
	b=bv9Oo93rLpwR7Bl46G7QtJ/30hoAsujQbC1ST4o4H70fG9+xZtlSFlytb/PgcE7Z3sUY
	 gGfAOUtjeRUWBPviBiSmBJ4+Bbv5QSzHriaq4owlnrHQeGn6khlNtPcDGWrz79WmKv+Lv
	 i5Rzt2GP4k1FIwZhZ+UH+gi6E2oy9cwI7VC2SmvMDWn6JeI9deApmXYUcI068fCABHE45
	 mQzteHwwIq7whEGywUx08kFXwW2wAiJOVK6DPgFJVg5/QEl9BHp3xuoecsdRzdezgo+x1
	 ZHK4RWD/DesfnAM8Qj7sJRXWNFIcMu5bsrfQFw2ljEK1DZd1ZTYQi+Vdq3mUPNG5K5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KsuM9RQ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C67606A32C;
	Wed, 18 Nov 2026 20:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KsuM9RQ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C1B1F000C4;
	Wed, 18 Nov 2026 20:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032831;
	bh=PYaLPCNbH6hPpvC4KkdFgsv3efRCITNN/ipUIli2Ja8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsuM9RQ33wBMVAD99Rs/EQmdqy0Gv/dRlLnmsNyw4/CUhO+OdMxRFe7OsS1B5Wftm
	 E3V/2ANFdP4IKC24m6EAJRa3F0XOz/+Ig/aJLV8VwZaOgLIbU6Y0r3YXIymq8T+fOB
	 RlJH7uHobau+YcusPaIYMHfuNprEJvqi9QQ6ML4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1549/1756] profiling: fix sampling step on 64-bit big-endian systems
Date: Wed, 18 Nov 2026 16:01:16 +0100
Message-ID: <20261118150110.658960076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit b1d68946a08313895f352af5336623d29739c299 ]

read_profile() stores the sampling step in an unsigned long but copies
only four bytes to userspace.  On 64-bit big-endian systems (not common
obviously), this copies the upper 32 bits and discards the rest, causing
/proc/profile to report zero for normal shift values.

Cast to unsigned int so we get the correct 4 bytes, while keeping the
shift calculation in unsigned long.

A small C reproducer under qemu-s390x reproduced this and proved the fix
works for prof_shift=2.

Link: https://lore.kernel.org/20261020101225.917959-1-thnkslprpt@gmail.com
Fixes: 2d186afd04d6 ("profiling: fix shift-out-of-bounds bugs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/profile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 1fcf1adcf4eb0..e7defa90a34c9 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -156,7 +156,7 @@ read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	unsigned long p = *ppos;
 	ssize_t read;
 	char *pnt;
-	unsigned long sample_step = 1UL << prof_shift;
+	unsigned int sample_step = (unsigned int)(1UL << prof_shift);
 
 	if (p >= (prof_len+1)*sizeof(unsigned int))
 		return 0;
-- 
2.53.0



