Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2581ABEB7;
	Mon, 14 Oct 2024 14:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917225; cv=none; b=q1LaSyxlNfTSZ5SOWQGmyrOTIVEHjdIpwUFvu1uNZerzKKpgZkH/omyYHT6NgTu4eMJvrdacnxkJzX+753S1NKyEThUUQE0UeRDWeIemD0qNcdP/0WoJwTZBeurgtiY6VAji3bwQwwP3P0CBf+P/gmDyM8GL9tSR3WFW/na1PcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917225; c=relaxed/simple;
	bh=s2gORQoysaQE7nzrTG4bV7BMhT/VqcokqZsb+suK8Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PA6LZev3PgSH59bugboKPn8Lhvuv/XrXquY//p/ipISnzIlLDOTItQndlGp9Dgt7fX/oIvxV4l10Ylr6GQqIEAYsigECoPmKZy0L6kE0FdWr8GmpDcT7p29ckcIMh8rQR714JUK7oWQK6tqe4Ij4s6cAp9Q9ZLRXYAp7OJaVkrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFIU5m/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFIU5m/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03FCC4CEC3;
	Mon, 14 Oct 2024 14:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917225;
	bh=s2gORQoysaQE7nzrTG4bV7BMhT/VqcokqZsb+suK8Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFIU5m/Cp0BBwOiXpWnUlN33r8O4U7MizCrp/NZZfXDmpbDBDDYSMNO6bmGPZmQ6t
	 xjyoas9aU60D4/JVGvWFqX75A/KMKWDg4kyA0WyL1N/tjdAqcJ0AFKW0c4LdHGkck3
	 Qt+rOvtyEaJJu2L4TDUisdWi9Oec5OSjw/a2kVKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <bbrezillon@kernel.org>,
	"Juan A. Suarez Romero" <jasuarez@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.6 189/213] drm/vc4: Stop the active perfmon before being destroyed
Date: Mon, 14 Oct 2024 16:21:35 +0200
Message-ID: <20241014141050.338338225@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit 0b2ad4f6f2bec74a5287d96cb2325a5e11706f22 upstream.

Upon closing the file descriptor, the active performance monitor is not
stopped. Although all perfmons are destroyed in `vc4_perfmon_close_file()`,
the active performance monitor's pointer (`vc4->active_perfmon`) is still
retained.

If we open a new file descriptor and submit a few jobs with performance
monitors, the driver will attempt to stop the active performance monitor
using the stale pointer in `vc4->active_perfmon`. However, this pointer
is no longer valid because the previous process has already terminated,
and all performance monitors associated with it have been destroyed and
freed.

To fix this, when the active performance monitor belongs to a given
process, explicitly stop it before destroying and freeing it.

Cc: stable@vger.kernel.org # v4.17+
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: Juan A. Suarez Romero <jasuarez@igalia.com>
Fixes: 65101d8c9108 ("drm/vc4: Expose performance counters to userspace")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Juan A. Suarez <jasuarez@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241004123817.890016-2-mcanal@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_perfmon.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_perfmon.c
+++ b/drivers/gpu/drm/vc4/vc4_perfmon.c
@@ -116,6 +116,11 @@ void vc4_perfmon_open_file(struct vc4_fi
 static int vc4_perfmon_idr_del(int id, void *elem, void *data)
 {
 	struct vc4_perfmon *perfmon = elem;
+	struct vc4_dev *vc4 = (struct vc4_dev *)data;
+
+	/* If the active perfmon is being destroyed, stop it first */
+	if (perfmon == vc4->active_perfmon)
+		vc4_perfmon_stop(vc4, perfmon, false);
 
 	vc4_perfmon_put(perfmon);
 
@@ -130,7 +135,7 @@ void vc4_perfmon_close_file(struct vc4_f
 		return;
 
 	mutex_lock(&vc4file->perfmon.lock);
-	idr_for_each(&vc4file->perfmon.idr, vc4_perfmon_idr_del, NULL);
+	idr_for_each(&vc4file->perfmon.idr, vc4_perfmon_idr_del, vc4);
 	idr_destroy(&vc4file->perfmon.idr);
 	mutex_unlock(&vc4file->perfmon.lock);
 	mutex_destroy(&vc4file->perfmon.lock);


