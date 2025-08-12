Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55C4291C1F;
	Tue, 12 Aug 2025 18:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024478; cv=none; b=ZLWLh0hhfk+ivByrcq2GjCsdaxnF7VY5vp06dH+MFoHIJCSBhjThKxP6LH5yTlrJjrwx6K/a7l2b41Tg9W6/sFNzs15nvZ4Y34HqSwOB2CS4BJB2qh5Vh+bZgjujEuRzaOWUrGxR3//SQBYgB5heblQRLLzE9vJG1KxdrIZwunM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024478; c=relaxed/simple;
	bh=hAHZAvvvdZYr8CnCeZ56Rd+0G1JXqc4UMWyDsd9ZiNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5d/n0T3i+4ZDJqYAHVeC6CYs1YTUXpOkZ0xXcCDiEQ0OobXGkenZnCRAwdYWBCok11VpQ6DBkGomUh2iR96bGCfYjqY9KsjCXv9I5jC8r0zAdIETPUIYTsvmCgqJacTXc5IrXRBv4qM/WFkuCo8i8SQl9xzoUsuYvjbpyl3JB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opdL918t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opdL918t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27901C4CEF0;
	Tue, 12 Aug 2025 18:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024478;
	bh=hAHZAvvvdZYr8CnCeZ56Rd+0G1JXqc4UMWyDsd9ZiNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opdL918t5lorhnYhkNndMcMtYtqKV4LGl/IckncopjfiOKEXVUM5sdnWh3WkgzVDC
	 VjrxnDXQZuoQTn+dPfNyPAZI5KH79DTW0kBTx0xP/6hGMAxqEZzpRxVpmN2h7H/YVb
	 Avmq3AnIOyq7j66KkzfKVwoTLmYzEstBAYSB/iqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 352/627] leds: pca955x: Avoid potential overflow when filling default_label (take 2)
Date: Tue, 12 Aug 2025 19:30:47 +0200
Message-ID: <20250812173432.670505369@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 239afba8b9f3b0fcfd464d5ffeaed0ed4441c5a4 ]

GCC compiler v8.5.0 is not happy about printing
into a too short buffer (when build with `make W=1`):

  drivers/leds/leds-pca955x.c:696:5: note: 'snprintf' output between 2 and 11 bytes into a destination of size 8

Unfortunately this is a false positive from the old GCC versions,
but we may still improve the code by using '%hhu' format specifier
and reduce buffer size by 4 bytes.

Fixes: bd3d14932923 ("leds: pca955x: Avoid potential overflow when filling default_label")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506282159.TXfvorYl-lkp@intel.com/
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250630093906.1715800-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pca955x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-pca955x.c b/drivers/leds/leds-pca955x.c
index 42fe056b1c74..70d109246088 100644
--- a/drivers/leds/leds-pca955x.c
+++ b/drivers/leds/leds-pca955x.c
@@ -587,7 +587,7 @@ static int pca955x_probe(struct i2c_client *client)
 	struct pca955x_platform_data *pdata;
 	bool keep_psc0 = false;
 	bool set_default_label = false;
-	char default_label[8];
+	char default_label[4];
 	int bit, err, reg;
 
 	chip = i2c_get_match_data(client);
@@ -693,7 +693,7 @@ static int pca955x_probe(struct i2c_client *client)
 			}
 
 			if (set_default_label) {
-				snprintf(default_label, sizeof(default_label), "%u", i);
+				snprintf(default_label, sizeof(default_label), "%hhu", i);
 				init_data.default_label = default_label;
 			} else {
 				init_data.default_label = NULL;
-- 
2.39.5



