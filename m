Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D4524113C;
	Tue, 29 Apr 2025 17:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946409; cv=none; b=sywzndgTcSq/RXOybJ/mGvIjqnMkH7yVJRrE2ZPRANrFHWCuSZHOmhv9Za8OPSqkdwocul/W1pJk/G/yTdPZAaSk7YjQgvX7G6XYM38cpoULOJsdx8EaYPte33fwjg6Bbqwe/ine0hb8oymOU5asdWRFO5FxX3eGAcVT9gjmkFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946409; c=relaxed/simple;
	bh=kBDoPAtEBVo77Pr1a89w7q7OIpbb5v2kDBtAqeUx1Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+ghGyzEehMI3/IXPbLBwOKjDu0Fpd64/wPmXqE72PAFNvxKYzqB2ir4yzlzeCSaHCk4InrqGL2hQ9bJAYb7G4Z8ByqGdc4Qgyw+HZk4ZP5NQhrhjvO8f/givaQoh5cYR3gYfn5lTqdfRrWUIleXAHEKRFbd18gw/vgwcoD40g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGCk++0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGCk++0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E02C4CEE3;
	Tue, 29 Apr 2025 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946409;
	bh=kBDoPAtEBVo77Pr1a89w7q7OIpbb5v2kDBtAqeUx1Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGCk++0pc6F2rwvh9vzJQIB7g6FVC+21E6NPJzNQPWKRN9FHLSKw+SuAat5S8yqp2
	 smi5yIaJQGEv/7KtKFnc/8UyHK1iOV2uy0LzqZMfO299lkNXGgBasITSGoPgg8hark
	 cPCjIyYIJBlLsrS5CpZj3G0sj9+3JLDir8QySAew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Lai <yi1.lai@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 258/311] selftests/mincore: Allow read-ahead pages to reach the end of the file
Date: Tue, 29 Apr 2025 18:41:35 +0200
Message-ID: <20250429161131.588489297@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 197c1eaa7ba633a482ed7588eea6fd4aa57e08d4 ]

When running the mincore_selftest on a system with an XFS file system, it
failed the "check_file_mmap" test case due to the read-ahead pages reaching
the end of the file. The failure log is as below:

   RUN           global.check_file_mmap ...
  mincore_selftest.c:264:check_file_mmap:Expected i (1024) < vec_size (1024)
  mincore_selftest.c:265:check_file_mmap:Read-ahead pages reached the end of the file
  check_file_mmap: Test failed
           FAIL  global.check_file_mmap

This is because the read-ahead window size of the XFS file system on this
machine is 4 MB, which is larger than the size from the #PF address to the
end of the file. As a result, all the pages for this file are populated.

  blockdev --getra /dev/nvme0n1p5
    8192
  blockdev --getbsz /dev/nvme0n1p5
    512

This issue can be fixed by extending the current FILE_SIZE 4MB to a larger
number, but it will still fail if the read-ahead window size of the file
system is larger enough. Additionally, in the real world, read-ahead pages
reaching the end of the file can happen and is an expected behavior.
Therefore, allowing read-ahead pages to reach the end of the file is a
better choice for the "check_file_mmap" test case.

Link: https://lore.kernel.org/r/20250311080940.21413-1-qiuxu.zhuo@intel.com
Reported-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mincore/mincore_selftest.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/mincore/mincore_selftest.c b/tools/testing/selftests/mincore/mincore_selftest.c
index 0fd4b00bd345b..17ed3e9917ca1 100644
--- a/tools/testing/selftests/mincore/mincore_selftest.c
+++ b/tools/testing/selftests/mincore/mincore_selftest.c
@@ -261,9 +261,6 @@ TEST(check_file_mmap)
 		TH_LOG("No read-ahead pages found in memory");
 	}
 
-	EXPECT_LT(i, vec_size) {
-		TH_LOG("Read-ahead pages reached the end of the file");
-	}
 	/*
 	 * End of the readahead window. The rest of the pages shouldn't
 	 * be in memory.
-- 
2.39.5



