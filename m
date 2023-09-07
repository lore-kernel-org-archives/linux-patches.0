Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458E313AC1
	for <patches@lists.linux.dev>; Thu,  7 Sep 2023 22:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=XC05CLRxBxiWntbZw3VKKBal5n44I+j/00vdUNPZdpU=; b=WLHW6hF/Z9PC6VVw4G4kyqPqb+
	x4h5apJUuVz98FM4kZRzYZylmarTmEx6bqjdYgUdGhmdvdzXPEU6OB8SjRAP8iB7E06Qfmfr+sLDt
	8a6dXy3ZszlRIyxLqBz92RWMGYWL5LNx0h6nhNDkkHX3g3+uQqyQwgVXXaxKMVsw3lHpS6FMH8nau
	8RwR0kF2MqrWb4DAXiBrd1ij7DRfy/n5GJNo0lY9YFX07D/5m6yVjlzRXOXubqwShSJ1OAPjHqtuC
	hrfnLyVIA7Qnd8GFGDA8L6TRxmWa+xDFMHVfVNFSlsa7xd7Xcpl2TCZljgzmJPc+9QRHdEPJEYddj
	A4+e6Zvw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qeNCr-00CkFa-1d;
	Thu, 07 Sep 2023 22:10:33 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: fstests@vger.kernel.org,
	aalbersh@redhat.com,
	chandan.babu@oracle.com,
	amir73il@gmail.com,
	djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH] check: add support for --start-after
Date: Thu,  7 Sep 2023 15:10:30 -0700
Message-Id: <20230907221030.3037715-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Often times one is running a new test baseline we want to continue to
start testing where we left off if the last test was a crash. To do
this the first thing that occurred to me was to use the check.time
file as an expunge file but that doesn't work so well if you crashed
as the file turns out empty.

So instead add super simple argument --start-after which let's you
skip all tests until the test infrastructure has "seen" the test
you want to skip. This does obviously work best if you are not using
a random order, but that is rather implied.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 check | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/check b/check
index 71b9fbd07522..1ecf07c1cb37 100755
--- a/check
+++ b/check
@@ -18,6 +18,8 @@ showme=false
 have_test_arg=false
 randomize=false
 exact_order=false
+start_after=false
+start_after_test=""
 export here=`pwd`
 xfile=""
 subdir_xfile=""
@@ -80,6 +82,7 @@ check options
     -b			brief test summary
     -R fmt[,fmt]	generate report in formats specified. Supported formats: xunit, xunit-quiet
     --large-fs		optimise scratch device for large filesystems
+    --start-after	only start testing after the test specified
     -s section		run only specified section from config file
     -S section		exclude the specified section from the config file
     -L <n>		loop tests <n> times following a failure, measuring aggregate pass/fail metrics
@@ -313,6 +316,11 @@ while [ $# -gt 0 ]; do
 				<(sed "s/#.*$//" $xfile)
 		fi
 		;;
+	--start-after)
+		start_after=true
+		start_after_test="$2"
+		shift
+		;;
 	-s)	RUN_SECTION="$RUN_SECTION $2"; shift ;;
 	-S)	EXCLUDE_SECTION="$EXCLUDE_SECTION $2"; shift ;;
 	-l)	diff="diff" ;;
@@ -591,6 +599,15 @@ _expunge_test()
 {
 	local TEST_ID="$1"
 
+	if $start_after; then
+		if [[ "$start_after_test" == ${TEST_ID}* ]]; then
+			start_after=false
+		fi
+		echo "       [skipped]"
+		return 0
+
+	fi
+
 	for f in "${exclude_tests[@]}"; do
 		# $f may contain traling spaces and comments
 		local id_regex="^${TEST_ID}\b"
-- 
2.39.2

