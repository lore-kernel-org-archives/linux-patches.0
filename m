Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022230;
	b=BnwSzucHU6412VdCpg+CzOHL841P+tXvK5C4kRo5xprUpS2Zt1UPqzDKtveWfTqDkkWQ
	 zBpYFRMzpecFWveVofjE+10asHfagLvdXSycP5DhQAHpYyp2eUFXJMvh6fYCdjsipbmas
	 co7k8n5+9R1CfpiWN22sbVxFSf3BRb9RmUUrUxXveqbJ6UtMTqA0Rxp5GDQrczIWJQYkV
	 9y5kFErMQ3ddQSpja62udkXm5rXGbOvzPphpgsjiBlmXXx36cnnmQzdsWPaBtptpNkcFK
	 s61X9SIftMLIM//LpgqABctKcvm29BOmNu7sNPAINGw0FmsTSxuG6pV+LjwGlgTkUwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DSpHi1f5pZbnaE+Nz1eVakNrAOxQl6Jcm+GCgzHOlAg=;
	b=Cfjki1KM/jlXeTSDTo9mCsI1sOPIqNJfdwiBAmGS4AIMZU2jwsIgN9hTXdkuET6mVhGS
	 DlL3nTXdypJCkzhGrWG3MoqPMpYI8DzNBgzwZ3yUnuyB8AobHSLzGvO0rPT5wkoUFw2cY
	 oBuLKmUwVbNBYWudzy+grVvEMa+UsEGNvuxtnX2129hVMYpkSfjnmCkKp0I4hQqn8Cchf
	 ylcbgsMyztJ4WUTbgNHfYYr6tbKZkoxH0cqTmdfjFgBroicgxK1ZcrVqbje2Wns8wyV8U
	 pQNJS/pcNpjJCUvLtOv5BQZ3RYqXCGpPSiRhKYr2tpOABqPxi6ACRS0KDAZM0T4vS/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbEyfNyw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA9B606A31C;
	Wed, 18 Nov 2026 17:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbEyfNyw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF56A1F000C4;
	Wed, 18 Nov 2026 17:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022230;
	bh=DSpHi1f5pZbnaE+Nz1eVakNrAOxQl6Jcm+GCgzHOlAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbEyfNywvOkdotWKsznJzJff0ef7ZoOzMLL6pPq9VR3B5IqVEir+3xS0lJ9GehgqQ
	 AHkvWzH9QKixTByfnvceidkJppOHBYiJiL+qAwnsI+UieEum4vBR/5H26FfJNKp2MO
	 nF1UgUcrQoSkkvz7E+z3bnYHe54IZr/+vN3xHWwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2589/2651] block: partitions/mac: compute the sectors in 64 bits
Date: Wed, 18 Nov 2026 16:03:49 +0100
Message-ID: <20261118150417.487134841@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 6c55f94317249bc195e197f6a8730c843e72ea8c ]

start_block and block_count are converted to 512 byte sectors in 32-bit
arithmetic, although put_partition() takes a sector_t. With a block size
above 512 bytes anything beyond 2TiB wraps and the partition lands on
top of another one.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-43-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/partitions/mac.c b/block/partitions/mac.c
index df03ca428e157..f372392af95b9 100644
--- a/block/partitions/mac.c
+++ b/block/partitions/mac.c
@@ -97,8 +97,8 @@ int mac_partition(struct parsed_partitions *state)
 		if (be16_to_cpu(part->signature) != MAC_PARTITION_MAGIC)
 			break;
 		put_partition(state, slot,
-			be32_to_cpu(part->start_block) * (secsize/512),
-			be32_to_cpu(part->block_count) * (secsize/512));
+			(sector_t)be32_to_cpu(part->start_block) * (secsize/512),
+			(sector_t)be32_to_cpu(part->block_count) * (secsize/512));
 
 		if (!strncasecmp(part->type, "Linux_RAID", 10))
 			state->parts[slot].flags = ADDPART_FLAG_RAID;
-- 
2.53.0



