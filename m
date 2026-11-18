Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062102;
	b=KMvZ9+YKocGRDYqNCHrJTHShULoaVDhbrDezPp/QuWhcHq4DH3t2pg3OoX6hTwSPsaIg
	 YQgGQygqkLKuK+n75xcaP1kLSRbLuNhicrqyoG65P8qzvUNOvCwCFsYAgMFYzqIU7mMvz
	 GuSNo33EPguHCZF8Um0JxRUZYATKf6X4HfZjcbBJDUpTAC+Dvc2VpR0cB3Qc6Pkj7SZKP
	 5n837uCU+kFOYHxSIwDaAurlZNOXDyQbr6T/dVrzV3NcWAgSS8dqiqQGuA0vzLBLrr4dC
	 7RO88stVCTLi+mVZaiJwOcUhsB+2M5hSayRIIAMDvF78NqN8Z583u5aSktzStbMa9vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DCBwZQ50166XohTB2X4aus7dFwDDFqKf8EkNwRJ9kwQ=;
	b=lkNMEw6TJIFO9NPuBFoIAKhgM3ljGIAUs0aLDIQh+xRyymMc7xk2YkFi8tewhDtyBdfV
	 Xp39vNS+3PE5ekSYHjxfGABYY0rLfEkMc+Uz2IMLWWdPi3TTzGwZ3VYt4Ac1kw+ueMohZ
	 CTHem2oN8PnY8KJYp/bgPigRNbWGF+mX6tvGBSLvMlYUExXapSqpzKuxsTqYO0C5gXvG/
	 hfzcbhqN/C7M+9+X0f8OURW/H8GWvAYjz+W7PZoi6EcirhbcUr4+PbBv1TYUi3/BDwdZl
	 5cJmlc9EtwMAeZ/t6kzLMQxuxqMVehlsbYhhwXTrqdmEmZ1ECHTWJedwLXZo1TeqTjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NsBStWQ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72923606A320;
	Thu, 19 Nov 2026 04:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NsBStWQ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48D31F000C4;
	Thu, 19 Nov 2026 04:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062102;
	bh=DCBwZQ50166XohTB2X4aus7dFwDDFqKf8EkNwRJ9kwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NsBStWQ25o3C9b9DBQxBEdVuU0x33i3PUcPjzz20AqyrGUTI/BeuTiOegXJKRszRN
	 WIVUDLzEVbbmWCxi3pGt4HWF5B5ayj7/X4SPetNek1IcxNgE175LlNnvo6am4PMJdn
	 MYzeaEC9KwQCHOPBCC4IGi48sknSXRDZKYGB6rho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1791/1848] x86_energy_perf_policy: Cleanup: Check fseek() in VM path
Date: Wed, 18 Nov 2026 16:03:49 +0100
Message-ID: <20261118150034.276876716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 916694583507e..e61c3c8b51e9d 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -658,7 +658,11 @@ void err_on_hypervisor(void)
 
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



