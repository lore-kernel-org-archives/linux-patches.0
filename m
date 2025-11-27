Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B423D32AAC4;
	Thu, 27 Nov 2025 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255972; cv=none; b=jn+pxNT3iQOH9b94l4MxUEFk0rXWJ0/z9OP45YoSzGYaneJFYkuO7A/idV9+ZCnkODf2GxBPqKLNQWRvcraNPqslYev9hEk9porLX9n0olw3j2N2+e8jGX/hvcY64n5kCL8VLmwFarw1Tw57mWDestAhtglpews2ABMfkeI9p3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255972; c=relaxed/simple;
	bh=JqJ0nTvrXa+8UB6ryKa9iDqnIHCj9KGWcrg3iLX3lnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RB1NW3Ix4v4p6TlbJTvFSSDyjMUBRtLHiPsk4jcC1k1UjU4+sGHKHi4qI/rQZagevfwypGjquH4mEOrKVvbvL4Rnvkgb4Jty362f0e7DzEDTKyi7XFy2AK5CrsIoSlJ3+rFJSSls+Y9m8J00kybunxGgkvN60cg9gxQuDGTABwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztG40265; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztG40265"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E1DC4CEF8;
	Thu, 27 Nov 2025 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255972;
	bh=JqJ0nTvrXa+8UB6ryKa9iDqnIHCj9KGWcrg3iLX3lnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztG40265kT4KwFOGrLKxqfVOee1Z1XybGLrGY5hBy3OPVHKC2S8T+SCvQb/PWv/hB
	 1EIetVQlnJhgrm24nZO4kfz1Knq4lEopaSoq7MWAO4Ndr5/1Wp5aLK6yQntKB45cfG
	 qE2YHugHhUbWmimD62iqg/GUWGMONhzTe8ub6dcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jari Ruusu <jariruusu@protonmail.com>
Subject: [PATCH 6.17 171/175] tty/vt: fix up incorrect backport to stable releases
Date: Thu, 27 Nov 2025 15:47:04 +0100
Message-ID: <20251127144049.203473684@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------


Below is a patch for 6.12.58+ and 6.17.8+ stable branches only.
Upstream does not need this.

Signed-off-by: Jari Ruusu <jariruusu@protonmail.com>
Fixes: da7e8b382396 ("tty/vt: Add missing return value for VT_RESIZE in vt_ioctl()")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt_ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -924,8 +924,10 @@ int vt_ioctl(struct tty_struct *tty,
 			if (vc) {
 				/* FIXME: review v tty lock */
 				ret = __vc_resize(vc_cons[i].d, cc, ll, true);
-				if (ret)
+				if (ret) {
+					console_unlock();
 					return ret;
+				}
 			}
 		}
 		console_unlock();


