Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591090;
	b=QLeFRoFuVtgCcr2CVfqw/8eeromC4wqIyJjDjc8vEe0KqXAoApo30u6xQDvR9Y5gceDI
	 WTMyhenwr6/ksRudrPt1QmUesxsYjuEsN6i/FAnYRvHTLD7IgjEjOXSvisjKCE/0iGWSy
	 8snQLkji7G/Br5kw+Q1vkPQ4hC1h1dRa661TcdZohWWrFvIfwdD4X2AGOtUffijskLOSd
	 uwISmTuU5Lvvd1jHRQ7kmzzWdJfSfp4UwfKLRjAh//GCGGfLAsCAB9nf+Ng6a9ZNMRbmG
	 SfL7Q3XWyp+jmUCwQcKgQLb78pKFq5V5QeM00t+sNUYPGqsNepXRZ7m3G5BKe+nfMzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hZSg8VPAhlIFJPL3Ds+EVaYsuB/j4xE4ZUI7mSfNud8=;
	b=4Jo/8SUaKjEm0ojrCMgRfcgfQpwVO09uis6LyON/T0BrsgeHEHWMqAS8Ubzi9dzJ07cr
	 siS18Q0gqmbZHBOys6DYXxan12eTAMFaUSyvbtpb37iif1nGfzYHDFtbd6HaHLLFP3NoL
	 sVuEAXV6PoCIFTV9MJ+QZyrBlI5tXQGDmgzD1w2sNWc7bT3YzFLsbAGbS+xxmd0kSM1DM
	 glfT4zUA7To9Upxuyq6ItC63YvmCShIfFzed5jc+rW30TtZe/zljbImKmJJxhPZ8EFWWE
	 VgSFhkp9xqQR1pJzbpLHnp0pAo4oPT0fYYkV+d6wzz5HkYO9jgz2Pnz5czXanOk4F3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WExnjS3s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4B0606B371;
	Fri, 13 Nov 2026 17:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WExnjS3s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3741F000C4;
	Fri, 13 Nov 2026 17:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591090;
	bh=hZSg8VPAhlIFJPL3Ds+EVaYsuB/j4xE4ZUI7mSfNud8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WExnjS3s8T2VprmfnBrcdmuWhqr4R0Gecok+19yvSi7M4cQCLmsqKillFOsPrn+eh
	 wzbq2kgvAw4ZNtIVDXu+KXeVqHa9YjpISFoE5NlaTFM0lMlblGcgD2b2l3Lp7VFWoY
	 gDkxognc63235L/kHHKDj9kgQOUpGGQnAA7LwQlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 242/670] vringh: reject empty / undersized indirect descriptor tables
Date: Fri, 13 Nov 2026 10:46:46 -0500
Message-ID: <20261113153820.047450251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 07dafd10ef8b6..db012d6b549e5 100644
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



