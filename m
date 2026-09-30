Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5A852CCE2;
	Wed, 30 Sep 2026 17:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789921; cv=none; b=iC0Qw2Bjevkq/fhpWnyVGBkS6/nCB4f7U/VKRtky2Hy4pUqqfCv8CYpEbka7X3eDFOjiuyRBxsQI10zrI8aM8KeK5Pf6+EBLk80RG/9oJYPBc0uyRbIpYG3n3Zabsv3jNR1vht8Y2HMPr8r4XAJpFI9MbmX4kIPPGLYTUiLIpK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789921; c=relaxed/simple;
	bh=uWEt9W1naHlBbYzbNG55+ASVUQjZIXwrLJIw7ZH0kx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0H0i8WJqtZsvriYEo1Jz5x52/AP+X6tRB+JOBXAbHd06/Gc89AZ2ZZ0H3QlQSXASSwDfsSWEHbJQdNpKyJCSySYhHC1SddIAjsvYfd50DyCQzWnAJvCBB1VgHZ0t9rZGnJQ3AumHyQ59S/JWDLta1hQTlm7x4dQuC8LVaqSI6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlPYYUbU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlPYYUbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126041F000FF;
	Wed, 30 Sep 2026 17:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789919;
	bh=yA1fI2ulzxA/w2YSTuYAdjmQfJhoce65/BFyWlTqN4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlPYYUbUS3gbcSUsBjoKCTbTYpcgf0B1IMURkja+434mx9jTXlWR6tFZ3HRcgsIyl
	 qREqO/b6mfyLwrdn5fzUyOiK9NEv1H+ZoaLxOt3jPaVgBPkKEysZjif/3aZGjE15O4
	 ZoRqUXv3e3cCd2+r8sYVvFPL4IAUvfVH623jxxfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Li Chen <me@linux.beauty>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 648/877] nvdimm: preserve flush callback -ENOMEM
Date: Wed, 30 Sep 2026 17:25:59 +0200
Message-ID: <20260930152428.643037375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Li Chen <me@linux.beauty>

[ Upstream commit 6b7108712a4b1c37cac69815aede1dde202b3187 ]

nvdimm_flush() maps provider flush failures to -EIO. Keep that default
because provider callbacks can report host-side or backend failures that
should remain generic I/O errors to the guest.

Guest-side allocation failures should not be reported as I/O errors. In the
virtio-pmem path, the flush request allocation can fail with -ENOMEM before
any request is submitted to the host. Mapping that to -EIO makes resource
pressure look like media failure.

Preserve -ENOMEM from provider callbacks and continue to map other non-zero
provider failures to -EIO. The generic flush path still returns 0, and
pmem_submit_bio() already converts errno values to block status for bio
completion.

Suggested-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Li Chen <me@linux.beauty>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260630092338.2094628-2-me@linux.beauty>
Stable-dep-of: e57140944b5a ("nvdimm: virtio_pmem: refcount requests for token lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/region_devs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1112,7 +1112,8 @@ int nvdimm_flush(struct nd_region *nd_re
 	if (!nd_region->flush)
 		rc = generic_nvdimm_flush(nd_region);
 	else {
-		if (nd_region->flush(nd_region, bio))
+		rc = nd_region->flush(nd_region, bio);
+		if (rc && rc != -ENOMEM)
 			rc = -EIO;
 	}
 


