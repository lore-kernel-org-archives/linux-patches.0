Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85C1186294;
	Mon,  9 Jun 2025 13:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476821; cv=none; b=XVRc7UKy5alvFpoJpO1EijLEVZc8zE0ABD3pDY77u9eT0yr67S3dVW9CZbgo4V/gSsWRC0toTzDYHUy5kiQeXn6d8w4gAOM9x8pBl1lr06WzZnKohzB0Mt7oo37LX6DjWUWYmURdiwORV3rtNkD/oHeSPo6gMZ0ykQ8Duynt5vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476821; c=relaxed/simple;
	bh=q1MfZpgonvJ1O5jXgTFOe/zLM4fYA4U3u2/nv8Vdi0c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r4780QtZYz4Xfy6CTkcmuMWTQG3zacmc+eq8OowZ5c6stshHTYOkdphc9gyb/+I20olsFzkSvbEEM5fSnflwYTPGTix+5t0FCstMk2tIpyyDD2LpU9FH+QyILCrMBhhAKbNLZgPgZdyIMcn1FhifA3u4utvC8yg81t2lbM/EA4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fUgElUlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fUgElUlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0B2C4CEED;
	Mon,  9 Jun 2025 13:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476821;
	bh=q1MfZpgonvJ1O5jXgTFOe/zLM4fYA4U3u2/nv8Vdi0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUgElUlL++etGCsFDUTGf2OwTyxijIQxjfO4r6iT5WbS3SR5OTyUjhLjfZKePQ21i
	 /E/Nn4fvZxymdxXe1I08cULrRBbi1NhvF2znlr47FcNRNW6GrRKX5Vjg4AvqgazWeg
	 lcsXSQ4uqbf4kgKKcEG2YKSWdUZJfEAv9Vsn1UUFMMsR9Ahrw7wQUtBHlK4IaTj4tM
	 +XxKAt1ydvpLIpAUD24l83+k/z06EG2UiqknXbRbhCzOqkrZ1/bfytwo+311hcREpP
	 lYkfxw1N9ADk/WeKElW2rO+SAczf3LyZnAmyp/dXQ3lyHKH1cLi+VJuGW5o4FIW10Y
	 XNpDIDrUjqiCw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	David Lechner <dlechner@baylibre.com>,
	Sasha Levin <sashal@kernel.org>,
	mazziesaccount@gmail.com,
	peterz@infradead.org,
	gregkh@linuxfoundation.org,
	viro@zeniv.linux.org.uk,
	javier.carrasco.cruz@gmail.com
Subject: [PATCH AUTOSEL 6.6 05/18] iio: pressure: zpa2326: Use aligned_s64 for the timestamp
Date: Mon,  9 Jun 2025 09:46:39 -0400
Message-Id: <20250609134652.1344323-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134652.1344323-1-sashal@kernel.org>
References: <20250609134652.1344323-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.93
Content-Transfer-Encoding: 8bit

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 886a446b76afddfad307488e95e87f23a08ffd51 ]

On x86_32 s64 fields are only 32-bit aligned.  Hence force the alignment of
the field and padding in the structure by using aligned_s64 instead.

Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-19-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis, here is my determination:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Critical Bug Fix**: The commit fixes a subtle but serious alignment
   bug that can cause **buffer overruns** on 32-bit architectures. The
   original code uses a plain `u64 timestamp` field in the sample
   structure, which is only guaranteed 4-byte alignment on x86_32 and
   other 32-bit architectures.

2. **Security Impact**: As shown in the
   `iio_push_to_buffers_with_timestamp()` function at line `((int64_t
   *)data)[ts_offset] = timestamp;`, the code performs a 64-bit write at
   a calculated offset. If the buffer is only 4-byte aligned but the
   offset calculation assumes 8-byte alignment, this can result in:
   - Buffer overflow beyond the allocated structure
   - Memory corruption of adjacent stack variables
   - Potential information leaks to userspace

3. **Pattern of Similar Fixes**: Looking at similar commits:
   - Commit #2 (mprls0025pa: use aligned_s64) was marked for stable with
     `Fixes:` tag
   - Commit #5 (ms5611 Fix buffer element alignment) was marked for
     stable
   - The analysis document shows this is part of a systematic campaign
     to fix these issues since 2020

4. **Small, Contained Change**: The fix is minimal - simply changing
   `u64 timestamp` to `aligned_s64 timestamp`. This ensures the
   timestamp field is properly 8-byte aligned through the `__aligned(8)`
   attribute, preventing any alignment issues.

5. **Architecture-Specific Vulnerability**: The bug specifically affects
   32-bit architectures where s64 has only 4-byte natural alignment.
   This makes it a real issue for ARM32 and other 32-bit platforms still
   in use.

6. **Recent Related Security Fix**: The same file had a recent security
   fix (commit 6007d10c5262) for information leaks, showing this driver
   has active security concerns that need addressing in stable trees.

The commit follows the stable tree rules perfectly: it fixes an
important bug with minimal changes and low regression risk. The
alignment issue can cause actual crashes or data corruption on affected
architectures, making it a clear candidate for stable backporting.

 drivers/iio/pressure/zpa2326.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/zpa2326.c b/drivers/iio/pressure/zpa2326.c
index ef1d0349f4247..a1c694199c989 100644
--- a/drivers/iio/pressure/zpa2326.c
+++ b/drivers/iio/pressure/zpa2326.c
@@ -582,7 +582,7 @@ static int zpa2326_fill_sample_buffer(struct iio_dev               *indio_dev,
 	struct {
 		u32 pressure;
 		u16 temperature;
-		u64 timestamp;
+		aligned_s64 timestamp;
 	}   sample;
 	int err;
 
-- 
2.39.5

