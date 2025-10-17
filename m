Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B37A289811;
	Fri, 17 Oct 2025 15:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714330; cv=none; b=K4LLiW4LZNBkbOM4Ktc/35shx8ysB2Th0hWSUfpfRciGqzFQWQW7u3fI89RhAYW9pkRlKqlPM1c98yG/aoq4olgnGoTA7kb32YCfwaa4raEjHPZzuTujzGk0xffMT32iA8igrVUvE+cLB2DafJ5B1ZwTUqYxEAH8xrdfP9ZA4uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714330; c=relaxed/simple;
	bh=e1n7RHUGjCxsmTD+j7ySOQQSJgJfzww+VeaU0ySrng0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXYVXA7VACjGJfH3rT3N0fHIegpA5S79IAZSKNT3MycuBieGDayeiPrpr+QyylFdI0WOizG7LevzzpgHfZ/jU67yHPntW8RAt2bBqTiIf9hd4g0QhBm6BE7Gd6qONZBBRtI07XCdlVffewPEl6HyOXIFeq7LXZrm0u9AomsSjuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvTVYyu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvTVYyu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03364C4CEE7;
	Fri, 17 Oct 2025 15:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714330;
	bh=e1n7RHUGjCxsmTD+j7ySOQQSJgJfzww+VeaU0ySrng0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvTVYyu7SljubqSFQbUYQdwwvwyNnlPnSk9ZlWK9zJAH6YRIrab3jNkOD4rms3I72
	 LsU1Pop57Eki5KOFpc7pwlc66vAWd/F+4FRu7QbBPHw1kRZjbs6eurW+NQfa0dNHo7
	 1aVyYKZv51X1vElnwjDpXB3a5SFoZwdjbfQ+z3tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 108/277] media: pci: mg4b: fix uninitialized iio scan data
Date: Fri, 17 Oct 2025 16:51:55 +0200
Message-ID: <20251017145151.071963563@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: David Lechner <dlechner@baylibre.com>

commit c0d3f6969bb4d72476cfe7ea9263831f1c283704 upstream.

Fix potential leak of uninitialized stack data to userspace by ensuring
that the `scan` structure is zeroed before use.

Fixes: 0ab13674a9bd ("media: pci: mgb4: Added Digiteq Automotive MGB4 driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/mgb4/mgb4_trigger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/mgb4/mgb4_trigger.c
+++ b/drivers/media/pci/mgb4/mgb4_trigger.c
@@ -91,7 +91,7 @@ static irqreturn_t trigger_handler(int i
 	struct {
 		u32 data;
 		s64 ts __aligned(8);
-	} scan;
+	} scan = { };
 
 	scan.data = mgb4_read_reg(&st->mgbdev->video, 0xA0);
 	mgb4_write_reg(&st->mgbdev->video, 0xA0, scan.data);


