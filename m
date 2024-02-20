Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D558C14AD12;
	Tue, 20 Feb 2024 21:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463334; cv=none; b=SC6mNHWZ8mKCxUEY7PUcQIxKNDTedNniHaYPShFj+ynfGdzCvx9hMhKN+uiI8EthjextsrM1N0PgGUxmhwaRD79YR9YCafNhpWsX+qy58Fi8EnDqWvh1jgQYXyo3ytehKFnpuK3scIqG18/skGTTJPRrTmRhVuDPLJcUwslKmDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463334; c=relaxed/simple;
	bh=/V/ymhNAGcCLAcZAHRqeMCSqF0jobcvMX5Hqx+YnhBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFxqO2AMs/tE5hn5BtH9Tt3YB/IFqb8i+pTKbEQeEVAOYgzcU0kjsrMWufyv6WoV/bHG0C6TqPjEiLsI2v/vTBxkiBZ1cfi3fTG/6AkMKC4zFk6VM8oBsHmQ8hOHbJuwyCMUlLH8YJgoUWETtv3Ba7PzmSiNm5252dZqsc1eGHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjWI/XCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjWI/XCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6F0C433F1;
	Tue, 20 Feb 2024 21:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463334;
	bh=/V/ymhNAGcCLAcZAHRqeMCSqF0jobcvMX5Hqx+YnhBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MjWI/XCfvS5xIOHU0ZA3h9RAi+mPCZKKKGYpqVesoSEeupgzCqtnFIwG67wHcZyMy
	 Uk4Gdx6tq4eh5GRG3tB7R+FTJIXKhFLV5i0bhhmEQuHu2+RwM7OQRequvWSMVtxNFE
	 k3OOy0O36sE1XaL6qMC8Xo+tTg1pQqjtkZfGLcAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.6 012/331] driver core: Fix device_link_flag_is_sync_state_only()
Date: Tue, 20 Feb 2024 21:52:08 +0100
Message-ID: <20240220205637.973632480@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Saravana Kannan <saravanak@google.com>

commit 7fddac12c38237252431d5b8af7b6d5771b6d125 upstream.

device_link_flag_is_sync_state_only() correctly returns true on the flags
of an existing device link that only implements sync_state() functionality.
However, it incorrectly and confusingly returns false if it's called with
DL_FLAG_SYNC_STATE_ONLY.

This bug doesn't manifest in any of the existing calls to this function,
but fix this confusing behavior to avoid future bugs.

Fixes: 67cad5c67019 ("driver core: fw_devlink: Add DL_FLAG_CYCLE support to device links")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240202095636.868578-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -283,10 +283,12 @@ static bool device_is_ancestor(struct de
 	return false;
 }
 
+#define DL_MARKER_FLAGS		(DL_FLAG_INFERRED | \
+				 DL_FLAG_CYCLE | \
+				 DL_FLAG_MANAGED)
 static inline bool device_link_flag_is_sync_state_only(u32 flags)
 {
-	return (flags & ~(DL_FLAG_INFERRED | DL_FLAG_CYCLE)) ==
-		(DL_FLAG_SYNC_STATE_ONLY | DL_FLAG_MANAGED);
+	return (flags & ~DL_MARKER_FLAGS) == DL_FLAG_SYNC_STATE_ONLY;
 }
 
 /**


