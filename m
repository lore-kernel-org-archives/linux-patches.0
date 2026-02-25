Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232C827A45C;
	Wed, 25 Feb 2026 01:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983840; cv=none; b=tMPgqNNkkNJW9up/uuaGlNWDvf3SA0SwhqlNcXjRCUFE/WLv1R673r66IAjy9PMd0r5TTMaRdXQM9MOhr7bHTPVX9Vkpp2EQLXe6ojuYWESlE8IM0H54lgk5QrK1+V0/exF9hwtClZO+BLBa9ch8/TaAdg7B6kX/Db8+vXmAKmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983840; c=relaxed/simple;
	bh=7hY3zhrtLT5Hln/ank4C1wea5KFfYX729VZrNilbtsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wk+bI7yq5EAc7EbaplBi7tsO0fBSpilTZT/G49MwcOa8KgnHOWrUirPHnnQXFAVrKMAjMVcBop1Q4Bg1l9kbkYMLsx9IhV/kug3jfdztA4SEgYTwWkYS8cBgZ9yYBRGE1wrIqj6Wkv7ZXLc0c7TsrEzhbmKp7Y0BA7uDQBFCvKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9sqXA/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9sqXA/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE347C116D0;
	Wed, 25 Feb 2026 01:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983840;
	bh=7hY3zhrtLT5Hln/ank4C1wea5KFfYX729VZrNilbtsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9sqXA/mT0g3myEbnhaSK6BWkdyDIVQ/uDrfgLzoLlhbVbYHTlKxbUVtbdu38hyee
	 rh0atR1JFQSTRHGpKJlFIYTxKNOoAtfVJOGcwBjmbT+wTYnUfZKfnSef9K82C1+4Zg
	 3rKdE3WE0tDBIR+x5oYUkkO7VD6DvsdPkyuuqvAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	KP Singh <kpsingh@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/641] bpf: Limit bpf program signature size
Date: Tue, 24 Feb 2026 17:17:24 -0800
Message-ID: <20260225012351.992745686@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: KP Singh <kpsingh@kernel.org>

[ Upstream commit ea1535e28bb3773fc0b3cbd1f3842b808016990c ]

Practical BPF signatures are significantly smaller than
KMALLOC_MAX_CACHE_SIZE

Allowing larger sizes opens the door for abuse by passing excessive
size values and forcing the kernel into expensive allocation paths (via
kmalloc_large or vmalloc).

Fixes: 349271568303 ("bpf: Implement signature verification for BPF programs")
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: KP Singh <kpsingh@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260205063807.690823-1-kpsingh@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f39367765f0c4..2649e0472dfe0 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2825,6 +2825,13 @@ static int bpf_prog_verify_signature(struct bpf_prog *prog, union bpf_attr *attr
 	void *sig;
 	int err = 0;
 
+	/*
+	 * Don't attempt to use kmalloc_large or vmalloc for signatures.
+	 * Practical signature for BPF program should be below this limit.
+	 */
+	if (attr->signature_size > KMALLOC_MAX_CACHE_SIZE)
+		return -EINVAL;
+
 	if (system_keyring_id_check(attr->keyring_id) == 0)
 		key = bpf_lookup_system_key(attr->keyring_id);
 	else
-- 
2.51.0



