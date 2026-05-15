Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBC5332634;
	Fri, 15 May 2026 16:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862781; cv=none; b=BjsIMA3ZS6R9bVyzNwZqgttO4l3b+6VnkdG6A/7yV8VRu2T/jBuX9tgRWTeDLHi3KtGz4HlsjhRqwDAamSSgz1GySi/GvJLQfyySmbv0AUs1mM2+k8slr2mjqmx9M4NzR6foJynCsjJZp53gSxLsP4TUbIap8PkiMdTmOf2k2i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862781; c=relaxed/simple;
	bh=qnrNxDPeQTij3KCEz75d0pJ5Md2k75uSFkxT9r2Zg8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jt8ZYduWtooeKfgDPfx0xla/fc8VKSQpgLhy5jFUSboCViAia4Q3K9E5sKnSaDqnoX8dzpwOrhUSGF3ICrJPzOQ6s41Yzn4064CvwvdVSBhTV8ietwGFRTH/68Og6MM7tAEKtkcTcwPKHl0lUaYe3WcTILKTx+0JxZ6oie9DJYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+ffmQ/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+ffmQ/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367B5C2BCB0;
	Fri, 15 May 2026 16:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862781;
	bh=qnrNxDPeQTij3KCEz75d0pJ5Md2k75uSFkxT9r2Zg8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+ffmQ/jn9I5Jp9/RVh2Kv5VvQ3RfcE7CqR1dSHg4DXA5BBeJuaBb1hy+E1UG3ODN
	 eztMsv23qmvdtXqMrABzOy5wvdAQW8Hi/XyN8q+3lOG9RABLFArH02HfLG1/ixlkB/
	 I73VJ+62Y8JabvE5Jl+d+pLlVZw9fesqZxCnyBLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Desai <ashutoshdesai993@gmail.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 7.0 128/201] drm/v3d: Reject empty multisync extension to prevent infinite loop
Date: Fri, 15 May 2026 17:49:06 +0200
Message-ID: <20260515154701.338257913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Desai <ashutoshdesai993@gmail.com>

commit fb44d589bf3148e13452185a6e772a7efbf2d684 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_submit.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/v3d/v3d_submit.c
+++ b/drivers/gpu/drm/v3d/v3d_submit.c
@@ -393,6 +393,11 @@ v3d_get_multisync_submit_deps(struct drm
 	if (multisync.pad)
 		return -EINVAL;
 
+	if (!multisync.in_sync_count && !multisync.out_sync_count) {
+		drm_dbg(&v3d->drm, "Empty multisync extension\n");
+		return -EINVAL;
+	}
+
 	ret = v3d_get_multisync_post_deps(file_priv, se, multisync.out_sync_count,
 					  multisync.out_syncs);
 	if (ret)


