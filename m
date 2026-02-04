Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8928E2C21ED;
	Wed,  4 Feb 2026 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217670; cv=none; b=JyfqVeV/z1YMvpP59OtSn3XVrU6Zfr35CKvAC3Da3FcJtzbGVkE+Q0YkL+5ofdDCt4QEpnlLHOK+XWmP5EFzC86DfC6Fu2wz3KYXhRuSCmt65yoBuusy9Yk/OpTYdgQ6x0YvGFi30mL6hFq0Gz8DpKOfBY8dXHLivfj8kiNEUno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217670; c=relaxed/simple;
	bh=NwY7/jCPFHTHThhPDHleFTuQ0hOiajHHuHhGkOh6rP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ztp8rJTn6bJ1jlXQBMQgUeSSaNvER0qWPyCWH9NTkun5cN2xQxOXL2oYAkSCnjHWKQ8JTcEqU/GxeyiiTsHXn8njjprNT5Nme3lOAavlmRQTOwhPJ3KE2sWG1JAaDwLW54n9aa8nEfHalttZS9D0MRXMYHnXgV32IM4OGiyO2kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vg0/eTPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vg0/eTPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE613C4CEF7;
	Wed,  4 Feb 2026 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217670;
	bh=NwY7/jCPFHTHThhPDHleFTuQ0hOiajHHuHhGkOh6rP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vg0/eTPPstMGzyuEz4pa0u5fPYIHEDNvzGkt05S2r9kW+eTG0jzHwlu7nK2Zojtxr
	 gPf1V338bHYJ2rENrNVBMyHPKVObHni4JSKhljdn25FFBniYGrWhq+2brhCUqq+i0e
	 ziq1eJ7JE8tY7596+8vUEkNAFBy2GZE8roZ4sbVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Maciek Machnikowski <maciek@machnikowski.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/280] testptp: Add support for testing ptp_clock_info .adjphase callback
Date: Wed,  4 Feb 2026 15:37:37 +0100
Message-ID: <20260204143912.645867230@linuxfoundation.org>
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

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 3a9a9a6139286584d1199f555fa4f96f592a3217 ]

Invoke clock_adjtime syscall with tx.modes set with ADJ_OFFSET when testptp
is invoked with a phase adjustment offset value. Support seconds and
nanoseconds for the offset value.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Maciek Machnikowski <maciek@machnikowski.net>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 76868642e427 ("testptp: Add option to open PHC in readonly mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ptp/testptp.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index cfa9562f3cd83..9c3d36a40309b 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -134,6 +134,7 @@ static void usage(char *progname)
 		"            1 - external time stamp\n"
 		"            2 - periodic output\n"
 		" -n val     shift the ptp clock time by 'val' nanoseconds\n"
+		" -o val     phase offset (in nanoseconds) to be provided to the PHC servo\n"
 		" -p val     enable output with a period of 'val' nanoseconds\n"
 		" -H val     set output phase to 'val' nanoseconds (requires -p)\n"
 		" -w val     set output pulse width to 'val' nanoseconds (requires -p)\n"
@@ -167,6 +168,7 @@ int main(int argc, char *argv[])
 	int adjfreq = 0x7fffffff;
 	int adjtime = 0;
 	int adjns = 0;
+	int adjphase = 0;
 	int capabilities = 0;
 	int extts = 0;
 	int flagtest = 0;
@@ -188,7 +190,7 @@ int main(int argc, char *argv[])
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
-	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:n:p:P:sSt:T:w:z"))) {
+	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:n:o:p:P:sSt:T:w:z"))) {
 		switch (c) {
 		case 'c':
 			capabilities = 1;
@@ -228,6 +230,9 @@ int main(int argc, char *argv[])
 		case 'n':
 			adjns = atoi(optarg);
 			break;
+		case 'o':
+			adjphase = atoi(optarg);
+			break;
 		case 'p':
 			perout = atoll(optarg);
 			break;
@@ -327,6 +332,18 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (adjphase) {
+		memset(&tx, 0, sizeof(tx));
+		tx.modes = ADJ_OFFSET | ADJ_NANO;
+		tx.offset = adjphase;
+
+		if (clock_adjtime(clkid, &tx) < 0) {
+			perror("clock_adjtime");
+		} else {
+			puts("phase adjustment okay");
+		}
+	}
+
 	if (gettime) {
 		if (clock_gettime(clkid, &ts)) {
 			perror("clock_gettime");
-- 
2.51.0



