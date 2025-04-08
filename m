Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1132E26461E;
	Tue,  8 Apr 2025 12:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115766; cv=none; b=h+Swt5eOb6MngVjkVouUmVVTr3c9si7Wd6bS3YAL13MM/f3blPiOYaFY50hRK8aaS594nchJTqhssShRhm5do549LELET1KFxisTybJHU8PIljnXNH0Kc3/+vvsy0rc33TCh0JzZPRJOkjWdI6ezqajWaOV6/aAFCqzBtNOUcWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115766; c=relaxed/simple;
	bh=h/xIPYwSnT0WNfcHNNtvCu5r5Rt9pWThbYPvIqDhtTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/c5j4ooVCBohPVPH/z4p/3eGG8+7o11JtlxQdiJYLB1eHNKrCHwlAdf9udoKzzEwiQSPEmpJ/Z2Dj26BA2XZ9AL2WqmbPic1RiV3q13jh+6IbIpz8ZPOKVRl/ygpKZ7n7bm3Ec8UXzjomY1fSexroQ/RQuahDTxqyH2ibUdAqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+G4WMDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+G4WMDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9341BC4CEE7;
	Tue,  8 Apr 2025 12:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115765;
	bh=h/xIPYwSnT0WNfcHNNtvCu5r5Rt9pWThbYPvIqDhtTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+G4WMDuQfHK3s8fpjz8FSZWfxL9sgK4uK7S9aIKGPdKy6+vxPrpWPbI6vjiIO1BH
	 CWXdfyJquxGQ0YaUZtmYyiRh9jSMbB6yWeIj4JdLY42WlqQOPAj6rlSfDmDyFNMUNL
	 t9U6HNlxRPOnI8wIOtnbiCMyi/odrKjzimx7GjlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/204] perf units: Fix insufficient array space
Date: Tue,  8 Apr 2025 12:50:26 +0200
Message-ID: <20250408104823.159558564@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit cf67629f7f637fb988228abdb3aae46d0c1748fe ]

No need to specify the array size, let the compiler figure that out.

This addresses this compiler warning that was noticed while build
testing on fedora rawhide:

  31    15.81 fedora:rawhide                : FAIL gcc version 15.0.1 20250225 (Red Hat 15.0.1-0) (GCC)
    util/units.c: In function 'unit_number__scnprintf':
    util/units.c:67:24: error: initializer-string for array of 'char' is too long [-Werror=unterminated-string-initialization]
       67 |         char unit[4] = "BKMG";
          |                        ^~~~~~
    cc1: all warnings being treated as errors

Fixes: 9808143ba2e54818 ("perf tools: Add unit_number__scnprintf function")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20250310194534.265487-3-acme@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/units.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/units.c b/tools/perf/util/units.c
index 32c39cfe209b3..4c6a86e1cb54b 100644
--- a/tools/perf/util/units.c
+++ b/tools/perf/util/units.c
@@ -64,7 +64,7 @@ unsigned long convert_unit(unsigned long value, char *unit)
 
 int unit_number__scnprintf(char *buf, size_t size, u64 n)
 {
-	char unit[4] = "BKMG";
+	char unit[] = "BKMG";
 	int i = 0;
 
 	while (((n / 1024) > 1) && (i < 3)) {
-- 
2.39.5



