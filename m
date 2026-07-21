Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525DD402BA9;
	Tue, 21 Jul 2026 17:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654469; cv=none; b=nhu5z7D3mf2TdI3bNYV9gqxYrsD2KOsG46YKbzXyz1VvVTWMGpwukBXJ9+Ld4fVWUmqjoAu44d67yiFRApX2WH2AaAhbcGSzXZnVYD1oYxkyiXAy+ohe1fx/Kz1GW8CmorSpRQIFjfeDivpsJBRtAqKwgDEJbxw7uI8oRPUi4rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654469; c=relaxed/simple;
	bh=D81wg0KbaL8IQS8zhzUdCbqsolLASn+4F4bNchpcsV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0LyMCp2J1R6WIGPwJHSfkt3YLrT2apFxSyuayzpPjYNafQwhHYUcL+SidkqUb1HcfRstEYlmBPG2o6w6SmCBUAACDhtiy4rXguVfk7X19mhuqouvHUlP2TWaU6lmb2i+QkVg2s18NPKSt/HefnztS89VOIa/zChQfkAxLoT5/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkCUuYXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkCUuYXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91361F000E9;
	Tue, 21 Jul 2026 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654468;
	bh=Y7AD5OVL4zGiNyU4Y2bdxwKVOmHn58HVFzg0qo9xWkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BkCUuYXMCQ4Uq52Fm+lDJoW8VevpI3rDt0fWjzuuCe3WmyOH18/wYMeb3J3i3TRMV
	 7oXX33umHEv+beTGXUEMVYGmSH4BIYXr6Jcp/fSYEC4gDQaP1FV3CiLn5ZUphHEb7C
	 NP2eEb0Lo6WzoPZmL9dwNZGacQo7XDAyr+ZkNmlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangho Lee <kudo3228@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1717/2077] ntfs: fix WARN_ON for resident attribute in ntfs_map_runlist_nolock()
Date: Tue, 21 Jul 2026 17:23:10 +0200
Message-ID: <20260721152633.252843144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit b8d6c528e9d57d263fee1a648409f84a68b2561d upstream.

When ntfs_map_runlist_nolock() needs to look up the attribute extent
containing a target VCN (ctx_needs_reset == true), it calls
ntfs_attr_lookup() and then expects the result to be a non-resident
attribute, since only non-resident attributes have a mapping pairs
array to decompress.

A crafted NTFS image can place a resident attribute where a non-resident
one is expected, causing ntfs_attr_lookup() to succeed but return a
resident attribute record.  Previously this was caught only by a
WARN_ON(), which does not stop execution.  The code then falls through to
read a->data.non_resident.highest_vcn from what is actually a resident
attribute, accessing the wrong union member and corrupting the VCN range
check.

The caller path triggering this warning during mount is:

  ntfs_map_runlist_nolock
  ntfs_empty_logfile
  load_system_files
  ntfs_fill_super

In this path ctx is NULL, so ntfs_map_runlist_nolock() allocates a
temporary search context internally and sets ctx_needs_reset = true.
The existing resident-attribute guard in the ctx != NULL branch already
returns -EIO silently for the same condition; make the ctx_needs_reset
path consistent by replacing the WARN_ON() with the same -EIO error
return.

This causes the crafted image to be rejected with a mount error instead
of triggering a kernel warning.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Cc: stable@vger.kernel.org
Reported-by: Sangho Lee <kudo3228@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/attrib.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -174,7 +174,10 @@ int ntfs_map_runlist_nolock(struct ntfs_
 				err = -EIO;
 			goto err_out;
 		}
-		WARN_ON(!ctx->attr->non_resident);
+		if (unlikely(!ctx->attr->non_resident)) {
+			err = -EIO;
+			goto err_out;
+		}
 	}
 	a = ctx->attr;
 	/*


