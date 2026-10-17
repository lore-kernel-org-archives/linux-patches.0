Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335DF303A0D;
	Sat, 17 Oct 2026 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255985; cv=none; b=HxB4cuBaFoGKTz45j4AFgv4gsWPjCXnp9Bkx2gX1lBrvFsWz5kaMvYYwbtySp9Ed1AYSDl51I1GGExkbjaghbUS3NIiDFMMXJv76ULVGcFlJwsqiVdGwbk02k8XTkz5XKl5eLYgb3wrhd7O8grtwE4x8J4mGjR7b2BiV9gT1GDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255985; c=relaxed/simple;
	bh=SkBNeG4PI7AvLRD3RQopnh4+8XAyW+X+igluHdLqtnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvY9lHr9dHvswrt9MEMsR+tQ7dOKGnDLY74l0cvALvjDVy7snXnECrTBqITDVDRArfEbdfP3nuqJQL/REJMP/NG5PFuT6uZUP2BhwgVuGOkfcxB0fbKL3qTVIsDvl22kvbBAbaLhuD1ID0ZlW9Zt6oLG1FUeThVJHZOZLMMNWUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjKe0CX4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjKe0CX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7611F000C4;
	Sat, 17 Oct 2026 16:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255984;
	bh=SbCAUuWHQP89P61j6niQE9Xjqxgcxv5wsHPOxHrwZbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjKe0CX44Gh6CG2LcxXUnfQdBYuAY6AFAxLI8IjAbhSIUk4pHLWc1FpB+qwMdxhiP
	 Bi326fC2w9ClxU51tuev7/oui7cRf2b24TCFsXc5OIouCkNMPUFC8B1VYZPdrxc/n0
	 EQynDNpMuc1p1t2NMXXjWY4bxwOc2FgHDuu3NCwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xu Rao <raoxu@uniontech.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0087/1674] nvme-fabrics: fix DHCHAP secret leak on parse failure
Date: Sat, 17 Oct 2026 17:39:19 +0200
Message-ID: <20261017160433.370004608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit afdee49a1b88ed9bb44e2b30e855297c169bcc53 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 8adcc8c97c42c..f910db503294a 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -952,6 +952,7 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 			}
 			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
 				pr_err("Invalid DH-CHAP secret %s\n", p);
+				kfree_sensitive(p);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -966,6 +967,7 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 			}
 			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
 				pr_err("Invalid DH-CHAP secret %s\n", p);
+				kfree_sensitive(p);
 				ret = -EINVAL;
 				goto out;
 			}
-- 
2.53.0



