Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1CC1C8605;
	Mon,  2 Jun 2025 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876742; cv=none; b=mVYKAjc5zHmTG8RcOV/QyfVw6sqFdBV0EgOAGXXerXHeLfcFCV9LXADvLOPmTxetmoiou0CH5oUZ2gvUYcUgG67TpCZ206KPv9gD6GmdLQdVJvXByFSvLCLztpYHOb0ykAcpk0vr6joY8xBHXbNMFuBtPF7//hAKMhiuTgltbRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876742; c=relaxed/simple;
	bh=QvwM22mt262tzKThy73afqUyEnzul4v0XAxAbFp6LF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlKPnxoBKhY2KL4fepKYeh529C28kvb74EQmIHC5znsqmFEJ8en8KzEmZjrLToBrySEAhGMkiiJvCgUoPq03H7RnPRJyvhHzNwDmlzwn/ainApd9kQQsWQJt75fGm/M9rjEaldu/YyFFzGeeVh78Qbh/zYnwvhyYk1Pz18SKlS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDfbgVQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDfbgVQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DE2C4CEEB;
	Mon,  2 Jun 2025 15:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876742;
	bh=QvwM22mt262tzKThy73afqUyEnzul4v0XAxAbFp6LF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDfbgVQ8XR6F5egFEbfmObhNPsoPsVcqxTtiMJwoFqpsBwBY0lk/hqEdqmUdB9aa3
	 1LxS0uiGk3YwH0S9CSJThcg3DLwF5NldbDLcWNM+Kku6BZWEYfethRqwY3nAKNhQho
	 Y9zpxr/UM1U+QftBj3qJGnTDfObWPIlRr4qYpIZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/325] dlm: make tcp still work in multi-link env
Date: Mon,  2 Jun 2025 15:45:35 +0200
Message-ID: <20250602134322.154951964@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2c797eb519da9..51a641822d6c4 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1863,8 +1863,8 @@ static int dlm_tcp_listen_validate(void)
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



