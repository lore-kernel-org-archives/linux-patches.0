Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E560C6FCF
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429A5C433EF;
	Tue, 10 Jan 2023 18:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375411;
	bh=9mT88kIlB8Z7IQ765JHAdkAM1qW7ZOwIYqvirQP6hCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tT0WxVKTgJ2Mhl0441pI+loeQuH4N2XOlSicsKdpngEKGQOWQwA225xyZT42wRkLo
	 OEP8EgKqKYE9mqPFRsuWTVgk2JWh5iVE6H/WhZQErOppaVTNT2f6F97P9VL5vLmreb
	 eW+yGns8HCwMGd5pfX+mSqIAp+HYfi7HfZFO5cr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	eriri <1527030098@qq.com>,
	void0red <void0red@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/290] btrfs: fix extent map use-after-free when handling missing device in read_one_chunk
Date: Tue, 10 Jan 2023 19:04:33 +0100
Message-Id: <20230110180038.178189403@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: void0red <void0red@gmail.com>

[ Upstream commit 1742e1c90c3da344f3bb9b1f1309b3f47482756a ]

Store the error code before freeing the extent_map. Though it's
reference counted structure, in that function it's the first and last
allocation so this would lead to a potential use-after-free.

The error can happen eg. when chunk is stored on a missing device and
the degraded mount option is missing.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216721
Reported-by: eriri <1527030098@qq.com>
Fixes: adfb69af7d8c ("btrfs: add_missing_dev() should return the actual error")
CC: stable@vger.kernel.org # 4.9+
Signed-off-by: void0red <void0red@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c773ecba7c2d..6b86a3cec04c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7155,8 +7155,9 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 			map->stripes[i].dev = handle_missing_device(fs_info,
 								    devid, uuid);
 			if (IS_ERR(map->stripes[i].dev)) {
+				ret = PTR_ERR(map->stripes[i].dev);
 				free_extent_map(em);
-				return PTR_ERR(map->stripes[i].dev);
+				return ret;
 			}
 		}
 
-- 
2.35.1



