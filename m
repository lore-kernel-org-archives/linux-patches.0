Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5735935DA78;
	Tue, 16 Jun 2026 19:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636987; cv=none; b=dzn2+Y4TUKt3YTLEgx9/6ah7FlIJ8KhxDS/iZS8aPnrkQosgYJW0ZOrF4dVYstQutWP2U7Qw6kK3awVTOmMff61g9sUQIC03Tu8wWFK/UruMchZnul31u3aAK4c3TV85LphfkV2MdCnOJ48gJM0WMKSUucCtSbSy0n3sb2EutuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636987; c=relaxed/simple;
	bh=CYl+JudXYw9QPWHxVMZI777FEZVmWqLhmdJivIMb7ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjHkGM9P9chIZ4ZnqfLqNUnGoZrqwwPtuZOUPPk5RlP+R0xjExQ76nxGd1jGtVA0Rp6tKf4Z4tU850IC9RbtqGKvaonxdjCk+lUXgzes5PAcXIC5R33PuOM0zyP0l1bHy2sXbucNmJNdDT0oOaohDKAp+CAvrrCH64lR7k+yGfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUQ2VTEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUQ2VTEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599461F000E9;
	Tue, 16 Jun 2026 19:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636986;
	bh=IdejpBWN5C0rFAG6x6AM1zvK6myP6fnsGVJFI/nqBrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUQ2VTEBGAUog6P+wB7x9WJEiioQHc0rdtn9+FVh7W8zHBY6eac8YotluyElPoP9c
	 CRiYZ2Fj/Gm7UWVV+ZhjJQIjbXcGLToWE2ZUXVpPV+Uedb/BZi7n0szxvuLdPhT9dN
	 YrgnmdGbNa6J5RgpTAIuLUD1QBlvX53Rb8hC2/WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 322/342] iio: chemical: scd30: fix division by zero in write_raw
Date: Tue, 16 Jun 2026 20:30:18 +0530
Message-ID: <20260616145103.564003443@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit 5aba4f94b225617a55fed442a70329b2ee19c0a5 ]

Add a zero check for val2 before using it as a divisor when setting the
sampling frequency. A user writing a zero fractional part to the
sampling_frequency sysfs attribute triggers a division by zero in the
kernel.

Fixes: 64b3d8b1b0f5 ("iio: chemical: scd30: add core driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/scd30_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/scd30_core.c
+++ b/drivers/iio/chemical/scd30_core.c
@@ -257,7 +257,7 @@ static int scd30_write_raw(struct iio_de
 	guard(mutex)(&state->lock);
 	switch (mask) {
 	case IIO_CHAN_INFO_SAMP_FREQ:
-		if (val)
+		if (val || !val2)
 			return -EINVAL;
 
 		val = 1000000000 / val2;


