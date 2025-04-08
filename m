Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6D4224F6;
	Tue,  8 Apr 2025 11:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111124; cv=none; b=X/rPZF+2K4APTmQJVNHdP9XRumXaOxw+mPgGbGJQkpqjQdrrAy7L/ltugh4bCyeB4BsmDLsOIVmUMKffqTFHeKidM0Mrji2xdXmKPsZJRK5s5v8G4JiKPK42smHPFfnCHlwfyfOCSyic187OTCpLnFBD2JRp8mTvx4J9NyJkbhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111124; c=relaxed/simple;
	bh=qddyf7Dub+myyGuCjBKs+w5o98pn9BkHi3yLFzcHKN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qa2RGFHAigG9oN85lIjPREpR2oo1lPGDLPdQbJc/+VNKgIUpnlaW290bysXp2UDkXCqsaIUxVyKVsKX62GOM5/7UgLS+8vXYcOPZVGF8WuSJOFdmxv60FBNzQr7EZfcAIgGiUIfSHoa0sQS+drtkfPof7n2qCVGiTDWJ81g4QNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASyAeKmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASyAeKmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFB8C4CEE5;
	Tue,  8 Apr 2025 11:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111124;
	bh=qddyf7Dub+myyGuCjBKs+w5o98pn9BkHi3yLFzcHKN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASyAeKmYF4CDA5rzYo4cbGb8Uwaf+On3Z3qFb7kkA0CGkUHdyhahdU3gQISLi8Bm6
	 WyJF2IcpL3FRZSGOwgG3f3lpWhxVbFwLEJFAkec9XUQqVDaV82JQYRparlTS5+Osym
	 AB4SjBWxO0o53oo6otqdp8yw7WQChRddXAHzNoVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 317/731] drm/file: Add fdinfo helper for printing regions with prefix
Date: Tue,  8 Apr 2025 12:43:34 +0200
Message-ID: <20250408104921.651448359@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit af6c2b7c46e16701fba44a21326cb634786e3e71 ]

This is motivated by the desire of some drivers (eg. Panthor) to print the
size of internal memory regions with a prefix that reflects the driver
name, as suggested in the previous documentation commit.

That means adding a new argument to print_size and making it available for
DRM users.

Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250130172851.941597-3-adrian.larumbe@collabora.com
Stable-dep-of: e379856b428a ("drm/panthor: Replace sleep locks with spinlocks in fdinfo path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_file.c | 26 ++++++++++++++++++--------
 include/drm/drm_file.h     |  5 +++++
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index 2289e71e2fa24..c299cd94d3f78 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -830,8 +830,11 @@ void drm_send_event(struct drm_device *dev, struct drm_pending_event *e)
 }
 EXPORT_SYMBOL(drm_send_event);
 
-static void print_size(struct drm_printer *p, const char *stat,
-		       const char *region, u64 sz)
+void drm_fdinfo_print_size(struct drm_printer *p,
+			   const char *prefix,
+			   const char *stat,
+			   const char *region,
+			   u64 sz)
 {
 	const char *units[] = {"", " KiB", " MiB"};
 	unsigned u;
@@ -842,8 +845,10 @@ static void print_size(struct drm_printer *p, const char *stat,
 		sz = div_u64(sz, SZ_1K);
 	}
 
-	drm_printf(p, "drm-%s-%s:\t%llu%s\n", stat, region, sz, units[u]);
+	drm_printf(p, "%s-%s-%s:\t%llu%s\n",
+		   prefix, stat, region, sz, units[u]);
 }
+EXPORT_SYMBOL(drm_fdinfo_print_size);
 
 int drm_memory_stats_is_zero(const struct drm_memory_stats *stats)
 {
@@ -868,17 +873,22 @@ void drm_print_memory_stats(struct drm_printer *p,
 			    enum drm_gem_object_status supported_status,
 			    const char *region)
 {
-	print_size(p, "total", region, stats->private + stats->shared);
-	print_size(p, "shared", region, stats->shared);
+	const char *prefix = "drm";
+
+	drm_fdinfo_print_size(p, prefix, "total", region,
+			      stats->private + stats->shared);
+	drm_fdinfo_print_size(p, prefix, "shared", region, stats->shared);
 
 	if (supported_status & DRM_GEM_OBJECT_ACTIVE)
-		print_size(p, "active", region, stats->active);
+		drm_fdinfo_print_size(p, prefix, "active", region, stats->active);
 
 	if (supported_status & DRM_GEM_OBJECT_RESIDENT)
-		print_size(p, "resident", region, stats->resident);
+		drm_fdinfo_print_size(p, prefix, "resident", region,
+				      stats->resident);
 
 	if (supported_status & DRM_GEM_OBJECT_PURGEABLE)
-		print_size(p, "purgeable", region, stats->purgeable);
+		drm_fdinfo_print_size(p, prefix, "purgeable", region,
+				      stats->purgeable);
 }
 EXPORT_SYMBOL(drm_print_memory_stats);
 
diff --git a/include/drm/drm_file.h b/include/drm/drm_file.h
index ef817926cddd3..94d365b225052 100644
--- a/include/drm/drm_file.h
+++ b/include/drm/drm_file.h
@@ -495,6 +495,11 @@ struct drm_memory_stats {
 enum drm_gem_object_status;
 
 int drm_memory_stats_is_zero(const struct drm_memory_stats *stats);
+void drm_fdinfo_print_size(struct drm_printer *p,
+			   const char *prefix,
+			   const char *stat,
+			   const char *region,
+			   u64 sz);
 void drm_print_memory_stats(struct drm_printer *p,
 			    const struct drm_memory_stats *stats,
 			    enum drm_gem_object_status supported_status,
-- 
2.39.5



