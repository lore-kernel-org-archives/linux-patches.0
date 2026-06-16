Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA04466B4E;
	Tue, 16 Jun 2026 16:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627961; cv=none; b=CIfYANu4ki3A55Q4KXrM5n9ZHBu06UOgpDgky60Cgq14tLeuR2RLUWNfiQE/Qm8ZGyDcmCNV5is4kchfQ7ODhFqQqqmOmlZ09l/fg5HfOpeZWPYyXV6S9+ReOVBeRc7hPBj5jmC6gP+Is0tgxTDg9npGgFmByN0oy73QOFBobwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627961; c=relaxed/simple;
	bh=9faKzHFPQumRC3fH6GvU1yXO2xzoBuh5Hj1Sd2G3Q7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoOVJHIkg77CrZ0cc3AJ8Eurmc8MB7W6dHhZTr7+IKxEloqaZ7y7bJ8M378cPgfEoi2c2Lf40q9OPyxecWGSZQhz/94k5Yn8ExFL/oRorVt4Ne0GuS2gqkAH9nl4CvnM17+Gv6Zj9dVqdx5ZVbOzXhIDnpLimSkWAWz31oqZZFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dVEeYTo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dVEeYTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875E31F000E9;
	Tue, 16 Jun 2026 16:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627960;
	bh=ImlhGzprYh7MSJ4V6+faDgFJObzoC3Li+rUMTX481DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dVEeYToMtd9u/KGtoyPNvFcnj7Q2JtmN9V1G8iZZXJSDITkRYK0Q3EQozVCrjbPw
	 ETP6OXCFrFYD5Ozw4UKqXtth4MokwxtTy0xnwXKJKgXHg97RDtGslzFM8B2z4EThXt
	 YjfUO0nzro4Esj7FZQRpS/gfeUAdVh6/lDeEfmSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wang <yongwang@nvidia.com>,
	Petr Machata <petrm@nvidia.com>
Subject: [PATCH 6.12 261/261] Revert "selftest/ptp: update ptp selftest to exercise the gettimex options"
Date: Tue, 16 Jun 2026 20:31:39 +0530
Message-ID: <20260616145057.159450909@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

This reverts commit fa361565a7275cc43c6ca1abec9ec4fcc9ec51f1, which is
commit 3d07b691ee707c00afaf365440975e81bb96cd9b upstream.

The cited commit allows testptp to set a configurable clock_id. That is
done via a PTP_SYS_OFFSET_EXTENDED ioctl call, whose argument is struct
ptp_sys_offset_extended, where the clock_id is set. However, this Linux
version does not support the ptp_sys_offset_extended.clockid field, and
the test case cannot be built against this tree's own UAPI headers.

The reverted commit was introduced to resolve a missing dependency of
commit c6dc458227a3 ("testptp: Add option to open PHC in readonly mode"),
which is 76868642e427 upstream. My suspicion is that the only conflict
between the two is the getopt string, and there is otherwise no direct
dependency between the two.

This patch therefore reverts the cited commit, with hand-resolving the
getopt string to include 'r' (as introduced by c6dc458227a3), but not
'y' (introduced by 06954f715deb).

Reported-by: Yong Wang <yongwang@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ptp/testptp.c |   62 ++--------------------------------
 1 file changed, 5 insertions(+), 57 deletions(-)

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
@@ -592,7 +575,6 @@ int main(int argc, char *argv[])
 		}
 
 		soe->n_samples = getextended;
-		soe->clockid = ext_clockid;
 
 		if (ioctl(fd, PTP_SYS_OFFSET_EXTENDED, soe)) {
 			perror("PTP_SYS_OFFSET_EXTENDED");
@@ -601,46 +583,12 @@ int main(int argc, char *argv[])
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
 


