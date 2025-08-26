Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E66321459;
	Tue, 26 Aug 2025 11:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207972; cv=none; b=ujMEtQtJPfqAr3ku4s52HTGN/+0rw/LlOgIjJzgdb9PQ5oX2fkPCxpLVwPfWEEBa61dPqjjH7mGZT4qllt8Y2bzyxNyCL3DWWYHUk0ONbiADVdZN15fYapoV7PZDOWe91z7vUvKyfuJ/os55VnbtkxxNrIMIqsqz8YGWjATWLMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207972; c=relaxed/simple;
	bh=5JDp/tiXFmwCBEiWr7AqnosU9OEn/t9NOuxUYJGLfjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ndq8ioBmfw5T09I3wz17csFO36YDXWoYFs8Qmqwik57/AJ26D1e4m3pmARJoUIlW4WYORN7T+t82DvplL/l2Qyh7DXTIE61U22RJD9j+5DHtW83j9w5iCbYiGaW4z/Cpw29srxqhh3l4H2/b2XbRWav/+atz/gMtqeVjclRROO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/4j4/b1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/4j4/b1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAACC4CEF1;
	Tue, 26 Aug 2025 11:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207972;
	bh=5JDp/tiXFmwCBEiWr7AqnosU9OEn/t9NOuxUYJGLfjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/4j4/b1C71lRJhryMSOWVUuSH5fVVdu0o50fc64Xs7o8WXX8WLvfnWPMDNkII3+Q
	 tOOaaW95FpfpAWuCoKsKGljFhKHscLlqi0mtQf05zIPuK6DKCe0B+8oJBMf3BA+iqt
	 ZZN5nyVhvEhrdHQ4cghbCVu5XWQI3lrl9xnw1ChM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 381/457] Bluetooth: hci_core: Fix not accounting for BIS/CIS/PA links separately
Date: Tue, 26 Aug 2025 13:11:05 +0200
Message-ID: <20250826110946.712477643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 9d4b01a0bf8d2163ae129c9c537cb0753ad5a2aa ]

This fixes the likes of hci_conn_num(CIS_LINK) returning the total of
ISO connection which includes BIS_LINK as well, so this splits the
iso_num into each link type and introduces hci_iso_num that can be used
in places where the total number of ISO connection still needs to be
used.

Fixes: 23205562ffc8 ("Bluetooth: separate CIS_LINK and BIS_LINK link types")
Fixes: a7bcffc673de ("Bluetooth: Add PA_LINK to distinguish BIG sync and PA sync connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 459f26d63451..439bc124ce70 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -129,7 +129,9 @@ struct hci_conn_hash {
 	struct list_head list;
 	unsigned int     acl_num;
 	unsigned int     sco_num;
-	unsigned int     iso_num;
+	unsigned int     cis_num;
+	unsigned int     bis_num;
+	unsigned int     pa_num;
 	unsigned int     le_num;
 	unsigned int     le_num_peripheral;
 };
@@ -1014,9 +1016,13 @@ static inline void hci_conn_hash_add(struct hci_dev *hdev, struct hci_conn *c)
 		h->sco_num++;
 		break;
 	case CIS_LINK:
+		h->cis_num++;
+		break;
 	case BIS_LINK:
+		h->bis_num++;
+		break;
 	case PA_LINK:
-		h->iso_num++;
+		h->pa_num++;
 		break;
 	}
 }
@@ -1042,9 +1048,13 @@ static inline void hci_conn_hash_del(struct hci_dev *hdev, struct hci_conn *c)
 		h->sco_num--;
 		break;
 	case CIS_LINK:
+		h->cis_num--;
+		break;
 	case BIS_LINK:
+		h->bis_num--;
+		break;
 	case PA_LINK:
-		h->iso_num--;
+		h->pa_num--;
 		break;
 	}
 }
@@ -1061,9 +1071,11 @@ static inline unsigned int hci_conn_num(struct hci_dev *hdev, __u8 type)
 	case ESCO_LINK:
 		return h->sco_num;
 	case CIS_LINK:
+		return h->cis_num;
 	case BIS_LINK:
+		return h->bis_num;
 	case PA_LINK:
-		return h->iso_num;
+		return h->pa_num;
 	default:
 		return 0;
 	}
@@ -1073,7 +1085,15 @@ static inline unsigned int hci_conn_count(struct hci_dev *hdev)
 {
 	struct hci_conn_hash *c = &hdev->conn_hash;
 
-	return c->acl_num + c->sco_num + c->le_num + c->iso_num;
+	return c->acl_num + c->sco_num + c->le_num + c->cis_num + c->bis_num +
+		c->pa_num;
+}
+
+static inline unsigned int hci_iso_count(struct hci_dev *hdev)
+{
+	struct hci_conn_hash *c = &hdev->conn_hash;
+
+	return c->cis_num + c->bis_num;
 }
 
 static inline bool hci_conn_valid(struct hci_dev *hdev, struct hci_conn *conn)
-- 
2.50.1



