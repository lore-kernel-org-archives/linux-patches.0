Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AFA268C5D;
	Tue,  8 Apr 2025 11:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111738; cv=none; b=MWCbaYhfAvD+JDuJt9QUXX/kYWwiRRog2ZOxShNFt1NqOXmGb/NpXCPWVizZRx2jhO1C6/kavuHfwjR1t1xOVG+FJFEE0Af8PLiN3r18meM0qNVCBUNVBFSUXX1N/Mh/yFugSnCmwe7wZGGjIburkz5GrJwFXh8jFCrhqo1DerE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111738; c=relaxed/simple;
	bh=yE404GQq97ciw6VKnVhU2Efmd+SOitEjS1nm0JPQZRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iczuiFCYY49q9K6ql+FE2giH0wlrWfHW/nanR41BMSzoUq23Q4ijZFMHKnm4Qr1+xnVLttWYcESYDrJj3gbOiN8Tv/pb2OGCNvEyfsp9n9OEEoD8M/+RVGdPpzWoTL0u782Qgx6hjEVTC/b1XrNuosTMn2vyyI0GsDAm5p0pA6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yu+4p3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yu+4p3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD817C4CEE7;
	Tue,  8 Apr 2025 11:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111738;
	bh=yE404GQq97ciw6VKnVhU2Efmd+SOitEjS1nm0JPQZRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yu+4p3ZtUC4CslLTH+qJo73JEDSWxXMdKl78Oor0BYqs82gaf5K9ZgDbXf+JfPPS
	 hVOvUqAPnsYKE2tsJzrch2KQL/cHUym6sdml4iK7vSoRbSCUbM15ZhajuL9e7xWmj6
	 J6JuLCcpj4NmzJdL5LxrQk+MJ++i7SCcxGyODUqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Likhitha Korrapati <likhitha@linux.ibm.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 540/731] perf tools: Fix is_compat_mode build break in ppc64
Date: Tue,  8 Apr 2025 12:47:17 +0200
Message-ID: <20250408104926.837620002@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Likhitha Korrapati <likhitha@linux.ibm.com>

[ Upstream commit 7e442be7015af524d2b5fb84f0ff04a44501542b ]

Commit 54f9aa1092457 ("tools/perf/powerpc/util: Add support to
handle compatible mode PVR for perf json events") introduced
to select proper JSON events in case of compat mode using
auxiliary vector. But this caused a compilation error in ppc64
Big Endian.

arch/powerpc/util/header.c: In function 'is_compat_mode':
arch/powerpc/util/header.c:20:21: error: cast to pointer from
integer of different size [-Werror=int-to-pointer-cast]
   20 |         if (!strcmp((char *)platform, (char *)base_platform))
      |                     ^
arch/powerpc/util/header.c:20:39: error: cast to pointer from
integer of different size [-Werror=int-to-pointer-cast]
   20 |         if (!strcmp((char *)platform, (char *)base_platform))
      |

Commit saved the getauxval(AT_BASE_PLATFORM) and getauxval(AT_PLATFORM)
return values in u64 which causes the compilation error.

Patch fixes this issue by changing u64 to "unsigned long".

Fixes: 54f9aa1092457 ("tools/perf/powerpc/util: Add support to handle compatible mode PVR for perf json events")
Signed-off-by: Likhitha Korrapati <likhitha@linux.ibm.com>
Reviewed-by: Athira Rajeev <atrajeev@linux.ibm.com>
Link: https://lore.kernel.org/r/20250321100726.699956-1-likhitha@linux.ibm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/powerpc/util/header.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
index c7df534dbf8f8..0be74f048f964 100644
--- a/tools/perf/arch/powerpc/util/header.c
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -14,8 +14,8 @@
 
 static bool is_compat_mode(void)
 {
-	u64 base_platform = getauxval(AT_BASE_PLATFORM);
-	u64 platform = getauxval(AT_PLATFORM);
+	unsigned long base_platform = getauxval(AT_BASE_PLATFORM);
+	unsigned long platform = getauxval(AT_PLATFORM);
 
 	if (!strcmp((char *)platform, (char *)base_platform))
 		return false;
-- 
2.39.5



