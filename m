Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3273B53FD2B;
	Wed,  9 Sep 2026 13:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962054; cv=none; b=eMORorPpxiRnKt0T36y1ejCtzL5dGc4vUUJm5NUkY2DxPqbguI0pSoP2EJqMopYKi105WYgZ9vfaRdWlbDtM+vyAPIJicJcM0mxhVE/atumQHaRSf5KS9V/ny86P9E9AVE8Fj38mVrr/N5kKnsOiryVGRDU1N9xMvdqx8MLYsLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962054; c=relaxed/simple;
	bh=nPVLTsSyOX4OMGiLDY1tzeJfX/ixngMNz5UYvcvHqjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TX+wbJPAxZwUtebYiaBB1nv/FcW5gORpmWrXn6/rthL0Ww79VR4KFIty4nnbGdVh4JjLClgObfgdaWXOAaErQxRwKx+jG4BPTYpaAzkZmVFk26ESruIR6NLGlkdwWcCTBV+s4KOVQWl5ocL2SjDtSdZCOpElzEnVJdIuW0RnDx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sg2yKsp4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sg2yKsp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0521F00A3A;
	Wed,  9 Sep 2026 13:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962053;
	bh=LkbNmpAKEHnXTgGVXEJJ/tTubFPC364SSKQXotJX1Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sg2yKsp4HhSSxnTAKL2lucsRozfwwcJoIezXg+KQdPr6BykwX+ZQpmIb+BpNMJBP1
	 Ua2gs/qnZWafrzP/SIYndR1+s1NHap42AaP6r5fJPSMm09sSx6vxN4UmYckXIV7A65
	 SQasjyK0wi0ahpByMYLYrxa3TEcZu2SpZI8gF6tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xu Rao <raoxu@uniontech.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 156/556] nvme-fabrics: fix DHCHAP secret leak on parse failure
Date: Wed,  9 Sep 2026 15:37:16 +0200
Message-ID: <20260909134235.918328756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit afdee49a1b88ed9bb44e2b30e855297c169bcc53 upstream.

nvmf_parse_options() duplicates dhchap_secret and dhchap_ctrl_secret
with match_strdup() before validating the DHHC-1: representation.

If validation fails, the parser returns -EINVAL before the temporary
string in p is assigned to opts->dhchap_secret or
opts->dhchap_ctrl_secret. nvmf_create_ctrl() subsequently frees opts,
but nvmf_free_options() cannot release the unassigned temporary string.
Each rejected option therefore leaks one allocation.

This is easy to miss because valid secrets transfer ownership to opts
and are freed normally, while the malformed-secret path still returns
the expected -EINVAL to userspace.

With CONFIG_NVME_HOST_AUTH enabled, the leak is reachable before the
required-option checks and transport lookup. No NVMe-oF target or
working transport connection is required; for example, repeatedly
writing

	dhchap_secret=BAD

or

	dhchap_ctrl_secret=BAD

to /dev/nvme-fabrics deterministically takes the leaking parse path.

Free the temporary string before leaving both validation error paths.
Use kfree_sensitive() because the copied option may contain secret
material even when its representation is rejected, matching the
sensitive cleanup used for stored DHCHAP secrets.

Fixes: f50fff73d620 ("nvme: implement In-Band authentication")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fabrics.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1028,6 +1028,7 @@ static int nvmf_parse_options(struct nvm
 			}
 			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
 				pr_err("Invalid DH-CHAP secret %s\n", p);
+				kfree_sensitive(p);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -1042,6 +1043,7 @@ static int nvmf_parse_options(struct nvm
 			}
 			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
 				pr_err("Invalid DH-CHAP secret %s\n", p);
+				kfree_sensitive(p);
 				ret = -EINVAL;
 				goto out;
 			}


