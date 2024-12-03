Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D3933FE;
	Tue,  3 Dec 2024 15:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238332; cv=none; b=IEzBRMCE8mFo2+4HsR7pEmRIXpHs+9ncw//lQ8umUCmGwTShuvUgjPDUP+QHMmR4KZ43ZinlFnRP7oHESYcWlPQe/RYbajBLYb++yiaGjmtyCf8w8lCsf7i1gLzAWvEDlcQMeX4rcJtwzbqUHSpQ3htQL3FJ0G+4QqL7elH+62Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238332; c=relaxed/simple;
	bh=ST3GODePlya8z53L0yalHZ5tPkoxUEUqJpFcV+sOkc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eplgygecw31z0AscVQGw2it0jFFI8/ii/5awOqul/zV3+ImLmRv3pyTC1prB1wEeRr1VsocDb55KuAjfGBQvE0hMSj4B0mpYPayURzDv/6kLdhmCujLdcORLWzScVu68mOqTXTGo4d6AO3fmGwmOmQp9qrXuYiebIaZunIuVZ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpqY0eCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpqY0eCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD7FC4CECF;
	Tue,  3 Dec 2024 15:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238332;
	bh=ST3GODePlya8z53L0yalHZ5tPkoxUEUqJpFcV+sOkc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpqY0eCvmq9cfKGeTUYAknodrRPz7dWzKFW+WAO6XmYo/5vwsoB9FTEAd8yjeNMO3
	 jNW4xOYG/i/S9uGVNnN4eD6oT6Nb0kNKvbcDN8jIkEaD2fLNeoeH9bTPS78/UuPRP8
	 MOLC/lqP8RyOOFaJ2lHHiHSAdO0DdgOQ43IHmB3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 202/817] selftests/resctrl: Fix memory overflow due to unhandled wraparound
Date: Tue,  3 Dec 2024 15:36:14 +0100
Message-ID: <20241203144003.630061467@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit caf02626b2bf164a02c808240f19dbf97aced664 ]

alloc_buffer() allocates and initializes (with random data) a
buffer of requested size. The initialization starts from the beginning
of the allocated buffer and incrementally assigns sizeof(uint64_t) random
data to each cache line. The initialization uses the size of the
buffer to control the initialization flow, decrementing the amount of
buffer needing to be initialized after each iteration.

The size of the buffer is stored in an unsigned (size_t) variable s64
and the test "s64 > 0" is used to decide if initialization is complete.
The problem is that decrementing the buffer size may wrap around
if the buffer size is not divisible by "CL_SIZE / sizeof(uint64_t)"
resulting in the "s64 > 0" test being true and memory beyond the buffer
"initialized".

Use a signed value for the buffer size to support all buffer sizes.

Fixes: a2561b12fe39 ("selftests/resctrl: Add built in benchmark")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/fill_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/resctrl/fill_buf.c b/tools/testing/selftests/resctrl/fill_buf.c
index ae120f1735c0b..34e5df721430e 100644
--- a/tools/testing/selftests/resctrl/fill_buf.c
+++ b/tools/testing/selftests/resctrl/fill_buf.c
@@ -127,7 +127,7 @@ unsigned char *alloc_buffer(size_t buf_size, int memflush)
 {
 	void *buf = NULL;
 	uint64_t *p64;
-	size_t s64;
+	ssize_t s64;
 	int ret;
 
 	ret = posix_memalign(&buf, PAGE_SIZE, buf_size);
-- 
2.43.0



