Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98B74F93A4;
	Tue, 13 Oct 2026 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895195; cv=none; b=nct3C6kXjU3pbaGtdWaY1/n2RPhNL2+fhsVeUf5s9uYt2MpgVrtDHSRsmVYD2QPT4wilVtaJpMq8q5buERKsjaI9FtKJMvmvlC7uZJ0b8ofKoH8ItpuWkkSLEH+WwUfRqYOz1gE7oGeAUl+20uzeEjsFFd3KM8kWR0hsycck5Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895195; c=relaxed/simple;
	bh=i77UcrsciVvOpjsRWg7ixILTcn/qYWGpjU/+n+BkO6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8n0CMBObiC1+rMxQ4af8Bi4ofZKd+RBSdjkpXlkmKLk9n9bDj5YToR1/gs+8G/73R2JppS8x8c/m/BY0orMJpHDu1b5aKeVXqKH/ksIbNB7PNpNw0Tk0Kh0u9ujHQ1DjlaWBRxukV6vtHg1okJUbMeZRWXQxb+pDLi/uWx51NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzKuw872; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzKuw872"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0C01F000FF;
	Tue, 13 Oct 2026 12:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895194;
	bh=X2SeMZ71jxx9eaUlGU6kIhKNI7f1ksJSNhiRs8+DWzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzKuw872oB2/vzKSU/Q7U59SBv6Hj3OZ7ruSQ8kebOyWnhQ1013bxJkq/ZarS2A7+
	 UhLyM9CgedNvAO5Bk/hTz/Q7kKvWSqFIe8RKua0rgKd/A809HQ/KkSmjD+BweLhL5m
	 aGA4mJR78af882kTzWQSbroJEW7gXPv+a8VyA2hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 194/497] nvme-multipath: fix underflow in ANA log bounds checks
Date: Tue, 13 Oct 2026 13:36:01 +0200
Message-ID: <20261013112912.497164264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit 63fa2d9c9c37020bd2703fe2a6a38027b5abeb15 upstream.

The number of ANA groups advertised through Identify Controller sizes the
ANA log buffer. The ANA log header and group descriptors independently
supply the number of groups and namespace IDs to parse.

Both bounds checks subtract an untrusted object size from ana_log_size
before comparing the current offset. If the object is larger than the
buffer, the size_t subtraction underflows and lets the parser read beyond
ana_log_buf.

Check the current offset before the first subtraction and compare each
object size with the remaining buffer instead. This rejects inconsistent
ANA data before dereferencing a truncated group descriptor or walking an
oversized namespace ID array.

Fixes: 0d0b660f214d ("nvme: add ANA support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/multipath.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -726,7 +726,8 @@ static int nvme_parse_ana_log(struct nvm
 		u32 nr_nsids;
 		size_t nsid_buf_size;
 
-		if (WARN_ON_ONCE(offset > ctrl->ana_log_size - sizeof(*desc)))
+		if (WARN_ON_ONCE(offset > ctrl->ana_log_size ||
+				 sizeof(*desc) > ctrl->ana_log_size - offset))
 			return -EINVAL;
 
 		nr_nsids = le32_to_cpu(desc->nnsids);
@@ -742,7 +743,7 @@ static int nvme_parse_ana_log(struct nvm
 			return -EINVAL;
 
 		offset += sizeof(*desc);
-		if (WARN_ON_ONCE(offset > ctrl->ana_log_size - nsid_buf_size))
+		if (WARN_ON_ONCE(nsid_buf_size > ctrl->ana_log_size - offset))
 			return -EINVAL;
 
 		error = cb(ctrl, desc, data);


