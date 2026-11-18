Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050484;
	b=5rLWXqRgAl0WXL+AGkWC8NxjYhTunpYIUCOXBRfVFcQa2oyzW0i8tC3D08YqkQziaVhb
	 msmzxXEkYa2T1RGmrnB4tdgsjuMjG8N7WeebNmArBX8i6yLLJ1Jp4+0wF2WOJQnlL+N/P
	 f4VOnRcoIORG85j4piwlr50VsJ1gInrwZVg0wZsg2kXGJaXx5vMnBhrE0fgXkuaiVjSYb
	 BjuXKPv//TYWQbhY4t0eYMEzjwqrUokyAHmimPv+AEz9lql9+7q5x4lIiUsoUHNVlCEx8
	 3Wnah8j2JePeky/aL0Ck2F0EvY6aVhBfvHG80xPOXUqx5Jo+/SUaxhTiOGrlxLFWSKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/iLLI5s/Fwxb2x3p/ZzCiJoDsq+hZf4gR5y0ktvuxAs=;
	b=TNa9gX1ZAHd2hnB+3pqfaFQlNkuxHahuDhAlzrgNVWLfatMRsdVQ/HWtMLjQ7TyUPetx
	 oxc46vzWjj2zwT3IIRzKOplYuNdqEAn4efFvCnJU+CGG2G5frUDZs4OS8UvC+COmNr+nc
	 jnEE1P8wOxVQnkjJfTTdT3ABICVbONM7voiZ55+6VCNJameORT32CCvDzbR46YGST2FaO
	 gFhciFKT/IgBNXV3qh5XXNiwfzRJRvx8rz4BFuhro4DmH2DodxgwceofIhe3nUMzCMBLN
	 C/GkbTZXa+y91hGCIPhfyenJiGvw5Pktq0lhpW4cRW3vzGPgq+ciNOATvEs0VzFa/kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXAGAio8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46781606A31C;
	Thu, 19 Nov 2026 01:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXAGAio8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996771F000C4;
	Thu, 19 Nov 2026 01:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050484;
	bh=/iLLI5s/Fwxb2x3p/ZzCiJoDsq+hZf4gR5y0ktvuxAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXAGAio8P0Bn76xvlZBaH8u/OZRPwtdWyZyXDW9gxfhK/z76OdIGsrItUDIsreb+P
	 GAVUHl2k3/pgdfNecYgDP4EnhX1c7SSh4QFkwyyoS6RLHr/VOxFDZcJc9rifUYBnkx
	 F7bMhXodBuAXYwy6WXeAUuw4VH77GToBEoAS2+Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2725/2857] profiling: fix sampling step on 64-bit big-endian systems
Date: Wed, 18 Nov 2026 16:02:39 +0100
Message-ID: <20261118150339.738349606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 984f819b701c9..45fdd0cb6141a 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -390,7 +390,7 @@ read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	unsigned long p = *ppos;
 	ssize_t read;
 	char *pnt;
-	unsigned long sample_step = 1UL << prof_shift;
+	unsigned int sample_step = (unsigned int)(1UL << prof_shift);
 
 	profile_flip_buffers();
 	if (p >= (prof_len+1)*sizeof(unsigned int))
-- 
2.53.0



