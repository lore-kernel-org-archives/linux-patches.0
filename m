Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25938246768;
	Tue, 11 Nov 2025 01:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822925; cv=none; b=R+oV7+1z6zym42zj8ptdS6V39ZJ77qc1QdEu20qOkFF9YPSFWJ02v4s1iUj94KdJuNcfKX2outA1YjW7uT41Ki17X7PtsNfYBEt1akbyu9Hfv7O79iiYOI7tnhUi5B1zh/sNqdQKETC4RjJ99zvCH325KKI0VGpNXgYw9O3m7gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822925; c=relaxed/simple;
	bh=a1yQ/8wB9wEK2yLMCcYVh54qOI9nrRndxsUs8DpCSiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhU34ovxEcCsMS7SLwp5V+ohj7PGGPdLueXltiQVxZF0t9CwKAWb1luBegY+hNPDJwXN2REXuaKTPp9JYc6jZ0AvH55SaLvJdDD7jdGLaYzUZ9dOYaZwj0XzfRBE4rEe6MC0xrXbvyOFG1kFUSXPc1jkhbGmcGD5/fJIbD3DWk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EozZAXqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EozZAXqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65782C16AAE;
	Tue, 11 Nov 2025 01:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822924;
	bh=a1yQ/8wB9wEK2yLMCcYVh54qOI9nrRndxsUs8DpCSiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EozZAXquMqOoyKZot5HjRmUOu1TKFyxIAxT9DGZDSyjxFDUImG0iRoOmsFPCzHl3d
	 92ulqgI+NyTJmf8xdvId8cQIp00bdtIl+H09p4u7CD25VYOLMQdzkFwrnQgvR2ayyT
	 kBBszPjGz4BrR+M35FCQZfdlMJELp8B5OhYLHc38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 197/849] selftests: ublk: fix behavior when fio is not installed
Date: Tue, 11 Nov 2025 09:36:07 +0900
Message-ID: <20251111004541.202241635@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit a3835a44107fcbf05f183b5e8b60a8e4605b15ea ]

Some ublk selftests have strange behavior when fio is not installed.
While most tests behave correctly (run if they don't need fio, or skip
if they need fio), the following tests have different behavior:

- test_null_01, test_null_02, test_generic_01, test_generic_02, and
  test_generic_12 try to run fio without checking if it exists first,
  and fail on any failure of the fio command (including "fio command
  not found"). So these tests fail when they should skip.
- test_stress_05 runs fio without checking if it exists first, but
  doesn't fail on fio command failure. This test passes, but that pass
  is misleading as the test doesn't do anything useful without fio
  installed. So this test passes when it should skip.

Fix these issues by adding _have_program fio checks to the top of all of
these tests.

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ublk/test_generic_01.sh | 4 ++++
 tools/testing/selftests/ublk/test_generic_02.sh | 4 ++++
 tools/testing/selftests/ublk/test_generic_12.sh | 4 ++++
 tools/testing/selftests/ublk/test_null_01.sh    | 4 ++++
 tools/testing/selftests/ublk/test_null_02.sh    | 4 ++++
 tools/testing/selftests/ublk/test_stress_05.sh  | 4 ++++
 6 files changed, 24 insertions(+)

diff --git a/tools/testing/selftests/ublk/test_generic_01.sh b/tools/testing/selftests/ublk/test_generic_01.sh
index 9227a208ba531..21a31cd5491aa 100755
--- a/tools/testing/selftests/ublk/test_generic_01.sh
+++ b/tools/testing/selftests/ublk/test_generic_01.sh
@@ -10,6 +10,10 @@ if ! _have_program bpftrace; then
 	exit "$UBLK_SKIP_CODE"
 fi
 
+if ! _have_program fio; then
+	exit "$UBLK_SKIP_CODE"
+fi
+
 _prep_test "null" "sequential io order"
 
 dev_id=$(_add_ublk_dev -t null)
diff --git a/tools/testing/selftests/ublk/test_generic_02.sh b/tools/testing/selftests/ublk/test_generic_02.sh
index 3e80121e3bf5e..12920768b1a08 100755
--- a/tools/testing/selftests/ublk/test_generic_02.sh
+++ b/tools/testing/selftests/ublk/test_generic_02.sh
@@ -10,6 +10,10 @@ if ! _have_program bpftrace; then
 	exit "$UBLK_SKIP_CODE"
 fi
 
+if ! _have_program fio; then
+	exit "$UBLK_SKIP_CODE"
+fi
+
 _prep_test "null" "sequential io order for MQ"
 
 dev_id=$(_add_ublk_dev -t null -q 2)
diff --git a/tools/testing/selftests/ublk/test_generic_12.sh b/tools/testing/selftests/ublk/test_generic_12.sh
index 7abbb00d251df..b4046201b4d99 100755
--- a/tools/testing/selftests/ublk/test_generic_12.sh
+++ b/tools/testing/selftests/ublk/test_generic_12.sh
@@ -10,6 +10,10 @@ if ! _have_program bpftrace; then
 	exit "$UBLK_SKIP_CODE"
 fi
 
+if ! _have_program fio; then
+	exit "$UBLK_SKIP_CODE"
+fi
+
 _prep_test "null" "do imbalanced load, it should be balanced over I/O threads"
 
 NTHREADS=6
diff --git a/tools/testing/selftests/ublk/test_null_01.sh b/tools/testing/selftests/ublk/test_null_01.sh
index a34203f726685..c2cb8f7a09fe3 100755
--- a/tools/testing/selftests/ublk/test_null_01.sh
+++ b/tools/testing/selftests/ublk/test_null_01.sh
@@ -6,6 +6,10 @@
 TID="null_01"
 ERR_CODE=0
 
+if ! _have_program fio; then
+	exit "$UBLK_SKIP_CODE"
+fi
+
 _prep_test "null" "basic IO test"
 
 dev_id=$(_add_ublk_dev -t null)
diff --git a/tools/testing/selftests/ublk/test_null_02.sh b/tools/testing/selftests/ublk/test_null_02.sh
index 5633ca8766554..8accd35beb55c 100755
--- a/tools/testing/selftests/ublk/test_null_02.sh
+++ b/tools/testing/selftests/ublk/test_null_02.sh
@@ -6,6 +6,10 @@
 TID="null_02"
 ERR_CODE=0
 
+if ! _have_program fio; then
+	exit "$UBLK_SKIP_CODE"
+fi
+
 _prep_test "null" "basic IO test with zero copy"
 
 dev_id=$(_add_ublk_dev -t null -z)
diff --git a/tools/testing/selftests/ublk/test_stress_05.sh b/tools/testing/selftests/ublk/test_stress_05.sh
index 566cfd90d192c..274295061042e 100755
--- a/tools/testing/selftests/ublk/test_stress_05.sh
+++ b/tools/testing/selftests/ublk/test_stress_05.sh
@@ -5,6 +5,10 @@
 TID="stress_05"
 ERR_CODE=0
 
+if ! _have_program fio; then
+	exit "$UBLK_SKIP_CODE"
+fi
+
 run_io_and_remove()
 {
 	local size=$1
-- 
2.51.0



