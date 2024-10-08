Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70631E53A;
	Tue,  8 Oct 2024 13:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394228; cv=none; b=pdEXl4LTUfF7HUHZA/Lw+Vj5MUuJXakmuejxryhQVoemh7QVPMDJZAx6sYJdg5XbNZv2fYLL8qGq//5PGZNSIb9U02V8uYaSHh4CSD5tsMbrcDnCqZG13soJUA8RpZJ+jXj7prbejYY3oRlgc+Cn+Hw64FSRdOpVxkuL6k77fYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394228; c=relaxed/simple;
	bh=q0lCW5MyPtouurCNkrsdmTNAktP2UsGlYkU1mSAlrJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqK/MZw6xG2vc4PtwzXyE42+CSeohotwwxr/LrREOamq8VrQ2qvcLKPXSXh93ajxaVl6LPAYoiUTf/P99TXAlR9w6X43l81gzmZmio6xn8GPBCyoQESbI7nTZb4Jmk81Qh30L6eeXwHh5O7xssCrGUkM3AiU051S4eQEOfDaHk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PupmowzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PupmowzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D070BC4CEC7;
	Tue,  8 Oct 2024 13:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394227;
	bh=q0lCW5MyPtouurCNkrsdmTNAktP2UsGlYkU1mSAlrJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PupmowzW22zTyBCF+EbWqa+aaPf021X3OFmbqgTk6DOllifz7J74ECTSXtsHLvzNx
	 Ar5o4u+24KrVYxnheud3pIfIv0FSI2ny4RD4F4E79j0B+gjwmHY8PToz/M0Zxz5lay
	 YbUkIscx5OUd1aL20MVhUoZ6Pf5z/pYIKe+qw0is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 385/386] null_blk: Fix return value of nullb_device_power_store()
Date: Tue,  8 Oct 2024 14:10:30 +0200
Message-ID: <20241008115644.542319888@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit d9ff882b54f99f96787fa3df7cd938966843c418 upstream.

When powering on a null_blk device that is not already on, the return
value ret that is initialized to be count is reused to check the return
value of null_add_dev(), leading to nullb_device_power_store() to return
null_add_dev() return value (0 on success) instead of "count".
So make sure to set ret to be equal to count when there are no errors.

Fixes: a2db328b0839 ("null_blk: fix null-ptr-dereference while configuring 'power' and 'submit_queues'")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Link: https://lore.kernel.org/r/20240527043445.235267-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/null_blk/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -470,6 +470,7 @@ static ssize_t nullb_device_power_store(
 
 		set_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags);
 		dev->power = newp;
+		ret = count;
 	} else if (dev->power && !newp) {
 		if (test_and_clear_bit(NULLB_DEV_FL_UP, &dev->flags)) {
 			dev->power = newp;


