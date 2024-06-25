Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0758A14A60F;
	Tue, 25 Jun 2024 09:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309254; cv=none; b=C9mKdbSUchvGVobQRS2UZtjCc0iPKQYeADrD+1OaZ5VCBAo7PBgu5Zu3CgFmUMLr/4h5VEHp1AOgDXLHuChQroC4eMLAMeh0T68IgQBMZtIM9hheL5HmLxiQCVfu6Ixyuo9x2UFyBcNIHAPvHvPoXOddqKsBp+cbZmD6Mh62rNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309254; c=relaxed/simple;
	bh=ra0ynV4hgCAATnK7poUTcc5YNWqKyT6lLd+/shDLiso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYWZidXK3rN0lU93kDfIv3/PB3O+8T/FLeGKWlqIgJrqzds1LKr/5n91TJzXFVEaxhr5uTZvl6GRO5VTh2UP+WgznmNwHhmIoGJrM/S2ECK9iEX7CTtnnWvWSKC2JIB20IvswEwn6uLU0D6RmrnA/cEpyOdHGNvQibv2EICMlps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mq0Ycc+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mq0Ycc+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB0AC32786;
	Tue, 25 Jun 2024 09:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309253;
	bh=ra0ynV4hgCAATnK7poUTcc5YNWqKyT6lLd+/shDLiso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mq0Ycc+u8O/gfKU0pkN1e6AeqLL90zQ/DOgxtprnvwpZi/3vnHdGrBOeW70FRDNa0
	 qqkzjlzZBpSu8nd5OZY29ds2IB0VokJspUm3HrneHRN8TFZh4SnEJZBA+JNFiQiOLD
	 I9eZ392LKWRft9Vu7Ht0EIhNwTmMeb9fONF7Rijc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.6 146/192] RDMA/mlx5: Remove extra unlock on error path
Date: Tue, 25 Jun 2024 11:33:38 +0200
Message-ID: <20240625085542.762802971@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit c1eb2512596fb3542357bb6c34c286f5e0374538 upstream.

The below commit lifted the locking out of this function but left this
error path unlock behind resulting in unbalanced locking. Remove the
missed unlock too.

Cc: stable@vger.kernel.org
Fixes: 627122280c87 ("RDMA/mlx5: Add work to remove temporary entries from the cache")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://lore.kernel.org/r/78090c210c750f47219b95248f9f782f34548bb1.1716900410.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/mr.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -697,10 +697,8 @@ static int mlx5_cache_ent_insert(struct
 			new = &((*new)->rb_left);
 		if (cmp < 0)
 			new = &((*new)->rb_right);
-		if (cmp == 0) {
-			mutex_unlock(&cache->rb_lock);
+		if (cmp == 0)
 			return -EEXIST;
-		}
 	}
 
 	/* Add new node and rebalance tree. */


