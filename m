Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9193FFD;
	Tue, 29 Apr 2025 18:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949620; cv=none; b=KXBARn0EjBAEJNdpdOhv9syzGNH4zDZm7cGalBmw2hjIkNCG4a79f1c9kFQcZxXZmpi2f3zESrsASHzdabrfYONW2ONa8otTTXukRpS1MSLxgHM7QGfxwEa86f0ajqSmewQneRs3ePd/yT6+u+vRXusXsqgVPJaPRsv4ni/Sd+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949620; c=relaxed/simple;
	bh=mkGzRbGrrUbF0xdtKug81tqxjHKLqtUkMGksqxPqX+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unuqZJpKu5hvMzh8z9sLWXhrAO/oAlp1jorPdgtmpSFCj/Advd1HiVJGCjtxAPys/2yGT8ROiHTLatuf4IvVhl4d0smqO/FLvObRtA2/7PFTbohUxKE3EvoZF/gqGAQbydrZmNAqX0dgRx3klTv+NKKHjPH7AWG14m/A33NtDWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csQcpB+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csQcpB+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C84C4CEE3;
	Tue, 29 Apr 2025 18:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949620;
	bh=mkGzRbGrrUbF0xdtKug81tqxjHKLqtUkMGksqxPqX+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csQcpB+00J61SCM3L6jjKr5m2wEcNykNgCmTPHkeiUsVIGZ2cRhfsSHeSK4I9RFEb
	 DSdqp8dD/bHCwZDkfcCljDRMyG/zhyzzOMbfRZW7c7Cnj5Y0a5R5jwC11WCXVNFWmN
	 UtbFAfiHEAQDrAT/+CHDyxjLtuTHDsT4VdiNZw5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Lai <yi1.lai@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 348/373] selftests/mincore: Allow read-ahead pages to reach the end of the file
Date: Tue, 29 Apr 2025 18:43:45 +0200
Message-ID: <20250429161137.444690796@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4c88238fc8f05..c0ae86c28d7f3 100644
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



