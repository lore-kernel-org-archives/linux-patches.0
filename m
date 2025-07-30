Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80802292B5C;
	Wed, 30 Jul 2025 09:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869093; cv=none; b=MsHRa41+8wBD/HvBcN7Hi/TDOfcrUqmJ4RMZc2d9kBfybdrJOqhY84pMw7KItwAUrAq36jS5xToxoDlfeUz9IwI6RTWl7K1z40AjoigpvUhR09/+HddZc0tDSTPNOkxgo/ERokUMPIVOVvo6YcD6nf0uZYEkinCw/goeb1njdYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869093; c=relaxed/simple;
	bh=ACb3iwt/KxWp59ZWLE2HGeL+PFZQKVTgUyx07pe0P/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjitPtmnnn2RmkN2fpkqd7t3/sVhCvWOPwXBFy2EprdGda5oILgJZgncBpBfv1ZMXoXCIEdSMXYBAhGOhpX9gY2vIFpZ5Q2dFOi3KSAMcr4t17Iu82WykFohQpeEfCaJSQsUDbkQzsTxhgAyl8WXSxfSOJRWr2t9/qT4uqHN9TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ti0i37nL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ti0i37nL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E03C4CEFF;
	Wed, 30 Jul 2025 09:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869093;
	bh=ACb3iwt/KxWp59ZWLE2HGeL+PFZQKVTgUyx07pe0P/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ti0i37nLt5roYzZcdtzoFH6sv3ucrUoizlPGV0TlbKaag/7jGFoq4kE4ZxE9nBYzy
	 eLZygXGWg3NGgCOgevbJiD1D3ydVH/AwC66P2aSCdFrSBYvS67gb0byLQsd6PKHXc8
	 tnq98u2QJcby/aKTr0QyVxC4qjd3JVPmNLJinuyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Burri <markus.burri@mt.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 08/92] iio: fix potential out-of-bound write
Date: Wed, 30 Jul 2025 11:35:16 +0200
Message-ID: <20250730093230.952332951@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Burri <markus.burri@mt.com>

[ Upstream commit 16285a0931869baa618b1f5d304e1e9d090470a8 ]

The buffer is set to 20 characters. If a caller write more characters,
count is truncated to the max available space in "simple_write_to_buffer".
To protect from OoB access, check that the input size fit into buffer and
add a zero terminator after copy to the end of the copied data.

Fixes: 6d5dd486c715 iio: core: make use of simple_write_to_buffer()
Signed-off-by: Markus Burri <markus.burri@mt.com>
Link: https://patch.msgid.link/20250508130612.82270-4-markus.burri@mt.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index b9f4113ae5fc3..ebf17ea5a5f93 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -410,12 +410,15 @@ static ssize_t iio_debugfs_write_reg(struct file *file,
 	char buf[80];
 	int ret;
 
+	if (count >= sizeof(buf))
+		return -EINVAL;
+
 	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, userbuf,
 				     count);
 	if (ret < 0)
 		return ret;
 
-	buf[count] = '\0';
+	buf[ret] = '\0';
 
 	ret = sscanf(buf, "%i %i", &reg, &val);
 
-- 
2.39.5



