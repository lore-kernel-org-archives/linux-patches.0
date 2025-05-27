Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AAA1CD0C;
	Tue, 27 May 2025 17:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366825; cv=none; b=mMRrS85SRio89HE0aTZF7XHZaXcygGjPxSxwim840OjTzgGLd8zbKP5B8nO368ULR/x4FiYwglV8NmIlIk7yL+CmOlVkPcYbfKx1zPb5Grdn0a5qcBQGO50oK/RwIiQZ4D9okgbLgEWgfSSiJsrFeuZWJjmHRvzJn3S9VDaHuF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366825; c=relaxed/simple;
	bh=W7DwfPYKXpL/UN6tzNPBTPItfqCabtZlH7fEOM8dF3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfd7YjHMNZB9hnmz/kzYeE8RBgONqmfI56zALUqiATYnHn8FQ9hyGYB3sfj2TEJjdWE01eWbMcyF8QrtYPL79iDjdwN59uZbUulmZQdQiLugQk9izkcZ+Rdf76tFddnph0ap3el55vSni1Q7uQSGWp793uRosJeuq423GRhnvF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ag66k+ko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ag66k+ko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C33BC4CEE9;
	Tue, 27 May 2025 17:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366824;
	bh=W7DwfPYKXpL/UN6tzNPBTPItfqCabtZlH7fEOM8dF3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ag66k+kotF0HsIjgsINU/i0OxD0zbvurPeOzqf/InC8cOJe/tYhE2xCi5IFwzkREH
	 /wBJnVpKW4HZD2HeggewphPog89hnoadd8To6r2azuGOyzSUUl/n4yQgQZcz75Hgc0
	 kKF2IGh7VMXZaEyOdk9xRchz3yWl1/Hzsuk5hz3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 147/783] dlm: make tcp still work in multi-link env
Date: Tue, 27 May 2025 18:19:04 +0200
Message-ID: <20250527162519.145620288@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Heming Zhao <heming.zhao@suse.com>

[ Upstream commit 03d2b62208a336a3bb984b9465ef6d89a046ea22 ]

This patch bypasses multi-link errors in TCP mode, allowing dlm
to operate on the first tcp link.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index d28141829c051..70abd4da17a63 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1826,8 +1826,8 @@ static int dlm_tcp_listen_validate(void)
 {
 	/* We don't support multi-homed hosts */
 	if (dlm_local_count > 1) {
-		log_print("TCP protocol can't handle multi-homed hosts, try SCTP");
-		return -EINVAL;
+		log_print("Detect multi-homed hosts but use only the first IP address.");
+		log_print("Try SCTP, if you want to enable multi-link.");
 	}
 
 	return 0;
-- 
2.39.5



