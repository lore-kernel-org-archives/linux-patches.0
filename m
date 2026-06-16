Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5C543E9FE;
	Tue, 16 Jun 2026 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629022; cv=none; b=LiAvbo//et+1K8YDRmmClCmKAoZd47ywImceEJF6PUjFP99uRREPytSesFyGGd1khN3D7t1DC5rS4Ek3yq6fYpLGoYE/RqNN8MuayGJAXNma3nQ2I5sNU1faU57mGdcH4rhQua4vZBI1HyWIQKcrUfVXfbgKwNnj7Uqj17rNrg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629022; c=relaxed/simple;
	bh=wB6po9p16KxM5zAx+PaWpQjx4mXDBNxpLLeodgqP8/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9gadOgK2YnPk2Z2XqVdn8mRK5pQChxzuVX+1KK8VSzQN8rSwC6XR2dz2QSYbw859ZPWncTASzaCm9UQoogmvRkZKzfbx3BeM7UwJwSxzIVbzVH8DGqIa8UsKDpc0PROwce4gGbfHHeng6GQzFkKeU3R4XRR28phEJHQlEB13I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2GXNwcR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2GXNwcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163C41F000E9;
	Tue, 16 Jun 2026 16:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629021;
	bh=bbpFkB/lb7qG+tc36SWqj28Qwcpr+RHe4+/1MdPzeGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2GXNwcRxyW9sbf0a+0iZqM5IgkY17LVvgH/0IrjTAAqDNC0klxNDL4sgVrrmYa4/
	 cZjS45j6aVqLd/fZrzhdMKi1/dK5HcWnmE8+MTKqaS/r5c00CAte1w60Eztrd9CE9m
	 DamgpDev/Lfn4lw4mOKZ9bwfG2jJLAXHeli8m9ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Alva Lan <alvalan9@foxmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 206/452] Bluetooth: hci_conn: fix potential UAF in set_cig_params_sync
Date: Tue, 16 Jun 2026 20:27:13 +0530
Message-ID: <20260616145128.628067797@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit a2639a7f0f5bf7d73f337f8f077c19415c62ed2c ]

hci_conn lookup and field access must be covered by hdev lock in
set_cig_params_sync, otherwise it's possible it is freed concurrently.

Take hdev lock to prevent hci_conn from being deleted or modified
concurrently.  Just RCU lock is not suitable here, as we also want to
avoid "tearing" in the configuration.

Fixes: a091289218202 ("Bluetooth: hci_conn: Fix hci_le_set_cig_params")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ Minor context conflict resolved. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index f51c530a3c4583..ab86cc4a5e3fc8 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1734,9 +1734,13 @@ static int set_cig_params_sync(struct hci_dev *hdev, void *data)
 	struct iso_cig_params pdu;
 	u8 cis_id;
 
+	hci_dev_lock(hdev);
+
 	conn = hci_conn_hash_lookup_cig(hdev, cig_id);
-	if (!conn)
+	if (!conn) {
+		hci_dev_unlock(hdev);
 		return 0;
+	}
 
 	memset(&pdu, 0, sizeof(pdu));
 
@@ -1776,6 +1780,8 @@ static int set_cig_params_sync(struct hci_dev *hdev, void *data)
 		cis->p_rtn  = qos->ucast.in.rtn;
 	}
 
+	hci_dev_unlock(hdev);
+
 	if (!pdu.cp.num_cis)
 		return 0;
 
-- 
2.53.0



