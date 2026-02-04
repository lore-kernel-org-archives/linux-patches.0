Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF7441B376;
	Wed,  4 Feb 2026 14:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217014; cv=none; b=EoV+NV42vn8DiFMRR0w1vxNu3XGt2sQPgU1q0G5cOvPtReA99wIkROdm7CoMEi6dPaWTB6syTXRWgceGNF5x/kKkVcX+mOS92YikyUR7x+EIFN7C8hCjX52UCZ3ywurOJzh//2wXM2JR+T8/FHrbsoql7peS3rhFO8rlvnN4jKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217014; c=relaxed/simple;
	bh=VhaOnX5WUGFC6FlEJZ1Nd34h4VzuWGhntGBQgU6koFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fT2qRmBu2KQblF/YD6Tpi4v8JxOAHVPz8aiY9C79lykdcGd46bSYBY23RlS7VK4sz6HDzNrjvjHYM26cO2AWJ0roESuQvAF4tDJYt454xdrkZAz3Te03ChyH3/jPaewCgN3PeO0oCeRRIxtlzJbpS2i78i8gnmrD95ZhbrBoRIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZK+f7Wo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZK+f7Wo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F374DC4CEF7;
	Wed,  4 Feb 2026 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217014;
	bh=VhaOnX5WUGFC6FlEJZ1Nd34h4VzuWGhntGBQgU6koFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZK+f7Wo/KQ2lDawF17oeiea2ooQhp9nNY6fFFMg8GuhOUMRLb4kcMcpDeFtupITwA
	 /Sx7z+/bW+pqroG23stWRa9DIWWXw2AuvmogGIt0X12Nnuu81WFtfR/PvcZWWs1q/T
	 kAf9ylGY2Qkp+VLhxtf7WgvVBtShue9KSsZf6gRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Bandewar <maheshb@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/206] selftest/ptp: update ptp selftest to exercise the gettimex options
Date: Wed,  4 Feb 2026 15:38:15 +0100
Message-ID: <20260204143900.520159886@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Mahesh Bandewar <maheshb@google.com>

[ Upstream commit 3d07b691ee707c00afaf365440975e81bb96cd9b ]

With the inclusion of commit c259acab839e ("ptp/ioctl: support
MONOTONIC{,_RAW} timestamps for PTP_SYS_OFFSET_EXTENDED") clock_gettime()
now allows retrieval of pre/post timestamps for CLOCK_MONOTONIC and
CLOCK_MONOTONIC_RAW timebases along with the previously supported
CLOCK_REALTIME.

This patch adds a command line option 'y' to the testptp program to
choose one of the allowed timebases [realtime aka system, monotonic,
and monotonic-raw).

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://patch.msgid.link/20241003101506.769418-1-maheshb@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 76868642e427 ("testptp: Add option to open PHC in readonly mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ptp/testptp.c | 62 ++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index 994ac7988426b..d3922e3c437f1 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -146,6 +146,7 @@ static void usage(char *progname)
 		" -T val     set the ptp clock time to 'val' seconds\n"
 		" -x val     get an extended ptp clock time with the desired number of samples (up to %d)\n"
 		" -X         get a ptp clock cross timestamp\n"
+		" -y val     pre/post tstamp timebase to use {realtime|monotonic|monotonic-raw}\n"
 		" -z         test combinations of rising/falling external time stamp flags\n",
 		progname, PTP_MAX_SAMPLES);
 }
@@ -189,6 +190,7 @@ int main(int argc, char *argv[])
 	int seconds = 0;
 	int settime = 0;
 	int channel = -1;
+	clockid_t ext_clockid = CLOCK_REALTIME;
 
 	int64_t t1, t2, tp;
 	int64_t interval, offset;
@@ -198,7 +200,7 @@ int main(int argc, char *argv[])
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
-	while (EOF != (c = getopt(argc, argv, "cd:e:f:F:ghH:i:k:lL:n:o:p:P:sSt:T:w:x:Xz"))) {
+	while (EOF != (c = getopt(argc, argv, "cd:e:f:F:ghH:i:k:lL:n:o:p:P:sSt:T:w:x:Xy:z"))) {
 		switch (c) {
 		case 'c':
 			capabilities = 1;
@@ -278,6 +280,21 @@ int main(int argc, char *argv[])
 		case 'X':
 			getcross = 1;
 			break;
+		case 'y':
+			if (!strcasecmp(optarg, "realtime"))
+				ext_clockid = CLOCK_REALTIME;
+			else if (!strcasecmp(optarg, "monotonic"))
+				ext_clockid = CLOCK_MONOTONIC;
+			else if (!strcasecmp(optarg, "monotonic-raw"))
+				ext_clockid = CLOCK_MONOTONIC_RAW;
+			else {
+				fprintf(stderr,
+					"type needs to be realtime, monotonic or monotonic-raw; was given %s\n",
+					optarg);
+				return -1;
+			}
+			break;
+
 		case 'z':
 			flagtest = 1;
 			break;
@@ -564,6 +581,7 @@ int main(int argc, char *argv[])
 		}
 
 		soe->n_samples = getextended;
+		soe->clockid = ext_clockid;
 
 		if (ioctl(fd, PTP_SYS_OFFSET_EXTENDED, soe)) {
 			perror("PTP_SYS_OFFSET_EXTENDED");
@@ -572,12 +590,46 @@ int main(int argc, char *argv[])
 			       getextended);
 
 			for (i = 0; i < getextended; i++) {
-				printf("sample #%2d: system time before: %lld.%09u\n",
-				       i, soe->ts[i][0].sec, soe->ts[i][0].nsec);
+				switch (ext_clockid) {
+				case CLOCK_REALTIME:
+					printf("sample #%2d: real time before: %lld.%09u\n",
+					       i, soe->ts[i][0].sec,
+					       soe->ts[i][0].nsec);
+					break;
+				case CLOCK_MONOTONIC:
+					printf("sample #%2d: monotonic time before: %lld.%09u\n",
+					       i, soe->ts[i][0].sec,
+					       soe->ts[i][0].nsec);
+					break;
+				case CLOCK_MONOTONIC_RAW:
+					printf("sample #%2d: monotonic-raw time before: %lld.%09u\n",
+					       i, soe->ts[i][0].sec,
+					       soe->ts[i][0].nsec);
+					break;
+				default:
+					break;
+				}
 				printf("            phc time: %lld.%09u\n",
 				       soe->ts[i][1].sec, soe->ts[i][1].nsec);
-				printf("            system time after: %lld.%09u\n",
-				       soe->ts[i][2].sec, soe->ts[i][2].nsec);
+				switch (ext_clockid) {
+				case CLOCK_REALTIME:
+					printf("            real time after: %lld.%09u\n",
+					       soe->ts[i][2].sec,
+					       soe->ts[i][2].nsec);
+					break;
+				case CLOCK_MONOTONIC:
+					printf("            monotonic time after: %lld.%09u\n",
+					       soe->ts[i][2].sec,
+					       soe->ts[i][2].nsec);
+					break;
+				case CLOCK_MONOTONIC_RAW:
+					printf("            monotonic-raw time after: %lld.%09u\n",
+					       soe->ts[i][2].sec,
+					       soe->ts[i][2].nsec);
+					break;
+				default:
+					break;
+				}
 			}
 		}
 
-- 
2.51.0



