Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C20A1C07C2;
	Tue, 15 Oct 2024 12:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997123; cv=none; b=gUAvSThEvPNNLGXWw7cD5fGHr6tBOqJFFhth5LYXeZFxdka6xNlPqoa4CIZ7uSWN7zCthcDXwrCXN8vP92O+cWb7ZMT+dbwlEZuGAOhTusTY4CNajNQ8xdGMfYP68TlkrEh5UxDlw57dU/cJB6ZChwC41PZOKB2grDXNHeIsfd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997123; c=relaxed/simple;
	bh=J0gyUGS8VmTbA5QMSwyfMl+VO9qY1v/xzxT+H9bsN3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkQN7XRPhsHcxkks9z/ThyqRoSeQMkgUNDrYQGgCEbcig66PlZBvVc/P1grH86jrCJ+HVAX3aYYNX+dO6hinDqjo2TC48FldW3jaA09fD5KwrM4VCmOU5FzI5j8rfwjbeBkBXgMJBhwbjBOeXUrEigyda74lK5mRIA+txeNFll8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iATPlkcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iATPlkcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF76FC4CEC6;
	Tue, 15 Oct 2024 12:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997123;
	bh=J0gyUGS8VmTbA5QMSwyfMl+VO9qY1v/xzxT+H9bsN3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iATPlkcjzx79/NWPMXL/AwkbLTjtO/GwV1/PD2wfXJbmAgXbbqsjrxyZyt7A1DmPr
	 7V9pAeS4UbEP5y7N8nKbyQXxu/hc/NfcciXQE743CB8ZUt9FzrGwj1ab95BtY0XnOA
	 mqDlmYcBNykglbY1uasTeZAyvPiipt1qfEsrWjqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/518] block: print symbolic error name instead of error code
Date: Tue, 15 Oct 2024 14:39:57 +0200
Message-ID: <20241015123920.592724876@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Heusel <christian@heusel.eu>

[ Upstream commit 25c1772a0493463408489b1fae65cf77fe46cac1 ]

Utilize the %pe print specifier to get the symbolic error name as a
string (i.e "-ENOMEM") in the log message instead of the error code to
increase its readablility.

This change was suggested in
https://lore.kernel.org/all/92972476-0b1f-4d0a-9951-af3fc8bc6e65@suswa.mountain/

Signed-off-by: Christian Heusel <christian@heusel.eu>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20240111231521.1596838-1-christian@heusel.eu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 26e197b7f924 ("block: fix potential invalid pointer dereference in blk_add_partition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index e3d61ec4a5a64..dad17a767c331 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -692,8 +692,8 @@ static bool blk_add_partition(struct gendisk *disk, struct block_device *bdev,
 	part = add_partition(disk, p, from, size, state->parts[p].flags,
 			     &state->parts[p].info);
 	if (IS_ERR(part) && PTR_ERR(part) != -ENXIO) {
-		printk(KERN_ERR " %s: p%d could not be added: %ld\n",
-		       disk->disk_name, p, -PTR_ERR(part));
+		printk(KERN_ERR " %s: p%d could not be added: %pe\n",
+		       disk->disk_name, p, part);
 		return true;
 	}
 
-- 
2.43.0



