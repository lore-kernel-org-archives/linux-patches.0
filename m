Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E9F10A1E;
	Wed, 28 Jan 2026 15:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614310; cv=none; b=PQua2HkQNqDFvOlDPrUw4Md+HS6glDywIcEI/AdEpXx4kpVQswiY6eg0WJENEqpGefC9XQwpNEXdtA+Gypte8o/qkZ8ZrwaP8UOj7Ea7Ama/7iU63wOZwYeG6R62FqZFBbdhgEyqF5rohaXA/D5rWRLWEKCSgkTJ0IBfBDG9UB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614310; c=relaxed/simple;
	bh=hMlTLxWenfTe9+6MUM7uzWCpjvfU8GA3tk7i5A7PYP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O63OeXhZKVW1E3MBGB0LUN+pJ7aiDCWYJRLDufkzwsYzi8vs3xV42HIaqwI3YhORLd5IawG5LzVWam+oouiex5RNyaVSNEfbtcjzpFOWbgQZ/NRXyU561vQi5JeQN9fP5FI+bm6QqwAaXZJ+/2k8ddsbSjG8G+Q15Q9Q6zUaqMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hx8A8Rv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx8A8Rv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB595C4CEF1;
	Wed, 28 Jan 2026 15:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614310;
	bh=hMlTLxWenfTe9+6MUM7uzWCpjvfU8GA3tk7i5A7PYP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hx8A8Rv64Sa1ZdAaaO0WXWSveSx//294VqZbNyCfmveEMnzMKMpRYh+S4hArgUHkC
	 oryfTMYEF92Yr49+1fo1XkHunqclMk+28vKBwDLl4XW2aK7GT77pjIyPOrMOslFH2Y
	 xDy+W/+OU2hB0PGGReMK5zgaG7bbGeKaqG45bfxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Wojtek Wasko <wwasko@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/254] testptp: Add option to open PHC in readonly mode
Date: Wed, 28 Jan 2026 16:21:13 +0100
Message-ID: <20260128145348.317865496@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 58064151f2c89..edc08a4433fd4 100644
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
@@ -436,14 +441,16 @@ int main(int argc, char *argv[])
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
@@ -455,10 +462,12 @@ int main(int argc, char *argv[])
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



