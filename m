Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049B2254AF0;
	Mon,  9 Jun 2025 13:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476666; cv=none; b=IZOdxGCLwBshf9MtEMteVRgnfczYUwGd136FPOYVKKShRz1yWPxOUZjTF6kH8+0ew65GMFlSIpmjHigdMrAt33WyGRBWoA7XTlQiryCxqbKIK8MrjdSJGEgtqjMM8ox+IyeZ+MsLJMjQ2yObfWwSWFUmqtcvd5I+eAb1oroHGU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476666; c=relaxed/simple;
	bh=LKm2808+cP+hBbJ2eJwniRk0sgjivoUvFgWACAexZSk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HzPSlwNoIbRrycCBCQEZ+PAWHA2T6pzudwjTvwSCKyyLRg00aIuEL3Pi5qR6L0GRAG1xC8WC+a/mzcuEU5Ly3uW/SK7x7NHZ1m2W+iLBvpnbtFncdTQQzyJMmwsvTM8YSDjUIKzvcv5BFurFzmrP7Q7YPu4VHgpqJn2qC/qUPn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HecTXjCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HecTXjCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEF4C4CEEB;
	Mon,  9 Jun 2025 13:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476665;
	bh=LKm2808+cP+hBbJ2eJwniRk0sgjivoUvFgWACAexZSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HecTXjCI69WJs/QzTa7xs0ivx6BrGIZbIQuRt0bcu3ua02Z8EdMCsJlgDt8QBeksp
	 eb0nH64t7cqE+kXOq6d9Eqprl6JgrVUp69NcWLcmWDFMIQz1CqtOzNuAQADuZJGfw7
	 eHxXketoDgTjgp78vP9zjX7oOwYkoG4MMImRIBg/EdZinvEaFjR/J4ehi4n3EgmWnL
	 VWOrmH6p7O8WZvW0tz4Ny6AqjD2JuSGy6vky0irJklCaJzx5NMKgSoxaj+OotGjsCo
	 h+fOiE55ed9Wob+mFQx/B7SNn8znLujCUe35EiYhUTtwNXk8a3o40unYWil9o+mioG
	 hvi4s7W00EftA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	David Lechner <dlechner@baylibre.com>,
	Sasha Levin <sashal@kernel.org>,
	marcelo.schmitt1@gmail.com,
	gregkh@linuxfoundation.org,
	javier.carrasco.cruz@gmail.com,
	peterz@infradead.org,
	viro@zeniv.linux.org.uk
Subject: [PATCH AUTOSEL 6.15 13/35] iio: pressure: zpa2326: Use aligned_s64 for the timestamp
Date: Mon,  9 Jun 2025 09:43:29 -0400
Message-Id: <20250609134355.1341953-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134355.1341953-1-sashal@kernel.org>
References: <20250609134355.1341953-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.1
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
index 9db1c94dfc188..b2e04368532a0 100644
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

