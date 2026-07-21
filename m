Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4643B42EF;
	Tue, 21 Jul 2026 20:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666537; cv=none; b=T2S45Wh7PA7+/bRZ6JcCTkTEcsJ39JhPLoxfEp4acIUfHqmHbUyOO+qY5o4OoByKLtXRWvxjKpZkiQL2HTcZ+ZHc0+ZGBEdv45Z8qloULswwyj7FemvINsVWlhaehpxi+mdP+YXAeBg2JEfz+o2F0suup4gEKUjIw8ZhlnAty/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666537; c=relaxed/simple;
	bh=nCJCXOuMr7bQhA/5m5kusVpKdr7dr6O6e/BzN1BVTQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSCFHLRFDn4l5/zCXQJsyliw4aggxKS9VSVAaE2uL7bxkujdKGBOtEl6XH9lFRUBCzMSr3IiSNG0j6RKriHrDfFHDyB32GueA1pmajC9zVI8jIk0f6xqewHNoKTecifWe1UH6kg6iulJs6uXzb7nNWbO9TNQo+1qlNiP84/2sdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFFC6k2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFFC6k2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5142E1F00A3A;
	Tue, 21 Jul 2026 20:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666535;
	bh=eyCrrrDFtnM+ha7XsfJne+NIS/P3v4KOH6cPwTXCi9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFFC6k2dVAKL/CExxV8flAGCzkHV/pVoJY3RCCl5lnyh1P9iY8bv7tOkZuqseT4gA
	 qSTzg8dpIlrk3bdeGNqcSOn/Mu2Bcu3YetvtWTF+434ux6HZ7DnTbbEAUG6eAJppPu
	 dEghOr7FX1Hf2LbyzWNyGWttiVLNoAUMA5wz+eqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@arm.com>,
	Leo Yan <leo.yan@linaro.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0719/1266] perf cs-etm: Require full global header in auxtrace_info size check
Date: Tue, 21 Jul 2026 17:19:16 +0200
Message-ID: <20260721152457.956681454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 78d8ba680126f3545e8d0fba667e12d79fd4353b ]

cs_etm__process_auxtrace_info() checks that header.size covers
event_header_size + INFO_HEADER_SIZE (16 bytes total), but then
accesses ptr[CS_PMU_TYPE_CPUS] at offset 24 from the start of the
event.  A crafted 16-byte auxtrace_info event passes the size check
but reads out-of-bounds.

Include CS_ETM_HEADER_SIZE in the minimum size check so that the
global header entries (version, pmu_type_cpus, snapshot) are
guaranteed to fit within the event.

Fixes: 55c1de9973d66516 ("perf cs-etm: Print auxtrace info even if OpenCSD isn't linked")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@arm.com>
Cc: Leo Yan <leo.yan@linaro.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm-base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/cs-etm-base.c b/tools/perf/util/cs-etm-base.c
index 4abe416e3febd2..aebef71d3a0a1d 100644
--- a/tools/perf/util/cs-etm-base.c
+++ b/tools/perf/util/cs-etm-base.c
@@ -170,7 +170,9 @@ int cs_etm__process_auxtrace_info(union perf_event *event,
 	u64 *ptr = NULL;
 	u64 hdr_version;
 
-	if (auxtrace_info->header.size < (event_header_size + INFO_HEADER_SIZE))
+	/* Ensure priv[] is large enough for the global header entries */
+	if (auxtrace_info->header.size < (event_header_size + INFO_HEADER_SIZE +
+					  CS_ETM_HEADER_SIZE))
 		return -EINVAL;
 
 	/* First the global part */
-- 
2.53.0



