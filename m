Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040118;
	b=qkrF/50BbInHaKjL0M5X5UX61YScm0G2ltg9CP9esbsw2ptB44WFyxbk0zqSEw8WPqg8
	 vF5vkhkVJ4XoKUnEUResiZX06GWhKyk+9a22oZQ1vwsmonDoXB47U+wyhxyYrTRZPUbXV
	 JnR9lCeORnTtyCqJMWRUQ9AMyl1QF20BHHAdX+zI2Q1AzA8LVrab7APGXLEjeXMglosbO
	 dWMiqOHhhnysbTsG9CsE2+rFmS6YoWgMxtXPe+Nm0eIbSCgvt15zU+uQa31qNVMNihddR
	 ECsPldNeS8DK+YhJ6NSk9qi/PZbGvASly+gNdyHT0pyDiBaurdCq2RoOZyGl4dfZvDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iY/QRFdyi9TChA2G1BOtOmDCg790v9VVU4QTiELh3kI=;
	b=te8OflAnpzCoKJV8cxLRQRBBRDVR1FwEUg7RX4NYN2jD3xmQTzR2OcbsSPkzjLMTlbHt
	 DA5DsTrZP2BKbSOb1Xc7jedVYn+BVnq5N1QiSVnejJGopWSGmxRCJxJCYmKDkVhIzJMX9
	 dSBqe9gQyWkoGxTjqWoQ+wuq59r7D4ODqFCmWThzLv51x/hvhO9Mj2GmfZoczZFobAdKw
	 lkGrvBPI9oVp4qVVPbUq0a/kOOZuXaBJ69KRLYXSlZOOqX8e82tP9B6Cj2ETTIgHdJnC+
	 3nxt88TjwrNCm5w1QNS670B/fcGRWuCBsnnRMyM6jRG3pQErSgXAXUyIumDkbAo8r7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IXqovzOS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90727606A331;
	Wed, 18 Nov 2026 22:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IXqovzOS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9744B1F000C4;
	Wed, 18 Nov 2026 22:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040118;
	bh=iY/QRFdyi9TChA2G1BOtOmDCg790v9VVU4QTiELh3kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IXqovzOSqLd2GrMmh5EebyaHXcHPY+ids/MwMXLoC+R8l793lvYQcwYZCbrzI6MPj
	 7YLJUpegYjr1cv6wvNINn2PVT2lRBZ0K9TiWh+uOMjrPBP9vf5eknOQP1bimZoNzSA
	 64JfhU55WaGkkui9jyrZbCZLLdoreKthLW9wCBQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Leo Yan <leo.yan@linux.dev>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2343/3318] perf mem: Fix size tracking for mem_lvls in perf_script__meminfo_scnprintf()
Date: Wed, 18 Nov 2026 15:49:25 +0100
Message-ID: <20261118150431.919735820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Falcon <thomas.falcon@intel.com>

[ Upstream commit 06d5ce78e4fea2cf0738da903aa248a81101c155 ]

When printing memory info in perf script, the entire size of the
buffer is passed to perf_mem__lvl_scnprintf() instead of the remaining
size. Pass the remaining buffer size instead.

This issue was detected by sashiko during an internal code review.

Fixes: fdefc3750e847a91 ("perf mem: Print memory operation type")
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Leo Yan <leo.yan@linux.dev>
Assisted-by: Sashiko:gemini-3.1-pro-preview
Signed-off-by: Thomas Falcon <thomas.falcon@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/mem-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/mem-events.c b/tools/perf/util/mem-events.c
index 3a2e3687878c1..7724c68c0f4cb 100644
--- a/tools/perf/util/mem-events.c
+++ b/tools/perf/util/mem-events.c
@@ -516,7 +516,7 @@ int perf_script__meminfo_scnprintf(char *out, size_t sz, struct mem_info *mem_in
 	i += scnprintf(out, sz, "|OP ");
 	i += perf_mem__op_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|LVL ");
-	i += perf_mem__lvl_scnprintf(out + i, sz, mem_info);
+	i += perf_mem__lvl_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|SNP ");
 	i += perf_mem__snp_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|TLB ");
-- 
2.53.0



