Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EB026980B;
	Thu, 13 Feb 2025 14:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457873; cv=none; b=J5+ogab+qY/PedlsOC3YPKsySrBjCXvnWy+DBuxLiNqGMwDchUPTGCwWne3Wa6ls9T+d3vbeDl2o8Mj0FYw26BLQfpnGJ46X7InBwXyjHNNF+SU7j9/tt1kytCWLNiQf90KiQ7VrAnfvfwimW3HoVtlOyidEExCW9HuEId/aoy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457873; c=relaxed/simple;
	bh=pZ5+DSbT6PV8lht7LqwRDkyhvQ/xyR8V6MY5ANYWEfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmQPgDwZ4utzs0/Lqjk+iknVMr4Mhi++0NEW98Bjy+Hlfq/fVCxBWgLnaqBpTBRNxdsL62BHppjz2nNITw3OxEiZmYEFWYf6/FqJc4qd1y/7I39b09bPT8Vf0VyZm0U/loskYcyS9yS/TLB2zO5D2OJn3U9b2Cgem1vNgd9fNIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqXkV+G9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqXkV+G9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE68C4CED1;
	Thu, 13 Feb 2025 14:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457873;
	bh=pZ5+DSbT6PV8lht7LqwRDkyhvQ/xyR8V6MY5ANYWEfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqXkV+G9+WP5yCERP06LYRK9oXjTxYUbNF4FncUtGk/739R93KRiD8BtqVO59Yr7y
	 hdH8tm4NAnxtQnRIWepMzkP1gq586Y+R7xyx+mIr8mvUD2qQq2QOaoQnfT5MNicsPj
	 06pkatEc5cTIoITwEIGwcgD/Q0rT20C+z0uzPc0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 238/422] block: dont revert iter for -EIOCBQUEUED
Date: Thu, 13 Feb 2025 15:26:27 +0100
Message-ID: <20250213142445.721139632@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit b13ee668e8280ca5b07f8ce2846b9957a8a10853 upstream.

blkdev_read_iter() has a few odd checks, like gating the position and
count adjustment on whether or not the result is bigger-than-or-equal to
zero (where bigger than makes more sense), and not checking the return
value of blkdev_direct_IO() before doing an iov_iter_revert(). The
latter can lead to attempting to revert with a negative value, which
when passed to iov_iter_revert() as an unsigned value will lead to
throwing a WARN_ON() because unroll is bigger than MAX_RW_COUNT.

Be sane and don't revert for -EIOCBQUEUED, like what is done in other
spots.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/fops.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/block/fops.c
+++ b/block/fops.c
@@ -758,11 +758,12 @@ static ssize_t blkdev_read_iter(struct k
 		file_accessed(iocb->ki_filp);
 
 		ret = blkdev_direct_IO(iocb, to);
-		if (ret >= 0) {
+		if (ret > 0) {
 			iocb->ki_pos += ret;
 			count -= ret;
 		}
-		iov_iter_revert(to, count - iov_iter_count(to));
+		if (ret != -EIOCBQUEUED)
+			iov_iter_revert(to, count - iov_iter_count(to));
 		if (ret < 0 || !count)
 			goto reexpand;
 	}


