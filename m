Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056874;
	b=Lb70UC15IWxnzBh/2/za6t7N2D+XKlAb3j6ogD/Xm7LzjDi6kDgLsxwAfhotv9on4Y+2
	 +w9cjtuBx6Y6vXqzM9KGUn0JxUiANmomdQl9FjYttiStvjbSgvm/3JwVjCBhTfZ/5E8lI
	 iid2my43xA4MindKXtYxySF82ULqzl1dkozK1z092GioaDso4Fa7X8jxa6N7I+NoNZS37
	 qKlXzZPRsmqbnQhzEcLdk5Du/AQgnjP34OUeGO70ukZ41bRxmnrVU9xjOAgAs+W6PRA70
	 /xaIwd8RcJ6urAssid5tzOQq+md61wHSZOBcpd2w9GSZKKaY0AWVlF0vG0EacrtDcjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6/aGEgAGTK/WyI8J6CFSTfOpx/j1We1M8ovsFRRSEwo=;
	b=jc/sD73z+OkT7R8azRH6elYDvEQbkRWFzooKHp3ZWMXW6XWs2KVsE/2m63L3ZN25xHyy
	 EORgJtwosZrpKPXBO6gPriI29EkZW0pXoyO4X297DNMZ+HuIrGnQ/cB6QFPPzQtvDpggJ
	 4cl+OZrZrc0WP23fsUnBkxEKcKK/hoqdaykbCq/y7AThPoyvNwMU5JQDfJDa9ox68kor1
	 gEzX+0YgP3cmqQuLP+kTuf/zeyXF/6GBA0h1+Jz0hXY8EgoxIpbopCAv+PqzYCfHze7gv
	 okJ9s6n0PRPRGOT+TlZtwIsQ7Wt84pi85MnRDIGaRNYENWuxeaTa3rIdF+Z/l1lBRBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nv+QiTkT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80C8606A31C;
	Thu, 19 Nov 2026 02:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nv+QiTkT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D571F000C4;
	Thu, 19 Nov 2026 02:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056874;
	bh=6/aGEgAGTK/WyI8J6CFSTfOpx/j1We1M8ovsFRRSEwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nv+QiTkTDLWRSzVrOdNoRsrrBz/YfZsqrQeeka8DJAil0KMC+9FYqJ85yx09460Dl
	 y0bJ2cZXbDp7LFjKjigtMl99KYQdLlRUw8KHydcv/ukKs+ZExlzPHWsbwc02dVyyWn
	 LAHMYpXNeBUXF2U/gTnd8K1/R1u0WHUxGbfLqHPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2143/2214] x86_energy_perf_policy: Cleanup: Check fseek() in VM path
Date: Wed, 18 Nov 2026 16:03:39 +0100
Message-ID: <20261118150136.220745344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



