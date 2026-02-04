Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963A73D3CF2;
	Wed,  4 Feb 2026 14:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217002; cv=none; b=X/q5VdOjeyrwM+sMieC63Erk9Mk3pRMv4qaI5KWrjwOdlxNFq66lQ0RH3nghrVv6x7WHjXUFdVn+m+PltxfnLz+uSBUHL+hjeN8I4duNARRd2QrlyAvGp8xOQ9zulFmrMuZxMTSL+kl5smChu3HnhnZGrKnu4Fiuw8NTKFbiYxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217002; c=relaxed/simple;
	bh=TSIMWbg+YwbE9WYd711TOOhKdFHfKOG1JmR75JkXuak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0Vp91tSxLreWWRBxUW3PRxLDGhwo/FsH1a5B5ZE7ThA8ASY7pMOAG+44yUyr4MnKg9xhotHdtUKOtmf6q87sYQORNcvwWcNrJ8vfAgH/FpYp/RfZt2FmURtG1QfxtMKLgUesO+r3JS/D6yFq3vkcjEMfEjgIL0xxXv1xqssm/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFOZUSNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFOZUSNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3094C4CEF7;
	Wed,  4 Feb 2026 14:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217002;
	bh=TSIMWbg+YwbE9WYd711TOOhKdFHfKOG1JmR75JkXuak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFOZUSNyT/dnOt3jmMpj4QMJDiAYM5x/jq9EX5xYwookUuIQiSRKQ7CaCryZmAlRq
	 ov0OYOrLuzGWUnoAvxD4u10yR8Q0eOhlU2DwqvmXXbHNjSwgg8sLmq9bDL47DQIQka
	 85eC7814HM7fgg9Iq3iyV7VJnTipFh7QEirshb/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Maftei <alex.maftei@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/206] selftests/ptp: Add -x option for testing PTP_SYS_OFFSET_EXTENDED
Date: Wed,  4 Feb 2026 15:38:12 +0100
Message-ID: <20260204143900.414061705@linuxfoundation.org>
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

From: Alex Maftei <alex.maftei@amd.com>

[ Upstream commit c8ba75c4eb846888f8f2730690b99cb5bf7b337c ]

The -x option (where 'x' stands for eXtended) takes an argument which
represents the number of samples to request from the PTP device.
The help message will display the maximum number of samples allowed.
Providing an invalid argument will also display the maximum number of
samples allowed.

Signed-off-by: Alex Maftei <alex.maftei@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 76868642e427 ("testptp: Add option to open PHC in readonly mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ptp/testptp.c | 44 +++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index eec05f659950a..d3cbd254a196d 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -143,8 +143,9 @@ static void usage(char *progname)
 		" -S         set the system time from the ptp clock time\n"
 		" -t val     shift the ptp clock time by 'val' seconds\n"
 		" -T val     set the ptp clock time to 'val' seconds\n"
+		" -x val     get an extended ptp clock time with the desired number of samples (up to %d)\n"
 		" -z         test combinations of rising/falling external time stamp flags\n",
-		progname);
+		progname, PTP_MAX_SAMPLES);
 }
 
 int main(int argc, char *argv[])
@@ -158,6 +159,7 @@ int main(int argc, char *argv[])
 	struct timex tx;
 	struct ptp_clock_time *pct;
 	struct ptp_sys_offset *sysoff;
+	struct ptp_sys_offset_extended *soe;
 
 	char *progname;
 	unsigned int i;
@@ -176,6 +178,7 @@ int main(int argc, char *argv[])
 	int index = 0;
 	int list_pins = 0;
 	int pct_offset = 0;
+	int getextended = 0;
 	int n_samples = 0;
 	int pin_index = -1, pin_func;
 	int pps = -1;
@@ -190,7 +193,7 @@ int main(int argc, char *argv[])
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
-	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:n:o:p:P:sSt:T:w:z"))) {
+	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:n:o:p:P:sSt:T:w:x:z"))) {
 		switch (c) {
 		case 'c':
 			capabilities = 1;
@@ -255,6 +258,15 @@ int main(int argc, char *argv[])
 		case 'w':
 			pulsewidth = atoi(optarg);
 			break;
+		case 'x':
+			getextended = atoi(optarg);
+			if (getextended < 1 || getextended > PTP_MAX_SAMPLES) {
+				fprintf(stderr,
+					"number of extended timestamp samples must be between 1 and %d; was asked for %d\n",
+					PTP_MAX_SAMPLES, getextended);
+				return -1;
+			}
+			break;
 		case 'z':
 			flagtest = 1;
 			break;
@@ -533,6 +545,34 @@ int main(int argc, char *argv[])
 		free(sysoff);
 	}
 
+	if (getextended) {
+		soe = calloc(1, sizeof(*soe));
+		if (!soe) {
+			perror("calloc");
+			return -1;
+		}
+
+		soe->n_samples = getextended;
+
+		if (ioctl(fd, PTP_SYS_OFFSET_EXTENDED, soe)) {
+			perror("PTP_SYS_OFFSET_EXTENDED");
+		} else {
+			printf("extended timestamp request returned %d samples\n",
+			       getextended);
+
+			for (i = 0; i < getextended; i++) {
+				printf("sample #%2d: system time before: %lld.%09u\n",
+				       i, soe->ts[i][0].sec, soe->ts[i][0].nsec);
+				printf("            phc time: %lld.%09u\n",
+				       soe->ts[i][1].sec, soe->ts[i][1].nsec);
+				printf("            system time after: %lld.%09u\n",
+				       soe->ts[i][2].sec, soe->ts[i][2].nsec);
+			}
+		}
+
+		free(soe);
+	}
+
 	close(fd);
 	return 0;
 }
-- 
2.51.0



