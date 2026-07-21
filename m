Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECBA46C4B0;
	Tue, 21 Jul 2026 17:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655101; cv=none; b=Jz2BVGyl8XNQoRSWb+cs1VOAtG+1tz7FK4qfiIXTZHN88NFcF3UF+dMMyggv7t7QowmUJk8Ss13JNh6IcumZs2oISHlluN6OhXzHN/cxjNNBe1bGHoh/BnuwElsoZ5Mu7zWoG7GI2j8o99v3iz55GMIl7/rEnMyWd2X5xtbiGzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655101; c=relaxed/simple;
	bh=4O9o7HMLgRcQvCskB0wmarY+4LHFFA+DoGQ9g/49hLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHi5Q6vm690qi3OChhBeRRDdaShs8GU+2OALvacXSv1ZUZ24ti4bU+7HlH+cwp5R4SU4hAAtCFNobdkdHExHfMIrE3rVF+9Ury7XV3ktwmtQgnBiQ1+31A+PTODFXHS7UzZpNVJVzTZlcdS3K7x3lIHfAte2gTvJqcz5F+ZEk0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wk+L0f+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wk+L0f+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA791F000E9;
	Tue, 21 Jul 2026 17:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655100;
	bh=qM0mNuh+O7NhE1gUXLXWt1cUAg8bwsRen6tfBcaUfzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wk+L0f+lLI+i5aJWWaZg9wvB2wgeYEdD08Jg+GF35zE5TmKtGbORpYnGcWCYOBYIU
	 sap3d6RibeLlm5RUaOm+2UauBHw2g+i3ZNsC3L8r87rGwVxScIzawwbhD0cDJ+jozC
	 YS3dShvVhVeGhihVxlHvQm1CvvqbpNIY3SOJkASI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.1 1956/2077] fhandle: reject detached mounts in capable_wrt_mount()
Date: Tue, 21 Jul 2026 17:27:09 +0200
Message-ID: <20260721152638.845258204@linuxfoundation.org>
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

From: David Lee <david.lee@trailofbits.com>

commit 6c732471740bc2ac9b0946134f9f551dc75f4369 upstream.

The recent fhandle RCU fix moved the mount namespace capability check
into capable_wrt_mount(), so a non-NULL mnt_namespace survives the
ns_capable() dereference. The helper still assumes the later
READ_ONCE(mount->mnt_ns) must be non-NULL because may_decode_fh()
checked is_mounted() first.

That assumption is not stable. A detached mount from
open_tree(..., OPEN_TREE_CLONE) can be dissolved on fput while
open_by_handle_at() is between those checks, and umount_tree() can
clear mount->mnt_ns. If the helper observes NULL, it dereferences
mnt_ns->user_ns and panics.

Return false when the RCU read observes a detached mount. This keeps
the relaxed permission path conservative: a mount no longer attached
to a namespace cannot authorize open_by_handle_at() access.

Fixes: 620c266f3949 ("fhandle: relax open_by_handle_at() permission checks")
Cc: stable@vger.kernel.org
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: LLM
Link: https://patch.msgid.link/20260701114438.24431-1-david.lee@trailofbits.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fhandle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -295,7 +295,7 @@ static bool capable_wrt_mount(struct mou
 	 */
 	guard(rcu)();
 	mnt_ns = READ_ONCE(mount->mnt_ns);
-	return ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN);
+	return mnt_ns && ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN);
 }
 
 static inline int may_decode_fh(struct handle_to_path_ctx *ctx,


