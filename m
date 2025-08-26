Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA29D284B5B;
	Tue, 26 Aug 2025 11:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208574; cv=none; b=qY4ouPb8sWr1ka3v8g2QfIBGzFkv0ShVEDw+hdhpGnDzE5nca0rQb8jGnXGhx9+GzT9HpjNGQe7AtD+pnXl8NGr+zORuB8+5zplrpORsNkBuPLpWFErzzamfoJ/vqLvaal1CXaYg0XdiBj3swAuCp4428lvnVHDuKHhbsf7cdVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208574; c=relaxed/simple;
	bh=y61hu5+2eciFXatgzbpAYDf2g4kBUXHdpUpxLXudO/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZKouktdxxlwIe8pM0JV8KqIM2zktAt0majx1SWaqkUHX1S/OBH/ItQgSuGb5pmRMsMmVDkYJIQFj4JCGSr3Nc/F8kCzMSa2X6aOrg6957wDSN8ExiwkVEZkZ0MRxGM9m21o0YKXgk+AXYPFaEPoTaUrzkSefJ+kmUafr/rsp1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJTJBhkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJTJBhkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45340C116B1;
	Tue, 26 Aug 2025 11:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208574;
	bh=y61hu5+2eciFXatgzbpAYDf2g4kBUXHdpUpxLXudO/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJTJBhkR85FELLJPEWzoXcPS2mqFBCuaZTK5Sz/kGYEfHkTlqz1+4Xcd4Bj/0j2mC
	 3dIc3WxRN0Fk29rCDKNwLXr0id9UfShZTFCO3OEpkITuiSk41Ht6CCu2NQHnE97t9p
	 9ASfjqThr+Mp4cMZ3Ot8VLZIAvv38d9VhPj+S55s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 163/322] io_uring/futex: ensure io_futex_wait() cleans up properly on failure
Date: Tue, 26 Aug 2025 13:09:38 +0200
Message-ID: <20250826110919.852004790@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

commit 508c1314b342b78591f51c4b5dadee31a88335df upstream.

The io_futex_data is allocated upfront and assigned to the io_kiocb
async_data field, but the request isn't marked with REQ_F_ASYNC_DATA
at that point. Those two should always go together, as the flag tells
io_uring whether the field is valid or not.

Additionally, on failure cleanup, the futex handler frees the data but
does not clear ->async_data. Clear the data and the flag in the error
path as well.

Thanks to Trend Micro Zero Day Initiative and particularly ReDress for
reporting this.

Cc: stable@vger.kernel.org
Fixes: 194bb58c6090 ("io_uring: add support for futex wake and wait")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/futex.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -337,6 +337,7 @@ int io_futex_wait(struct io_kiocb *req,
 		goto done_unlock;
 	}
 
+	req->flags |= REQ_F_ASYNC_DATA;
 	req->async_data = ifd;
 	ifd->q = futex_q_init;
 	ifd->q.bitset = iof->futex_mask;
@@ -359,6 +360,8 @@ done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
+	req->async_data = NULL;
+	req->flags &= ~REQ_F_ASYNC_DATA;
 	kfree(ifd);
 	return IOU_OK;
 }


