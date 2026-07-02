Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAC534AB00;
	Thu,  2 Jul 2026 16:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009624; cv=none; b=gB+nnnjc3oOksNcLmLLs5IeyglwOYMvDZJ2TXCEXL5RCiU3l1mgULCinGj7Vl5wrErhyfYZGxp1Ys4gvz4XRwlVzLbwKtpDWO9985htoqUeDEKofGhRq3UOJll3ew27+ETsYTM6frQ8iHYj8TSfDeWAbAFFE+bHtoCJXK3grk7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009624; c=relaxed/simple;
	bh=5Et4eiz7I3BrMV6ZMf8zbzmEduy9PQqj0KHj8roG2vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELnywm5EZ6OhuxXbwiLkWsZuB1xVID/cEer6cy4DiexIM6eL50E+t7x6u1WxdFZ2+I+4OTEouZzwWrpFuOL0UWHJv0B3/TRffsOYyWNvoLu4CyZDptNxJ+JbcZ3XCt89Xsg0PPV70DydoAcWIdQrDy0dzyNY/W5QKDK6H9QefIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5hjDXsy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5hjDXsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1D71F000E9;
	Thu,  2 Jul 2026 16:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009620;
	bh=gyAmClFmt7YgsOeyqt9ZaKUrlfF94O32aiLBcyVsZSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5hjDXsy6d5e98jrr6NnSSCZxws5nvdN+azML90siaILHpEW2LLrrc+Pp25ZSl6XH
	 Y1mqDcTRzLVM2E5YAfN8v12QjfCswaV7vRqcnrzFbDTwS7u86tSs8Z0Im6h+EB8z8Z
	 L48ttXVJ2znyzTIojRJChqJLZ0IpnN5MRWRS3/1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wang <yongwang@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 24/95] Revert "selftest/ptp: update ptp selftest to exercise the gettimex options"
Date: Thu,  2 Jul 2026 18:19:27 +0200
Message-ID: <20260702155109.717109635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

This reverts commit 6b32d042aa8255e964ebed860e24adccb204fcbc, which is
commit 3d07b691ee707c00afaf365440975e81bb96cd9b upstream.

The cited commit allows testptp to set a configurable clock_id. That is
done via a PTP_SYS_OFFSET_EXTENDED ioctl call, whose argument is struct
ptp_sys_offset_extended, where the clock_id is set. However, this Linux
version does not support the ptp_sys_offset_extended.clockid field, and
the test case cannot be built against this tree's own UAPI headers.

The reverted commit was introduced to resolve a missing dependency of
commit bef3a83a9a67 ("testptp: Add option to open PHC in readonly mode"),
which is 76868642e427 upstream. My suspicion is that the only conflict
between the two is the getopt string, and there is otherwise no direct
dependency between the two.

This patch therefore reverts the cited commit, with hand-resolving the
getopt string to include 'r' (as introduced by c6dc458227a3), but not
'y' (introduced by 06954f715deb).

Reported-by: Yong Wang <yongwang@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ptp/testptp.c | 62 +++------------------------
 1 file changed, 5 insertions(+), 57 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index 89b4f43a7ba459..d78d52f028ab52 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -147,7 +147,6 @@ static void usage(char *progname)
 		" -T val     set the ptp clock time to 'val' seconds\n"
 		" -x val     get an extended ptp clock time with the desired number of samples (up to %d)\n"
 		" -X         get a ptp clock cross timestamp\n"
-		" -y val     pre/post tstamp timebase to use {realtime|monotonic|monotonic-raw}\n"
 		" -z         test combinations of rising/falling external time stamp flags\n",
 		progname, PTP_MAX_SAMPLES);
 }
@@ -192,7 +191,6 @@ int main(int argc, char *argv[])
 	int readonly = 0;
 	int settime = 0;
 	int channel = -1;
-	clockid_t ext_clockid = CLOCK_REALTIME;
 
 	int64_t t1, t2, tp;
 	int64_t interval, offset;
@@ -202,7 +200,7 @@ int main(int argc, char *argv[])
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
-	while (EOF != (c = getopt(argc, argv, "cd:e:f:F:ghH:i:k:lL:n:o:p:P:rsSt:T:w:x:Xy:z"))) {
+	while (EOF != (c = getopt(argc, argv, "cd:e:f:F:ghH:i:k:lL:n:o:p:P:rsSt:T:w:x:Xz"))) {
 		switch (c) {
 		case 'c':
 			capabilities = 1;
@@ -285,21 +283,6 @@ int main(int argc, char *argv[])
 		case 'X':
 			getcross = 1;
 			break;
-		case 'y':
-			if (!strcasecmp(optarg, "realtime"))
-				ext_clockid = CLOCK_REALTIME;
-			else if (!strcasecmp(optarg, "monotonic"))
-				ext_clockid = CLOCK_MONOTONIC;
-			else if (!strcasecmp(optarg, "monotonic-raw"))
-				ext_clockid = CLOCK_MONOTONIC_RAW;
-			else {
-				fprintf(stderr,
-					"type needs to be realtime, monotonic or monotonic-raw; was given %s\n",
-					optarg);
-				return -1;
-			}
-			break;
-
 		case 'z':
 			flagtest = 1;
 			break;
@@ -590,7 +573,6 @@ int main(int argc, char *argv[])
 		}
 
 		soe->n_samples = getextended;
-		soe->clockid = ext_clockid;
 
 		if (ioctl(fd, PTP_SYS_OFFSET_EXTENDED, soe)) {
 			perror("PTP_SYS_OFFSET_EXTENDED");
@@ -599,46 +581,12 @@ int main(int argc, char *argv[])
 			       getextended);
 
 			for (i = 0; i < getextended; i++) {
-				switch (ext_clockid) {
-				case CLOCK_REALTIME:
-					printf("sample #%2d: real time before: %lld.%09u\n",
-					       i, soe->ts[i][0].sec,
-					       soe->ts[i][0].nsec);
-					break;
-				case CLOCK_MONOTONIC:
-					printf("sample #%2d: monotonic time before: %lld.%09u\n",
-					       i, soe->ts[i][0].sec,
-					       soe->ts[i][0].nsec);
-					break;
-				case CLOCK_MONOTONIC_RAW:
-					printf("sample #%2d: monotonic-raw time before: %lld.%09u\n",
-					       i, soe->ts[i][0].sec,
-					       soe->ts[i][0].nsec);
-					break;
-				default:
-					break;
-				}
+				printf("sample #%2d: system time before: %lld.%09u\n",
+				       i, soe->ts[i][0].sec, soe->ts[i][0].nsec);
 				printf("            phc time: %lld.%09u\n",
 				       soe->ts[i][1].sec, soe->ts[i][1].nsec);
-				switch (ext_clockid) {
-				case CLOCK_REALTIME:
-					printf("            real time after: %lld.%09u\n",
-					       soe->ts[i][2].sec,
-					       soe->ts[i][2].nsec);
-					break;
-				case CLOCK_MONOTONIC:
-					printf("            monotonic time after: %lld.%09u\n",
-					       soe->ts[i][2].sec,
-					       soe->ts[i][2].nsec);
-					break;
-				case CLOCK_MONOTONIC_RAW:
-					printf("            monotonic-raw time after: %lld.%09u\n",
-					       soe->ts[i][2].sec,
-					       soe->ts[i][2].nsec);
-					break;
-				default:
-					break;
-				}
+				printf("            system time after: %lld.%09u\n",
+				       soe->ts[i][2].sec, soe->ts[i][2].nsec);
 			}
 		}
 
-- 
2.53.0



