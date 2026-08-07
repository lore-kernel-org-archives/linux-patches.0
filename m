Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2EB303C97;
	Fri,  7 Aug 2026 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113984; cv=none; b=EhoyfB9smsYvOget/wFymvO7FKq25q2M5msftkhgXEqarPcjC3L9r4S+bG7qAYZg8q+SGFzw2JWXppElsVnXQqZN8akLXrG97iPT/yCvGw4XoI4IqyokwanF8m4qVT7MPdt90TvmwZBTeTm4DEdQMb01UXcMyy11XN5TSKUVgBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113984; c=relaxed/simple;
	bh=YPJjP4Yx3gLIHoVQ/f8f4khHdeO8IlCdQNidRT8lHAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izsTZvcMciI8/jnV9JWFXidZMWWVYxsDar8lFL2MKelC86nhtKda51GtAITLuGchWcvHZTo2AoNFQP4XA02JQfxEGgzKWYAK+/rYUrZ4rXvKVfBMuikRaSmAotVZw3SJwlXChk2Fc77ytdhbT9x1kEgcQfRivb6oBy1pAUVDTfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BciR2LDp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BciR2LDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D141F000E9;
	Fri,  7 Aug 2026 14:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113982;
	bh=EqiBwPeRrFSCIN/RbINJ3q0q8GpWJhEZ8/LhnrJG9j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BciR2LDpNGpQamYWozergUPKYwfsI+zPB7DNrrlqvZbpe3XFmvv9nXmfZtOTMZfRO
	 kuppEi4gX09Njt8gKm97Y3JG5X/HyynYrconX41Wk1TNO1Ptw/fvZJIzjNQraXOxfA
	 UNd/6oqrjEOFNYF/Ibcb/dnuGXqVRjF5FqX3Do4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/337] Bluetooth: hci_sync: make hci_cmd_sync_run_once return -EEXIST if exists
Date: Fri,  7 Aug 2026 16:35:06 +0200
Message-ID: <20260807143420.771951975@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit d288f4db0909c22342eb50cd1632b4d850517281 ]

hci_cmd_sync_run_once() needs to indicate whether a queue item was
added, so caller can know if callbacks are called, so it can avoid
leaking resources.

Change the function to return -EEXIST if queue item already exists.

Modify all callsites vs. the changes.  The only callsite is
hci_abort_conn().

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 5761d003daa9 ("Bluetooth: hci_conn: hold conn reference in abort_conn_sync()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 4 +++-
 net/bluetooth/hci_sync.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index ac98e3f2344e2..93c14e2d66c8a 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2928,6 +2928,7 @@ static int abort_conn_sync(struct hci_dev *hdev, void *data)
 int hci_abort_conn(struct hci_conn *conn, u8 reason)
 {
 	struct hci_dev *hdev = conn->hdev;
+	int err;
 
 	/* If abort_reason has already been set it means the connection is
 	 * already being aborted so don't attempt to overwrite it.
@@ -2949,5 +2950,6 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 	 * as a result to MGMT_OP_DISCONNECT/MGMT_OP_UNPAIR which does
 	 * already queue its callback on cmd_sync_work.
 	 */
-	return hci_cmd_sync_run_once(hdev, abort_conn_sync, conn, NULL);
+	err = hci_cmd_sync_run_once(hdev, abort_conn_sync, conn, NULL);
+	return (err == -EEXIST) ? 0 : err;
 }
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index d2e8543b5a51e..111b8f3c77296 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -825,7 +825,7 @@ int hci_cmd_sync_run_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 			  void *data, hci_cmd_sync_work_destroy_t destroy)
 {
 	if (hci_cmd_sync_lookup_entry(hdev, func, data, destroy))
-		return 0;
+		return -EEXIST;
 
 	return hci_cmd_sync_run(hdev, func, data, destroy);
 }
-- 
2.53.0



