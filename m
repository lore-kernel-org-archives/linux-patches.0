Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DD9155389;
	Mon,  6 Jan 2025 15:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177062; cv=none; b=lvye2R/2qwFOJE8tODAdnryFm+kIbEfjY2coV2Dc1jH5bkIyUEIPbvYdWRqZmfbIZiQRqhyl/uTaIHnZQvdwh/NSU70FGQHF8YNC2fWKI1lLGnTX2pH/py3aUKqkfBV0R/YnbTjretoExhnQhSf2KURYIIj0eoPTKJW1ZWxA2vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177062; c=relaxed/simple;
	bh=PlqklGMz0wdh3J8G33GfdS31ieRM9xh0hHZG0UMXJRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRy+L9XlYZ25EULEt3con9JnHOZWU26DEE9N8VVmoZxLqmhSR58hkdkv7RvQ1Kq4rJGdcccOlwfeyqXixZwJp/C+aLqBmEi6FzMb+t99ex746H7mcATjoO0dJHidqSzl/t6dx5RkopVTjRYPVdPdKi+2xGocgcb+s38Dr3S4dCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cC3cEsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cC3cEsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586DDC4CED2;
	Mon,  6 Jan 2025 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177062;
	bh=PlqklGMz0wdh3J8G33GfdS31ieRM9xh0hHZG0UMXJRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cC3cEsPCV+EQeATmyWtwkt+KXRRH0TEpGoDOW+6hBoVU6VDjmBbUx4VQUqyQYUpB
	 vjxZHbJbFiuAGNvPkoXpQ/mj5hDy5pOlkGNcg3jR6sljER/dmQdgmo5rKhnD2c+1um
	 tVoLvU7HowmaekiXXuvL6MSfoy5Fvbd1pzQhnCrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/222] Bluetooth: hci_conn: Reduce hci_conn_drop() calls in two functions
Date: Mon,  6 Jan 2025 16:14:03 +0100
Message-ID: <20250106151152.083035292@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit d96b543c6f3b78b6440b68b5a5bbface553eff28 ]

An hci_conn_drop() call was immediately used after a null pointer check
for an hci_conn_link() call in two function implementations.
Thus call such a function only once instead directly before the checks.

This issue was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 6178ae8feafc..549ee9e87d63 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2178,13 +2178,9 @@ struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst,
 					  conn->iso_qos.bcast.big);
 	if (parent && parent != conn) {
 		link = hci_conn_link(parent, conn);
-		if (!link) {
-			hci_conn_drop(conn);
-			return ERR_PTR(-ENOLINK);
-		}
-
-		/* Link takes the refcount */
 		hci_conn_drop(conn);
+		if (!link)
+			return ERR_PTR(-ENOLINK);
 	}
 
 	return conn;
@@ -2274,15 +2270,12 @@ struct hci_conn *hci_connect_cis(struct hci_dev *hdev, bdaddr_t *dst,
 	}
 
 	link = hci_conn_link(le, cis);
+	hci_conn_drop(cis);
 	if (!link) {
 		hci_conn_drop(le);
-		hci_conn_drop(cis);
 		return ERR_PTR(-ENOLINK);
 	}
 
-	/* Link takes the refcount */
-	hci_conn_drop(cis);
-
 	cis->state = BT_CONNECT;
 
 	hci_le_create_cis_pending(hdev);
-- 
2.39.5



