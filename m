Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4405222596;
	Mon,  2 Jun 2025 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873348; cv=none; b=fuQYWaTMHbrN4n7gBOwkMjIqs3lAzMZ50BjhDwaQIOlDd1hCE2ncJVLZC5LGWsZ7pVOP11hHAjjcGJK7wwnkxWaglPNsA+93UEIjUgxaKn5AKDynhQeFgOfkpvbMEtLoK5u7aHaPf+B5vx8wecvVZT4PHw7XpID0XVzZujCkk9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873348; c=relaxed/simple;
	bh=OuNx40xk6IOFFBFr/k0X5i95gnBWnPbWaWcHdrQwqGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuzeJSyz/9JgplINtcD7fNbjbyUrdIwkfYYJ49cnSwmOdT80NtkDOqoVxO/iBBFHO/iufMVFU1T9y8LjqIb0oIxK3Yikt3udu1gmbDjQGzCjTuUW0qwqdlthY5/QmZUM4rkhWcD+/4qkwcrOa1BGrVSX6XYpDabFcPXHgp0o+mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CScismlo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CScismlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69E6C4CEEB;
	Mon,  2 Jun 2025 14:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873348;
	bh=OuNx40xk6IOFFBFr/k0X5i95gnBWnPbWaWcHdrQwqGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CScismlovt6ezizwdbZkVQHnmSQSEdqZ8PH2TSPOy91UGrkTKTf7Vpo/rJRyxD2jv
	 7HraCP16AcIra+n03TNVo+3mUcbjZsw3JIWPK4OHb8xaaDftdWMcsDZmIdUw6scneg
	 GIGcwbIFZSAhDwUE6Trtlz0AazC0doIyelIhQzrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/444] dlm: make tcp still work in multi-link env
Date: Mon,  2 Jun 2025 15:42:27 +0200
Message-ID: <20250602134344.270451672@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0618af36f5506..3c9ab6461579c 100644
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



