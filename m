Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021687;
	b=bRXMpFnf0JIGbz3UZhk5TI1zYb+Wfg6/36q+8k8N88P+ZKja/QaCOG7wZS+M+ziJDrKT
	 eFRI47Lwvg8lzMNoonA6v8f3KdPrAMuT/VIkHXsZxWmfWid6NBvWEGXaHCZ+8MzHT60IH
	 wpsKjN2ym5IG06sDEQyGFvRq4mnhY2tKURhjQqgLWGplPeRO/b/AnbVJ1cwr7aFnE5iYV
	 Y6IOtnfGA/MQl8GgaCVqZLH0wM9qrmgyBMe3F7alM7mF5cXZDcjxux3n8i9H3Si2gmQVi
	 CzGTUQ+ZvDb2bkZ3TAlNBqa7DRCOE2ALfc1C591aMJ0cFsRkxvgIwZg1LTpqRu+hc8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bulKjsVq3ZYVgMQf606AMamsY3eBooQbgCmCFlPMNMo=;
	b=A+Hop4iVXrn9xOuaayBGUdb6IsvGBxjwc3+4I9jXXrKKlAs53go+AnrvBU0F3tRGebd+
	 3QNFCuMrWNwdp5QiCB93VnE35FoUVTithwqQgEQKci9nUgxYZ1kBl5w6F53wIcNlJpJqm
	 gtyu7tHiNcLank0fPC42T5wgA12V5/0he4noSEWuxofbw7lDiO1tYxtoxJdMkIETuejUe
	 aHhT1T06yFt0Eu0Mm+VBwCxmJJ/ObPYBTj1SohBjZKReXPqdgpFGpMzc4bAnVwR1wLXdx
	 bMTrsTrdQu+d10Uw1k+JMTJOwaPY7NdL/FaaXHuU1iIJO2HSnQVderXSKDkpzHd0CjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZwCA9RtS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC82F606A320;
	Wed, 18 Nov 2026 17:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZwCA9RtS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE1B1F000C4;
	Wed, 18 Nov 2026 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021687;
	bh=bulKjsVq3ZYVgMQf606AMamsY3eBooQbgCmCFlPMNMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZwCA9RtSkM0IRNl8mVYtUVByKavjVrMQF8uKGHwVdLn04AoXbz8hHJCb1XrOmJ2cz
	 d90j12BlMcWfKfKRYarS7PxReC97fLQhIbYJRk3kGlEheaxVK9CJaAcRFglDzTKvS2
	 hoe81CfV9mWlImQ7gLlWW6H5TrVvimfbkrFlIJPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2395/2651] profiling: fix sampling step on 64-bit big-endian systems
Date: Wed, 18 Nov 2026 16:00:35 +0100
Message-ID: <20261118150411.600333303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



