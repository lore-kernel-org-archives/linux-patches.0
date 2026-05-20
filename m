Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B663F0A83;
	Wed, 20 May 2026 17:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299322; cv=none; b=rNQaFmm2oq7sOKimGErs7qIGldrkcS65smZ9FJ9d1ZxAQmCbBrXZhjtBFgvqTjKuPmCFVWBveo96S/NMtgAfWcYI6S1KPlR8MtHKt73eYLIy1tzrzLEZXjDGid+p+gqkAtYGqRIvLhPYPrF9HfmQR0Hh7eKwESXpueZ3ZPfElF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299322; c=relaxed/simple;
	bh=qtFLutK6xkLztUssGeyydMx2Ir25PzkHa6sf/dwIV/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5fdeLuM+zPj3y8LS6eAlsOJ4qHxD54ME91kMTzH0MVncajwoOlV6Ms0+EVGSVxQDT9H04PHDnU3fVG5Obg/CBAuVytHJZVSSJGbovmz6T/Ez3knLdTh5g76KI59lJbna8Gal4x5H2ZrCEDOau8MEo+sC9zGjvUCqoghjufHjSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlZn1qhi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlZn1qhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D8A1F000E9;
	Wed, 20 May 2026 17:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299321;
	bh=frRPUR8ieQvqyyfIZ4LsTMlIcDp+04fu7upQEbYyiWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BlZn1qhiCE6LAhIZm0qBtm26PgYRDqebE51RbI4tFVVNl3w9K3gKOqPeI2pmuJoQ/
	 Vv3UB5kT4Au8dX3GDIy/mfbFrwymmiGbtAWbjh/ayfI/J4DGCQbTOugyH3fMlSoOM8
	 4UsTVGuNSeBPh0QTNJ7ME2oIz57XiC+GS3oaaY+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 728/957] tools/power turbostat: Use strtoul() for iteration parsing
Date: Wed, 20 May 2026 18:20:11 +0200
Message-ID: <20260520162150.341241470@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 8e5c0cc326f2e95a71bb6e6063e65caa60c8f951 ]

Replace strtod() with strtoul() and check errno for -n/-N options, since
num_iterations and header_iterations are unsigned long counters. Reject
zero and conversion errors; negative inputs wrap to large positive values
per standard unsigned semantics.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Stable-dep-of: ce012c966b51 ("tools/power turbostat: Fix unrecognized option '-P'")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 48677f1846347..29441e3c711d9 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -11133,18 +11133,20 @@ void cmdline(int argc, char **argv)
 			/* Parsed earlier */
 			break;
 		case 'n':
-			num_iterations = strtod(optarg, NULL);
+			num_iterations = strtoul(optarg, NULL, 0);
+			errno = 0;
 
-			if (num_iterations <= 0) {
-				fprintf(outf, "iterations %d should be positive number\n", num_iterations);
+			if (errno || num_iterations == 0) {
+				fprintf(outf, "invalid iteration count: %s\n", optarg);
 				exit(2);
 			}
 			break;
 		case 'N':
-			header_iterations = strtod(optarg, NULL);
+			header_iterations = strtoul(optarg, NULL, 0);
+			errno = 0;
 
-			if (header_iterations <= 0) {
-				fprintf(outf, "iterations %d should be positive number\n", header_iterations);
+			if (errno || header_iterations == 0) {
+				fprintf(outf, "invalid header iteration count: %s\n", optarg);
 				exit(2);
 			}
 			break;
-- 
2.53.0



