Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B53E35C6AA;
	Sat, 12 Sep 2026 11:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213271; cv=none; b=bgWQy1rfC+qsRWPazLUyRMf/9qO2Si47qjCqjdFATlnzQPZEFo/zf6C8Mx+dzxJwvJEUGs7XDPoUY6iy/UYnilnhh1ZK15nP5tkiU9gFQzGL+8R6wYOx/qXMyvvfnm+xP4iNSPLs8HgXXN1t/EzGeOrmcHBjLO6ytumaK8EC7Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213271; c=relaxed/simple;
	bh=wM7V71g5Xj+3zadRiavf/CWzuL9v+k2hZD6YsrO0ddk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXuEz+c2H8VIlV7jOBN+WZQP0MIM6RZHG4YtJQdPqrSI2uOQYDE/EGD96JVYZIckV7DZFpl6myUVySkRPde9Lu0M6otnyjsfpv/qM2pr6o/x62frEwHyzaJP7BvUlZpN3ylJ95TiCujE8jIoMA+d+YjrerlVIu4m7+q+EkBm3k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PS+EDXar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PS+EDXar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725F01F000FF;
	Sat, 12 Sep 2026 11:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213270;
	bh=JuJVF/7hCX70W8EXBOntsyjT+dPAQX6jpmdrmoUWP/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PS+EDXar5fCr6KY8A5+uLrKzfnXA5yMxaDZEU0F2fEB6LMDJ8hHyP4ZEl4TJxdN35
	 Gmtdq8dLUb0+yn4zuZHfhmKQFVVRn8GGWsN+ffU+e/lo8xRZCR/ZNshV5poMSl9Jie
	 askRaKjv0QgyJ2jHGk4bY/rsZX2M1CTHgi/qtLCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xu Rao <raoxu@uniontech.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 0085/1376] nvme-fabrics: fix DHCHAP secret leak on parse failure
Date: Sat, 12 Sep 2026 08:41:51 +0200
Message-ID: <20260912065609.454646700@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -1025,6 +1025,7 @@ static int nvmf_parse_options(struct nvm
 			}
 			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
 				pr_err("Invalid DH-CHAP secret %s\n", p);
+				kfree_sensitive(p);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -1039,6 +1040,7 @@ static int nvmf_parse_options(struct nvm
 			}
 			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
 				pr_err("Invalid DH-CHAP secret %s\n", p);
+				kfree_sensitive(p);
 				ret = -EINVAL;
 				goto out;
 			}


