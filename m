Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4932A2D77E5;
	Mon, 20 Apr 2026 15:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700150; cv=none; b=GpYcOM+ocdeIavBoavIMFaXtwU1QbHzjIsKwRfcyCJ9KcnJ7B8vA3bKypOOEZsU+Nh/SEhe6tQNohkfv+R2dfMkrIVjEp/PoMFUb3TPTwjhsVVNg/PIbUJkc1FV2mavOKq90jKboxRC4EDe8uwlBzTLyPIjb+PuERS+8Q+Z3mU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700150; c=relaxed/simple;
	bh=SUtC7y4j8mqSM6m8EyrewbOSuIaq2YH/JiGU5pMX2Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FB5cgDOAlL+2KsUs3QyKFwX51NCvl0E3tJARC0yU+lLZjcq9PVaUVOKwSyEdfL3rI7atJydga7vRFU3aSpUFIpksO/d1KXnU7LcXH1UJNrLICyQQJeUUS3mojAyIv2jnFXsifrQclPwyXnjd9wsvOSIJyHM91wUYuj75H9a9ppc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WDlaEQqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDlaEQqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEFCC2BCB4;
	Mon, 20 Apr 2026 15:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700149;
	bh=SUtC7y4j8mqSM6m8EyrewbOSuIaq2YH/JiGU5pMX2Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDlaEQqt51zcO0preSmZ7XA6JmBvjJ4XcS08AlkwsQQYFCsm+HeTV6f7AoKMX+N25
	 1/mu7vFOCblUFEHMLpcpm/M2fgepYamcTzXrznkN0S3VDt2ACUQLBhE/vczHWYMIdy
	 /V7e7lPW2fa7OPMVvOGwy4QYcWWugiaf5k85KxNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 061/220] tools/power turbostat: Fix delimiter bug in print functions
Date: Mon, 20 Apr 2026 17:40:02 +0200
Message-ID: <20260420153936.239042248@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

[ Upstream commit cdbefe9d4029d4834d404f7ba13a960b38a69e88 ]

Commands that add counters, such as 'turbostat --show C1,C1+'
display merged columns without a delimiter.

This is caused by the bad syntax: '(*printed++ ? delim : "")', shared by
print_name()/print_hex_value()/print_decimal_value()/print_float_value()

Use '((*printed)++ ? delim : "")' to correctly increment the value at *printed.

[lenb: fix code and commit message typo, re-word]
Fixes: 56dbb878507b ("tools/power turbostat: Refactor added column header printing")
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index b01a905bd24a7..c6060f65eaaf1 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2732,29 +2732,29 @@ static inline int print_name(int width, int *printed, char *delim, char *name, e
 	UNUSED(type);
 
 	if (format == FORMAT_RAW && width >= 64)
-		return (sprintf(outp, "%s%-8s", (*printed++ ? delim : ""), name));
+		return (sprintf(outp, "%s%-8s", ((*printed)++ ? delim : ""), name));
 	else
-		return (sprintf(outp, "%s%s", (*printed++ ? delim : ""), name));
+		return (sprintf(outp, "%s%s", ((*printed)++ ? delim : ""), name));
 }
 
 static inline int print_hex_value(int width, int *printed, char *delim, unsigned long long value)
 {
 	if (width <= 32)
-		return (sprintf(outp, "%s%08x", (*printed++ ? delim : ""), (unsigned int)value));
+		return (sprintf(outp, "%s%08x", ((*printed)++ ? delim : ""), (unsigned int)value));
 	else
-		return (sprintf(outp, "%s%016llx", (*printed++ ? delim : ""), value));
+		return (sprintf(outp, "%s%016llx", ((*printed)++ ? delim : ""), value));
 }
 
 static inline int print_decimal_value(int width, int *printed, char *delim, unsigned long long value)
 {
 	UNUSED(width);
 
-	return (sprintf(outp, "%s%lld", (*printed++ ? delim : ""), value));
+	return (sprintf(outp, "%s%lld", ((*printed)++ ? delim : ""), value));
 }
 
 static inline int print_float_value(int *printed, char *delim, double value)
 {
-	return (sprintf(outp, "%s%0.2f", (*printed++ ? delim : ""), value));
+	return (sprintf(outp, "%s%0.2f", ((*printed)++ ? delim : ""), value));
 }
 
 void print_header(char *delim)
-- 
2.53.0



