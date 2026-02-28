Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C959233FE26
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300931; cv=none; b=W1DsrRRodElzklvUHYcyfHWB4sSELwly+9TM7tzlI/tWKsg4PD6r5JKVX6vE5Ys0O1Jtvt07cSFUgcMDcqWnq3v6nVVrU2Zq0LqfCI7fq5sptz9k6EIyXf7vYvL1BrYWjdO0JsIgnLacOWblVZBJCTFHVOcZd/bNzD/IOspUOQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300931; c=relaxed/simple;
	bh=eos+W5dgWBr84Cow/J5rcuEMcfxBGD33YVhkDr+QZkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSgAg4Sy3vq2zKx/MA8s75KK+SpIfffqR1bu/3ecdgKgVqGnSDFw0TpR51Hred+2PpxSHhBFroE01qs/5/NvwJ+P4BG5hc9Eb5wT0aM6MApCnIby/rO6lH/+bBZVxvCa91zKhDvzxdhIzhuhEHaikGsqOoG5n29Vkp+tMKx8qms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=diuOXu/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="diuOXu/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABD7C116D0;
	Sat, 28 Feb 2026 17:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300931;
	bh=eos+W5dgWBr84Cow/J5rcuEMcfxBGD33YVhkDr+QZkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diuOXu/U8vUSCh5YMBWHLyQL4kjNP0GV30nxyHy/Dj3YNwP/XfPXYwOPMQv+Vz6K2
	 fo6jWV+JD2ughwtoEokKOHf5uV1WPz2u/YLX8k90mNKMgy2M/2XhOMkXKZJFkPyH9B
	 jR/8uYrihOEzgHtsZHInGDdQKDYfAQNC3kmseZenJhr4RToHk287ETgqt1xSEIZZe0
	 bpCcoWk+3Ni8CU3+/IgpiLo6+twGYBRly9kIXF2AtfkWAEC19GJc0LNqpgvKY3PFHv
	 tzlPdrItqErEdkHno1qd4xFWl8JXGAOj2kDRvEUiKwmN608oCY92KTeeyAICdmuB7k
	 gVmpTFg6qO7MA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 051/752] EFI/CPER: don't dump the entire memory region
Date: Sat, 28 Feb 2026 12:36:02 -0500
Message-ID: <20260228174750.1542406-51-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 55cc6fe5716f678f06bcb95140882dfa684464ec ]

The current logic at cper_print_fw_err() doesn't check if the
error record length is big enough to handle offset. On a bad firmware,
if the ofset is above the actual record, length -= offset will
underflow, making it dump the entire memory.

The end result can be:

 - the logic taking a lot of time dumping large regions of memory;
 - data disclosure due to the memory dumps;
 - an OOPS, if it tries to dump an unmapped memory region.

Fix it by checking if the section length is too small before doing
a hex dump.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
[ rjw: Subject tweaks ]
Link: https://patch.msgid.link/1752b5ba63a3e2f148ddee813b36c996cc617e86.1767871950.git.mchehab+huawei@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/cper.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 322c6bdefb611..d58ff956a699c 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -560,6 +560,11 @@ static void cper_print_fw_err(const char *pfx,
 	} else {
 		offset = sizeof(*fw_err);
 	}
+	if (offset > length) {
+		printk("%s""error section length is too small: offset=%d, length=%d\n",
+		       pfx, offset, length);
+		return;
+	}
 
 	buf += offset;
 	length -= offset;
-- 
2.51.0

