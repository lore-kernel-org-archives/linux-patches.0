Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B443D40801A;
	Wed, 20 May 2026 18:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303021; cv=none; b=cQK9gk1/SyhCV7cGnL595UT1lRgCFdxIUb4UQuk8nB+UD6K6SNbWvOQW6RmGrVQWJIQyFjZGxM2YUR8fTYG3n7bxXYwbXA5FY4VgxpUiak/qBUTCpLUghDY4f4i3GLJiak9w5hlDhxK9c0f+7pT+HVPNvdkd3PvITUWRImwxo4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303021; c=relaxed/simple;
	bh=eXzE8i8ned9x5+vM855sBqYZLaLYogsOQ9GdoTWy0Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oO5kt5PVvL1dxgFpvbtdjoJiJnKZD6fr4k9O1/OKXVpY6MuyMxc4E9mv6U+a/AG9u45Loba2W7VgHZcUuHQYjDtZ9VEmKMGmWG49a3YWtwt3tHL171kMARhXuRjtr99MlE6Khltn4ex4+37C0hv9XH9qId+5hosSNQAZj2kEFvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7NldXLG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7NldXLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D41E1F000E9;
	Wed, 20 May 2026 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303017;
	bh=bHJkVqvyrVC8M3G6LfNwdKErZnxE65qmocWkXIzqGAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l7NldXLGluregfYXmkDCpwysouCcTxsNqrTExGVkSt6b/fRERA6A1vXTpEylqIzdx
	 CTS96uLGNliPG6FifVnKjq6czqwp39jlboHyhdLM590dBG7HuVDknKNRH1YVGEFUyA
	 cA1L8z9giWkSGHL4p51DlVBA3j+det9lUVrJ054o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Desai <ashutoshdesai993@gmail.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.6 488/508] drm/v3d: Reject empty multisync extension to prevent infinite loop
Date: Wed, 20 May 2026 18:25:11 +0200
Message-ID: <20260520162109.167618197@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ashutosh Desai <ashutoshdesai993@gmail.com>

v3d_get_extensions() walks a userspace-provided singly-linked list of
ioctl extensions without any bound on the chain length. A local user
can craft a self-referential extension (ext->next == &ext) with zero
in_sync_count and out_sync_count, which bypasses the existing duplicate-
extension guard:

    if (se->in_sync_count || se->out_sync_count)
            return -EINVAL;

The guard never fires because v3d_get_multisync_post_deps() returns
immediately when count is zero, leaving both fields at zero on every
iteration. The result is an infinite loop in kernel context, blocking
the calling thread and pegging a CPU core indefinitely.

Fix this by rejecting a multisync extension where both in_sync_count
and out_sync_count are zero in v3d_get_multisync_submit_deps(). An
empty multisync carries no synchronization information and serves no
useful purpose, so returning -EINVAL for such an extension is the
correct defense against this attack vector.

Fixes: e4165ae8304e ("drm/v3d: add multiple syncobjs support")
Cc: stable@vger.kernel.org
Signed-off-by: Ashutosh Desai <ashutoshdesai993@gmail.com>
Link: https://patch.msgid.link/20260415050000.3816128-1-ashutoshdesai993@gmail.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
(cherry picked from commit fb44d589bf3148e13452185a6e772a7efbf2d684)
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_gem.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -597,6 +597,11 @@ v3d_get_multisync_submit_deps(struct drm
 	if (multisync.pad)
 		return -EINVAL;
 
+	if (!multisync.in_sync_count && !multisync.out_sync_count) {
+		DRM_DEBUG("Empty multisync extension\n");
+		return -EINVAL;
+	}
+
 	ret = v3d_get_multisync_post_deps(file_priv, data, multisync.out_sync_count,
 					  multisync.out_syncs);
 	if (ret)


