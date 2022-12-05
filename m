Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD8115C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C163C433C1;
	Mon,  5 Dec 2022 19:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268224;
	bh=qR3ecGN+bDM1sfIz4tYuS3CGvoUE56QXFPrnFibYKE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEDCntJM51ZEanVtQxXOI70HOFHG2NHOhu0fnkqXHAA45Djc1WGNaZwMmimTRGTyF
	 GZ9mn5iFo25NPmUszt6cmtAggnt6tlyhAHESAmbke0M+sXTIPyfCVIAMAmxEIkWGIw
	 5df87/NftZu3+N5QSi0T4HPYU8KFJQjHVfu7uMsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 025/124] bpf: Do not copy spin lock field from user in bpf_selem_alloc
Date: Mon,  5 Dec 2022 20:08:51 +0100
Message-Id: <20221205190809.166658253@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 836e49e103dfeeff670c934b7d563cbd982fce87 ]

bpf_selem_alloc function is used by inode_storage, sk_storage and
task_storage maps to set map value, for these map types, there may
be a spin lock in the map value, so if we use memcpy to copy the whole
map value from user, the spin lock field may be initialized incorrectly.

Since the spin lock field is zeroed by kzalloc, call copy_map_value
instead of memcpy to skip copying the spin lock field to fix it.

Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://lore.kernel.org/r/20221114134720.1057939-2-xukuohai@huawei.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index d13ffb00e981..cbe918ba9035 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -74,7 +74,7 @@ bpf_selem_alloc(struct bpf_local_storage_map *smap, void *owner,
 				gfp_flags | __GFP_NOWARN);
 	if (selem) {
 		if (value)
-			memcpy(SDATA(selem)->data, value, smap->map.value_size);
+			copy_map_value(&smap->map, SDATA(selem)->data, value);
 		return selem;
 	}
 
-- 
2.35.1



