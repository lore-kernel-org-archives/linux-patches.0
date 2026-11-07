Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065590;
	b=nMyAjUhfDz+ao0wP08bIrbuMVbqfM6SU1tL2B4urRtLzqPN3/xvvbFQQvO31x5iSga9N
	 ecG5q4dIPaPc8u1YcyhFUpMGcHtvvqzJLFFYelzyZ6u+TkeHwltp6F833YQ0jr6ZF17V7
	 zrfF/WbrvyGR6fNH9RLesfmTQsnOytGwnUFmMfI3X0/QN4toQKjI7Hb+vhVX5YyEz+Bmh
	 jSxizA6ZkWxvTOP8v+4b9+aCNQOe7lv6RDAHq5M93T3oul9NL7rLbtq0hTZTlFvAG+WI2
	 wlO43EktOWe3S/sjZdnzkACnn8aE/0R5bzRtKitRScjjExiK8xmsCr1wkf6aV6rQlnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HJGFBcDpmRqkDQ33/u8Pc8gw44B1SCzVaTchJgAHQ8o=;
	b=iRICi4KpWKpsWoUmCexzeqg8sdtGHst+nyccdYbEY40enfYtwJMd20XQMWmx4hY7s1IX
	 53A92JS2TMUWYIbvyyjDqFzkMFKOEVogSCfP3ziL8q1mJDwhMfRMEBWHKSO5ck2er9qSE
	 kBoa7QxvEqyW4DO0cU5/FqLqRY3gcLJDoDB35y6gWVoDBmgHVTKqdEjAYYgBdlnpMPufr
	 0GPs3x/lO5WNlKW2zwA5TzyyT1LlrYy5sn8RM3YcXju1sw5RxVWWiu+qYwtNQw1C3Rzpx
	 kajKs+FNrjQMYMy0DioltwgFZiqCr5plHMVgwQALSEMbM3NZSFD3dcfSPQ7d5TjSQKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=acgfaYrx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27988606A33A;
	Sat,  7 Nov 2026 15:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=acgfaYrx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF93A1F0089F;
	Sat,  7 Nov 2026 15:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065590;
	bh=HJGFBcDpmRqkDQ33/u8Pc8gw44B1SCzVaTchJgAHQ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=acgfaYrx/agex3Qhjl4il3STnJ+HsV43vXB0NC4qQy6nOyh/oyWeSusciMDfwI7sh
	 ts7zRUN7mvNi6E+tJXxC6gSWtzwibGhWtSbmpGabPiuKpuzcrJSzakFO4KofYaN97v
	 Y/BO//JN+qgAThKwdWW9MclRnj+n8x3CNLaU/R5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1210/1257] nvmet: Finish the blk plug when integrity allocation fails
Date: Sat,  7 Nov 2026 08:58:26 -0500
Message-ID: <20261107135012.792357211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 18fc5f6f1ca945630dae5404265de55d65194e22 ]

nvmet_bdev_execute_rw() starts a plug before building the bios, but
the two error exits taken when nvmet_bdev_alloc_bip() fails return
without calling blk_finish_plug().  current->plug is left pointing
at the stack frame of the returned function, so the next
blk_flush_plug() walks a stale list.

Route both failures through a common exit that finishes the plug.

Fixes: c6e3f13398123 ("nvmet: add metadata support for block devices")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index f2d9e8901df4e..4b7483bc9cc31 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -316,7 +316,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 							  &prot_miter);
 				if (unlikely(rc)) {
 					bio_io_error(bio);
-					return;
+					goto out_plug;
 				}
 			}
 
@@ -336,11 +336,12 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 		rc = nvmet_bdev_alloc_bip(req, bio, &prot_miter);
 		if (unlikely(rc)) {
 			bio_io_error(bio);
-			return;
+			goto out_plug;
 		}
 	}
 
 	submit_bio(bio);
+out_plug:
 	blk_finish_plug(&plug);
 }
 
-- 
2.53.0



