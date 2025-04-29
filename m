Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDBE219A63;
	Tue, 29 Apr 2025 18:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950769; cv=none; b=Rcw55NrwK4K6Y9avloKXw2E9d0YJ5hv3VVnt9P7wyAblOg8L7voKMxQvedwQ4xG5VxrdnFX5nbjoGN+ojjG9+dleUHAYUqVtcLt1GVZg/tE5FCVfvmGNAZRVKX/E98PzWPNmop4ZmGitg4G741FT5lFAkV1EHppd1R/qhQ0uNcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950769; c=relaxed/simple;
	bh=FHVyiwnvw6pF3r5JwB5EkK5uzjw3EqIWw37kX5fTifQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeZOG1jSi6+euGGtaq6IGjHjaoeZBuYi+kWYZwQaaSApdBsC1n0Hs5/AZHsc0OJACwUWYLKey6n6tEaYAZiG4x5pUOENxUwcvv74aXMTCRLRkPwmRj4d1D1MH8YqEk6mlqoQJALa9j6Yhvbv+oiwNbb1o2I2iTu7V0xjNAXVQDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FO2483Kj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FO2483Kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1951C4CEE3;
	Tue, 29 Apr 2025 18:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950769;
	bh=FHVyiwnvw6pF3r5JwB5EkK5uzjw3EqIWw37kX5fTifQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FO2483KjhqP1QuI+0fe3zR7C5FDrh05W3LHqEZ3yGyjrRJ/NGN18uZ1K04WkzcIwA
	 W0Lfpp+i2GFEhbHTbZ3B5YvVbn+d5IW6ZrlB1mIAX3qxnzs4jTM/XOqqBjwn/6lTZ9
	 8e9GFcvuT6goo3jE2xVqIwkN5nxT9ImhBlOejGjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/204] nvme: requeue namespace scan on missed AENs
Date: Tue, 29 Apr 2025 18:44:07 +0200
Message-ID: <20250429161105.918972962@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 9546ad1a9bda7362492114f5866b95b0ac4a100e ]

Scanning for namespaces can take some time, so if the target is
reconfigured while the scan is running we may miss a Attached Namespace
Attribute Changed AEN.

Check if the NVME_AER_NOTICE_NS_CHANGED bit is set once the scan has
finished, and requeue scanning to pick up any missed change.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f00665ad0c11a..e36c6fcab1eed 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3972,6 +3972,10 @@ static void nvme_scan_work(struct work_struct *work)
 			nvme_scan_ns_sequential(ctrl);
 	}
 	mutex_unlock(&ctrl->scan_lock);
+
+	/* Requeue if we have missed AENs */
+	if (test_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events))
+		nvme_queue_scan(ctrl);
 }
 
 /*
-- 
2.39.5



