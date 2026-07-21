Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215803644B3;
	Tue, 21 Jul 2026 19:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663646; cv=none; b=LAW9wSWNA3gT7aKA/IHwmEsUZv9I73WJ/wzZRTMR6Bdei+09YIW5w3fE+Zr3Pact9764zcasXJip4qlAq66/mSBbaIySMoT2AFUuaPq0UPcMvDXy9QWGZOK4HiXg7UbHiZKTTyv3MCCzQzNZT/YmFIo7SOU5W8Bb326meEqFtic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663646; c=relaxed/simple;
	bh=ixKSQWbI4szD9hbRKrL5SKQVYAxxoV5J+wLkLtK7j7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baHmT5oYEGjoaWKwiMni44qlGN5XmbKZ+BpEDFQDX7nqBQoLqRXk3QOEoS7jCMP32CHk78MtyXFN8H5IAA/edLXN5BPcL0WeURT6XZaiJEE35f+JJSmCyxbAjVonahiBK49NWPC2fctlgR2NPFZy6a1MqHV4sqjEBJ9Lt7lLna8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxdzDyHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxdzDyHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861851F00A3A;
	Tue, 21 Jul 2026 19:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663645;
	bh=ofmz5yzGatTBwbkmyaiiACmHKdn+/QxizWq8mHFjF5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FxdzDyHddNwN1vqu5d5n9ummKix4sApmiiNstIlusZXJNg6oIqZkb3jM0m6rbWQFp
	 nDYbkKWmr4qi8vRLnF9BK8nm1pupDsa4axPzEBTO8Uvq6Y0BKF1vvLWHz7mBdTms+6
	 RPKcGIm5ELtWVdR5fnsLQfYe+WTchL4VwC+3wr6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 6.12 0901/1276] nvdimm/btt: Free arena sub-allocations on discover_arenas() error path
Date: Tue, 21 Jul 2026 17:22:24 +0200
Message-ID: <20260721152506.203447543@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -921,6 +921,9 @@ static int discover_arenas(struct btt *b
 	return ret;
 
  out:
+	kfree(arena->freelist);
+	kfree(arena->rtt);
+	kfree(arena->map_locks);
 	kfree(arena);
 	free_arenas(btt);
 	return ret;


