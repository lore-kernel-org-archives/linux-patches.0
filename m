Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F9063C3;
	Sat, 13 Jan 2024 10:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVOM7PUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F500C433F1;
	Sat, 13 Jan 2024 10:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140067;
	bh=Av1MDFn+Gvxnlkq8gUm2C4aiZdgaK8v0cLqeS+wo+QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVOM7PUJPCQFhJy4Q9G4GtyQ+2lbIO/nwQa6D3zVEffNvxvhLcWtzmCDtbLzWSUC7
	 kIfTd5Vvl8gj9+O4v4FXw+hqUzDmOlfr1tkENLEcSPL2ar77UEl8s7zNaFv6Tncbls
	 a/KlezZh028Qun1y1jMyrUEWQFyEoz59y4nQDVHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	"kernelci.org bot" <bot@kernelci.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/59] selftests: secretmem: floor the memory size to the multiple of page_size
Date: Sat, 13 Jan 2024 10:50:13 +0100
Message-ID: <20240113094210.591947330@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
References: <20240113094209.301672391@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit 0aac13add26d546ac74c89d2883b3a5f0fbea039 ]

The "locked-in-memory size" limit per process can be non-multiple of
page_size.  The mmap() fails if we try to allocate locked-in-memory with
same size as the allowed limit if it isn't multiple of the page_size
because mmap() rounds off the memory size to be allocated to next multiple
of page_size.

Fix this by flooring the length to be allocated with mmap() to the
previous multiple of the page_size.

This was getting triggered on KernelCI regularly because of different
ulimit settings which wasn't multiple of the page_size.  Find logs
here: https://linux.kernelci.org/test/plan/id/657654bd8e81e654fae13532/
The bug in was present from the time test was first added.

Link: https://lkml.kernel.org/r/20231214101931.1155586-1-usama.anjum@collabora.com
Fixes: 76fe17ef588a ("secretmem: test: add basic selftest for memfd_secret(2)")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Closes: https://linux.kernelci.org/test/plan/id/657654bd8e81e654fae13532/
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/memfd_secret.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/vm/memfd_secret.c b/tools/testing/selftests/vm/memfd_secret.c
index 93e7e7ffed337..9177490981489 100644
--- a/tools/testing/selftests/vm/memfd_secret.c
+++ b/tools/testing/selftests/vm/memfd_secret.c
@@ -62,6 +62,9 @@ static void test_mlock_limit(int fd)
 	char *mem;
 
 	len = mlock_limit_cur;
+	if (len % page_size != 0)
+		len = (len/page_size) * page_size;
+
 	mem = mmap(NULL, len, prot, mode, fd, 0);
 	if (mem == MAP_FAILED) {
 		fail("unable to mmap secret memory\n");
-- 
2.43.0



