Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E2029D27A;
	Fri,  7 Aug 2026 14:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114429; cv=none; b=fgoX/QV0Qo4o6cltOkeatdE1TmDUz+qgqW4GL/RfYBYqXMFfxsvGR9kNM+U6Y4ix9Kfo8/fzcP1QGJwKjxjJ3O6fLj0IdObQCyGE6wZseRWquc/MLqyC6HsN2qBmAPfilGz4BWkaoOCvqK5I1tZN9M8UgoVp1p+tVhumKYUCs2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114429; c=relaxed/simple;
	bh=cocQVNSXWrXdsLRubK10RgIk+gXf64z+nFH5jvDqiAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/w6TrNJA30ak5HjH1Z7Q6JHF62jSruefOJ+6ZTXTQIzEzWjh4KTTrBBaOusJJQyCgKbf0gpWPU369YpuqDRtBtIBp9A4ej7Pn+PmaJxJt2SMSRtfufxuSbuRd4esxBKeD9ExjLETQCXiCBUH0vU7cbTpDa47M8b/sG1u2jU5v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcrmWyQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcrmWyQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584881F000E9;
	Fri,  7 Aug 2026 14:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114427;
	bh=he7Z7Cd+VOE23vUTOWd6EbzqF0fCVx3SNjrK/x7+5Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcrmWyQuB2PGKTDsNgZ8nlZkG/eeLKBgh9Fyn7Pl6ap4XWZ4yASs4C5jvYhBePWPo
	 0yoPvRDlGXVaQFwOYi2Iqe1hYatvC9T/CjE/VvsH42pHT/F/W/HPD5GfMUEnmedjLS
	 kiIkJnyf/lgDyz7FgOGBEczwVTZB2tDmtf3j51QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Palacek <William.Palacek@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 258/337] drm/amdkfd: hold event_mutex while checkpointing CRIU events
Date: Fri,  7 Aug 2026 16:37:41 +0200
Message-ID: <20260807143424.139140472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Palacek <William.Palacek@amd.com>

commit ff8bc5a68a9a70bdc38d61a72c7a49c56063f9d2 upstream.

kfd_criu_checkpoint_events() counts the entries in p->event_idr via
kfd_get_num_events(), allocates an array sized to that count, and then
walks the same IDR to fill it. Neither the count nor the walk holds
p->event_mutex.

The CRIU checkpoint caller holds only p->mutex. Event create and destroy
(kfd_event_create()/kfd_event_destroy()) take p->event_mutex and do not
take p->mutex, so a second thread in the same process can insert or remove
events between the count and the walk. If an event is inserted, the walk
iterates more entries than were counted and writes past the end of the
ev_privs allocation; if an event is removed, the walk dereferences an
entry that is being freed.

Hold p->event_mutex across the count and the walk so both observe a
consistent view of p->event_idr. The lock is released before
copy_to_user(), which only touches the local buffer. The caller already
holds p->mutex and the create/destroy paths never take p->mutex, so the
p->mutex -> p->event_mutex order is not inverted and no deadlock is
introduced.

Fixes: 40e8a766a761 ("drm/amdkfd: CRIU checkpoint and restore events")
Signed-off-by: William Palacek <William.Palacek@amd.com>
Reviewed-by: Alysa Liu <Alysa.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ff57e223ab105795b05d3ef3f3c35a5a441bcbaa)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_events.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -545,15 +545,27 @@ int kfd_criu_checkpoint_events(struct kf
 	int ret =  0;
 	struct kfd_event *ev;
 	uint32_t ev_id;
+	uint32_t num_events;
 
-	uint32_t num_events = kfd_get_num_events(p);
-
-	if (!num_events)
+	/* Serialize the count and the walk below against concurrent event
+	 * create/destroy. Those paths take only p->event_mutex, not the
+	 * p->mutex held by the CRIU checkpoint caller, so without this the
+	 * event_idr can grow between kfd_get_num_events() and the loop and the
+	 * walk writes past the ev_privs allocation.
+	 */
+	mutex_lock(&p->event_mutex);
+
+	num_events = kfd_get_num_events(p);
+	if (!num_events) {
+		mutex_unlock(&p->event_mutex);
 		return 0;
+	}
 
 	ev_privs = kvzalloc(num_events * sizeof(*ev_privs), GFP_KERNEL);
-	if (!ev_privs)
+	if (!ev_privs) {
+		mutex_unlock(&p->event_mutex);
 		return -ENOMEM;
+	}
 
 
 	idr_for_each_entry(&p->event_idr, ev, ev_id) {
@@ -594,6 +606,8 @@ int kfd_criu_checkpoint_events(struct kf
 		i++;
 	}
 
+	mutex_unlock(&p->event_mutex);
+
 	ret = copy_to_user(user_priv_data + *priv_data_offset,
 			   ev_privs, num_events * sizeof(*ev_privs));
 	if (ret) {


