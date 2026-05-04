Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A373DA7D7;
	Mon,  4 May 2026 13:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902997; cv=none; b=pqcDN3F83rfIcMN1aX1MnPNY5s7VBYjxCT1HxlIV7YKrY9LE7EcN86aeMKM6OpdodsKehxFgvkiNkk+WBysw/ejl/PYNtSrdAP12Z4wAQMg4gRZUKi0nLGKxeY68kTIYzSNmIF9RKWr2XQBY+ozwgh9UILDZfANXiu+3Kb3uJoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902997; c=relaxed/simple;
	bh=SSGKDtHte0qc3l00Pes7+tzdtQDdz05UO1auhbaYsyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTdZRjTtdWhW3CUd9/Rgie6jnw/LcW/4LLSqKXSJAcMRlsXzH3WIn3M/JxtLQd9tJdYQCMhUw1qoPBFvj8xKGY5ubveuDYJv8Q+MPZdbO+HCDp0z4XiJa2m/i+TK8jqkmWkZZbh43iwavd6AjbqHgG9Yzjym6t8An05fhK0hhfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHT05pfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHT05pfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF644C2BCB8;
	Mon,  4 May 2026 13:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902997;
	bh=SSGKDtHte0qc3l00Pes7+tzdtQDdz05UO1auhbaYsyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHT05pfpe96p2ewpHVzXfYOzI8fhTGTdcLa5fTuOGATPssCIAtGo29CojirjXPDgz
	 RUKhx2YlfUcAvPM+/Kgc+UdkAFkk4GoHeOUH69S7ArgL+MUVJMZuHKEOo9lnBacVPZ
	 KvbIwF7n8UHMg2wJiHy0eLv4tiRoWhtB3nXrfeC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.0 031/307] Input: edt-ft5x06 - fix use-after-free in debugfs teardown
Date: Mon,  4 May 2026 15:48:36 +0200
Message-ID: <20260504135144.002343325@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit f5f9e07060519e2287e99019a6de1eb3ebb65c37 upstream.

The commit 68743c500c6e ("Input: edt-ft5x06 - use per-client debugfs
directory") removed the manual debugfs teardown, relying on the I2C core
to handle it. However, this creates a window where debugfs files are
still accessible after edt_ft5x06_ts_teardown_debugfs() frees
tsdata->raw_buffer.

To prevent a use-after-free, protect the freeing of raw_buffer with the
device mutex and set raw_buffer to NULL. The debugfs read function
already checks if raw_buffer is NULL under the same mutex, so this
safely avoids the use-after-free.

Fixes: 68743c500c6e ("Input: edt-ft5x06 - use per-client debugfs directory")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/adnJicDh-bTUaWXP@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/edt-ft5x06.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -829,7 +829,10 @@ static void edt_ft5x06_ts_prepare_debugf
 
 static void edt_ft5x06_ts_teardown_debugfs(struct edt_ft5x06_ts_data *tsdata)
 {
+	guard(mutex)(&tsdata->mutex);
+
 	kfree(tsdata->raw_buffer);
+	tsdata->raw_buffer = NULL;
 }
 
 #else


