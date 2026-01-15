Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8198C3C00BC;
	Thu, 15 Jan 2026 17:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499419; cv=none; b=ghkuNu+6h1bvZm8vJjqSoMz9HP9UmmY1fdjUe5SaFV+LzzzJh2crD6H0SQcvMK+USSK/pQ37wNcyAq5858Bu6y6hAWAtqPa1pf7hCU+aPFn6B4caDK7rK24wW7hrP9dtK/GyTVoMTwp3lRoSrukQUfOmPnwhRAZEPn959Jz8m2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499419; c=relaxed/simple;
	bh=ygWHq9LWLC+2eBNpwPW+hfuVcrccPUglQwbrR8CvEas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bb+B5B3cKkrOjWUshM2kYBYgg1ajNQfxWJdEnQjIF4tJgr4e2Dz2R3gqmITkFFpTBV45wPA+7Nu/WaIBJWuVagDCnUvC2QXA0WFek+fkvn8Jo2AhRpRlxwlvsGwvNLXVhseVF0O09j0+2lmjV7Y3aPA5D0DCSdGHHXeu31utfNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEJVSGGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEJVSGGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E207C2BC9E;
	Thu, 15 Jan 2026 17:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499419;
	bh=ygWHq9LWLC+2eBNpwPW+hfuVcrccPUglQwbrR8CvEas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEJVSGGG8+p06ccOUn/NRu+i6T9W0KR4WhMpkYTR+ZUlOz+tlfkq0XdtxHMlq07+I
	 JRACRqIxLREASGkRt0UX1JE3e0J56u9ZJ1Cu7CytOPVHCdk2i43ATZ4yJ/al7keHZy
	 6bf1Jt/jKZQaTdl0/npw1tGprBNZKoHwZYw3Lzb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/451] block: rnbd-clt: Fix signedness bug in init_dev()
Date: Thu, 15 Jan 2026 17:47:01 +0100
Message-ID: <20260115164238.857231813@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 1ddb815fdfd45613c32e9bd1f7137428f298e541 ]

The "dev->clt_device_id" variable is set using ida_alloc_max() which
returns an int and in particular it returns negative error codes.
Change the type from u32 to int to fix the error checking.

Fixes: c9b5645fd8ca ("block: rnbd-clt: Fix leaked ID in init_dev()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rnbd/rnbd-clt.h b/drivers/block/rnbd/rnbd-clt.h
index 2941e3862b9c..beda2d6ce910 100644
--- a/drivers/block/rnbd/rnbd-clt.h
+++ b/drivers/block/rnbd/rnbd-clt.h
@@ -105,7 +105,7 @@ struct rnbd_clt_dev {
 	struct rnbd_queue	*hw_queues;
 	u32			device_id;
 	/* local Idr index - used to track minor number allocations. */
-	u32			clt_device_id;
+	int			clt_device_id;
 	struct mutex		lock;
 	enum rnbd_clt_dev_state	dev_state;
 	char			*pathname;
-- 
2.51.0



