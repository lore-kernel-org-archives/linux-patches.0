Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C426C3FF1AE;
	Sat, 12 Sep 2026 12:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217091; cv=none; b=hwWiCSuDBaPAaaj3m4NDu7odcVuEVDeDzif777/oq13CSKls8l5G/ScCAiwz3b3qQ1z7ilfeMjRvkQ7IbBU8bpWPcHTLC2aCO8R/8pCNAtudmvn/1b0BmjmOfpJFwLw3WpHpYF8Vdh9qW+raDN8KH//3NqiTgaCV8vVUCx91PXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217091; c=relaxed/simple;
	bh=wdyF/F8tCtDBDDFa6ThdBBjr+0NW6ZNCxaBf9Fi+Zac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0rUnpEWGADBqUHK4KTAl3XiebdFDpP2jNCP7L6BvQ5nOJfU3CiDepaY7QSAP8+/TyPwl73fOzgnHfj5l/2zaejvwU5zsqpQaP+m50f4/46hghUM424ClyuI3XLy1Mu25dNuteMyGla6SgrzdIY+mnaTDx6Sv0dzkCDUhQTpMUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1wx27kZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1wx27kZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4F91F000FF;
	Sat, 12 Sep 2026 12:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217090;
	bh=yNntigXL5rGCMyzSlVXQWdFBeaYqMTvrrmebri1G5X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1wx27kZvf+0N1qScYTLY04jc/pFd1MS3qdu6sg2bO584xc6rwneHxFrIECEn1WLe
	 NS33CAvsV1YhmkrwVkWhFYuVTt4b5LCClSnhSa21DhZhnPdjL/+FmEMV5pKNE0+sEx
	 v25q21NMzK2pdfvpAzy+xe43u3EYMqw3mgIfevQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0869/1376] perf intel-bts: Fix off-by-one in auxtrace_info minimum size check
Date: Sat, 12 Sep 2026 08:54:55 +0200
Message-ID: <20260912065626.927364048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit b9fb8225951ce27e62a2235a71f3ab01137aaec3 ]

Same pattern as the Intel PT fix: min_sz is set to
sizeof(u64) * INTEL_BTS_SNAPSHOT_MODE, but the code accesses
auxtrace_info->priv[INTEL_BTS_SNAPSHOT_MODE], which requires at least
INTEL_BTS_SNAPSHOT_MODE + 1 elements.

Use (INTEL_BTS_SNAPSHOT_MODE + 1) to ensure the highest accessed index
is within bounds.

Fixes: d0170af7004dce9c ("perf tools: Add Intel BTS support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-bts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/intel-bts.c b/tools/perf/util/intel-bts.c
index 27d9b5c9fec8b..056dde772eabf 100644
--- a/tools/perf/util/intel-bts.c
+++ b/tools/perf/util/intel-bts.c
@@ -829,7 +829,7 @@ int intel_bts_process_auxtrace_info(union perf_event *event,
 				    struct perf_session *session)
 {
 	struct perf_record_auxtrace_info *auxtrace_info = &event->auxtrace_info;
-	size_t min_sz = sizeof(u64) * INTEL_BTS_SNAPSHOT_MODE;
+	size_t min_sz = sizeof(u64) * (INTEL_BTS_SNAPSHOT_MODE + 1);
 	struct intel_bts *bts;
 	int err;
 
-- 
2.53.0



