Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABF413DBA0;
	Mon, 16 Sep 2024 12:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488421; cv=none; b=JGOsTiJMS3cyxqNRK2WwZHdQu6nNC3oZOinBdJhFPinlseWaAdmysG4YWWkBhMZAPYUXL7RjmyRfrDN/MibI4c2qqscYX9Kns4qn0PBPohJI+7OBDrC1dlSSnAYBLt2F0R5DyUC8lnbaQyhdcpNAPoXfZauMMZFMVlt2wEujvIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488421; c=relaxed/simple;
	bh=yBrnshcmPM6yQEVV14O87PpAhYAXzY2B4X6Dz6ESjV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bYeobGodZdmJLsd7gdc4CDe2MUYYSX+Io7werI/36yNj2EmuDn+bIN2h4DxtL11S2NjF8+n7Lv+fIyJB8Zj9E/llbKFCdAtlSvQlxqngXucukHlW4VtxBgLfZ+0VlWbB5ESnlPBclIKVz6c3hc9CTLvpkSl135xm2c7us9qjLlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ak+qkIFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ak+qkIFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39251C4CEC4;
	Mon, 16 Sep 2024 12:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488421;
	bh=yBrnshcmPM6yQEVV14O87PpAhYAXzY2B4X6Dz6ESjV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ak+qkIFVcaHhFkYacQdQnGD686/KTIEaiJjJr/5wzVmJHn3poAVrb0ljPh3IHMjcX
	 ce0kpySdnizYI/prCoKqOPNwW6v1u/TSc0NVcVzLOsHEbQF2X/x5mbYiF5iIjzaYpL
	 ZF5nf1KLGc0bWB8gVLfk6gEajctwXvKtXhqOamSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.10 108/121] drm/xe/client: fix deadlock in show_meminfo()
Date: Mon, 16 Sep 2024 13:44:42 +0200
Message-ID: <20240916114232.666997898@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 9bd7ff293fc84792514aeafa06c5a17f05cb5f4b upstream.

There is a real deadlock as well as sleeping in atomic() bug in here, if
the bo put happens to be the last ref, since bo destruction wants to
grab the same spinlock and sleeping locks.  Fix that by dropping the ref
using xe_bo_put_deferred(), and moving the final commit outside of the
lock. Dropping the lock around the put is tricky since the bo can go
out of scope and delete itself from the list, making it difficult to
navigate to the next list entry.

Fixes: 0845233388f8 ("drm/xe: Implement fdinfo memory stats printing")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2727
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Tejas Upadhyay <tejas.upadhyay@intel.com>
Cc: "Thomas Hellström" <thomas.hellstrom@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240911155527.178910-5-matthew.auld@intel.com
(cherry picked from commit 0083b8e6f11d7662283a267d4ce7c966812ffd8a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_drm_client.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_drm_client.c
+++ b/drivers/gpu/drm/xe/xe_drm_client.c
@@ -138,6 +138,7 @@ static void show_meminfo(struct drm_prin
 	struct xe_drm_client *client;
 	struct drm_gem_object *obj;
 	struct xe_bo *bo;
+	LLIST_HEAD(deferred);
 	unsigned int id;
 	u32 mem_type;
 
@@ -157,11 +158,14 @@ static void show_meminfo(struct drm_prin
 	list_for_each_entry(bo, &client->bos_list, client_link) {
 		if (!kref_get_unless_zero(&bo->ttm.base.refcount))
 			continue;
+
 		bo_meminfo(bo, stats);
-		xe_bo_put(bo);
+		xe_bo_put_deferred(bo, &deferred);
 	}
 	spin_unlock(&client->bos_lock);
 
+	xe_bo_put_commit(&deferred);
+
 	for (mem_type = XE_PL_SYSTEM; mem_type < TTM_NUM_MEM_TYPES; ++mem_type) {
 		if (!xe_mem_type_to_name[mem_type])
 			continue;


