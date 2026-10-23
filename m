Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774808;
	b=ACrxpnRShdtAPTgUOM22PIV/Yj6vIIQD5XzOC8ItXxUXXQBf4qVDI1WwnDKYb7yg0MYI
	 Egh+DhtwwaUsXTRLZVXppkizvLLCHrqZffy2XB/XZDdS4RVm+QeBBjxYIKBAVRpXp5twQ
	 hAKwvTG5l/I0BkZXnfioYaTPwaIsj6sua2cL3QVaCTB5tLVf7OJzgXYMV1sODR78k39uD
	 L++ucBovYuNitwsaX8hVBROxxQ7Jia3G4MivoBAghWVd7NkCufV41sXsLy40KWR712eIb
	 mzips+49SqueeNlQzBsb/ZWoS+jcGyqFVnfZ8aWXFSdO1PzDUJFTPyj5gzyq+qN/YLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=OO3YxadxTotsivQmUzIwDqzbxFrfltbxO5y3LvuAy3A=;
	b=QyNsPdc3mto6MUFP0vrfEYrOo8KhNA6ejCmDLKms2/wBu8DaSvVFQAbV+FS0Ah/Hxos9
	 1MpnoHi7T7Jd8992ECaci+dgs0U0AsoHnZgA/XSMAI6EOmXFkPv7Z0F61JhMgBnyb00IG
	 Ol4WAPU0DeRlh0Lbgw9tY/6fTwI9iAtmIXXAx70CFQKB32SKPankCrLtccXt97LE9lCOt
	 c+zCeeVBk3aCPGYOkSY7dYDeBeDz3sntjRTWPb5WPAv02wDZefW5GOSVDn4w84H7ydHt1
	 0Y7WZmVbF15rJ76Wdl++Zs6cYfZVvxHtKKv7dKs7NAexn2Dfs4a4xHSjGBgzK6bBN7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2pEE2rF7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A7606A31E;
	Fri, 23 Oct 2026 17:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2pEE2rF7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070E91F01825;
	Fri, 23 Oct 2026 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774807;
	bh=OO3YxadxTotsivQmUzIwDqzbxFrfltbxO5y3LvuAy3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2pEE2rF7bDlRloxCyktwanggSNBiJM6q7OrEJ1WZHq+5lk4umehc094503S1dsdI5
	 K9sjgMjay4OOW0yfwaDjr5tlHiBLPvSiLkn1aTOpcfLFusPgTr5lhAD0SMt0lC5Oqd
	 6h/VtBdwAbpptcZfWXhEuvU8Fh5joi+3yzumvTNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arvind Yadav <arvind.yadav@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	intel-xe@lists.freedesktop.org,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 7.2 164/242] drm/xe: Dont transfer shrinker pages for pinned bos on purgeable state change
Date: Fri, 23 Oct 2026 18:40:06 +0200
Message-ID: <20261023163717.662320372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit ffbfd3f98f4393e91dffce3a46ccb7cf5329cf2f upstream.

Pinned bos have their pages removed from the shrinker's shrinkable /
purgeable counts on pin, and added back on unpin according to the
bo's purgeable state at that time.

However, xe_bo_set_purgeable_shrinker() unconditionally transfers
pages between the shrinkable and purgeable counts. If the purgeable
state of a pinned bo changes, for example by userspace madvising
DONTNEED on a VMA of a bo that is also pinned as a scanout buffer,
this underflows one count and, after unpin, leaves the other one
permanently inflated.

Only update the purgeable flag for pinned bos, and leave the page
accounting to unpin.

Fixes: 536a2ead3a8f ("drm/xe/bo: Add purgeable shrinker state helpers")
Cc: Arvind Yadav <arvind.yadav@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: intel-xe@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v7.1+
Assisted-by: LLM
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20261009070053.7790-1-thomas.hellstrom@linux.intel.com
(cherry picked from commit afe6bc012034123fd838328668e609bf57e46bd3)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -938,6 +938,8 @@ static int xe_bo_move_notify(struct xe_b
  *
  * Transfers pages between shrinkable and purgeable buckets when the BO
  * purgeable state changes. Called automatically from xe_bo_set_purgeable_state().
+ * For pinned BOs, whose pages are not accounted, only the purgeable flag is
+ * updated, so that the correct bucket is used when the BO is unpinned.
  */
 static void xe_bo_set_purgeable_shrinker(struct xe_bo *bo,
 					 enum xe_madv_purgeable_state new_state)
@@ -954,7 +956,8 @@ static void xe_bo_set_purgeable_shrinker
 		return;
 
 	xe_tt = container_of(tt, struct xe_ttm_tt, ttm);
-	tt_pages = tt->num_pages;
+	/* Pinned bos are not accounted. Only update the purgeable flag. */
+	tt_pages = xe_bo_is_pinned(bo) ? 0 : tt->num_pages;
 
 	if (!xe_tt->purgeable && new_state == XE_MADV_PURGEABLE_DONTNEED) {
 		xe_tt->purgeable = true;


