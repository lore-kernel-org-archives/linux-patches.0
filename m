Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3C135A296;
	Mon, 18 Aug 2025 14:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526446; cv=none; b=RWXTc9cF1q4MNE6+E3Hf+G7I9cQOxDCpLB3/Nvivx2m5rWHM+2QShAWfLjtQNi+nGKGLqihoP9Y9rDQIl6QMcs9HPpOapHiWymvffBaWgVXXHMur8TAGQZ5Tn9DeF7ixaZwgdoEyeJXKci2JS9Mloc2HXXKYS5BF90GBP8k0k/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526446; c=relaxed/simple;
	bh=v6wptlNWf0EHBkZPcWxyiH2olJQT+dkMyVGW82xklsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeXgoD+s/XNpNgOk6uAa6nIf29FvzxLwAV2qwVOfdXyNt3EA6JSh9mX2Q/DhqcaDHUt/zNfiorQJCsArxsPw8eFtPQtEVM29g0TGSay6nr1ZuwGxEhux79Txg3B2Egv+DwwsgrvLB2XqrSHiFjs40ssJvJjj+VZls9fdOFcE5QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQ78F7PH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQ78F7PH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C27C4CEEB;
	Mon, 18 Aug 2025 14:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526446;
	bh=v6wptlNWf0EHBkZPcWxyiH2olJQT+dkMyVGW82xklsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQ78F7PH1ER5LqerNRkG4+RmYMhoT+rNZHZC4Y6jSkhvmJwboSw74CXNBEDMzkGef
	 0IOwYSiwMO8Sbs5brLp73Oitwz7CjKeKsfzAybuOBo2K9HqRGhnG/SOCmSqphlq9sV
	 JScg2MlGpWF1D4zAn0yTiH7uh81IM+LglkBA8M80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 515/570] btrfs: zoned: requeue to unused block group list if zone finish failed
Date: Mon, 18 Aug 2025 14:48:22 +0200
Message-ID: <20250818124525.701344287@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 62be7afcc13b2727bdc6a4c91aefed6b452e6ecc upstream.

btrfs_zone_finish() can fail for several reason. If it is -EAGAIN, we need
to try it again later. So, put the block group to the retry list properly.

Failing to do so will keep the removable block group intact until remount
and can causes unnecessary ENOSPC.

Fixes: 74e91b12b115 ("btrfs: zoned: zone finish unused block group")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1616,8 +1616,10 @@ void btrfs_delete_unused_bgs(struct btrf
 		ret = btrfs_zone_finish(block_group);
 		if (ret < 0) {
 			btrfs_dec_block_group_ro(block_group);
-			if (ret == -EAGAIN)
+			if (ret == -EAGAIN) {
+				btrfs_link_bg_list(block_group, &retry_list);
 				ret = 0;
+			}
 			goto next;
 		}
 


