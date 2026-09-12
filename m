Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723933D47A1;
	Sat, 12 Sep 2026 08:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201915; cv=none; b=FPi3GY0gpK+u+/00Gtkx4V2vRA0HxXTvHAL1DhtBNZLdYNDyUb/aS5Q1Bf0ds3msH3L/cNw/oht55m0Mg1Xq4/lwtyAvZrR6w6z8dtv5ccSAZyQxLlR4N2SxTATSEGD4pCujFKawOceDxNz541Wm73sd4tHK6t0Kbc5vaXgq/mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201915; c=relaxed/simple;
	bh=aOZS9TsGlWim4SIPl3edKLwyWIFLVluVJ8UoWZGRIwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYaCX1QuqJ4G0KOxJvxPPJ6qGRuC1/kptPIPUruDYOruLLXyVMk1a36JwMefw/wfcxiLaRXueMSY4WwmQ7zBur7PBrwUDOKGiXSMYa1/dHBV8w9nYp5HRq9/OZbDR9hmuzt9YKIFetV73ajoZcsjo77mwISgXBy+WIZTO/J0yuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGfwRJmn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGfwRJmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94D51F000FF;
	Sat, 12 Sep 2026 08:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201910;
	bh=PBO7xigrKfzHd6m31gGrF1Q3gxpX3JJG6ubbdJbueR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGfwRJmnhTO7wWP5rctqnPDO6CyrS4VWFXH9+tUUF6eOdJqMwEVun9dLZAhiL+yHX
	 XRz1+4f2hyUPitVgoFk9cbZLvgDmg2Pvjv1Pem8l+EFZwLylHmOGQvp1JT70GqUsGJ
	 en4+jYJaZZuzEV0sMPdJT0+BSDZnED6jcTMtxXGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1092/1815] thunderbolt: stream: Fix possible short reads/writes
Date: Sat, 12 Sep 2026 08:47:22 +0200
Message-ID: <20260912065714.656129517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit af73a21a8eb460744d733fa5e2627935ed125081 ]

Since copy_page_{to|from}_iter() advances the iterator and makes
iov_iter_count() reflect the remaining bytes, subtracting nbytes from it
makes it count it twice resulting in possible short reads/writes on a
read/write spanning multiple frames.

Fix this by using iov_iter_count() directly.

Fixes: 6db21d817b43 ("thunderbolt: Add support for USB4STREAM")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/stream.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/thunderbolt/stream.c b/drivers/thunderbolt/stream.c
index c456f18ab4cd5..43d29d69dcdbb 100644
--- a/drivers/thunderbolt/stream.c
+++ b/drivers/thunderbolt/stream.c
@@ -673,7 +673,7 @@ tbstream_dev_fops_read_iter(struct kiocb *kiocb, struct iov_iter *to)
 	}
 
 	nbytes = 0;
-	while (nbytes < iov_iter_count(to)) {
+	while (iov_iter_count(to)) {
 		struct tbstream_frame *sf;
 		size_t size, sf_size;
 
@@ -695,7 +695,7 @@ tbstream_dev_fops_read_iter(struct kiocb *kiocb, struct iov_iter *to)
 		}
 
 		sf_size = tb_ring_frame_size(&sf->frame);
-		size = min(iov_iter_count(to) - nbytes, sf_size);
+		size = min(iov_iter_count(to), sf_size);
 
 		if (copy_page_to_iter(sf->page, sf->offset, size, to) != size) {
 			ret = -EFAULT;
@@ -765,10 +765,10 @@ tbstream_dev_fops_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 	}
 
 	nbytes = 0;
-	while (nbytes < iov_iter_count(from)) {
+	while (iov_iter_count(from)) {
 		size_t size;
 
-		size = min(iov_iter_count(from) - nbytes, TB_MAX_FRAME_SIZE);
+		size = min(iov_iter_count(from), TB_MAX_FRAME_SIZE);
 		ret = tbstream_dev_send_data(sdev, from, size);
 		if (ret) {
 			/*
-- 
2.53.0



