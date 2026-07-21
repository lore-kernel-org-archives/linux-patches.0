Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6E846EC9B;
	Tue, 21 Jul 2026 19:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660704; cv=none; b=rC2oe0hvoVNURuAbYNyplSsQkEWg7JCCHgJSwu1USCPkFa/2bu5YXszDJhu+3n3oQtTSGZ8KWnVyjYCE/ZPRPjnTehsTkRMwet5WO3qQSOU4QE/vcoL2MDHax+URqeOwFfWM4SquVTWnRz+Zl2Elg7cVatYjCmaMSsJxNw3O6P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660704; c=relaxed/simple;
	bh=E0/rDFUSdf2wPy/PJTF+TLKIn9tWE0ZaoXKwU7WaxRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3haGLFwIPYQyn0RPN0TGF8hc4CmPdQoE5kgyE0CXp7PXfbufSQ+6f3WUeABV11r1d+HOuD9Yyt+5jAOKQHLAKvYeSm/KYdIrumtY11IJBPuHfNwZIVS2zMzI1WBleIvD0d/FlcB3iUE7dVxkZ0b4WrJcJp5nBkc5hrX/TlAZgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aq3TdQwJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aq3TdQwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7021F000E9;
	Tue, 21 Jul 2026 19:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660703;
	bh=WXBPMPSRWE5YOvI822WJZlOr1A/HkwaznQGAe0WnPCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aq3TdQwJVB4hyS9EaBO2Rg3kjKMsbb1tv8JvzOHhtc41GhlENmzrbG0crsIVcDPmf
	 Q8NqqzbHECdqCLdUP5ilMJkqOu+HkapRzYsVSwV/GPXjxzmYOEwf4l8UCUc3jhvL/j
	 BNsBw/zwYSKuc+2txSPnyx+uuWSxLEuXeBTRUqZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1080/2077] perf c2c: Free format list entries when releasing c2c hist entries
Date: Tue, 21 Jul 2026 17:12:33 +0200
Message-ID: <20260721152618.295161634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 4a7500d772fe59653053db22ca83c9e2232b22e1 ]

c2c_hists__init() calls hpp_list__parse() which allocates and registers
format entries on hists->list.  When c2c_he_free() destroys a c2c hist
entry, it deletes the histogram entries and frees the hists container but
never unregisters the format list entries, leaking them.

Call perf_hpp__reset_output_field() before freeing the hists to properly
unregister and free all format entries.

Fixes: f485e33c4543ac31 ("perf c2c report: Add cacheline hists processing")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 74ded7d238c800..17161278ce94cd 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -181,6 +181,7 @@ static void c2c_he_free(void *he)
 	c2c_he = container_of(he, struct c2c_hist_entry, he);
 	if (c2c_he->hists) {
 		hists__delete_entries(&c2c_he->hists->hists);
+		perf_hpp__reset_output_field(&c2c_he->hists->list);
 		zfree(&c2c_he->hists);
 	}
 
-- 
2.53.0



