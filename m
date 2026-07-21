Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD31E402444;
	Tue, 21 Jul 2026 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654458; cv=none; b=hX5cUkJmBhsY12EokgP22jMoLY5wp/DFBTnnZNBfRxelJhMWfpX/Y0CUTVScaXk8/xQ0tPvg24T9/XDQYYb6rV1T7Rt8Eum935Vf7upccjRBDBoOGcHqvP1afgzOMqWHBGtDc7QT1026AkbW9QmlBUxLbOF6OpmA2lF8rb3suT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654458; c=relaxed/simple;
	bh=LKmoIJ855/QfqYsL47OTIpmxLJyqREJjIpN9iK/L8/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2JU3TsVTscSyjzzsOFZef/R5VMEW8MO38Vf+za1PebtNhHRkQDX5UssFsAuXXhlKfM9kwcGL1t5qiQTOiy6MlfdpAI9uQgZJs/V0g8IHB7CNfL9HjKISZgVCteYESO+krIUKvWPVHhisfa0TqaTlGDnLYxZ9g11D3APeA133EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTMpwX5K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTMpwX5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C3D1F000E9;
	Tue, 21 Jul 2026 17:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654457;
	bh=F+PywR+Ib7fo4uFofcZloKcXfTHn7q6iQEtSRFYTSac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTMpwX5KMPrqi1FIwXFL/RkNx/iNX4DdJlmO1WYvKieZ5CIWs4yb401XpmxUlUXjC
	 jkzPO2qeJJA3kMnYlydvo9cQOu2OBGpW1TdhIl2nJ5GWIYnV3/A+sajd+f1ywTmtQp
	 GHRqq/5pMiU1QmgH0O+9YQuPtf0IUqYfSBCp3o2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 7.1 1659/2077] nvdimm/btt: Free arena sub-allocations on discover_arenas() error path
Date: Tue, 21 Jul 2026 17:22:12 +0200
Message-ID: <20260721152631.875834857@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 13fe4cd9ddd0aacb7777812328be525a11ea3fea upstream.

Memory allocated by btt_freelist_init(), btt_rtt_init(), and
btt_maplocks_init() is not freed on some discover_arenas() error
paths. This leaks memory when arena discovery fails.

Add the missing kfree() calls to release the allocations before
returning an error.

[ as: commit message and log edits ]

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260519-nvdimmleaks-v1-1-592300fb7a43@cse.iitm.ac.in
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/btt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -919,6 +919,9 @@ static int discover_arenas(struct btt *b
 	return ret;
 
  out:
+	kfree(arena->freelist);
+	kfree(arena->rtt);
+	kfree(arena->map_locks);
 	kfree(arena);
 	free_arenas(btt);
 	return ret;


