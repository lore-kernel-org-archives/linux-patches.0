Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E1E288C1F;
	Mon, 18 Aug 2025 14:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526199; cv=none; b=sRg6U6SFN1e4Z6DcxwPsk7OcuZqQEycHtaCXeSaY4uINLTCctgSpNygcxUKuoBbvkr4ibHB/xYZR13rncQxsi5qoN6wylgl/UE6tlGNblVaY8EN0Ipv+Vu36K+H9/cZq9s3IQxhNfwmxuBykGO7TjpzxO3nU1mysi9NjinN6niM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526199; c=relaxed/simple;
	bh=GDUvMl36M58VmyzDnczTRAaPnldPuQyikL7E4t8pzTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRcSBuTYOgnqAt+P4mi0gUTaKafN5T+t/eWeASa8fFczUSoKVoboIcoGv9Qm2EzBTqeXoR/Q7dKkzmGws/tKqZ1aRrbAGtJAUQfQDfr5tdjiwA1rFw5VkZ2s/i8TYt5kdzKkhiwZKI0EYbeDz6aPX1t0s7BPLSMwokU7raGaVGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+FAEsQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+FAEsQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D7FC4CEEB;
	Mon, 18 Aug 2025 14:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526199;
	bh=GDUvMl36M58VmyzDnczTRAaPnldPuQyikL7E4t8pzTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+FAEsQ2YqbywG8YZ6S0zysNypGegIVI0rf4bjgoZ8l/WvidxpQT6V5bPm31MgtTU
	 A0/14rTKXqbw3Q00r/DAobEO4m1H0BgD/CiIWmNss36vp5S6v0h/LPWC13gcQgP9SE
	 vQChnckB7Cq/rSx1sV2tHMK/8DXxpU4R1yq1+IzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Owens <calvin@wbinvd.org>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 454/570] tools/power turbostat: Handle cap_get_proc() ENOSYS
Date: Mon, 18 Aug 2025 14:47:21 +0200
Message-ID: <20250818124523.306481116@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Owens <calvin@wbinvd.org>

[ Upstream commit d34fe509f5f76d9dc36291242d67c6528027ebbd ]

Kernels configured with CONFIG_MULTIUSER=n have no cap_get_proc().
Check for ENOSYS to recognize this case, and continue on to
attempt to access the requested MSRs (such as temperature).

Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 9eb8e8a850ec..5c747131f155 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -6573,8 +6573,16 @@ int check_for_cap_sys_rawio(void)
 	int ret = 0;
 
 	caps = cap_get_proc();
-	if (caps == NULL)
+	if (caps == NULL) {
+		/*
+		 * CONFIG_MULTIUSER=n kernels have no cap_get_proc()
+		 * Allow them to continue and attempt to access MSRs
+		 */
+		if (errno == ENOSYS)
+			return 0;
+
 		return 1;
+	}
 
 	if (cap_get_flag(caps, CAP_SYS_RAWIO, CAP_EFFECTIVE, &cap_flag_value)) {
 		ret = 1;
-- 
2.39.5



