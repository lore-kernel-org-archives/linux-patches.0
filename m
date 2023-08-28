Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E9C11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC28C433C7;
	Mon, 28 Aug 2023 10:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218454;
	bh=KCSoi35ovnuyaNZFfGNGv4oPwxi5I3sWbUoIIZ+aCss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPirEe6PEVogmV6CqK8vn5/fyA9V2bQUmGltcvuwlw/sSWjS3k3jhIHzOSrXK5rlO
	 iWVYVZJO2PK3iwmys0hEN0zVSRxjL7xt9b8IHrhGi6xawPPfGTwipyh712up2Ez7/n
	 Po3fbHm/i7+GyNwj0EdxBvkEkf4E0iRgRrcq9Xxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/129] MIPS: cpu-features: Enable octeon_cache by cpu_type
Date: Mon, 28 Aug 2023 12:13:00 +0200
Message-ID: <20230828101156.511277204@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit f641519409a73403ee6612b8648b95a688ab85c2 ]

cpu_has_octeon_cache was tied to 0 for generic cpu-features,
whith this generic kernel built for octeon CPU won't boot.

Just enable this flag by cpu_type. It won't hurt orther platforms
because compiler will eliminate the code path on other processors.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: 5487a7b60695 ("MIPS: cpu-features: Use boot_cpu_type for CPU type based features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/cpu-features.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index 4e2ee743088fd..73fa4c3337f89 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -111,7 +111,24 @@
 #define cpu_has_tx39_cache	__opt(MIPS_CPU_TX39_CACHE)
 #endif
 #ifndef cpu_has_octeon_cache
-#define cpu_has_octeon_cache	0
+#define cpu_has_octeon_cache						\
+({									\
+	int __res;							\
+									\
+	switch (current_cpu_type()) {					\
+	case CPU_CAVIUM_OCTEON:						\
+	case CPU_CAVIUM_OCTEON_PLUS:					\
+	case CPU_CAVIUM_OCTEON2:					\
+	case CPU_CAVIUM_OCTEON3:					\
+		__res = 1;						\
+		break;							\
+									\
+	default:							\
+		__res = 0;						\
+	}								\
+									\
+	__res;								\
+})
 #endif
 /* Don't override `cpu_has_fpu' to 1 or the "nofpu" option won't work.  */
 #ifndef cpu_has_fpu
-- 
2.40.1



