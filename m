Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5CB8F59;
	Fri, 16 Jun 2023 16:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED29C433C0;
	Fri, 16 Jun 2023 16:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686933699;
	bh=wVP9KiItEr8mSN+tUTw1LX0kVRv/kPOjeQ4/eD7jAGQ=;
	h=From:Date:Subject:To:Cc:From;
	b=iYgsjdiZFE5XgFNrwAXDyB2HL4aWLv5j/6Sw40HMnepdzIRc92o0Gitqy66qikBeP
	 ETCbvFXDbne2TZWh8TEh7U32pvcgY4hAALxNNlUw1vb2oh5ctGsRM2cRt/hfwg0RDP
	 JkVMmurdcqDQLtcPT8wC8H4XOScWj9gd3SZzc/lgFk0wh0oYfIoJUdDh7ZvHlHguQO
	 /1XE2TnV+K3tlsyDZ8BRZscbbkHVKVfv3HqHJaEaiRdZiFVvYVU6ducRGdYbzbSZCU
	 PoRkI1G5rQA6SMzzYNIoBtP0oxeOpcD1754mEBYinoCsrNroU5lTl/ewifXAG1C4xr
	 p9C5ahwTfMIjQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 16 Jun 2023 09:41:30 -0700
Subject: [PATCH] coresight: dummy: Update type of mode parameter in
 dummy_{sink,source}_enable()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230616-coresight-dummy-fix-kcfi-warnings-v1-1-c55c64f8f0f5@kernel.org>
X-B4-Tracking: v=1; b=H4sIALmQjGQC/x2NSwrDMAwFrxK8rsBOwU17ldKFYiu2KHaKlP4Iu
 XudLofhzVuNkjCpuXSrEXqx8lwbuENnQsaaCDg2Nr3tj9Y7D2EWUk55gfgs5QsTf+AeJoY3SuW
 aFLwfTjjGIVp3Nq0zohKMgjXkvVRQF5JdPITa+n9+vW3bD+4jZmeMAAAA
To: suzuki.poulose@arm.com
Cc: mike.leach@linaro.org, james.clark@arm.com, leo.yan@linaro.org, 
 quic_hazha@quicinc.com, coresight@lists.linaro.org, 
 linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3308; i=nathan@kernel.org;
 h=from:subject:message-id; bh=wVP9KiItEr8mSN+tUTw1LX0kVRv/kPOjeQ4/eD7jAGQ=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCk9Ew79uibVedT37S+9vKA+PYHSCQcUI9arsrFkzlp42
 8tC/mldRykLgxgHg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhIAjsjw6T0jcaPGTsDbs3V
 6PtbJ+M186UX2zWVuJfS+UdLbDy4nRn+Bzw+JiCWkxqaEqCoNeF+Za/opkuGPWxbk3OPuNy7NnM
 SNwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang's kernel Control Flow Integrity (kCFI) is a compiler-based
security mitigation that ensures the target of an indirect function call
matches the expected type of the call and trapping if they do not match
exactly. The warning -Wincompatible-function-pointer-types-strict aims
to catch these issues at compile time, which reveals:

  drivers/hwtracing/coresight/coresight-dummy.c:53:12: error: incompatible function pointer types initializing 'int (*)(struct coresight_device *, struct perf_event *, enum cs_mode)' with an expression of type 'int (struct coresight_device *, struct perf_event *, u32)' (aka 'int (struct coresight_device *, struct perf_event *, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
     53 |         .enable = dummy_source_enable,
        |                   ^~~~~~~~~~~~~~~~~~~
  drivers/hwtracing/coresight/coresight-dummy.c:62:12: error: incompatible function pointer types initializing 'int (*)(struct coresight_device *, enum cs_mode, void *)' with an expression of type 'int (struct coresight_device *, u32, void *)' (aka 'int (struct coresight_device *, unsigned int, void *)') [-Werror,-Wincompatible-function-pointer-types-strict]
     62 |         .enable = dummy_sink_enable,
        |                   ^~~~~~~~~~~~~~~~~
  2 errors generated.

Commit 9fa3682869d4 ("coresight: Use enum type for cs_mode wherever
possible") updated the type of the mode parameter in the prototype but
this driver was not introduced until commit 9d3ba0b6c056 ("Coresight:
Add coresight dummy driver") and 'int' is ABI compatible with 'enum
cs_mode', so there is no warning from regular
-Wincompatible-function-pointer-types.

Adjust the type of the mode parameter in the callback implementations in
the coresight dummy driver to match the prototype, clearing up the
warning and avoiding kCFI failures at runtime.

Fixes: 9d3ba0b6c056 ("Coresight: Add coresight dummy driver")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/hwtracing/coresight/coresight-dummy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-dummy.c b/drivers/hwtracing/coresight/coresight-dummy.c
index 42125b7a0f39..8035120b70b3 100644
--- a/drivers/hwtracing/coresight/coresight-dummy.c
+++ b/drivers/hwtracing/coresight/coresight-dummy.c
@@ -21,7 +21,7 @@ DEFINE_CORESIGHT_DEVLIST(source_devs, "dummy_source");
 DEFINE_CORESIGHT_DEVLIST(sink_devs, "dummy_sink");
 
 static int dummy_source_enable(struct coresight_device *csdev,
-			       struct perf_event *event, u32 mode)
+			       struct perf_event *event, enum cs_mode mode)
 {
 	dev_dbg(csdev->dev.parent, "Dummy source enabled\n");
 
@@ -34,7 +34,7 @@ static void dummy_source_disable(struct coresight_device *csdev,
 	dev_dbg(csdev->dev.parent, "Dummy source disabled\n");
 }
 
-static int dummy_sink_enable(struct coresight_device *csdev, u32 mode,
+static int dummy_sink_enable(struct coresight_device *csdev, enum cs_mode mode,
 				void *data)
 {
 	dev_dbg(csdev->dev.parent, "Dummy sink enabled\n");

---
base-commit: 3b79104f80036231a40ba5d15c3e329985029a0f
change-id: 20230616-coresight-dummy-fix-kcfi-warnings-6687abd8d019

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

