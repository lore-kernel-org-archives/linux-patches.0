Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667412C11DF;
	Fri, 15 May 2026 16:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862380; cv=none; b=BvJtXkBVSOj+9JAd+0CAzWToIweLtTEdMiqbpJwMfBl8EEdUyQ7/Mq7KYzwSMXzplNObxLZnk1zS4G02yqWKsVuTYRXXMvQ/RHe5nBU3gyXEnTSIGYyc9povvDymG8vU+7fNAMZXbkV1k2UMcpIDUvq0z+Pq9+B56Zi666hcAis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862380; c=relaxed/simple;
	bh=KsY9DCZV7YR9tItlqAbNcgYJ21OoCp3qEpa0iuCq4sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZAqvwT/dlFeG+vnHVP8coz/uUE25/8i+PxKq9PR5NvCrmaIB2KSniO/vy6x3R5OucwxRKQ76JnvMBwTgdlfqZQVyDb14hYA34rJIzxoCVWug2qrQ2e8FmDBovGBSj4rcdtSTgvKNw5iICpL+JIG/8OsQOm7XaRNl99Bvc/uvj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqObvtjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqObvtjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12CAC2BCC7;
	Fri, 15 May 2026 16:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862380;
	bh=KsY9DCZV7YR9tItlqAbNcgYJ21OoCp3qEpa0iuCq4sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqObvtjqVO5TopMCRLlje836joE7mbOE+ubXUVvCk57U9uchB8g8qHBy3TBzO3dBt
	 3bFdWgJAw9PXnjxzRe+YoQOVxjrcl8ZR+EckiGTUZ0OlZbZW4EKcaKDmz9+Ol2NBea
	 n+H/wkgEgmMv1/F+AzeAhN8qmtfxkh3+LwATd34E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH 7.0 026/201] drm/gpusvm: Allow device pages to be mapped in mixed mappings after system pages
Date: Fri, 15 May 2026 17:47:24 +0200
Message-ID: <20260515154659.100154142@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

commit ec49857ad181f2a68a3bea15422f2936ff366d47 upstream.

The current code rejects device mappings whenever system pages have
already been encountered. This is not the intended behavior when
allow_mixed is set.

Relax the restriction by permitting a single pagemap to be selected when
allow_mixed is enabled, even if system pages were found earlier.

Fixes: bce13d6ecd6c ("drm/gpusvm, drm/xe: Allow mixed mappings for userptr")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Francois Dugast <francois.dugast@intel.com>
Link: https://patch.msgid.link/20260130194928.3255613-3-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gpusvm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1495,7 +1495,7 @@ map_pages:
 			}
 			zdd = page->zone_device_data;
 			if (pagemap != page_pgmap(page)) {
-				if (i > 0) {
+				if (pagemap) {
 					err = -EOPNOTSUPP;
 					goto err_unmap;
 				}


