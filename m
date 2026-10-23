Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773802;
	b=n+Trr63CBkMbsZO0rufT3FJ3LK0j40dK5jw278Trs4DrLvXPatCcBrOmcBgiBZwwta3A
	 qfpKP3vlYVua+GQHOchsqOYnDhITbMvwCEgoRJ7YMnGB1SVq4pzZgoQyJ5BTlZLcd7cr2
	 uY5Y8tq1qnyMeAgXLjhAhc4tBL10TKOQbJnUSpC6HdQAGVnxNZ6uPPRZqF0XUTtaU0WA6
	 /I8t98wxsTw37++BFNjzWKvAwpor15fDU2h4GVS6Y1Hz5xb51PZyjuKjvhySuYgxajznZ
	 3bdhA9KGbv6OcRTbkcOwjMT+BuYTNYvumzW10XEtB1gXkcEP/JOVxltakKrDKM9qE6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rg886dStneh1dNd4N2UCmUyJLnr/T6nLPI7IpYO9Gsk=;
	b=XBb2CFNPG9ePRS23VSg55qCdQsJfz9Lb9BjXnU8HbE3K9BMVZxxQBlec7yPjCUMBExNJ
	 woDP2cgdiffGYR9hKd5hqFH5kv+1BY0xfJarN/46N2Mj821yIj1ldqEZf/s63AwUmzAQY
	 xsVF+71c2leeYw/QrZgvtwgyGQ1Wc9IZjdIjS0QTWcAb4gE1i4ZoZP5rayG9+JEAVzjkY
	 DQaa3Y1Cvv9pnWhMJGOBcKZis7YOYMY4G8y5QfUXXUWXf1jWmNffMWKBiUnGIVYCjxV9v
	 VCBOwGm53emSXDmgny8DvHk+TJlA5Y2YK2cS2p5mlwfYvPaY1Pt+kwYSaEwYEotUoNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCf5myq2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0066C606A323;
	Fri, 23 Oct 2026 16:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCf5myq2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498661F01825;
	Fri, 23 Oct 2026 16:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773801;
	bh=rg886dStneh1dNd4N2UCmUyJLnr/T6nLPI7IpYO9Gsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCf5myq2cg5/sUHuxMlo1snJLommGcSc8cIWx7AlzBBP1Ur0ExW2QxnTfmlQwzW+o
	 l317nWcvQ2sVE/8A3srtODV055DAgvVkgChGIO2RXS2G+nyZ0G8Xpb65zSrQCeOZhX
	 nNYSsP+FnpOW277iWe2hMSFEJ3T9HY9bknxLvmRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/193] tools/power turbostat: Fix add_counter issue if > 24 counters.
Date: Fri, 23 Oct 2026 18:34:58 +0200
Message-ID: <20261023163714.703104709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 154b96dab83fd953b9b82c8bcfa041cd6a9d74d3 ]

We allocate space for added counters ahead of time,
and we arbitrarily chose 24 added counters of each type.
If a future code flow hits this limit and continues,
and then removes counters, we do a phantom increment
and lose track of the number of added counters.

Increment the count only if there is no error.

Fixes: 388e9c8134be ("tools/power turbostat: Make extensible via the --add parameter")
Assisted-by: Claude: Claude Sonnet 4.6
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index d7b079d45d365..3bab2677b0670 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -10195,10 +10195,11 @@ int add_counter(unsigned int msr_num, char *path, char *name,
 				fprintf(stderr, "%s: %s FOUND\n", __func__, name);
 			break;
 		}
-		if (sys.added_thread_counters++ >= MAX_ADDED_THREAD_COUNTERS) {
+		if (sys.added_thread_counters >= MAX_ADDED_THREAD_COUNTERS) {
 			warnx("ignoring thread counter %s", name);
 			return -1;
 		}
+		sys.added_thread_counters++;
 		break;
 	case SCOPE_CORE:
 		msrp = find_msrp_by_name(sys.cp, name);
@@ -10207,10 +10208,11 @@ int add_counter(unsigned int msr_num, char *path, char *name,
 				fprintf(stderr, "%s: %s FOUND\n", __func__, name);
 			break;
 		}
-		if (sys.added_core_counters++ >= MAX_ADDED_CORE_COUNTERS) {
+		if (sys.added_core_counters >= MAX_ADDED_CORE_COUNTERS) {
 			warnx("ignoring core counter %s", name);
 			return -1;
 		}
+		sys.added_core_counters++;
 		break;
 	case SCOPE_PACKAGE:
 		msrp = find_msrp_by_name(sys.pp, name);
@@ -10219,10 +10221,11 @@ int add_counter(unsigned int msr_num, char *path, char *name,
 				fprintf(stderr, "%s: %s FOUND\n", __func__, name);
 			break;
 		}
-		if (sys.added_package_counters++ >= MAX_ADDED_PACKAGE_COUNTERS) {
+		if (sys.added_package_counters >= MAX_ADDED_PACKAGE_COUNTERS) {
 			warnx("ignoring package counter %s", name);
 			return -1;
 		}
+		sys.added_package_counters++;
 		break;
 	default:
 		warnx("ignoring counter %s with unknown scope", name);
-- 
2.53.0



