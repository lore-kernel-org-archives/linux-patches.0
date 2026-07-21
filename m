Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FFF30EF9A;
	Tue, 21 Jul 2026 19:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662622; cv=none; b=OtPVW/mL6i52/tgE5crIo+4S3owokWA0eZqlCONam4aDeIZjmv4GCB5mJpY4dYmP/o42wkF/TU1NxT30hX63I+4URE+MEYauYkG3p0CLFyf+0BrBFN9QCrtyop4BCxdkLAe+hBg2hfzO3BU4/JmH1sXB+uHf7bn7H+rVvHRb5Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662622; c=relaxed/simple;
	bh=uyNd908MMC4dL227AIcPSuQudYlPw3jxxVym/CX4wVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AthqDAIf2MrxJ5w6N4cI8+p9RLiG4L9bQPgrqxPy94opepyxOvv2H2Fa/HX+2BbE9HJXwQZos3k11QPyJB1ySLhl5MJl31cVXvW555X9frvOKLICxXRff/XT6LBTNGnI2Mx/du49kGIyaVxdk8+yYTOMyCQH1KElbr6YRpD3mIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4ktRpOe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4ktRpOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CFA1F000E9;
	Tue, 21 Jul 2026 19:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662620;
	bh=F2pgButWyTAy6nH1+mv9MqZDYSRoZnI1IKhAZXVNGlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4ktRpOeLzHUaKfI+H8vOcB0JWExBgnKrOp/1Yzg3fPRnQXgPFKEYU/I18W6kW38P
	 sFfUJpPQDnDQGIbyxWtLY1mEeafdgB75wbXSnBuT1ar9LhmLeLyvA/IBlD6rojvUK5
	 reCWsKSBVmzvY2L+h0yO2JxhHcDYxUy/AvLKcd08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0515/1276] perf pmu: Fix pmu_id() heap underwrite on empty identifier file
Date: Tue, 21 Jul 2026 17:15:58 +0200
Message-ID: <20260721152457.636957506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 836455e6dbd34eb3d12eeab5e2d2b9a7f1512459 ]

pmu_id() calls filename__read_str() then strips the trailing newline
via str[len - 1] = 0.  If the PMU identifier file is empty,
filename__read_str() succeeds with len = 0.  len - 1 underflows
size_t to SIZE_MAX, writing a null byte before the heap allocation.

Add a len == 0 check before the newline stripping.

Fixes: 51d548471510843e ("perf pmu: Add pmu_id()")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 8885998c195308..bf9793a995316b 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -796,6 +796,12 @@ static char *pmu_id(const char *name)
 	if (filename__read_str(path, &str, &len) < 0)
 		return NULL;
 
+	/* empty identifier file — nothing useful */
+	if (len == 0) {
+		free(str);
+		return NULL;
+	}
+
 	str[len - 1] = 0; /* remove line feed */
 
 	return str;
-- 
2.53.0



