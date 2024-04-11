Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7853914600A;
	Thu, 11 Apr 2024 10:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830736; cv=none; b=J95LehEQHFGBZEXV8oWROpHndRnItqhDFp8Rfay/kRYBXyxmCXvCwkXaeRv0fqYLVF4aVOunwcJ3iLEY2YwXBxJwrvx2cwg3hWwNgbmt/xViuQgN3io7gDQeTpCxFKVzTh9KqXG6a8/3sier9xPlAi+4S5XbplvSnVbqvq5nwec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830736; c=relaxed/simple;
	bh=YMNirU3C/bbfK5YcuSkk9PXrK/+5ytT0hN4lRYXsW6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nc21kXkZ7mBl+u3MLDM3teJK1MRp8ex9wPYSpRxgnr1riiY7oLn4v6jgwIDoSaqFMW5mwThQWc1b1Qq/j90WDLl/bCoccvxfGa1TkIpdSvbMJ3fnZa5ejRRCk+SAr1XIIZDULuZktp13LvsFYSg9C/2KfoZ6jkP2BBsdnQHdTUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJCRbOzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJCRbOzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C8DC433C7;
	Thu, 11 Apr 2024 10:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830736;
	bh=YMNirU3C/bbfK5YcuSkk9PXrK/+5ytT0hN4lRYXsW6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJCRbOzBGS1vOWRguAwdZiNEfD7dDHf1JSF2N40F+1NXCIwcOMDUpoKk/JK6MDaV4
	 BOL3j/v7edbsPXfhyKebsJ4TzzzugLfub0yOcIzyMtVqDO+eg4VjfJ60fat4NpPavi
	 r/mTeA6IPOP+d+ofzqkFLB/SZnWvAQFSclFTLCmk=
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
Subject: [PATCH 5.4 099/215] loop: Call loop_config_discard() only after new config is applied
Date: Thu, 11 Apr 2024 11:55:08 +0200
Message-ID: <20240411095427.876402729@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1332,8 +1332,6 @@ loop_set_status(struct loop_device *lo,
 		}
 	}
 
-	loop_config_discard(lo);
-
 	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
 	memcpy(lo->lo_crypt_name, info->lo_crypt_name, LO_NAME_SIZE);
 	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
@@ -1357,6 +1355,8 @@ loop_set_status(struct loop_device *lo,
 		lo->lo_key_owner = uid;
 	}
 
+	loop_config_discard(lo);
+
 	/* update dio if lo_offset or transfer is changed */
 	__loop_update_dio(lo, lo->use_dio);
 


