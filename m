Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A571422C4;
	Thu, 11 Apr 2024 10:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829741; cv=none; b=FKYFvHGORiL3/b+D0bsfCwviOfF9D68z1A28SORaWuCS55J+rb0VZ+8G4o3GblHxVylJjT+J1Z0Oecnp2gOMJ013bOIZ9+pCFdm/VkC29EwYjewsP45I6MYR0sZRrlzvpPDk8GKTp0J8DH3NzhqN7dFVihMN3mWK7JCM+JMLSHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829741; c=relaxed/simple;
	bh=Nbby2tkEPOTksKROBjablKFTjpzLLZB4wkn6y8SVwCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkMEupwLid9dcEnLus2G7UAEpQxbulEXgl7Z5zmOS98XC5fvR8zT651C1rmP4Un38xaLt2Qi4YG4c+O4izjOkz4zA/FEmbtvSiQAf/CrfFvno6MhtSD8eo92gQZV7U3bB/v9Q/2FERWje+MachZEnylqcLtnQJyuWSD7156yiuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3EY84fb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3EY84fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690C7C433C7;
	Thu, 11 Apr 2024 10:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829740;
	bh=Nbby2tkEPOTksKROBjablKFTjpzLLZB4wkn6y8SVwCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3EY84fb+kil2HKqHDss8qu8ibpKchF2LRpxTQnXcYmqOEg/DyxUuINRM5Bxhx81h
	 pl0WuWUMzHb4QxQ2Z7djwGtFzJnLEs8I5EuvH5ayXQQDUVc0ulFRf//bEkY9VjqWEf
	 xmgIOyxQw3BS9eVrCe4RgldDUm6fAoO1llJK8IRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martijn Coenen <maco@android.com>,
	Christoph Hellwig <hch@lst.de>,
	Bob Liu <bob.liu@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: [PATCH 4.19 090/175] loop: Call loop_config_discard() only after new config is applied
Date: Thu, 11 Apr 2024 11:55:13 +0200
Message-ID: <20240411095422.273162804@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martijn Coenen <maco@android.com>

[ Upstream commit 7c5014b0987a30e4989c90633c198aced454c0ec ]

loop_set_status() calls loop_config_discard() to configure discard for
the loop device; however, the discard configuration depends on whether
the loop device uses encryption, and when we call it the encryption
configuration has not been updated yet. Move the call down so we apply
the correct discard configuration based on the new configuration.

Signed-off-by: Martijn Coenen <maco@android.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1286,8 +1286,6 @@ loop_set_status(struct loop_device *lo,
 		}
 	}
 
-	loop_config_discard(lo);
-
 	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
 	memcpy(lo->lo_crypt_name, info->lo_crypt_name, LO_NAME_SIZE);
 	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
@@ -1311,6 +1309,8 @@ loop_set_status(struct loop_device *lo,
 		lo->lo_key_owner = uid;
 	}
 
+	loop_config_discard(lo);
+
 	/* update dio if lo_offset or transfer is changed */
 	__loop_update_dio(lo, lo->use_dio);
 


