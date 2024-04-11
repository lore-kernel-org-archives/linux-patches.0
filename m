Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385A62EAE5;
	Thu, 11 Apr 2024 10:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829661; cv=none; b=bYc+JV0yyubPxGa36KXugIl7udOcMTCBNKGIp9aRK50rfv1wI/sf5J1HRA6EYwl8XftiaAIeq4/AfOGaJ2yQLELutc9zEyMYs+yUjfAvslp3Wid1rLH8fclPOghD9zmRCdUlP/oH+5H+XoZGBqNXV8eFHCs7gTX5cKyyAeEhKZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829661; c=relaxed/simple;
	bh=Y1UjfouNKSjpl+eU3HV6uYryuJ7yOpHX9PvZN1I9xSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klKN4eYeemfRqOuIdmzl8kMjTSZXeDBeeARDlpyg+1fzG3i2d7F/milVCBtGeh4i+kYMFXq5oZBqvp/mrvUXvmvDk8LaWUNAwP+UHhMP5T88K8li/L9kaZHIHR40sZ0zr8agnb42xZWwpKyVsdLs3anB9IlSh5QtU/AQLYgJoUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLccYwcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLccYwcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75C3C433C7;
	Thu, 11 Apr 2024 10:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829661;
	bh=Y1UjfouNKSjpl+eU3HV6uYryuJ7yOpHX9PvZN1I9xSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLccYwcY6FpBuLHQwLsT0pY3JNrD62ImSgzpcbV2l0UR1Tyoj/yuwPMrZguzJFpAS
	 CvHz8oMsKG8+5PW+BJNlBd+Nm2aDiTuBuc/+6H4SNW30UViSc9o8BU7dUD/34Z5/i8
	 ygia4d0v7ZuFE6cC8W/QpoTTr9h/PbOlK0q8pTXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Zhang <qiang4.zhang@intel.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/175] memtest: use {READ,WRITE}_ONCE in memory scanning
Date: Thu, 11 Apr 2024 11:54:45 +0200
Message-ID: <20240411095421.432750450@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

From: Qiang Zhang <qiang4.zhang@intel.com>

[ Upstream commit 82634d7e24271698e50a3ec811e5f50de790a65f ]

memtest failed to find bad memory when compiled with clang.  So use
{WRITE,READ}_ONCE to access memory to avoid compiler over optimization.

Link: https://lkml.kernel.org/r/20240312080422.691222-1-qiang4.zhang@intel.com
Signed-off-by: Qiang Zhang <qiang4.zhang@intel.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memtest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memtest.c b/mm/memtest.c
index f53ace709ccd8..d407373f225b4 100644
--- a/mm/memtest.c
+++ b/mm/memtest.c
@@ -46,10 +46,10 @@ static void __init memtest(u64 pattern, phys_addr_t start_phys, phys_addr_t size
 	last_bad = 0;
 
 	for (p = start; p < end; p++)
-		*p = pattern;
+		WRITE_ONCE(*p, pattern);
 
 	for (p = start; p < end; p++, start_phys_aligned += incr) {
-		if (*p == pattern)
+		if (READ_ONCE(*p) == pattern)
 			continue;
 		if (start_phys_aligned == last_bad + incr) {
 			last_bad += incr;
-- 
2.43.0



