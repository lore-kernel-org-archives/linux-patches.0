Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050649;
	b=05671UlxspBIIY/ABsyr8Ku+bvXDnX/7pMavsphgN9FOE02YNHttrZfNYYDOxPBRuZn8
	 vTLwW1li7cSrHFhAJ2PQa317gQdCjD2Wqvg54TQZ1p2ZsNZ4iVU69Lur4XH/+XPC8EPcm
	 GsebcTa50BlWj6rz5DFPwWR0YiOvlcpJFCLCBhGTFQ3+prPvGYHgMxCvTZEQVlbsSgVIu
	 rmk9q2O9zk35cyta41Mmp+dRRdDPhVA6MbTzsVBG8W3pQFVKtvmbgPxksQ6Q3wn2EJeaV
	 EzljgUuNOAFsz/6HamlK31lbvkEfUJKdiX+OZDpprKMVfyGh7O6ONTZTl4ONu5/nwmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RGEX9STOHod5RODTK3QRICZ/2AVNeDD1lji2tMJNnXg=;
	b=Nwk3O/SZRsI/Ha24dfHPLpIUpm2DR5b9rL95SjsbVpoCysyFTY8IDuLuSYBecIHjw7Az
	 6miRI0U4giRACjBKE3nLmDxxvwPdOhR3Gb4k+8NH6C3vpkSA9tesu2jn9IL4+iivWWieg
	 RWxTQiKMho0mNqjk1tFD/UQiWAHa3vi7IryPkMieGNx8d3LEL94AW7shlnKer0zF84r3B
	 obFSz+oHRn8ygo1joi/xzDsgmlqUb0a+K1c/0HJrmX89PRm7CMN0V07EhF4xdbU+4fb54
	 l4LkSum6CcPEHNVuEJvFt93roMAVGDgZXHD1PiUFPx00v2n2k4UYu5sb6htIbfe/+ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0MiTvfO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BA6606A320;
	Thu, 19 Nov 2026 01:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0MiTvfO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E0F1F000C4;
	Thu, 19 Nov 2026 01:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050649;
	bh=RGEX9STOHod5RODTK3QRICZ/2AVNeDD1lji2tMJNnXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0MiTvfOeaH4/QMea1/HbuB/yfWbDrDbihmW9Fd+e3gG5+4Zq8jBi0zKjCfpsHLG7
	 U36Vats0VaFi7VjdI7VAMzu1p5Jtrt5hXhYs+9un0cRvGbDQvSLz34kt/sZpMPum+p
	 WjvdvuBCAduPQbsWktY75NS7OijyiE87v28A66o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2756/2857] x86_energy_perf_policy: Cleanup: Check fseek() in VM path
Date: Wed, 18 Nov 2026 16:03:10 +0100
Message-ID: <20261118150340.838767879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 2778dc35d40e7e84c134ca4cab1376fa58208f80 ]

Add return value validation for fseek() and ensure consistent
resource cleanup on all error paths in err_on_hypervisor().

Fixes: 0936cdfbb527 ("tools/power x86_energy_perf_policy: Input/output error in a VM")
Assisted-by: GitHub-Copilot:Claude-Sonnet-4.6
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86/x86_energy_perf_policy/x86_energy_perf_policy.c     | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 2545f64d5f43b..f26c6dd0d6c14 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -661,7 +661,11 @@ void err_on_hypervisor(void)
 
 	flags = strstr(buffer, "flags");
 	rewind(cpuinfo);
-	fseek(cpuinfo, flags - buffer, SEEK_SET);
+	if (fseek(cpuinfo, flags - buffer, SEEK_SET) != 0) {
+		fclose(cpuinfo);
+		free(buffer);
+		err(1, "Failed to seek in /proc/cpuinfo");
+	}
 	if (!fgets(buffer, 4096, cpuinfo)) {
 		fclose(cpuinfo);
 		free(buffer);
-- 
2.53.0



