Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033102;
	b=Nuwm4tY4Z8q+bF+2yy6YX3wR3Rh4oAGKRBmp6SeQplnkr38UBhsVjKPPdmQGKR3ARm4L
	 NwIoo1aP6PwwDB2MqwK50gJzRw7xot/044vIiheIhN/Vhxq86Jpz7fw8n9x1ruv5rZA4D
	 HldvQkIX0YoU1S/zqCtLBoXUOTV6bvrdsimbgxefKdGhcu5GW095VtoArlERKAvzd4zCO
	 3U+TCyoilGwTsAZDnWYZLD0/t3IBQ36WG/7zPw1NBmUTZzFYyl6JTC9tbZcMxpuu8q8Mi
	 gwlfvKvzHgSSScja8RcZVcj80P5UmUo2mYOrzn9R1JtlYr4kq2aEyPuRPygOnZiY/qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=++3aIgIXsOiR4E8JC/uwN1Mod/vuKqy7edGGGQpRobc=;
	b=zbgf7F31UZ+tAJzI+z/6o4Ch1SZ24MQhndB3Tnyvcsnr67lBOR8FV2kHtpisJA6acaH2
	 aTNDjjcjVy629ZLWKATNTB0/wG9DlnJFUVimy7FY0nkMk5NFJ23eoGsCwExk0EgUOmHNi
	 pffScFqIX3HXLO/rxs7sVtyB1P8uUauMXeahh3abDYClBhXy6BNAgsPiDvh3pXJ9Qggq9
	 wydcvdBs0OMGEjlgJ1QnzRUIXnM9i+W7NHgySMoTlMPHaUWfbMuiQdfe+LZC/nVD1c5Kh
	 cisU7I6jXH169ZOuZq0cN07QrfOQBmVV5ETAfIA7CvBFbnnCdw/1wYXdXkj6t0WQlQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bzwlaqco;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3E3606A31C;
	Wed, 18 Nov 2026 20:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bzwlaqco
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F8F1F000C4;
	Wed, 18 Nov 2026 20:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033102;
	bh=++3aIgIXsOiR4E8JC/uwN1Mod/vuKqy7edGGGQpRobc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bzwlaqcoy23ng0Aq36RSJ5/Ya2H14TJW+sCekjBYYXYpuZ6G4EfjtRGfO6ENG15XX
	 nM20TRW25OmpzMUztM8plNgrQw1BehkxB4MuCJHJRGz6J4zhuohH9xYop9Wwuvcrqt
	 6oxk8tEtqBrf52Ork7wxGgCOJ+YgiG/oGvm/hTSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1606/1756] x86_energy_perf_policy: Cleanup: Check fseek() in VM path
Date: Wed, 18 Nov 2026 16:02:13 +0100
Message-ID: <20261118150113.811903243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



