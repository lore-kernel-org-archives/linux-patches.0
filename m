Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037599;
	b=NLXcBpGwwqmTK3zwkYQKVsUf4bGuqPm7d4wXQJduFpcVSv8Tx0R835zMcULahWGJrSXU
	 0nYp8eo02XvWjqFgYOByjbpZXlioYSAJuP69E4Y7v/C0GZKN0ksqiCyUifEyNfB5Z+oGX
	 A7762WpLybI92+Qw99E6kQ/lBsIUT1zkdPNWaVP5PCVDahPfbwPwOE0o2wdZMnQ1OoUFJ
	 cYti1ngrlaG32r4SzZuknFsH9Rph3GghFhdC7sb719l1Eq/FaVWziPynVsB/ph9FHzX/O
	 S6+AMeqezjqji0yusEV9L9Jp350oiFfYeLerjPPPoPuN1Bmve99g0vUF0Y2h2DS8Ftw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dcdKPUu1wxo1NzTPv4HvnLR1UVKJvAp/X+YWx39A9i8=;
	b=YR0YGMsvoo6WK+aa1+it3i5jhKVgCecSHoe629u0ZD5r8ft0kua62OO/BtREh37LEnE/
	 gzwMt18e3K6VEMUc1XhNIKo4BkH7w/QbO21YgXhvhQgsyk86dKmuia/3C+ANyFCKL7B8W
	 0K8VvmWmE2cBBwUQjmfhzbUeDNUaNHaMmfuHu5beHgp4LDj0MKsP5GCBFgxetmpkZ1Y2D
	 yx7O4NRR7L7qkPNnALIsfOt8MaGmgyB2iptlcVYk78/r/0Y0J2NimExNpFj8IWaQ609HM
	 Ck5AJEDnVRe83LmktLsYm2DWeYETgz9XvyzEZo38nCjsaPdnp/Cv7DDBZNbkD6dB0PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AtIbMzuv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1787606A31C;
	Wed, 18 Nov 2026 21:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AtIbMzuv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D491F000C4;
	Wed, 18 Nov 2026 21:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037599;
	bh=dcdKPUu1wxo1NzTPv4HvnLR1UVKJvAp/X+YWx39A9i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtIbMzuv03w9HAyWHfSiNSVfUA3Sl1rmi/uz/56JQG9U4JrotPVoNP30oCW/Paap5
	 hn5UtQhN+Pazul/m9LTQK6qh3l5ExZqxHOFzq9JYxuDd8NeXGhBDHNPyzgZXuAr1+J
	 qvCFwSlXj5TfzHo05Z42dfxkVn9sgCL4QfhffTgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1453/3318] vringh: reject empty / undersized indirect descriptor tables
Date: Wed, 18 Nov 2026 15:34:35 +0100
Message-ID: <20261118150404.449534414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit 60a792b97933a686316737838cd007d27963011e ]

move_to_indirect() validates an indirect descriptor table only with
"len % sizeof(struct vring_desc)".  A descriptor flagged
VRING_DESC_F_INDIRECT with len == 0 passes that test, so *desc_max is
set to 0 while *descs points at the empty table.  __vringh_iov() then
copies one struct vring_desc from descs[0] -- 16 bytes past the end of
the table -- before the "indirect_count > desc_max" loop detection
aborts the walk.  The over-read value is discarded when the walk aborts
and is never used to map anything, but the access itself is out of
bounds.

Reject any len smaller than one descriptor, alongside the existing
stride check, so an empty table is refused with -EINVAL and no
descriptor is ever fetched from it.

Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Message-ID: <20260926160755.21485-1-fangxy@xiaopeng.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 03cbe0333cab2..9fc522489106b 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -197,8 +197,9 @@ static int move_to_indirect(const struct vringh *vrh,
 	}
 
 	len = vringh32_to_cpu(vrh, desc->len);
-	if (unlikely(len % sizeof(struct vring_desc))) {
-		vringh_bad("Strange indirect len %u", desc->len);
+	if (unlikely(len < sizeof(struct vring_desc) ||
+		     len % sizeof(struct vring_desc))) {
+		vringh_bad("Invalid indirect len %u", desc->len);
 		return -EINVAL;
 	}
 
-- 
2.53.0



