Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062839;
	b=Ls9SDPV5ng1ZXXxAoodPkcdB0EtaA/6keZ2LFEqmOZG9R+Icuomv9BgyJ2rjgFDE4+Ch
	 jlNGEa28L/L6sICyK8oP3j0DHCdY6PxzfW3AkCkFbknslfcigfwSr++u9Q15bNsBVmR04
	 vl/beLcQtSddKRgx+D/rWtYP3V1L9zRux2h0aHuJLXMZeBTC+aEc3lz5Rd0HaxHtc2tnY
	 IsKwdGcAoSMTk/qkKmH2NIEb9TCWLU1wso/VDaDizVNfkErfKoBly39ZnspCECZZadGar
	 VdV+K3ll9BbAEpHiKUjmmDZFAYRSyiBOw1DuQh1TG/hgHg9+kG4N7afFr8bCpgEV4Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9vL2ZiRii47S4zejAJ5xgTRfirlg9lCY9Ofl8hxvOXg=;
	b=4PUoC20dj+zTxrGrbIzolOXMRJMaCOi53q/KTHhunFU/pI4wtk1pJWAgv2rO8dxdx1iR
	 Ksyr0Wl3ZXnFXOY7RQwVKuKvzba0in3FVX/2kq//mXdyOZB3ka+zOVGYEieylulVITOkA
	 GShpisllaPVVjRkl7cSvQEeFIyFgWCaCIYXYs1xuEaNTRWOeueP9Li7zEH6TenFvqWGiY
	 AIKgDqDHMyZIMmp833waoyXZqZ/zHGNX3ZNplURJwJGgESknb/jBwK5YeJLRuxawipyrM
	 EVohyRBFUcMbbAIPGw3EkrW99JyLmO1zcqWOpsSqT1el7ZXGVQgk30e5IG2l9bDMeag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AxiI7zjV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C6D606A334;
	Sat,  7 Nov 2026 14:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AxiI7zjV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46CE1F0089F;
	Sat,  7 Nov 2026 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062839;
	bh=9vL2ZiRii47S4zejAJ5xgTRfirlg9lCY9Ofl8hxvOXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxiI7zjVJCVs3AyjTjWY+T1OBgx685PjHkuzA2MsebJqYgkW6oRP/TklIWS4AdzWb
	 ljfP/hwuXt8howYHMdNHWa/o+0MEbdVDJUT/PXczLm81CxfoqykINxywzr/Qf9YYFH
	 EFtR6i0NVR98ztFswEJyxXTipG+IOZkkeSP3SUUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 134/869] dm vdo indexer: validate record page numbers better
Date: Sat,  7 Nov 2026 08:46:56 -0500
Message-ID: <20261107134856.980867120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Sakai <msakai@redhat.com>

[ Upstream commit e3683a76a313a81f3f7bc7f65e4fc1e61232838b ]

Move the record_page_number validation check into the
chapter index lookup function in order to detect (and
discard) corrupted values on all paths.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-vdo/indexer/chapter-index.c | 15 +++++++++++----
 drivers/md/dm-vdo/indexer/volume.c        |  6 ------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/chapter-index.c b/drivers/md/dm-vdo/indexer/chapter-index.c
index fb1db41c794b3..7a744b2da28f9 100644
--- a/drivers/md/dm-vdo/indexer/chapter-index.c
+++ b/drivers/md/dm-vdo/indexer/chapter-index.c
@@ -284,10 +284,17 @@ int uds_search_chapter_index_page(struct delta_index_page *index_page,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	if (was_entry_found(&entry, address))
-		*record_page_ptr = uds_get_delta_entry_value(&entry);
-	else
+	if (!was_entry_found(&entry, address)) {
 		*record_page_ptr = NO_CHAPTER_INDEX_ENTRY;
+		return UDS_SUCCESS;
+	}
 
-	return UDS_SUCCESS;
+	*record_page_ptr = uds_get_delta_entry_value(&entry);
+	result = VDO_ASSERT(*record_page_ptr < geometry->record_pages_per_chapter,
+			    "0 <= %d < %u", *record_page_ptr,
+			    geometry->record_pages_per_chapter);
+	if (result != VDO_SUCCESS)
+		*record_page_ptr = NO_CHAPTER_INDEX_ENTRY;
+
+	return result;
 }
diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index 425b3a74f4dba..f7de78e0d0dbd 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -891,12 +891,6 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 	if (record_page_number == NO_CHAPTER_INDEX_ENTRY)
 		return UDS_SUCCESS;
 
-	result = VDO_ASSERT(record_page_number < geometry->record_pages_per_chapter,
-			    "0 <= %d < %u", record_page_number,
-			    geometry->record_pages_per_chapter);
-	if (result != VDO_SUCCESS)
-		return result;
-
 	page_number = geometry->index_pages_per_chapter + record_page_number;
 
 	physical_page = map_to_physical_page(volume->geometry, chapter, page_number);
-- 
2.53.0



