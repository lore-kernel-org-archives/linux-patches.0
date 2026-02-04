Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F9142B725;
	Wed,  4 Feb 2026 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217776; cv=none; b=iac/gLP3CPMVmmWeL7W+lTFxueJYT2Q+aq5q9cS7kChLHflKzcCYd98lJQ9nVVWsahEXkUWtiP+r5BHIxxxZMnM/mPUngQ/u/VvsO2qHiS0IgYEv8t3HqA/HZD731xsoMPSl+3XYxvBtkdHm6c0czGdFBJZp2rTz0r5UXsGRR1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217776; c=relaxed/simple;
	bh=c11y4grOC4SsSq97zTPne4Z4mPiw1WePzyKWozutD4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ct9rkpzwGtU9o+1dvzFMUVeSe8QAPqPHdy15jl0Y+Wqm5guKCi5Ctlzq4szpoknvJ7if9AXv20urlzKAjR6bzwni+SXiBMVa04cMwJn7EVtOOr1WV8jcrfyiwfWoVvhP/Iz0jqnqfPVPPf4cfwBCDEdpGWPG9iBkV7kI4spopxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHxa/PgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHxa/PgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2BDC4CEF7;
	Wed,  4 Feb 2026 15:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217775;
	bh=c11y4grOC4SsSq97zTPne4Z4mPiw1WePzyKWozutD4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHxa/PgBmGyEYYARcswi0CYcGDsISw7ndcegHsPktcz+/N6iZaVwbP27uIxy/nf4p
	 3GEv6tbWEqoMchKVP+JhW20brqFqMAd7nLatvcksbKyh6eP6nJwRkKL/+Kz1pCtK91
	 k9vJdKcoHn9Fx5yIlwXSU6Rw9feZAE0H2bEycVdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Wojtek Wasko <wwasko@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/280] testptp: Add option to open PHC in readonly mode
Date: Wed,  4 Feb 2026 15:37:42 +0100
Message-ID: <20260204143912.824943936@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wojtek Wasko <wwasko@nvidia.com>

[ Upstream commit 76868642e42795353106197abf9c607ad80f4c9e ]

PTP Hardware Clocks no longer require WRITE permission to perform
readonly operations, such as listing device capabilities or listening to
EXTTS events once they have been enabled by a process with WRITE
permissions.

Add '-r' option to testptp to open the PHC in readonly mode instead of
the default read-write mode. Skip enabling EXTTS if readonly mode is
requested.

Acked-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Wojtek Wasko <wwasko@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ptp/testptp.c | 37 +++++++++++++++++----------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index 2323a3329b298..532fb6a5d0591 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -140,6 +140,7 @@ static void usage(char *progname)
 		" -H val     set output phase to 'val' nanoseconds (requires -p)\n"
 		" -w val     set output pulse width to 'val' nanoseconds (requires -p)\n"
 		" -P val     enable or disable (val=1|0) the system clock PPS\n"
+		" -r         open the ptp clock in readonly mode\n"
 		" -s         set the ptp clock time from the system time\n"
 		" -S         set the system time from the ptp clock time\n"
 		" -t val     shift the ptp clock time by 'val' seconds\n"
@@ -188,6 +189,7 @@ int main(int argc, char *argv[])
 	int pin_index = -1, pin_func;
 	int pps = -1;
 	int seconds = 0;
+	int readonly = 0;
 	int settime = 0;
 	int channel = -1;
 	clockid_t ext_clockid = CLOCK_REALTIME;
@@ -200,7 +202,7 @@ int main(int argc, char *argv[])
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
-	while (EOF != (c = getopt(argc, argv, "cd:e:f:F:ghH:i:k:lL:n:o:p:P:sSt:T:w:x:Xy:z"))) {
+	while (EOF != (c = getopt(argc, argv, "cd:e:f:F:ghH:i:k:lL:n:o:p:P:rsSt:T:w:x:Xy:z"))) {
 		switch (c) {
 		case 'c':
 			capabilities = 1;
@@ -252,6 +254,9 @@ int main(int argc, char *argv[])
 		case 'P':
 			pps = atoi(optarg);
 			break;
+		case 'r':
+			readonly = 1;
+			break;
 		case 's':
 			settime = 1;
 			break;
@@ -308,7 +313,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	fd = open(device, O_RDWR);
+	fd = open(device, readonly ? O_RDONLY : O_RDWR);
 	if (fd < 0) {
 		fprintf(stderr, "opening %s: %s\n", device, strerror(errno));
 		return -1;
@@ -434,14 +439,16 @@ int main(int argc, char *argv[])
 	}
 
 	if (extts) {
-		memset(&extts_request, 0, sizeof(extts_request));
-		extts_request.index = index;
-		extts_request.flags = PTP_ENABLE_FEATURE;
-		if (ioctl(fd, PTP_EXTTS_REQUEST, &extts_request)) {
-			perror("PTP_EXTTS_REQUEST");
-			extts = 0;
-		} else {
-			puts("external time stamp request okay");
+		if (!readonly) {
+			memset(&extts_request, 0, sizeof(extts_request));
+			extts_request.index = index;
+			extts_request.flags = PTP_ENABLE_FEATURE;
+			if (ioctl(fd, PTP_EXTTS_REQUEST, &extts_request)) {
+				perror("PTP_EXTTS_REQUEST");
+				extts = 0;
+			} else {
+				puts("external time stamp request okay");
+			}
 		}
 		for (; extts; extts--) {
 			cnt = read(fd, &event, sizeof(event));
@@ -453,10 +460,12 @@ int main(int argc, char *argv[])
 			       event.t.sec, event.t.nsec);
 			fflush(stdout);
 		}
-		/* Disable the feature again. */
-		extts_request.flags = 0;
-		if (ioctl(fd, PTP_EXTTS_REQUEST, &extts_request)) {
-			perror("PTP_EXTTS_REQUEST");
+		if (!readonly) {
+			/* Disable the feature again. */
+			extts_request.flags = 0;
+			if (ioctl(fd, PTP_EXTTS_REQUEST, &extts_request)) {
+				perror("PTP_EXTTS_REQUEST");
+			}
 		}
 	}
 
-- 
2.51.0



