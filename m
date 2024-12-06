Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3227E149C69;
	Fri,  6 Dec 2024 14:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496962; cv=none; b=V6AaQWIveFfgH5x/FB/OmZwki9yB9R2LVU83T8z+WmddMWVzv8nmVFNvL8HISghhMDuXQEnBznLT14knD66v07AqZ8sUCNqea/RDU1g42QiuOhQfQ0A8fJEgBTEnAXnst+XMAuIFD0TDsX9rGz93bb88jRxfb+/zN6ImFxZvIvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496962; c=relaxed/simple;
	bh=Y9d1ztPMsnZy5XrtkH0u0BomspNcuY6men7BoMgZpe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rzA5nvlW71gyT7kLVyVK5zb5HkgQAyJPNDdhh4ihSw5e9BQkT0gQLGz7lTdZHjPHVehsE/Fhkav9ylv6oT12rvUZ55NROMGyUCmdfYulydy9Pr+KQmGRhQdaBTv7rj8D3s9J2V+otevNs2ZqsY4BK16/GP5wtq0sZ/ffzlkHj4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgE+mLby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgE+mLby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C05C4CED1;
	Fri,  6 Dec 2024 14:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496962;
	bh=Y9d1ztPMsnZy5XrtkH0u0BomspNcuY6men7BoMgZpe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgE+mLbyyb3rIW9lN1STtlikq+0yuW4Re7JU79/juoniDgJAg9Acy4e7/oSzGh0Du
	 9JXK+jY45qeVVNkjQKGVBTQSpWKb593qv9Q5FAyok7egJ/3u7l/qLH+kl7v5utdw+C
	 dhKaXrZYudO+ukr8rQmf7WnaD7IQc9OomAkAdRPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/676] selftests/resctrl: Fix memory overflow due to unhandled wraparound
Date: Fri,  6 Dec 2024 15:29:36 +0100
Message-ID: <20241206143659.487644082@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 635f938b11f09..a85ae8148db84 100644
--- a/tools/testing/selftests/resctrl/fill_buf.c
+++ b/tools/testing/selftests/resctrl/fill_buf.c
@@ -116,7 +116,7 @@ static unsigned char *alloc_buffer(size_t buf_size, int memflush)
 {
 	void *buf = NULL;
 	uint64_t *p64;
-	size_t s64;
+	ssize_t s64;
 	int ret;
 
 	ret = posix_memalign(&buf, PAGE_SIZE, buf_size);
-- 
2.43.0



