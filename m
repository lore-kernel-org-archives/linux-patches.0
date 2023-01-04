Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0127FAD38
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5ECC433EF;
	Wed,  4 Jan 2023 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848611;
	bh=iSNkqAXuNQm200tVTtX5m5L+vp5w2EixIJ3ertlAq+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Nc1uQdl0Rp/ON0XiwvqTTGl1UgSZ6vGHG7sT8yzcTubMUj9hUS7pXHoz3/gfId8b
	 Da/goSKzzixRiQsWEVXxFW2Vrl+B5wJ5sv7KIEeqBpHYurWktyJNv9+5zgqaCcvlIH
	 K6+ehihGPFK/FJEuWP3apCWpVZHbX5ePY1xHMyps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	eriri <1527030098@qq.com>,
	void0red <void0red@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 021/207] btrfs: fix extent map use-after-free when handling missing device in read_one_chunk
Date: Wed,  4 Jan 2023 17:04:39 +0100
Message-Id: <20230104160512.590464387@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

commit 1742e1c90c3da344f3bb9b1f1309b3f47482756a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7241,8 +7241,9 @@ static int read_one_chunk(struct btrfs_k
 			map->stripes[i].dev = handle_missing_device(fs_info,
 								    devid, uuid);
 			if (IS_ERR(map->stripes[i].dev)) {
+				ret = PTR_ERR(map->stripes[i].dev);
 				free_extent_map(em);
-				return PTR_ERR(map->stripes[i].dev);
+				return ret;
 			}
 		}
 


