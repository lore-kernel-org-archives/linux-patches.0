Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3469B424651;
	Thu, 16 Jul 2026 14:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210475; cv=none; b=JN45yQcbiA8OsMDyV+SvqjKDbt0647pfjEKnP7ByiLByW/eVjmKy2WfSi5IRvYw3656oMQ7x7PbqLpBVjBIR6lMwaqrUnNQFI1VagcHJQaMV1Dpv5PYBXsjUx6IRetB+WyUDn9krykp57U2J6UBQAHWrKBnuGeXcZDStJCPx1Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210475; c=relaxed/simple;
	bh=wtAIVpA7wVhEhzqisyHH1r/6NldDRFSGRRPm/7qDWoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJxOCObzmYvLZ5UqLz2RAO9/SsYnBfOYbngnmhoajS9hhLGSUVXKbGH4SbgFU06QI2a0CLBWQmYOVfzfvFqhp3rqhwIDaXkqPEKmo+j1XZsUSP7KiwgYFCIZoHv4JlASf/SeN6uepjsFCTA9IxrwR2SYuwJ60wqRKm7iwdryseg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvdI399T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvdI399T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAD01F000E9;
	Thu, 16 Jul 2026 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210474;
	bh=a9l/qOOMnwQg2o0mY5IoPamgn3bS7IOaYpWluFBANr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvdI399TKpqKPuVB9qdWoE7fJpFkK7F33ZiL//rea8Cf/1qjiQshiQo2teHgNlvN7
	 m0MzLksb1ujC38QHVu1HD1GeRDdEUhp2FznvxZuoVsIc7UuTVXjZUJ326bZw7YCWBu
	 sDDisXUVzi0zDNSRh5qwVSXn+dNeIUL+5oMbwH8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Maxwell Doose <m32285159@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 062/480] iio: core: fix uninitialized data in debugfs
Date: Thu, 16 Jul 2026 15:26:49 +0200
Message-ID: <20260716133046.051254243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit ab92ed206d41fd171ebd37bc46360d9f2140d043 upstream.

If *ppos is non-zero then simple_write_to_buffer() will not initialize
the start of buf[].  Non zero values for *ppos aren't going to work
anyway.  Test for them at the start of the function and return -EINVAL.

Fixes: 6d5dd486c715 ("iio: core: make use of simple_write_to_buffer()")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Maxwell Doose <m32285159@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -418,7 +418,7 @@ static ssize_t iio_debugfs_write_reg(str
 	char buf[80];
 	int ret;
 
-	if (count >= sizeof(buf))
+	if (*ppos != 0 || count >= sizeof(buf))
 		return -EINVAL;
 
 	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, userbuf,


